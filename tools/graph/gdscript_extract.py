#!/usr/bin/env python3
"""GDScript (.gd) ve sahne (.tscn) dosyalarından Graphify uyumlu graph.json üretir.

Graphify (graphifyy) GDScript'i desteklemiyor; bu betik eksik kalan kısmı çıkarır ve
`graphify merge-graphs` ile Python grafiğiyle birleştirilir (bkz. tools/graph.sh).

Çıkarılanlar:
  dosya düğümü, class_name, iç sınıflar, fonksiyonlar, sinyaller
  kenarlar: contains, defines, inherits, calls (aynı dosya + class_name.metod), imports (preload/load res://),
            emits (sinyal.emit), uses (sahne → betik/alt sahne)
Kullanım: python3 tools/graph/gdscript_extract.py <kök klasör> <çıktı.json> [--exclude addons]
"""
import argparse
import json
import os
import re
import sys

from gdtoolkit.parser import parser
from lark import Tree, Token

ap = argparse.ArgumentParser()
ap.add_argument("root"); ap.add_argument("out")
ap.add_argument("--exclude", action="append", default=[".godot"], help="atlanacak klasör adı (tekrarlanabilir)")
ap.add_argument("--res-root", default=None, help="res:// karşılığı klasör (varsayılan: project.godot bulunan klasör)")
a = ap.parse_args()

root = os.path.abspath(a.root)
nodes, links, seen = {}, [], set()


def nid(*parts):
    return re.sub(r"[^a-zA-Z0-9]+", "_", "_".join(parts)).strip("_").lower()


def add_node(id_, label, src, loc="L1", ftype="code", **extra):
    if id_ not in nodes:
        nodes[id_] = {"id": id_, "label": label, "norm_label": label.lower(), "_origin": "ast", "file_type": ftype,
                      "source_file": src, "source_location": loc, **extra}
    return id_


def add_link(s, t, rel, src, loc):
    key = (s, t, rel)
    if key in seen:
        return
    seen.add(key)
    links.append({"source": s, "target": t, "relation": rel, "_origin": "ast", "confidence": "EXTRACTED",
                  "confidence_score": 1.0, "source_file": src, "source_location": loc, "weight": 1.0})


def external(name):
    return add_node(nid("ext", name), name, "", ftype="concept", external=True, type="external")


def rel(path):
    return os.path.relpath(path, root).replace(os.sep, "/")


def find_res_root(path):
    if a.res_root:
        return os.path.abspath(a.res_root)
    d = os.path.dirname(path)
    while d.startswith(root):
        if os.path.exists(os.path.join(d, "project.godot")):
            return d
        d = os.path.dirname(d)
    return root


def res_to_rel(res_path, from_file):
    if not res_path.startswith("res://"):
        return None
    return rel(os.path.join(find_res_root(from_file), res_path[6:]))


def file_node_id(relpath):
    return nid(relpath.rsplit(".", 1)[0])


files = []
for dp, dns, fns in os.walk(root):
    dns[:] = [d for d in dns if d not in a.exclude and not d.startswith(".")]
    files += [os.path.join(dp, f) for f in fns if f.endswith((".gd", ".tscn"))]

class_index = {}  # class_name -> (file_id, {method: node_id})
parsed = {}
fallback = []
for path in sorted(files):
    if not path.endswith(".gd"):
        continue
    try:
        parsed[path] = parser.parse(open(path, encoding="utf-8").read(), gather_metadata=True)
    except Exception as e:  # gdtoolkit yeni sözdizimini tanımayabilir: satır tabanlı yedek okuyucu
        print(f"[gdscript_extract] yedek okuyucu: {rel(path)}: {str(e).splitlines()[0]}", file=sys.stderr)
        fallback.append(path)


def line(t):
    return f"L{getattr(getattr(t, 'meta', None), 'line', 1) or 1}"


def first_token(t):
    for c in t.children:
        if isinstance(c, Token):
            return str(c)
    return None


# 1. geçiş: tanımlar
defs = {}
for path, tree in parsed.items():
    r = rel(path); fid = add_node(file_node_id(r), os.path.basename(r), r)
    methods = {}

    def walk_defs(t, owner, prefix):
        for c in t.children:
            if not isinstance(c, Tree):
                continue
            if c.data == "classname_stmt":
                cname = first_token(c); nodes[fid]["label"] = f"{cname} ({os.path.basename(r)})"
                class_index[cname] = (fid, methods)
            elif c.data == "extends_stmt":
                base = first_token(c) or "".join(str(x) for x in c.scan_values(lambda v: isinstance(v, Token)))
                if base and base.startswith('"res://'):
                    tgt = res_to_rel(base.strip('"'), path)
                    if tgt: add_link(owner, file_node_id(tgt), "inherits", r, line(c))
                elif base:
                    add_link(owner, external(base), "inherits", r, line(c))
            elif c.data == "func_def":
                fname = first_token(c.children[0])
                f_id = add_node(nid(r, prefix, fname), f"{fname}()", r, line(c), _callable=True)
                add_link(owner, f_id, "contains", r, line(c))
                if owner == fid: methods[fname] = f_id
                defs[(path, prefix, fname)] = f_id
            elif c.data == "signal_stmt":
                sname = first_token(c)
                s_id = add_node(nid(r, "signal", sname), f"signal {sname}", r, line(c), type="signal")
                add_link(owner, s_id, "defines", r, line(c))
            elif c.data == "class_def":
                iname = first_token(c)
                i_id = add_node(nid(r, prefix, iname), iname, r, line(c), type="class")
                add_link(owner, i_id, "defines", r, line(c))
                walk_defs(c, i_id, prefix + "." + iname)
    walk_defs(tree, fid, "")

# 2. geçiş: kullanımlar
for path, tree in parsed.items():
    r = rel(path); fid = file_node_id(r)
    for t in tree.iter_subtrees():
        if t.data == "func_def":
            fname = first_token(t.children[0])
            src_id = next((v for (p, pre, n), v in defs.items() if p == path and n == fname), fid)
            for c in t.iter_subtrees():
                if c.data == "standalone_call":
                    callee = first_token(c)
                    if callee in ("preload", "load"):
                        continue
                    tgt = next((v for (p, pre, n), v in defs.items() if p == path and n == callee), None)
                    if tgt: add_link(src_id, tgt, "calls", r, line(c))
                elif c.data == "getattr_call":
                    parts = [str(x) for x in c.children[0].children if isinstance(x, Token) and str(x) != "."]
                    if len(parts) == 2 and parts[0] in class_index:
                        cfid, meths = class_index[parts[0]]
                        add_link(src_id, meths.get(parts[1], cfid), "calls", r, line(c))
                    elif len(parts) == 2 and parts[1] == "emit":
                        sig = nid(r, "signal", parts[0])
                        if sig in nodes: add_link(src_id, sig, "emits", r, line(c))
        if t.data == "standalone_call" and first_token(t) in ("preload", "load"):
            s = next((str(x) for x in t.scan_values(lambda v: isinstance(v, Token) and str(v).startswith('"res://'))), None)
            tgt = res_to_rel(s.strip('"'), path) if s else None
            if tgt:
                add_node(file_node_id(tgt), os.path.basename(tgt), tgt)
                add_link(fid, file_node_id(tgt), "imports", r, line(t))

# Ayrıştırılamayan dosyalar: satır tabanlı tarama (yalnız tanımlar ve res:// bağımlılıkları)
for path in fallback:
    r = rel(path); fid = add_node(file_node_id(r), os.path.basename(r), r)
    for i, ln in enumerate(open(path, encoding="utf-8", errors="replace"), 1):
        if m := re.match(r"class_name\s+(\w+)", ln):
            nodes[fid]["label"] = f"{m.group(1)} ({os.path.basename(r)})"; class_index.setdefault(m.group(1), (fid, {}))
        elif m := re.match(r"extends\s+(\w+)", ln):
            add_link(fid, external(m.group(1)), "inherits", r, f"L{i}")
        elif m := re.match(r"(?:static\s+)?func\s+(\w+)", ln):
            f_id = add_node(nid(r, "", m.group(1)), f"{m.group(1)}()", r, f"L{i}", _callable=True)
            add_link(fid, f_id, "contains", r, f"L{i}")
        elif m := re.match(r"signal\s+(\w+)", ln):
            add_link(fid, add_node(nid(r, "signal", m.group(1)), f"signal {m.group(1)}", r, f"L{i}", type="signal"), "defines", r, f"L{i}")
        for m in re.finditer(r'(?:pre)?load\("(res://[^"]+)"\)', ln):
            tgt = res_to_rel(m.group(1), path)
            if tgt:
                add_node(file_node_id(tgt), os.path.basename(tgt), tgt); add_link(fid, file_node_id(tgt), "imports", r, f"L{i}")

# Sahneler: ext_resource yolları
for path in files:
    if not path.endswith(".tscn"):
        continue
    r = rel(path); sid = add_node(file_node_id(r), os.path.basename(r), r, type="scene")
    for m in re.finditer(r'path="(res://[^"]+)"', open(path, encoding="utf-8", errors="replace").read()):
        tgt = res_to_rel(m.group(1), path)
        if tgt and tgt.endswith((".gd", ".tscn")):
            add_node(file_node_id(tgt), os.path.basename(tgt), tgt)
            add_link(sid, file_node_id(tgt), "uses", r, "L1")

json.dump({"directed": True, "multigraph": False, "graph": {"schema_version": 1, "generator": "uomd-gdscript-extract"},
           "nodes": list(nodes.values()), "links": links, "hyperedges": []}, open(a.out, "w"), indent=1)
print(f"[gdscript_extract] {len(parsed)} .gd (+{len(fallback)} yedek), {sum(f.endswith('.tscn') for f in files)} .tscn -> "
      f"{len(nodes)} düğüm, {len(links)} kenar -> {a.out}")
