# AGENTS.md — Unaware of My Demise

Bu dosya depoda çalışan **her yapay zekâ ajanının** tek giriş noktasıdır (Google Antigravity / Gemini, Claude Code, Codex, Jules…).
Sahibe her zaman **Türkçe** yaz. Kod, dosya ve değişken adları İngilizce; yorumlar ve belgeler Türkçe.
Claude'a özgü ek kurallar `CLAUDE.md`'dedir. Çelişirse bu dosya ve sahibin son yönergesi geçerlidir.

## 1. Proje

*Unaware of My Demise*: gotik-fantezi, anime stilinde, hikâye odaklı **gacha RPG**. Eski oyun 2D'ydi; bu repo onun
**Godot 4 ile sıfırdan 3D yeniden yapımıdır**.

- **Hedef:** Android'de oynanabilen, yapabileceğin **en iyi oyun** (sahibin son yönergesi). PC aynı kod tabanından çıkar.
- Motor: Godot 4.7.2, **Mobile** render yöntemi (PC ve Android aynı görünür).
- Oyun: 3D keşif (yürünen bölümler, kamp) + **sıra tabanlı parti savaşı** (Honkai: Star Rail tarzı) + gacha (canlı oyun).
- Görünüm: Godot'ta **toon / cel shader + kontur**; sıcak mum ışığı ↔ soğuk kül ve sis karşıtlığı.
- 3D modeller **elle, kodla** üretilir: Blender Python betikleri (`art_src/`). Görselden-3D servisleri (Meshy, Tripo) **kullanılmaz** (sahip kararı).

## 2. Önce bunları oku (sırayla)

1. `docs/ILERLEME.md` — şu an ne durumda, kim ne yapıyor, karar günlüğü, sahibe açık sorular.
2. `docs/YOL_HARITASI.md` — görev kuyruğu; her görevin **kabul ölçütü** ve **doğrulama komutu**.
3. `docs/DEVIR_GEMINI.md` — Gemini Orchestrator'a devir notu: araştırma, yapılan/yapılmayan, riskler, ilk çalıştırma listesi.
4. `design/OYUN_BILGI_DOKUMANI.md` (hikâye, dünya, karakter **kanonu**), `design/OYUN_TASARIM_PLANI.md` (oynanış, savaş, UI), `design/art_bible/` (görsel tarifler).
5. `docs/ALTYAPI.md` (araçlar, kalite döngüsü), `docs/KAYNAKLAR.md` (hangi araç neden var / neden yok).

## 3. Kırmızı çizgiler (sahibin kilitli kararları: değiştirme, sor)

- **Kanon:** `design/OYUN_BILGI_DOKUMANI.md` ile çelişme; yeni lore uydurma; **Part II sırlarını çözme ya da ifşa etme**.
- Gacha kalıyor (canlı oyun). Savaş sıra tabanlı. Motor Godot 4. Görünüm anime toon.
- **Salt okunur kaynak içerik:** `art/ audio/ story/ data/ fonts/ localization/`. Değiştirme, silme. Gerekenler işlenip `game/assets/` altına kopyalanır.
- Eski oyunun kodunu (UOMD reposu) bu repoya taşıma.
- Gizli bilgi (API anahtarı, şifre, keystore) commit etme. 50 MB üstü dosya ve üretilebilen çıktı (render, ara dosya) commit etme.
- `game/addons/` altındaki üçüncü taraf dosyalarını düzenleme (sürümler sabit).
- Telemetrisi açık araç ekleme; ekleyeceksen kapat ve `docs/KAYNAKLAR.md`'ye yaz.

## 4. Özerklik sınırı

Amaç, sahibin onayını beklemeden ilerlemendir. Yalnız şunlarda **dur ve sahibe sor** (`docs/ILERLEME.md` → "Açık sorular"
tablosuna yaz, sonra başka göreve geç):

- Kanonu, kırmızı çizgileri ya da §1'deki kararlardan birini değiştirmek.
- Para harcatan her şey: ücretli API / abonelik / kota aşımı, hesap açma, Play Console'da yayın, imza anahtarı üretme ve saklama.
- Geri alınamaz git işlemleri (force push, geçmişi yeniden yazma, dal silme) ve kaynak içerik silme.
- Lisansı belirsiz içerik ya da araç eklemek.

Şunları **kendin karara bağla** ve `docs/ILERLEME.md` karar günlüğüne yaz: denge sayıları, UI yerleşimi, harita ve seviye
tasarımı, kamera, VFX, ilerleme eğrisi, model ve animasyonlar, performans bütçeleri, test stratejisi.

## 5. Çalışma döngüsü

1. `git pull --rebase origin main`. `docs/ILERLEME.md`'den aktif görevi al, "aktif" yaz.
2. Görevin kabul ölçütünü ve doğrulama komutlarını oku (`docs/YOL_HARITASI.md`).
3. Küçük adımlarla yap. Her görsel değişiklikten sonra **ekran görüntüsü / karşılaştırma sayfası üret ve bak**. Bakmadan "oldu" deme.
4. Doğrula: `tools/test.sh` ve `tools/lint.sh` yeşil; görevin QA komutu geçti; ilgili belge güncel.
5. Küçük, anlamlı commit; `git push origin main`. Mesaj Türkçe: ne yaptın, neyi doğruladın, neyi **yapmadın**. Son satır: `Ajan: <ad>`.
6. `docs/ILERLEME.md`'yi güncelle (durum, kanıt yolu). Yapmadığını açıkça yaz; denenmemiş bir şeye "çalışıyor" deme.

Yeni oyun sistemi = yeni test (`game/tests/`, GUT). İçerik **veri odaklıdır** (`game/data/`): yeni içerik kod değişikliği gerektirmesin.

## 6. Araçlar ve doğrulama komutları

Tümü repo kökünden çalışır. Ubuntu 24.04 + kök yetkisi varsayılır (bkz. `docs/DEVIR_GEMINI.md` §5, başka ortamlar).

| Ne | Komut | Not |
|---|---|---|
| Ortamı kur | `bash tools/bootstrap.sh` | Blender 5.2.4 LTS, Godot 4.7.2, MPFB2, gdtoolkit, Graphify, Godot AI; tekrar çalıştırılabilir |
| Sağlık kontrolü | `tools/doctor.sh` | 13 kontrolün hepsi ✅ olmalı |
| Birim testleri | `tools/test.sh` | GUT, ekransız; başarısızsa çıkış kodu 1 |
| Kod kalitesi | `tools/lint.sh` | gdlint + gdformat (`game/addons` hariç) |
| Blender betiği | `tools/blender.sh art_src/<tür>/<id>/build.py -- --render` | ekransız EEVEE |
| QA sayfası | `python3 tools/qa/sheet.py out/x.png <referans> <render>...` | referans + render yan yana; **sayfaya bak** |
| Toon görsel kontrol | `tools/qa/toon_stage.sh` | düz ↔ toon, Mobile + shader hatası denetimi |
| Godot çalıştır / ekran görüntüsü | `tools/godot.sh --path game ...` | sanal ekran, Mobile yöntemi |
| Godot editörü + MCP | `tools/godot-editor.sh start`, `wait`, `stop` | MCP sunucusu `godot-ai`; iş bitince `stop` |
| MCP'siz araç çağrısı | `tools/mcp-call.sh godot-ai --list` | sunucu oturuma yüklü değilken |
| Kod grafiği | `tools/graph.sh`, `graphify query "<soru>"` | kodu tanımadan önce dene |

Ortam tutarsızsa `tools/doctor.sh` neyin eksik olduğunu söyler. Tahmin etme: Blender API için
`/opt/uomd-tools/venv/lib/python3.13/site-packages/bpy-stubs/`, Godot API için `godot-ai` aracı `api_manage` ya da editör belgeleri.

## 7. Repo haritası

| Klasör | İçerik | Kural |
|---|---|---|
| `art/ audio/ story/ data/ fonts/ localization/` | Eski oyundan **kaynak** içerik | Salt okunur |
| `design/` | Tasarım belgeleri, art bible | Kararlar buraya + `docs/ILERLEME.md` karar günlüğüne |
| `art_src/` | 3D modellerin kaynağı: Blender Python betikleri | Modelin tek gerçek kaynağı betiktir; `.glb`'yi elle düzenleme |
| `game/` | Godot 4.7 projesi (`res://` = `game/`) | Veri odaklı; testli; Mobile |
| `tools/` | Kurulum, sarmalayıcılar, QA, MCP araçları | |
| `docs/` | Altyapı, yol haritası, ilerleme, devir | |
| `.agents/` | Antigravity: kurallar, yetenekler, MCP yapılandırması | |
| `out/` | Yerel çıktılar | git'e girmez |

## 8. Google araçları

Sahibin yönergesi: Google'ın araçlarını kullan. Her yeni araç için: önce küçük bir deneme, çalıştığını gör, sonra `docs/KAYNAKLAR.md`'ye yaz.

| Araç | Ne için | Durum |
|---|---|---|
| Gemini API (`generativelanguage.googleapis.com`) | Referans görseller (ön / yan / arka turnaround, T1.3), konsept | Eski oyunda kullanıldı; bu repoda **denenmedi**. Anahtar sahipten. Model adlarını çalışma anında güncel belgeden doğrula |
| Google Cloud TTS (Chirp 3 HD, ja-JP) | Japonca seslendirme: mevcut ~59 dk `audio/voice/` aynı hatla genişler | Planlı, **denenmedi** |
| Android CLI + Android Studio | SDK kurulumu, emülatör, cihaz, UI inceleme, profil | **Denenmedi** (T2.1). Godot'un Android dışa aktarımı (SDK + JDK + şablonlar + keystore) buna dayanır |
| Antigravity: skills, `/goal`, `/swarm`, MCP | Orkestrasyon ve otomasyon | Sahibin tarafında; ayrıntı `docs/DEVIR_GEMINI.md` |
| Firebase / Play Games Services / Play Console | Hesap, bulut kaydı, yayın | Karar bekliyor (`design/OYUN_TASARIM_PLANI.md` §7: sunucu kararı ilk oynanabilir sürümden sonra) |

## 9. Başka ajanlarla (Claude) birlikte çalışma

- Aynı anda **bir ajan bir görev**: `docs/ILERLEME.md` "Şu an aktif" tablosunda satırın yoksa başlama.
- Her çalışmadan önce `git pull --rebase`; her commit'ten sonra hemen `git push`. Çatışmada `docs/ILERLEME.md` satırlarını **birleştir**, başkasının satırını silme.
- `CLAUDE.md` Claude'un dosyasıdır; yalnız işaretçi ekle. `.mcp.json` Claude'un (kapsül yolları); Antigravity için `.agents/mcp_config.json`.
- `/swarm` ya da paralel ajan: yalnız birbirinden **bağımsız dizinlerde** (`art_src/`, `game/`, `docs/`); ayrı worktree kullan.

## 10. Takılınca (kontrolü geri ver)

- Aynı doğrulama **iki kez** düşerse: nedenini `docs/ILERLEME.md` "Sorunlar"a yaz, görevi ⛔ işaretle, sahibe üç satır özet yaz, başka göreve geç.
- Plan bir tasarım seçimini çözmüyorsa ya da bir arayüz beklenmedik davranıyorsa uydurma; karar günlüğüne soru olarak yaz.
- Emin olmadığın bir kural için `docs/KAYNAKLAR.md` ve `docs/ALTYAPI.md`'ye bak; orada yoksa sor.
