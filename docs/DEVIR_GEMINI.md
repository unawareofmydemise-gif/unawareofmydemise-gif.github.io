# Gemini Orchestrator'a devir notu

> Hazırlayan: Claude (Sonnet 5.5), 2026-11-24. Sahibin isteği: projeyi **Gemini 4 Carbon Orchestrator**'ın (Google Antigravity) devralıp
> Google araçlarıyla, kendi başına, yapabileceği en iyi **Android oyununa** kadar götürmesi. Bu belge: o şeyin ne olduğu (araştırma),
> repo onun için nasıl hazırlandı, nereden başlanacağı, neyin yapılıp **yapılmadığı** ve bilinen riskler.
> Denenmemiş hiçbir şey "çalışıyor" diye yazılmadı.

## 1. Özet

- Oyun, hedef ve kurallar: `AGENTS.md`. Canlı durum: `docs/ILERLEME.md`. Görev kuyruğu: `docs/YOL_HARITASI.md`.
- **Durum:** altyapı (A1–A5, Godot AI köprüsü) hazır ve doğrulandı; **A6 (anime gövde tabanı) ve sonrası yapılmadı**. Hiçbir oynanabilir oyun, karakter modeli ya da APK yok.
- **İlk iş:** §8 (ortam keşfi). Sonra `docs/YOL_HARITASI.md` T1.1.

## 2. "Gemini 4 Carbon Orchestrator" nedir, ne değildir (araştırma, 2026-11-24)

**Güven notu:** Birincil Google sayfalarına (antigravity.google, blog.google) Claude'un bulut kapsülünden erişilemedi (ağ ilkesi). Aşağıdakiler,
arama motorunun Google belgelerinden çıkardığı özetlere ve ikincil haberlere dayanır. Kaynaklar kısmen çelişir; sayılar Google'ın kendi beyanıdır.
Kendi ortamında modelin ve belgelerin güncel hâlini doğrula.

**Nedir**
- **Ayrı bir model değil**, Google **Antigravity**'nin model seçicisindeki **Orchestrator (Carbon)** girdisi. Büyük bir **planlayıcı** (Gemini 4 Carbon) ile hızlı bir **yürütücü**
  (Gemini 4 Hydrogen) **tek konuşmada** eşleşir.
- Her mesaj **salt-okunur bir planlama aşamasıyla** başlar: planlayıcı kod tabanını gezer, planı yazar. Sonra yürütücü arama, düzenleme, derleme ve test yapar. Yürütücü
  takılırsa (bir doğrulama iki kez düşerse, bir arayüz beklenmedik davranırsa, plan bir tasarım seçimini çözmemişse) kontrolü planlayıcıya geri verir; planlayıcı uzun işlerde ilerlemeyi de gözden geçirir.
- Gemini 4 ailesi: **Argon** (30 Eylül 2026 duyuruldu; uzun süreli karmaşık işler; ilk erişim sınırlı), **Carbon** (~11–13 Kasım 2026; `/swarm` ile paralel ajan ekipleri), **Hydrogen** (hızlı yürütücü).
  Yeni belgelerde planlayıcı olarak **Neon** da geçiyor. Hangi planlayıcının hangi planda olduğu kaynaklarda çelişiyor: model seçicine bak.
- Erişim **ücretli abonelikle**: Carbon tabanlı Orchestrator Google AI Ultra'da; Argon tabanlı Ultra ve Pro'da (kaynaklar çelişiyor).
- Antigravity yüzeyleri: Uygulama (2.0), IDE, CLI (`agy`). CLI **headless** çalışabilir (tek istem, yazdır modu; önbellekteki oturumla; `--print-timeout`, `--dangerously-skip-permissions`, `--continue`).
  **`/goal`**: hedef doğrulanmış tamamlanana kadar ara duraksama olmadan otonom çalışır. **Remote Agents**: Google'ın yönettiği ortamda çalışır, siz kapatsanız da sürer (yalnız Pro/Ultra, kişisel hesap).
- Google'ın bildirdiği: Terminal-Bench 4.1'de Carbon'a yakın başarı, ~%24 daha az kota ve ~%19 daha hızlı (**Google'ın kendi beyanı**, bağımsız doğrulama bulamadım).
- Android tarafı: Android CLI (derleme, emülatör, cihaz, SDK kurulumu, UI inceleme, profil) Antigravity, Claude Code ve Codex için resmî eklenti olarak geliyor.

**Ne değildir / sınırlar**
- Ayrı bir ürün ya da bağımsız model değil; yalnız Antigravity içinde bir seçenek. Ücretsiz katmanda yok.
- Ne zaman hangi modele geçtiği ve geçişlerin maliyeti belgelenmemiş (The New Stack'e göre Google söylememiş).
- Bir **kodlama ajanı orkestratörü** olarak tanıtılıyor. Kaynaklarda görsel, 3D ya da ses **üretim** yeteneğinden söz eden bir şey **bulamadım**: bunlar için ayrı Google araçları (Gemini API vb.) çağrılmalı.
- Blender ve Godot'u kendisi çalıştırabilmesi için o ortamda kurulu olmaları gerekir. Bu depodaki betikler Linux/bash varsayar (§5).
- "Kendi başına en iyi oyunu tasarlar" bir garanti değil. Doğrulanabilir hedefler, kabul ölçütleri ve özerklik sınırı gerekir; bu yüzden `docs/YOL_HARITASI.md` böyle yapılandı.

## 3. Repo Antigravity için nasıl hazırlandı

Antigravity'nin okuduğu yerler (belge özetlerine göre). **İlk oturumda yüklendiklerini doğrula**; yüklenmediyse `docs/ILERLEME.md` → "Sorunlar"a yaz.

| Dosya | Rolü |
|---|---|
| `AGENTS.md`, `GEMINI.md` (kök) | Frontmatter'sız düz Markdown; her zaman açık. `AGENTS.md` kanonik, `GEMINI.md` Orchestrator'a özgü notlar |
| `.agents/rules/*.md` | Frontmatter'lı kurallar (`trigger: glob`, `globs:` virgüllü metin): `art-src.md`, `godot.md`, `kanon.md`. Tek seviye taranır; geçersiz frontmatter'lı dosya **sessizce atılır** |
| `.agents/skills/<ad>/SKILL.md` | Yetenekler (ad + açıklama): ortam kur/doğrula, model kalite döngüsü, Godot editörü kontrolü. Açıklamaya göre ilgili işte yüklenir |
| `.agents/mcp_config.json` | Çalışma alanı MCP: `godot-ai` (taşınabilir `uvx` biçimi). Genel yapılandırma `~/.gemini/config/mcp_config.json` |
| `.mcp.json`, `CLAUDE.md` | Claude'un dosyaları (kapsül yolları); Antigravity için **kullanılmaz** |

Workflows (`.agents/workflows/`) bilerek kullanılmadı: belgeler onlardan skills ve slash komutlarına geçişi gösteriyor.

## 4. İşbölümü ve hazır hedefler

- **Carbon (planlayıcı):** aktif görevi `docs/ILERLEME.md`'den seçer; `docs/YOL_HARITASI.md`'deki **Kabul** ve **Doğrulama** sütunlarını plana aynen taşır; karar noktalarını (örn. T1.1'de MPFB-türevi mi sıfırdan mı) 2 küçük denemeyle çözdürür; ilerlemeyi gözden geçirir; karar günlüğünü yazar.
- **Hydrogen (yürütücü):** küçük adımlar: dosya yazma, betik çalıştırma, test, QA sayfası üretme. Doğrulama iki kez düşerse kontrolü geri verir.
- **`/goal` şablonu:** `Görev: <T-no>. Bitiş: o görevin Kabul satırı sağlandı, Doğrulama komutları yeşil, docs/ILERLEME.md güncel. Dur ve sor: AGENTS.md §4.`
- **Hazır hedef G1 (anime gövde tabanı):** "`docs/YOL_HARITASI.md` T1.1'in Kabul ölçütlerinin hepsi sağlanana kadar çalış. Bitiş: `tools/test.sh` ve `tools/lint.sh` yeşil; `tools/doctor.sh` 13/13;
  `art_src/lib/body_base.py` kadın ve erkek tabanı üretiyor; `out/body_base/sheet.png` üretildi ve bakıldı; Godot'ta toon render alındı; `docs/ILERLEME.md` T1.1 ✅ ve kanıt yolları yazılı.
  MPFB-türevi / sıfırdan seçimini ve iskelet standardını karar günlüğüne gerekçeyle yaz. `AGENTS.md` §4'teki bir şey çıkarsa görevi ⛔ işaretle."
- **Hazır hedef G2 (Android yürüyen iskelet):** "T2.1 ve T2.2'nin Kabul ölçütleri sağlanana kadar çalış. Bitiş: toon test sahnesi APK olarak Android emülatöründe açılıyor, ekran görüntüsü alındı, FPS ölçümü `docs/PERFORMANS.md`'de;
  yayın paketinde `_mcp_game_helper` yok; anahtar/şifre commit edilmedi; `docs/ILERLEME.md` güncel. İmza anahtarı ve Play Console için sahibe sor."
- **`/swarm`:** yalnız bağımsız dizinlerde (`art_src/`, `game/`, `docs/`), ayrı worktree; `docs/ILERLEME.md` için her commit'ten önce `git pull --rebase`.

## 5. Çalışma ortamları (sahip hangisini seçeceğini söylemedi: açık soru 1)

| Yer | Anlamı | Notlar |
|---|---|---|
| **A. Antigravity masaüstü / CLI, sahibin makinesi** (Windows / macOS / Linux) | Ajan yerel terminalde çalışır | Blender 5.2.4 ve Godot 4.7.2 (standart, .NET'siz) makineye kurulmalı. Gerçek GPU varsa `xvfb`/lavapipe gerekmez. `tools/*.sh` bash'tir: Windows'ta WSL2; yoksa altlarındaki komutları doğrudan çalıştır (`blender -b -P art_src/.../build.py -- --render`, `godot --path game`). Godot editörü normal açılır; Godot AI eklentisi projede etkin |
| **B. Antigravity Remote Agents** (Google'ın yönettiği ortam) | Pro/Ultra, kişisel hesap | İmaj ve ağ kuralları **bilinmiyor**. `bash tools/bootstrap.sh` çalışırsa tam hat; çalışmazsa 3D hattı olmadan (tasarım, veri, GDScript, belgeler) ilerle ve `docs/ILERLEME.md`'ye yaz |
| **C. Claude bulut kapsülü** (bu repoyu hazırlayan ortam) | Ubuntu 24.04, 4 çekirdek, GPU yok, yazılımsal Vulkan | Referans ortam: her şey burada doğrulandı |

- Taşınabilir ortam fikri: `docs/YOL_HARITASI.md` T0.1 (Dockerfile / devcontainer ile `tools/bootstrap.sh`). **Denenmedi.**
- Android araç zinciri: Godot'un Android dışa aktarımı Godot export şablonları, Android SDK, JDK ve keystore ister (sürümleri Godot 4.7 belgesinden doğrula). Google'ın Android CLI'ı SDK/emülatör işini kolaylaştırır; **imzalama ve yayın komutları aracın listelediği komutlar arasında yoktu**: Lightbuild / Play Console API belgelerine bak.

## 6. Google araçları planı

| Araç | Ne için | Durum |
|---|---|---|
| Gemini API (`generativelanguage.googleapis.com`) | Referans görseller (T1.3), konsept; metin işleri | Bu repoda **denenmedi**. Anahtar sahipten. Model adlarını çalışma anında belgeden doğrula |
| Google Cloud TTS (Chirp 3 HD, ja-JP) | Japonca seslendirme: mevcut ~59 dk `audio/voice/` aynı hatla genişler | **Denenmedi** |
| Android CLI + Android Studio (+ `android-cli` skill'i) | SDK, emülatör, cihaz, UI inceleme, profil (T2.1–T2.3) | **Denenmedi** |
| Antigravity skills / `/goal` / `/swarm` / MCP | Orkestrasyon; yeni skills'i kendin yazabilirsin | — |
| Godot AI (MCP) | Godot editörünü yönetme: sahne, düğüm, betik, oyun karesi, günlük | Claude kapsülünde **canlı doğrulandı** (35 sn, 9/9) |
| Google'ın "Game Solver & Balance Tester" codelab'ı | Sıra tabanlı savaş denge testi için fikir (T4.3) | Okunmadı; kaynak bağlantısı §10 |
| Firebase / Play Games Services / Play Console | Hesap, bulut kaydı, yayın | Karar bekliyor (sunucu kararı ilk oynanabilir sürümden sonra) |

Her yeni araç: önce küçük deneme, çalıştığını gör, sonra `docs/KAYNAKLAR.md`'ye yaz.

## 7. Durum: yapılanlar, yapılmayanlar, riskler

**Yapıldı ve doğrulandı** (kanıt: `docs/ALTYAPI.md`, `docs/KAYNAKLAR.md`):
- Blender 5.2.4 + Godot 4.7.2 kurulum hattı (`tools/bootstrap.sh`), sağlık kontrolü (`tools/doctor.sh`, 13/13), Mobile yöntemi zorlanıyor ve doğrulanıyor.
- **A5 toon shader + kontur** (`game/shaders/`, `ToonSkin`, 17 GUT testi, `tools/qa/toon_stage.sh`): mum / kül / nötr ışıkta, doku ve emisyonla, iskelet pozu altında kontur silüeti izliyor.
- **Godot AI** (Godot editörünü MCP ile yönetme): canlı test geçti; telemetri kapalı.
- Eklentiler: GUT, Phantom Camera, Dialogue Manager, Godot State Charts, Godot AI. Lint, test, kod grafiği (Graphify).

**Yapılmadı / denenmedi:**
- **A6 anime gövde tabanı, hiçbir karakter modeli, yüz, saç, kıyafet, animasyon, harita, savaş, UI, APK yok.**
- A5'in "anime görünüyor mu" onayı (danışman/sahip) alınmadı. Hareketli animasyonda kontur titremesi ve performans (GPU yok) ölçülmedi.
- Gerçek dışa aktarmada Godot AI yardımcısının ayıklanması (A8'de sınanacak). Taze kapsülde bootstrap + canlı test birlikte. Kurulum betiği taze kapsülde (yeni oturum) çalıştırılmadı.
- Gemini API, TTS, Android CLI, Play Console: hiçbiri denenmedi.
- Dockerfile/devcontainer ve Windows/macOS yolları denenmedi.

**Riskler:**
- **En riskli iş: karakter yüzü ve saçı** (`design/OYUN_TASARIM_PLANI.md` §5). İlk dikey kesit (T1.4) önce tek karakterle yapılsın.
- Orchestrator'ın gerçek yetenekleri ve kota/maliyet davranışı belgelenmemiş (§2): ilk oturumda kısa görevlerle ölç.
- Godot AI 4.4.2'nin kendi sunucu başlatması bir denemede engellendi; `tools/godot-editor.sh` bunu aşar (sunucuyu biz başlatıp eklentiye devrederiz). Sahibin makinesinde eklentinin kendi yolu çalışabilir; engellenirse bu betiğin mantığını uygula.
- Taze projede Godot editörünün ilk açılışı ~8–10 dk sürdü (belge üretimi); sonrası hızlı.
- Üçüncü taraf telemetri: Godot AI varsayılan olarak açık gönderir; bu depoda kapalı yapılandırıldı. Yeni araç eklerken aynısını yap.

## 8. İlk çalıştırma kontrol listesi (ortam keşfi)

1. `git pull`. Antigravity'de `AGENTS.md`, `GEMINI.md`, `.agents/rules`, `.agents/skills`, `.agents/mcp_config.json` yüklendi mi? (Kural ve skill listesine bak.) Yüklenmediyse `docs/ILERLEME.md` → "Sorunlar".
2. Ortamı öğren: işletim sistemi, GPU var mı, `godot --version` (4.7.2 olmalı), `blender --version` (5.2.4), `python3 --version` (3.11+), `uv --version` (≥ 0.9.25), `git --version`.
3. Linux ise `bash tools/bootstrap.sh` ve `tools/doctor.sh` (13/13). Windows ise WSL2 ya da manuel kurulum; hangisini yaptığını yaz.
4. Godot kuruluysa `tools/test.sh` ve `tools/lint.sh`. Yeşil değilse devam etme; nedenini yaz.
5. Godot editörü + Godot AI: editörde projeyi aç; "Godot AI" dock'unda bağlantıyı gör; `editor_state` aracını çağır. Linux/başsız ortamda `tools/godot-editor.sh start` + `wait`.
6. `docs/ILERLEME.md` "Ortam" satırını doldur: ne çalışıyor, ne çalışmıyor, hangi araçlar eksik.
7. Aktif görev seç (T1.1), "aktif" yaz. Sahibe 5 satırlık Türkçe rapor ver.

## 9. Sahibe açık sorular

`docs/ILERLEME.md` → "Açık sorular" tablosunda tutulur (tek kaynak). Özet: Orchestrator nerede çalışacak; Android öncelikli mi (önceki karar "önce PC" idi); hedef cihaz sınıfı ve minimum Android sürümü;
Gemini API anahtarı ve TTS erişimi; Play Console hesabı ve imza anahtarı politikası; baş oranı; A5 görsel onayı.

## 10. Kaynaklar (arama özetleri + ikincil haberler; Google sayfaları bu kapsülden okunamadı)

- Orchestrator ve model seçici: [InfoWorld](https://www.infoworld.com/article/4248403/google-adds-multi-model-orchestrator-gemini-4-hydrogen-to-antigravity.html) ·
  [Antigravity blog: Gemini 4 Hydrogen](https://antigravity.google/blog/gemini-4-hydrogen-in-google-antigravity) · [Antigravity: model seçimi](https://antigravity.google/docs/models/) ·
  [The New Stack: Carbon `/swarm`](https://thenewstack.io/gemini-4-carbon-swarm/?p=22843270) ·
  [Silicon Report](https://www.siliconreport.com/google-introduces-orchestrator-in-antigravity-to-pair-gemini-models) ·
  [Let's Data Science](https://letsdatascience.com/news/google-antigravity-adds-orchestrator-model-option-and-gemini-4f318e65)
- Gemini 4: [Gemini 4 Argon (Google)](https://blog.google/innovation-and-ai/models-and-research/gemini-models/gemini-4-argon/) · [Axios](https://axios.com/2026/09/30/google-gemini-4)
- Antigravity yapılandırması: [Rules](https://antigravity.google/docs/rules/) · [Customization discovery](https://antigravity.google/docs/customization-discovery/) ·
  [Skills](https://antigravity.google/docs/skills?app=antigravity-ide) · [MCP](https://antigravity.google/docs/mcp) · [CLI headless](https://antigravity.google/docs/cli/headless/) ·
  [Remote Agents](https://antigravity.google/docs/remote-agents/)
- Android: [AI tools for Android](https://developer.android.com/ai-tools) · [Android CLI](https://developer.android.com/cli) · [Agents](https://developer.android.com/tools/agents) ·
  [Android skills](https://developer.android.com/tools/agents/android-skills)
- Denge testi fikri: [Mastering Slash Commands of Antigravity 2.0 (Game Solver & Balance Tester)](https://codelabs.developers.google.com/codelabs/devsite/codelabs/mastering-slash-commands-antigravity)
