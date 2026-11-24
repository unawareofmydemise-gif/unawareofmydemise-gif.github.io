# Altyapı: bulut ortamı, araçlar ve üretim hattı

> Son güncelleme: 2026-11-24. Bu belge altyapının **gerçekte** ne durumda olduğunu anlatır; denenmemiş bir şey "çalışıyor"
> diye yazılmaz.

## 1. Bulut ortamı

| | |
|---|---|
| Ortam adı | **Unaware of My Demise** (kişisel). Repolar: `unawareofmydemise-gif.github.io`, `UOMD` |
| Makine | Ubuntu 24.04, 4 çekirdek, 15 GB RAM, **GPU yok** |
| Render | Yazılımsal GPU: Vulkan → lavapipe (`/opt/lavapipe`), OpenGL → llvmpipe |
| Kurulum | `tools/bootstrap.sh` (ortamın kurulum betiği bunu çalıştırır) |
| Gerekli ağ adresleri | `download.blender.org`, `downloads.godotengine.org`, `github.com`, `release-assets.githubusercontent.com` (Godot indirmesi buraya yönlenir), `generativelanguage.googleapis.com` (Gemini) + paket depoları |

## 2. Araçlar (sabitlenmiş sürümler)

| Araç | Sürüm | Doğrulama |
|---|---|---|
| Blender | **5.2.4 LTS** | SHA-256 `tools/bootstrap.sh` içinde |
| Godot | **4.7.2 stable** (standart, .NET'siz) | SHA-256 `tools/bootstrap.sh` içinde |
| Python + Pillow | sistem | QA sayfaları |

Sürüm yükseltmek bilinçli bir karardır: `bootstrap.sh` içindeki sürüm ve SHA-256 birlikte değişir, `tools/doctor.sh` geçmeli.

## 3. Doğrulanmış yetenekler (2026-11-24, `tools/doctor.sh`)

| Yetenek | Durum | Not |
|---|---|---|
| Blender ekransız EEVEE render (toon + kontur) | ✅ | 512² ~7 sn (başlangıç dahil ~15 sn). `--gpu-backend vulkan` + lavapipe |
| Blender Cycles (CPU) | ✅ | Gerektiğinde; toon için EEVEE kullanılır |
| Blender → glTF (.glb) | ✅ | |
| Godot ekransız içe aktarma | ✅ | `godot --headless --import` |
| Godot render + ekran görüntüsü | ✅ | Xvfb + Vulkan (llvmpipe), Mobile renderer |
| Standart açı render'ları + karşılaştırma sayfası | ✅ | `art_src/lib/uomd_render.py`, `tools/qa/sheet.py` |
| Godot dışa aktarma (Windows/Linux/Web/Android) | ⏳ | Export template'leri ve Android SDK henüz kurulmadı (bkz. §7) |
| Blender toon malzemesinin Godot'a taşınması | ❌ (beklenen) | Toon görünüm Godot shader'ında yapılacak |

## 4. Üretim hattı ve kalite kontrol döngüsü

```
 Referans (art/portraits, art bible, gerekirse Gemini ile üretilen yan/arka görünüm)
        │
        ▼
 art_src/<tür>/<id>/build.py  ──(tools/blender.sh)──▶  Blender sahnesi
        │                                              │
        │                     ┌────────────────────────┤
        ▼                     ▼                        ▼
  render_views() → out/<id>/{front,three_quarter,side,back}.png      export → game/assets/<tür>/<id>.glb
        │                                                                 │
        ▼                                                                 ▼
  tools/qa/sheet.py  referans + render'lar  ──▶  Claude sayfaya bakar   tools/godot.sh ile oyunda render
        │                                         │
        └──── fark var ──▶ build.py düzeltilir ◀──┘
```

Kurallar:
- Her model betiği `--render` ile QA görüntülerini, `--export` ile `.glb`'yi üretir (betik kalıbı `art_src/README.md`).
- QA sayfasına bakılmadan model "tamam" sayılmaz. Bakılan sayfanın yolu commit mesajına veya ilgili nota yazılır.
- Render'lar `out/` altında kalır (git'e girmez); onaylanan son görüntüler gerekirse `docs/` veya ilgili klasöre küçük
  boyutta eklenir.

## 5. Karakterleri "elle" (kodla) modelleme yaklaşımı

Hazır yapay zekâ 3D servisleri kullanılmıyor; her model Claude tarafından Blender Python ile adım adım kurulur. Bunun için
kendi "VRoid benzeri" sistemimizi kodla kuruyoruz:

1. **Anime gövde tabanı** (kadın / erkek): temiz topoloji, standart insansı iskelet, oran parametreleri (boy, baş oranı,
   omuz, bel, bacak), yüz ifadesi şekil anahtarları. **Bir kez, çok dikkatle** yapılır; her karakter bunu kullanır.
2. **Yüz:** anime stilinde basit yüz geometrisi + göz/kaş/ağız **dokuları** (SVG ile çizilip PNG'ye çevrilir). İfadeler doku
   değişimi ve şekil anahtarlarıyla yapılır.
3. **Saç:** eğri (Bezier) tabanlı saç tutamları; kalınlık ve uç incelmesi parametrik.
4. **Kıyafet:** gövdeden türetilen katmanlar (kabuk) + ayrı parçalar (pelerin, başlık, kemer, zırh plakaları).
5. **Aksesuar ve silah:** ayrı prop betikleri (Fadyme'nin çanı, Mahmut'un kalkanı…).
6. **Animasyon:** iskelet ortak olduğu için animasyonlar (bekleme, yürüme, saldırı…) **bir kez** yazılır, tüm karakterlerde
   çalışır.

Risk: yüz ve saç estetiği en zor kısım. Bu yüzden gövde tabanından sonraki ilk iş tek karakterle (Fadyme) dikey kesit testi.

## 6. Git stratejisi

- Kaynaklar metin: modeller Python betiği, sahneler `.tscn`, veriler JSON. Diff'lenebilir ve küçük.
- `.glb` gibi ikili dışa aktarmalar yalnız **onaylanmış** sürümlerde `game/assets/` altına commit edilir.
- Git LFS şimdilik kullanılmıyor (ücretsiz kota düşük). Repo boyutu 2 GB'ı geçerse yeniden değerlendirilecek.
- Çalışma doğrudan `main` dalında.

## 7. Altyapı yol haritası

| # | İş | Durum |
|---|---|---|
| A1 | Bulut ortamı, Blender + Godot kurulumu, sağlık kontrolü | ✅ |
| A2 | Repo yapısı, `CLAUDE.md`, Godot proje iskeleti | ✅ |
| A3 | QA render modülü ve karşılaştırma sayfası | ✅ |
| A4 | Ortamın kurulum betiği ve ağ adresleri (yeni oturumlar otomatik kurulsun) | ⏳ sahibin onayıyla |
| A5 | Godot toon shader + kontur (karakterler için temel malzeme) | ⏳ |
| A6 | Anime gövde tabanı v1 + standart iskelet | ⏳ |
| A7 | Referans paketi: her ana karakter için ön/yan/arka referans (Gemini) | ⏳ |
| A8 | Godot export template'leri; tarayıcıda oynanabilir önizleme (Web) | ⏳ |
| A9 | Android SDK + imzalama ile Android derlemesi | ⏳ (PC sürümünden sonra) |
| A10 | Otomatik testler (GDScript birim testleri, savaş hesapları) | ⏳ |
