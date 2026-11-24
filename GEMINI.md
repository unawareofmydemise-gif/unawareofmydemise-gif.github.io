# GEMINI.md — Antigravity / Gemini notları

**Önce `AGENTS.md`'yi oku: tüm kurallar, kırmızı çizgiler, çalışma döngüsü ve komutlar orada.** Bu dosya yalnız Antigravity ve
Gemini Orchestrator'a özgü işletim notlarıdır; `AGENTS.md` ile çelişirse `AGENTS.md` geçerlidir. Sahibe Türkçe yaz.

## Orchestrator (Carbon planlar, Hydrogen yürütür)

- **Planlama (salt-okunur):** `docs/ILERLEME.md` → aktif görevi seç; `docs/YOL_HARITASI.md` → görevin **Kabul** ve **Doğrulama**
  sütunlarını aynen plana kopyala. Plan, yürütücünün tahmin yürütmesine yer bırakmayacak kadar somut olsun (dosya yolu, komut, beklenen çıktı).
- **Yürütme:** adımlar küçük ve tek komutla doğrulanabilir olsun (`tools/test.sh`, `tools/lint.sh`, `tools/qa/toon_stage.sh`…).
  Bir doğrulama **iki kez** düşerse ya da plan bir tasarım seçimini çözmüyorsa kontrolü planlayıcıya geri ver.
- **Hedef verme (`/goal`):** bitiş ölçütü olarak görevin Kabul satırını ve çalıştırılabilir doğrulama komutlarını yaz.
  Hazır hedef metinleri: `docs/DEVIR_GEMINI.md` §4. `--dangerously-skip-permissions` yalnız sahibin açıkça verdiği oturumda;
  `AGENTS.md` §4'teki "dur ve sor" listesi izin ayarından bağımsız geçerlidir.
- **`/swarm`:** yalnız birbirinden bağımsız dizinlerdeki görevlerde (`art_src/`, `game/`, `docs/`), ayrı worktree ile.
  `docs/ILERLEME.md` ortak dosyadır: her commit'ten önce `git pull --rebase`.

## Bu depodaki Antigravity yapılandırması

- `.agents/rules/*.md`: dizine göre bağlama özgü kurallar (frontmatter'lı, `trigger: glob`).
- `.agents/skills/<ad>/SKILL.md`: ortam kurma, model kalite döngüsü, Godot editörü kontrolü.
- `.agents/mcp_config.json`: `godot-ai` (Godot editörünü yönetir). Telemetri kapalı. Godot editörü açık olmalı.
- Bunların yüklendiğini ilk oturumda doğrula (kural ve skill listesi). Yüklenmediyse `docs/ILERLEME.md` → "Sorunlar"a yaz.

## Çalışma ortamın

Bu depo Ubuntu 24.04 bulut kapsülünde (GPU yok, yazılımsal render) geliştirildi. Senin ortamın farklı olabilir:
**ilk iş** `docs/DEVIR_GEMINI.md` §8'deki ortam keşfini yap, neleri çalıştırabildiğini `docs/ILERLEME.md`'ye yaz.
