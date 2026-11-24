# UOMD — Çizim ve simge istekleri (tek dosya)

> Sahip, 2026-11-12: "Tüm oyun için gerekli bütün karakterler, kötü yaratıklar, ikonlar vs. için gerekli tüm eksik ve gerekli
> çizimleri oraya yaz; Codex'e yaptıracağız." Bu dosya **tek iş listesidir**: her satır bir teslim dosyası. Bitirilen satırın
> kutusu `[x]` yapılır. Teslim yolu her satırda yazılıdır; başka yere koyma. Motor tarafı (içe alma, şablonlar, klipler)
> Claude'dadır (PLAN §17 D10/D11); bu dosya yalnız çizimdir.
>
> **Ses üretimi de Codex'te (2026-11-22):** Gemini TTS ile kayıt alma, yeniden okutma ve sahibin ses/ton seçimlerini uygulama işi
> `docs/VOICE_REQUESTS.md`'dedir; çizim sırasını bozmadan, Gemini günlük sınırı açıldıkça oradaki döngüyü çalıştır.
>
> **Sahip, 2026-11-14 — görsel sıfırlama:** "Gemini'nin ses ve müziği hariç tüm assetleri sil, sadece Codex üzerinden görüntüler
> yapılacak; kodlama ve animasyon Claude'da." Oyundaki **bütün görseller silindi** (2.395 dosya: chibiler, portreler, arka planlar,
> arayüz kiti, afişler, efektler, videolar). Ses ve müzik (836 dosya) ve yazı tipleri duruyor. Silinenlerin yolu ve ölçüsü:
> `docs/art_bible/removed_2026-11-14.tsv`. Çizim gelene kadar oyun her eksik resmin yerine adından renk alan bir yer tutucu çizer,
> karakterler kemik animasyonlu siluet olarak oynar; yani oyun her an oynanır, gelen her resim kendi yerine oturur.

## 0. Codex için çalışma kuralları
1. Sıra: **P0 → P1 → P2 → P3**. Bir öncelik bitmeden sonrakine geçme.
2. Her teslimden sonra `.venv\Scripts\python.exe games/uomd/art_check.py` çalıştır (depo kökünden; düz `python` bu makinede
   Windows Store kısayoluna gider, kullanma): eksik/yanlış boyut/yanlış ad/saydam olmayan dosyayı listeler; temiz değilse düzelt.
   Rig'e çevirme (`art_import.py`), portre manifesti (`build_portrait_emotions.py`) ve animasyon Claude'un işidir; sen yalnız
   resmi doğru yola, doğru ölçüde koyarsın. Kod, sahne, test ve `docs/PLAN.md`'ye dokunma.
3. Görsellerde **yazı yok** (harf, rakam, sembol karakteri yok). Yazıyı oyun koyar; dil sonra değişebilir.
4. **Efekt resme gömülmez**: ışıma, iz, kıvılcım, büyü halkası, zemin çatlağı ayrı dosyadır (bkz. §C).
5. Arka plan **saydam** (PNG, RGBA, düz renkli zemin yok). Kenarlarda 8 px boş alan bırak (kırpılmasın). **İstisna:** §I.1'deki
   9 dilimli arayüz parçaları (panel, düğme, sekme, kart çerçevesi, rozet, ilerleme çerçevesi): onların çerçevesi dokunun
   kenarına değer, saydam pay **yok** (oyun dokuyu kutunun kenarına kadar gerer; 8 px pay her düğmeyi 16 px kısaltır).
6. **Tasarım kaynağı yazılı:** eski resimler yok; karakterin yüzü, saçı, kıyafeti, silahı ve renkleri `docs/art_bible/` içindeki
   metinden gelir (`heroes/<id>.md` 24 kahraman, `character_locks.md` Mahmut/Fadyme ve kötüler, `enemies.md` düşmanlar,
   `locations.md` mekânlar, `costume_guide.md` ortak kıyafet dili). Bir karakterin **ilk teslim edilen resmi onun kilididir**:
   aynı karakterin sonraki bütün resimleri (chibi, portre ifadeleri, tam boy, kesme şeridi) ona sadık kalır.
7. Telif: başka bir oyunun karakterini, logosunu, simgesini kopyalama; referans oyunlardan yalnız "tür kalitesi" alınır.
8. Teslim yolu = oyunun okuduğu yol. Satırdaki yolu aynen kullan (`games/uomd/...`, git'e girer). Oyun `assets/approved_art/<ad>`
   gibi eski adlarla istediği düz resimleri `games/uomd/art/<ad>` içinde de bulur (§M).

## 0.1 Adım adım sıra (partiler — PLAN §18 M16 A-satırları)
Her parti bitince: `art_check.py` temiz → o satırları `[x]` yap → commit ("art: parti N, <ne>"). Claude partiyi
oyuna bağlar (PLAN §18 aynı numaralı A-satırı) ve sorun bulursa satırın yanına not yazar; notlu satır bir sonraki partiden önce düzeltilir.
Bir partinin içinde tablo sırasıyla git. Ses ve müzik Codex'in işi değil (en son, Gemini API, PLAN §18 S).

| Parti | İçerik | Satır | Neden bu sırada |
| --- | --- | --- | --- |
| 0 | §I.1–I.2 arayüz kiti + §J.1 ekran arka planları + §L Mahmut ve Fadyme portreleri (7'şer ifade) | 18 + 18 + 4 + 2 | sıfırlamadan sonra her ekranın zemini; iki ana karakter ilk sahneden beri konuşuyor |
| 1 | §D11 arayüz yardımcıları + §E1 havuz afişleri | 20 + 17 | her ekranda görünür; çağırma ekranı afişsiz |
| 2a–2e | §A kahraman chibileri, 5'erli (tablo sırası) | 25 | savaşın kendisi; her 5'li ayrı içe alınır |
| 3a–3f | §B düşman ve boss chibileri, 5'erli (bosslar en son) | 27 | |
| 4 | §D1 eşya, §D2 para, §D7 durum, §D8 rol, §D10 gezinme simgeleri | 17 + 7 + 28 + 8 + 18 | metin yerine simge |
| 5 | §C efektler + §H etkinlik ortak parçaları (ilk tablo) | 22 + 18 | savaş hissi, etkinlik ekranı |
| 6 | §D3–D6 ekipman, §E2'nin P2 7 tam boyu, §G mağaza, §H.2 yan hikâye afişleri + portreler, §H.3 mod görselleri | 20 + 25 + 12 + 7 + 7 + 5 + 27 + 10 | |
| 7 | §D9 beceri simgeleri, §E2'nin kalan tam boyları, §F NPC portreleri | 100 + 18 + 3 | en uzun |
| 8 | §K prolog sahneleri + §J.2 kampanya mekânları (P1) + §L kahraman portreleri + §I.5 kesme şeritleri | 9 + 46 + 23 + 25 | hikâyenin kendisi |
| 9 | §J.2 yan etkinlik mekânları (P2) + §L kötüler ve Ash Circle konuşmacıları + §M Ash Circle + §I.3–I.4 | 28 + 9 + 20 + 8 | en son |

Not: parti 0 her şeyden önce gelir; 8 ve 9, 2–7 ile aynı öncelik sırasına göre (P1 önce) araya girebilir.

## 0.2 Düzeltme listesi — Claude'un notları (sıradaki partiden önce yap)
Claude 2026-11-15'te oyunun 17 sahnesini tek tek inceledi (PLAN §19 G10). Kodla çözülemeyen, teslim edilmiş resimdeki sorunlar
burada; ilgili satırların kutusu yeniden `[ ]` yapıldı ve yanına not yazıldı. Aynı yol, aynı boyut, aynı `theme.json` kenar payı.

| # | Dosyalar | Sorun (oyunda görülen) | İstenen |
| --- | --- | --- | --- |
| 1 | `panel_normal`, `panel_hot`, `panel_active` | Köşelerden zincirle sarkan çan süsleri panelin içine ~48×46 px giriyor; oyunda ~55 panel başlığı (ör. "PART I CHRONICLE", "OWNED HEROES", "ACTIVE SANCTUARY BANNERS") ve bazı alt satırlar tam bu süsün üstüne düşüyor | Köşe süsü çerçeve çizgisine yapışık, düz bir kıvrım; her kenardan en fazla **22 px** içeri girsin, içeri sarkan çan yok. Orta alan düz kalsın |
| 2 | §I.1'in bütün 9 dilimli parçaları: `panel_normal`, `panel_hot`, `panel_active`, `button_primary`, `button_secondary`, `button_tab_active`, `button_tab_inactive`, `frame_card_3star`, `frame_card_4star`, `frame_card_5star`, `badge_pill`, `progress_frame` | Dokunun her kenarında 8 px saydam pay var (opak alan 8..W-8). Oyun dokuyu kutunun tamamına gerdiği için her düğme ve çerçeve kutusundan 16 px küçük görünüyor; 44 px'lik bir sekme ekranda 28 px (Denemeler ekranındaki mod sekmeleri) | Çerçeve dokunun kenarına değsin (saydam pay 0). Boyut ve `theme.json` kenar payları aynı kalsın; süsler o payın içinde |


## 0.4 Ekran incelemesinden Codex'e not — Claude (2026-11-22, 316/649 teslim sonrası)
`games/uomd/review_screens.py` ile oturum açılmış hâlde dört veri ekranı, `store_screenshots.py` ile sekiz mağaza karesi ve panelden 17 sahne tek tek
gözden geçirildi. Teslim edilen **405 resmin hepsi oyunda kullanılıyor** (kodda ya da kurulan adla yükleniyor; kullanılmayan yok) ve gerçek resimle çiziliyor.
Bugün bir oyuncunun ilk saatinde gördüğü **yer tutucular ve boş yüzeyler** şunlar; sıra, görülme sırasına göredir (yolları ve boyutları ilgili bölümlerde):

1. **§K Prolog 9 resim (P0)** — TAP TO START'tan sonra oyuncunun gördüğü ilk ekran bugün düz yeşil/pembe bir zemin ve yalnız altyazı. Bu dokuz resim gelmeden ilk açılış
   "bitmemiş" görünür; ilk AAB'nin ve Play ekran görüntüsünün önündeki tek P0 budur.
2. **§D8 rol simgeleri (8) ve §D10 gezinme simgeleri (18) (P1)** — Şirket ve Kadro ekranlarındaki kahraman plakası artık **rol + element** gösteriyor (rol yalnız yazı); simge gelince yanına
   oturacak (`GothicUIKit.has_icon` kuralı: dosya gelince kendiliğinden görünür, kod değişmez).
3. **§D2 para ve puanlar (7) (P1)** — her ekranın başlığındaki "Bell's Remains 12,840" ve Ödüller/Mağaza/Çağırma yazıları simgesiz.
4. **§H Etkinlik görselleri (18) ve §H.3 Mod görselleri (8) (P1'e çıkarıldı)** — Etkinlikler ve Denemeler ekranlarında bugün kart başına resim yok; ekranların yarısı boş. H.3 (Hunts, Pilgrim, Oath,
   Reliquary, Dispatch, Ash Circle…) Denemeler ekranındaki mod kartlarına girecek.
5. **§D1 eşyalar (3/17), §D3–D6 silah/zırh/aksesuar (64) (P2)** — Cephanelik'te yadigâr listesi ve ayrıntısı yalnız yazı; resim gelince listede ve ayrıntıda görünecek.
6. **§M Ash Circle (20) (P2)** — arena zemini (`bg_sol_ac_arena_ground.webp`) olmadığı için giriş sahnesi düz gri; bu tek dosya ilk istek.
7. **§E2 tam boy kahraman çizimleri (25) (P2 → P3)** — Şirket ekranı artık kahramanın **tüm boyunu** ortada tutuyor (AFK Arena ve Reverse: 1999'un karakter sayfası gibi) ve bunun için bugün §L'nin
   `composed.webp` portresini (768×1152) kullanıyor; hepsinde çok iyi duruyor, E2 gelene kadar beklemeye gerek yok. E2 gelirse aynı yere (400×600 çerçeve) daha büyük boy oturur.
8. **§L eksik 7 temel ifade** (`27/34`) — konuşan 7 karakterin ifadeleri eksik; hikâyede `composed`'a düşüyorlar (oyun bozulmuyor).

Gözlem (istek değil): Mağaza ekranındaki afiş (`oath_02_sable`) bu hâliyle Play sayfasına girecek bir kareyi etkileyebilir; mağaza/IARC yanıtlarında "açık kıyafet" işaretli, yine de ekran görüntüsüne
alınacak karelerde daha ölçülü bir afiş tercih edilir.

## 0.3 Oyun sırasına göre sıra — Claude'un notu (2026-11-21, 109/649 teslim sonrası)
Parti 2a–2e (25/25 kahraman) ve 3a'nın 5 düşmanı **oyunda**: 25 kahramanın tamamı ve Bölüm 1'in 3 düşmanı savaşta gerçek
çizimle oynuyor (`art_import.py` ile bağlandı; kurt, iskelet, zincirli kültçü şablonları temiz; yırtılma yok). Teslim kalitesi çok
iyi, düzeltme yok. Ama oyuncu oyunu **Bölüm 1'den başlayarak sırayla** oynar ve bugün ilk saatte üç şey hâlâ yer tutucu: savaş ve
hikâye zemini (düz yeşil), Bölüm 1 bossu (`boss_ash_maw`) ve konuşan karakterlerin çoğu. Bu yüzden §0.1'deki tür sırası yerine
**aşağıdaki bölüm sırasını** izle: her bölüm bitince oyuncu o bölümü baştan sona çizimle oynayabilir (ilk AAB'nin dikey dilimi).
Kimlikler hikâye ve savaş dosyalarından, oyun sırasıyla çıkarıldı (kaç düğümde kullanıldığı parantezde; Zor modlar aynı mekânı kullanır).
Satırların kendisi aynı: yol, boyut ve kurallar yukarıdaki bölümlerde. Yalnızca **sıra** değişiyor.

| Sıra | Düşman/boss chibisi (§B) | Mekân (§J.2) | Konuşan karakter (§L = 7 ifade, §F) |
| --- | --- | --- | --- |
| **Bölüm 1** Whispering Ash Forest | ~~ash_wolf~~ ~~hollow_pilgrim~~ ~~bellbound_dead~~ ~~boss_ash_maw~~ (2026-11-21 oyunda) | ~~**forest_whispering_ash**~~ (oyunda; savaş ve hikâye şimdi çok güzel) | ~~kera_voss~~ ~~brin_alder~~ ~~nixie_vale~~ ~~lady_yseldra_vale~~ ~~shrine_keeper~~ (parti 3c, oyunda; 1-2 sahnesi gerçek zemin ve portrelerle çok güzel) |
| **Bölüm 2** Saint Luthos | ~~hollow_cleric~~ ~~inkbound_dead~~ ~~choir_knight~~ ~~boss_bell_widow~~ (2026-11-21 oyunda) | ~~forest_edge_road~~ ~~**cathedral_saint_luthos**~~ (oyunda) | ~~sister_aveline~~ ~~mirel_quill~~ (oyunda) — **Bölüm 2 çizimle baştan sona oynanıyor** |
| **Bölüm 3** Oakhaven | orchard_ghoul, red_vial_scout, corrupted_mercenary, **boss_captain_rusk** | orchard_lowlands, **village_oakhaven** (10), oakhaven_inn | jori_flint, pippa_bell, rusk |
| **Bölüm 4** Undercity | glass_viper, red_vial_alchemist, ~~chain_cultist~~, **boss_red_vial_matron** | river_city_gates, **undercity_subterranean** (10) | odelia_pike, tilda_fen, iona_mist, clem_marr, alchemist (§F), red_vial_matron |
| **Bölüm 5** Bridge | lost_vow_knight, ~~bridge_revenant~~, corrupted_crown_guard, **boss_marshal_oren** | eastern_ravine_road, **bridge_forsaken** (10), bridge_far_bank | marek_vane, nara_vell, rikka_ember, sable_wren, refugee_woman (§F), marshal_oren |
| **Bölüm 6** Ashen Lord's Estate | noble_retainer, estate_wraith, **boss_ashen_lord_wraith** | eastern_highland_road, **estate_ashen_lord** (10), ashen_estate_ruins | hana_birch, vespera_wisp, thistle_roe, ashen_lord_wraith |
| **Bölüm 7** Altar of the First Eclipse | royal_hollow, crownless_knight, eclipse_sentinel, **boss_eclipse_construct** | mountain_crater_rim, **altar_first_eclipse** (10), altar_first_eclipse_outer_dais, altar_first_eclipse_reflection | eclipse_construct, lord_cael_veyr |

**2026-11-22 gece (316/649):** B 27/27, J.2 74/74, §F 3/3, §L 27/34, logo kenarı temizlendi: hepsi içe aktarıldı ve oyunda (Bölüm 3 savaşı gözle bakıldı: Oakhaven zemini çok güzel). Tek gözlem: Bölüm 3+ düşmanları (ör. orchard_ghoul) gerçekçi orantılı ve kahramanlardan ~%40 büyük, kahramanlar ise 2–2,5 baş boy chibi; kasıtlıysa sorun yok, değilse sonraki düşmanlarda §1'deki chibi oranına yaklaşılabilir. Kalan: §L 7 portre, §K prolog 9, §D (eşya/para/silah/zırh/rol/beceri/gezinme simgeleri), §E2 tam boy çizimler, §H etkinlikler, §M.

**2026-11-22 akşam (204/649):** §I.5 25/25 ve §G 5/5 geldi ve bağlandı (simge güvenli bölgede, öne çıkan görsel temiz; teşekkürler). Tek not: `art_src/branding/logo.png`'de harf kenarlarında ince kırmızımsı halka var (kenar piksellerinin %4'ü; koyu zeminde görünür). Sırası gelince temiz kenarla (halesiz alfa) yeniden verilirse iyi olur; bloklayıcı değil. **Sıradaki: Bölüm 3** (tablodaki sıra).

**2026-11-22 (194/649):** §I.5 kesme şeritleri 20/25 (parti 8a–8d oyunda; Marek Vane'e gözle bakıldı, düzeltme yok). Sıra şimdi: **(1) §I.5'in kalan 5 şeridi, (2) §G (logo, uyarlanabilir simge ön plan/arka plan/tek renk, Play öne çıkan görseli 1024×500)** — Google Play ilk yükleme için 512×512 simge ve 1024×500 görsel ister, uygulama simgesi de AAB'ye girer; ikisi de P2'den P1'e alındı — **(3) Bölüm 3** (tablodaki sıra).

Önemli sonuçlar:
- **Ana kampanya yalnızca 18 mekân kullanıyor** (yukarıdaki tablo; kalın olanlar bölümün ana mekânı, her biri 10+ düğümde). §J.2'nin kalan
  ~28 P1 satırı yoldaş yan hikâyelerinin mekânları: ana kampanyadan **sonra**. Yani 18 arka planla bütün ana hikâye ve savaşlar zeminli olur.
- **İki boss hikâyede de konuşuyor** (`boss_ashen_lord_wraith` ve `boss_eclipse_construct` hem savaş chibisi hem §L portresi):
  ikisi aynı karakterin kilidi, birbirine sadık kal; öteki bosslar (Ash-Maw, Rusk, Oren, Matron, Bell-Widow) için de aynı kural.
- Bölümlerden bağımsız, **her savaşta görünen** üç grup ve bunlar Bölüm 1'in ilk savaşından itibaren bekliyor: §C efekt kareleri (22:
  vuruş, ışık, büyü halkası; şimdi hiçbir vuruşun görseli yok), §D7 durum etkisi simgeleri (28; şimdi oyuncu birimlerinin plakasında
  "TRAIL MARK 2" yazısı çıkıyor) ve §I.5 kesme şeritleri (25 ultimate). Bunları **Bölüm 1 + 2 tamamlandıktan hemen sonra**, tür
  sırasını beklemeden al; sonra Bölüm 3'ten devam.
- Savaş sonu ve ödül ekranları §D1 eşya (17) ve §D2 para (7) simgesini bekliyor; ödül satırları şimdilik yalnız yazı. §D1/D2 efektlerden sonra.

## 1. Ortak stil
- **Dünya:** karanlık gotik masal, çanlar, kül, mum ışığı; sıcak kenar ışığı (amber/altın), soğuk gölge (mor-lacivert).
- **Chibi oranı:** 2–2,5 baş boy; büyük baş, kısa gövde; çizgi kalınlığı 3–4 px (1024 px yükseklikte), boyalı (painterly) gölge.
- **Bakış:** savaşta bütün birimler **3/4 görünüş, ekranın sağına bakar** (düşmanları motor aynalar).
- **Element renkleri:** Ember turuncu-kırmızı `#E8572A`, Tide deniz mavisi `#2F7FD0`, Gale yeşil `#5FC48A`,
  Stone toprak-altın `#B38A4A`, Veil mor `#8A4FD0`, Dawn açık altın `#F2D27A`.
- **Simgeler:** aynı ışık yönü (sol üst), aynı kalın dış hat, hafif iç parıltı; yuvarlak/kalkan çerçeve **yok** (çerçeveyi
  oyun nadirliğe göre çizer).

## 2. Teknik biçimler
| Tür | Boyut | Biçim | Not |
| --- | --- | --- | --- |
| Katmanlı chibi | 1024×1024 tuval, karakter ~900 px boy | Her katman ayrı PNG, hepsi **aynı tuvalde, yerinde** | + `pivots.json` (eklem noktaları, bkz. §A.2) |
| Simge | 256×256 | PNG RGBA | İçerik 216×216 alanda ortalı |
| Durum etkisi simgesi | 128×128 | PNG RGBA | 32 px'e küçülünce okunmalı |
| Havuz afişi | 2592×1080 | WebP (kalite 90) | Önemli içerik orta 1920×1080'de; sağ alt 900×300 boş (düğmeler) |
| Kahraman tam boy çizimi | 1600×2400 | PNG RGBA | Diz üstü değil, tam boy; saydam |
| Efekt kareleri | 512×512 kare başına | PNG şerit (kareler yan yana) | Toplamalı (additive) olarak oynatılacak: siyah değil saydam zemin |
| Portre (VN) | 768×1152 | WebP/PNG RGBA, ifade başına tek resim | `games/uomd/art/portraits/<id>/<ifade>.webp` (§L); katman yok, nefes animasyonu motorda |
| Arka plan | 1920×1080 | WebP (kalite 90) | yazısız, karakter yok (§J) |
| Prolog sahnesi | 1920×1080 | WebP | §K |
| Arayüz kiti | satırdaki boyut | PNG RGBA | 9 dilim payı `theme.json`'da (§I) |

## 3. Öncelikler (özet)
- **P0 (sıfırlama)** — arayüz kiti (§I.1–I.2), ekran arka planları (§J.1), Mahmut ve Fadyme'nin 7 ifadesi (§L).
- **P1 (sıfırlama)** — 46 kampanya mekânı (§J.2), 9 prolog sahnesi (§K), 23 kahramanın 7 ifadesi (§L), 25 kesme şeridi (§I.5).
- **P2 (sıfırlama)** — 28 yan etkinlik mekânı (§J.2), kötülerin ve Ash Circle konuşmacılarının portreleri (§L), Ash Circle (§M),
  canlı arayüz kareleri (§I.3); **P3** parçacık dokuları (§I.4).
- **P0** — 25 kahramanın katmanlı savaş chibisi (§A), 17 havuz afişi (§E1), arayüz yardımcı simgeleri (§D11).
- **P1** — 27 düşman/boss katmanlı chibisi (§B), eşya ve para simgeleri (§D1–D2), durum etkileri (§D7), rol simgeleri (§D8),
  gezinme simgeleri (§D10), efektler (§C).
- **P2** — silah/zırh/aksesuar simgeleri (§D3–D6), 7 öne çıkan kahramanın tam boy çizimi (§E2), uygulama/mağaza görselleri (§G).
- **P3** — 100 beceri simgesi (§D9), kalan 18 kahramanın tam boy çizimi, 3 NPC portresi (§F), etkinlik görselleri (§H).
- **P2 (D13)** — eski projeden gelen 7 yan hikâye etkinliğinin afiş + şeridi ve 13 yan karakter portresi (§H.2).
- **P2 (M16)** — mod simgeleri, Pilgrim's Trial ve Oath Hunt afişleri (§H.3); Reliquary Medal ve etkinlik parası (`sun_eclipse_token`) simgeleri §D1'de.
## A. Katmanlı savaş chibileri — kahramanlar (P0)

### A.1 Neden
Savaş chibisi katmanlı çizilir: kol ve silah sert parça olarak döner, gövde ezilip uzar, pelerin ayrı sallanır (tek parça resim
bükülünce kol/silah gerçekten savrulamaz, PLAN D10). Oyunda şu an bu birimler dokusuz siluet olarak oynuyor.

### A.2 İnsan şablonu (`humanoid`) — katmanlar ve eklemler
Klasör: `games/uomd/art_src/chibi/<id>/`. Katman dosyaları (alttan üste, bu sırayla çizilir):

| Dosya | İçerik | Bağlandığı kemik |
| --- | --- | --- |
| `00_cape_hair.png` | Arka saç + pelerin/etek arkası (gövdenin arkasında kalan her şey) | `cape_hair` (yay ile sallanır) |
| `01_arm_l.png` | **Uzak kol** (ekranda arkadaki): omuzdan parmak ucuna, tuttuğu kalkan/kitap/fener dahil | `arm_l` |
| `02_leg_l.png` | Uzak bacak: kalçadan ayak ucuna | `leg_l` |
| `03_leg_r.png` | Yakın bacak | `leg_r` |
| `04_pelvis.png` | Kalça, kemer, etek önü | `pelvis` |
| `05_torso.png` | Gövde, göğüs zırhı, boyun | `torso` |
| `06_head.png` | Baş: yüz, ön saç, şapka/başlık | `head` |
| `07_arm_r.png` | **Yakın kol + ana silah** (kılıç/mızrak/asa elde, tek parça) | `arm_r` |

Kurallar:
- Her katman **eklemin altına 20–30 px taşar** (kol katmanı omuzun içine, bacak kalçanın içine boyanır); döndüğünde boşluk
  görünmez. Gövde katmanı omuz ve kalça bölgesini tam boyalı içerir.
- İki elle tutulan silah (mızrak, glaive, uzun yay): silah `07_arm_r` içinde; uzak el silahın üstünde görünüyorsa o el
  `07_arm_r`'ye boyanır.
- `pivots.json` (piksel, tuval koordinatı, sol üst 0,0):
```json
{"template": "humanoid", "facing": "right",
 "joints": {"ground": [512, 980], "pelvis": [512, 640], "chest": [512, 470], "neck": [512, 395], "head_top": [512, 90],
            "shoulder_l": [440, 430], "hand_l": [400, 640], "shoulder_r": [585, 430], "hand_r": [640, 640],
            "hip_l": [470, 650], "foot_l": [455, 975], "hip_r": [555, 650], "foot_r": [570, 975],
            "cape_root": [470, 400], "cape_tip": [400, 760]}}
```
- Kontrol: katmanlar üst üste konunca tek parça, temiz bir chibi görünür; karakter `docs/art_bible/` tarifine ve §L portresine
  uyar (aynı yüz, saç, kıyafet, silah), 3/4 sağ açıda (§1).

### A.3 Kahraman listesi
| ✓ | Kimlik | Ad | Element | Rol | Silah (elde) | Teslim | Not |
| --- | --- | --- | --- | --- | --- | --- | --- |
| [x] | `mahmut` | Mahmut | Stone | tank_bruiser | Arming Sword | `games/uomd/art_src/chibi/mahmut/` (8 katman + pivots.json) |  |
| [x] | `fadyme` | Fadyme | Veil | support_dps | Bell Focus | `games/uomd/art_src/chibi/fadyme/` (8 katman + pivots.json) | Uzun boylu (230×325): oranı diğerlerine eşitle |
| [x] | `kera_voss` | Kera Voss | Ember | alchemist_dps | Alchemy Mortar | `games/uomd/art_src/chibi/kera_voss/` (8 katman + pivots.json) |  |
| [x] | `brin_alder` | Brin Alder | Stone | tank | Axe and Buckler | `games/uomd/art_src/chibi/brin_alder/` (8 katman + pivots.json) |  |
| [x] | `nixie_vale` | Nixie Vale | Gale | ranged_dps | Shortbow | `games/uomd/art_src/chibi/nixie_vale/` (8 katman + pivots.json) |  |
| [x] | `sister_aveline` | Sister Aveline | Dawn | healer | Reliquary Staff | `games/uomd/art_src/chibi/sister_aveline/` (8 katman + pivots.json) |  |
| [x] | `sable_wren` | Sable Wren | Veil | assassin_dps | Twin Daggers | `games/uomd/art_src/chibi/sable_wren/` (8 katman + pivots.json) |  |
| [x] | `tilda_fen` | Tilda Fen | Tide | healer | Healer Staff | `games/uomd/art_src/chibi/tilda_fen/` (8 katman + pivots.json) |  |
| [x] | `rikka_ember` | Rikka Ember | Ember | bruiser_dps | Spear | `games/uomd/art_src/chibi/rikka_ember/` (8 katman + pivots.json) |  |
| [x] | `mirel_quill` | Mirel Quill | Dawn | buffer | Astrolabe Folio | `games/uomd/art_src/chibi/mirel_quill/` (8 katman + pivots.json) |  |
| [x] | `odelia_pike` | Odelia Pike | Tide | debuff_archer | Longbow | `games/uomd/art_src/chibi/odelia_pike/` (8 katman + pivots.json) |  |
| [x] | `pippa_bell` | Pippa Bell | Gale | buffer_bard | Lute and Sling | `games/uomd/art_src/chibi/pippa_bell/` (8 katman + pivots.json) |  |
| [x] | `nara_vell` | Nara Vell | Stone | tank_support | Glaive and Shield | `games/uomd/art_src/chibi/nara_vell/` (8 katman + pivots.json) |  |
| [x] | `clem_marr` | Clem Marr | Veil | debuffer | Ritual Lantern | `games/uomd/art_src/chibi/clem_marr/` (8 katman + pivots.json) |  |
| [x] | `vespera_wisp` | Vespera Wisp | Veil | mage_dps | Glass Focus | `games/uomd/art_src/chibi/vespera_wisp/` (8 katman + pivots.json) |  |
| [x] | `hana_birch` | Hana Birch | Stone | counter_dps | Hatchet and Trap | `games/uomd/art_src/chibi/hana_birch/` (8 katman + pivots.json) |  |
| [x] | `thistle_roe` | Thistle Roe | Gale | healer_support | Thorn Crook | `games/uomd/art_src/chibi/thistle_roe/` (8 katman + pivots.json) |  |
| [x] | `iona_mist` | Iona Mist | Tide | healer | Tidal Censer | `games/uomd/art_src/chibi/iona_mist/` (8 katman + pivots.json) |  |
| [x] | `jori_flint` | Jori Flint | Ember | guard | Hammer and Shield | `games/uomd/art_src/chibi/jori_flint/` (8 katman + pivots.json) |  |
| [x] | `marek_vane` | Marek Vane | Gale | control_buffer | Spear and Signal Horn | `games/uomd/art_src/chibi/marek_vane/` (8 katman + pivots.json) |  |
| [x] | `garrick_cinder` | Garrick Cinder | Ember | siege_breaker_dps | Glaive and Shield | `games/uomd/art_src/chibi/garrick_cinder/` (8 katman + pivots.json) |  |
| [x] | `corbin_locke` | Corbin Locke | Tide | harpoon_vanguard | Spear | `games/uomd/art_src/chibi/corbin_locke/` (8 katman + pivots.json) |  |
| [x] | `cassian_thorne` | Cassian Thorne | Dawn | reliquary_templar | Arming Sword | `games/uomd/art_src/chibi/cassian_thorne/` (8 katman + pivots.json) |  |
| [x] | `dorian_kesk` | Dorian Kesk | Veil | cipher_debuffer_dps | Twin Daggers | `games/uomd/art_src/chibi/dorian_kesk/` (8 katman + pivots.json) |  |
| [x] | `rowan_reed` | Rowan Reed | Dawn | shrine_support | Ritual Lantern | `games/uomd/art_src/chibi/rowan_reed/` (8 katman + pivots.json) |  |

## B. Katmanlı savaş chibileri — düşmanlar ve bosslar (P1)

Şablonlar (`pivots.json` içindeki `template`):
- **humanoid** — §A.2 ile aynı 8 katman.
- **humanoid_large** — aynı katmanlar, tuval 1536×1536 (iri gövde; boss ve hantal yaratıklar).
- **beast** (dört ayaklı) — katmanlar: `00_tail`, `01_leg_bl` (arka uzak), `02_leg_fl` (ön uzak), `03_body`, `04_leg_br`,
  `05_leg_fr`, `06_head` (boyun dahil). Eklemler: `ground, hips, shoulders, neck, snout, tail_root, tail_tip,
  hip_bl, paw_bl, hip_br, paw_br, shoulder_fl, paw_fl, shoulder_fr, paw_fr`. Tuval 1536×1024.
- **serpent** — katmanlar: `00_tail`, `01_body_3`, `02_body_2`, `03_body_1`, `04_head`; eklemler: `ground`, `p0` (kuyruk ucu),
  `p1`, `p2`, `p3`, `p4` (baş dibi), `head_tip`. Gövde bölümleri birbirinin altına 30 px taşar. Tuval 1536×1024.
- **floater** (süzülen, bacaksız) — katmanlar: `00_robe_tail` (alt dalgalı kısım), `01_arm_l`, `02_torso`, `03_head`,
  `04_arm_r`, isteğe bağlı `05_prop` (taşıdığı nesne); eklemler: `hover` (gölgenin düşeceği yer), `chest, neck, head_top,
  shoulder_l, hand_l, shoulder_r, hand_r, tail_tip`.

| ✓ | Kimlik | Ad | Element | Şablon | Teslim | Not |
| --- | --- | --- | --- | --- | --- | --- |
| [x] | `bellbound_dead` | Bellbound Dead | Veil | humanoid | `games/uomd/art_src/chibi/bellbound_dead/` |  |
| [x] | `hollow_pilgrim` | Hollow Pilgrim | Veil | humanoid | `games/uomd/art_src/chibi/hollow_pilgrim/` |  |
| [x] | `ash_wolf` | Ash Wolf | Ember | beast | `games/uomd/art_src/chibi/ash_wolf/` |  |
| [x] | `bridge_revenant` | Bridge Revenant | Veil | humanoid | `games/uomd/art_src/chibi/bridge_revenant/` |  |
| [x] | `chain_cultist` | Chain Cultist | Veil | floater | `games/uomd/art_src/chibi/chain_cultist/` |  |
| [x] | `choir_knight` | Choir Knight | Dawn | humanoid | `games/uomd/art_src/chibi/choir_knight/` |  |
| [x] | `corrupted_crown_guard` | Corrupted Crown Guard | Stone | humanoid_large | `games/uomd/art_src/chibi/corrupted_crown_guard/` | Arkadaki savrulma yayı resme gömme; ayrı efekt: `fx/crown_guard_sweep`. |
| [x] | `corrupted_mercenary` | Corrupted Mercenary | Ember | humanoid | `games/uomd/art_src/chibi/corrupted_mercenary/` |  |
| [x] | `crownless_knight` | Crownless Knight | Stone | humanoid | `games/uomd/art_src/chibi/crownless_knight/` |  |
| [x] | `eclipse_sentinel` | Eclipse Sentinel | Veil | humanoid | `games/uomd/art_src/chibi/eclipse_sentinel/` |  |
| [x] | `estate_wraith` | Estate Wraith | Veil | floater | `games/uomd/art_src/chibi/estate_wraith/` |  |
| [x] | `glass_viper` | Glass Viper | Tide | serpent | `games/uomd/art_src/chibi/glass_viper/` |  |
| [x] | `hollow_cleric` | Hollow Cleric | Veil | humanoid | `games/uomd/art_src/chibi/hollow_cleric/` |  |
| [x] | `inkbound_dead` | Inkbound Dead | Veil | humanoid | `games/uomd/art_src/chibi/inkbound_dead/` | Soldaki mürekkep sembolü resme gömme; ayrı efekt: `fx/inkbound_sigil`. |
| [x] | `lost_vow_knight` | Lost-Vow Knight | Stone | humanoid | `games/uomd/art_src/chibi/lost_vow_knight/` | Kılıç savuruş izi ve yerdeki kırık taşlar resme gömme; ayrı efekt: `fx/lost_vow_knight_slash`. |
| [x] | `noble_retainer` | Noble Retainer | Dawn | humanoid | `games/uomd/art_src/chibi/noble_retainer/` | Büyü kalkanı ve altındaki kaide resme gömme; ayrı efekt: `fx/noble_retainer_ward`. |
| [x] | `orchard_ghoul` | Orchard Ghoul | Veil | humanoid_large | `games/uomd/art_src/chibi/orchard_ghoul/` |  |
| [x] | `red_vial_alchemist` | Red Vial Alchemist | Ember | humanoid | `games/uomd/art_src/chibi/red_vial_alchemist/` |  |
| [x] | `red_vial_scout` | Red Vial Scout | Gale | humanoid | `games/uomd/art_src/chibi/red_vial_scout/` |  |
| [x] | `royal_hollow` | Royal Hollow | Stone | humanoid | `games/uomd/art_src/chibi/royal_hollow/` |  |
| [x] | `boss_ash_maw` | The Ash-Maw | Ember | humanoid_large | `games/uomd/art_src/chibi/boss_ash_maw/` | **BOSS**  |
| [x] | `boss_bell_widow` | The Bell-Widow | Veil | humanoid | `games/uomd/art_src/chibi/boss_bell_widow/` | **BOSS**  |
| [x] | `boss_captain_rusk` | Captain Rusk | Gale | humanoid | `games/uomd/art_src/chibi/boss_captain_rusk/` | **BOSS**  |
| [x] | `boss_red_vial_matron` | The Red Vial Matron | Ember | humanoid | `games/uomd/art_src/chibi/boss_red_vial_matron/` | **BOSS** Elindeki alev ve şişe parıltısı → efekt değil ama `arm_r` içinde kalsın; ışıma halesi ayrı efekt: `fx/red_vial_glow`. |
| [x] | `boss_marshal_oren` | Marshal Oren | Stone | humanoid | `games/uomd/art_src/chibi/boss_marshal_oren/` | **BOSS**  |
| [x] | `boss_ashen_lord_wraith` | The Ashen Lord's Wraith | Veil | floater | `games/uomd/art_src/chibi/boss_ashen_lord_wraith/` | **BOSS** Çerçeveli ayna (portre) bir sahne parçası: `prop` katmanı olarak ver, hayalet ayrı. |
| [x] | `boss_eclipse_construct` | Eclipse Construct | Veil | humanoid_large | `games/uomd/art_src/chibi/boss_eclipse_construct/` | **BOSS**  |

## C. Efekt kareleri (P1)
Klasör `games/uomd/art_src/fx/`. Şerit PNG: kareler yan yana, kare 512×512, saydam zemin, beyaza yakın çekirdek + element rengi
kenar (oyun toplamalı çizer). Kare sayısı ve süre satırda.

| ✓ | Dosya | İçerik | Kare | Süre |
| --- | --- | --- | --- | --- |
| [x] | `games/uomd/art_src/fx/hit_ember.png` | Ember vuruş patlaması (darbe anı) | 8 | 0,27 sn |
| [x] | `games/uomd/art_src/fx/hit_tide.png` | Tide vuruş patlaması (darbe anı) | 8 | 0,27 sn |
| [x] | `games/uomd/art_src/fx/hit_gale.png` | Gale vuruş patlaması (darbe anı) | 8 | 0,27 sn |
| [x] | `games/uomd/art_src/fx/hit_stone.png` | Stone vuruş patlaması (darbe anı) | 8 | 0,27 sn |
| [x] | `games/uomd/art_src/fx/hit_veil.png` | Veil vuruş patlaması (darbe anı) | 8 | 0,27 sn |
| [x] | `games/uomd/art_src/fx/hit_dawn.png` | Dawn vuruş patlaması (darbe anı) | 8 | 0,27 sn |
| [x] | `games/uomd/art_src/fx/slash_blade.png` | Kılıç/hançer savuruş izi (yay) | 6 | 0,2 sn |
| [x] | `games/uomd/art_src/fx/slash_heavy.png` | Ağır silah (balta, çekiç, glaive) izi | 6 | 0,2 sn |
| [x] | `games/uomd/art_src/fx/slash_thrust.png` | Mızrak saplama izi (düz) | 6 | 0,2 sn |
| [x] | `games/uomd/art_src/fx/arrow_trail.png` | Ok izi (uzayan çizgi) | 4 | 0,15 sn |
| [x] | `games/uomd/art_src/fx/cast_circle.png` | Büyü çemberi (yerde, beceri hazırlığı) | 12 | 0,5 sn |
| [x] | `games/uomd/art_src/fx/heal_bloom.png` | İyileşme çiçeklenmesi (yukarı süzülen ışık) | 10 | 0,5 sn |
| [x] | `games/uomd/art_src/fx/shield_up.png` | Kalkan belirme kubbesi | 8 | 0,35 sn |
| [x] | `games/uomd/art_src/fx/ultimate_burst.png` | Ultimate son vuruş patlaması (büyük, ekranı dolduran) | 12 | 0,5 sn |
| [x] | `games/uomd/art_src/fx/death_ash.png` | Ölümde küle dağılma | 12 | 0,6 sn |
| [x] | `games/uomd/art_src/fx/summon_rarity_5.png` | Çağırma: 5★ ışık sütunu | 16 | 1,0 sn |
| [x] | `games/uomd/art_src/fx/summon_rarity_4.png` | Çağırma: 4★ mor parıltı | 12 | 0,8 sn |
| [x] | `games/uomd/art_src/fx/lost_vow_knight_slash.png` | Lost-Vow Knight'ın yer yarığı (resimden çıkarılan) | 8 | 0,3 sn |
| [x] | `games/uomd/art_src/fx/noble_retainer_ward.png` | Noble Retainer büyü kalkanı (döngü) | 8 | 0,8 sn döngü |
| [x] | `games/uomd/art_src/fx/crown_guard_sweep.png` | Crown Guard savrulma yayı | 6 | 0,25 sn |
| [x] | `games/uomd/art_src/fx/inkbound_sigil.png` | Inkbound mürekkep sembolü (döngü) | 8 | 0,8 sn döngü |
| [x] | `games/uomd/art_src/fx/red_vial_glow.png` | Red Vial Matron şişe halesi (döngü) | 8 | 0,8 sn döngü |

## D. Simgeler
Hepsi `games/uomd/assets/icons/<grup>/<kimlik>.png`, 256×256 (durum etkileri 128×128). Çerçeve yok, yazı yok.

### D1. Eşyalar (P1)
| ✓ | Kimlik | Ad | Tür | Nadirlik | Teslim |
| --- | --- | --- | --- | --- | --- |
| [x] | `first_oath_invitation` | First Oath Invitation | recruit_selector | 4★ | `games/uomd/assets/icons/items/first_oath_invitation.png` |
| [x] | `torn_chronicle_page` | Torn Chronicle Page | character_xp | 3★ | `games/uomd/assets/icons/items/torn_chronicle_page.png` |
| [x] | `bound_chronicle` | Bound Chronicle | character_xp | 4★ | `games/uomd/assets/icons/items/bound_chronicle.png` |
| [ ] | `illuminated_chronicle` | Illuminated Chronicle | character_xp | 4★ | `games/uomd/assets/icons/items/illuminated_chronicle.png` |
| [ ] | `iron_oath_seal` | Iron Oath Seal | ascension | 4★ | `games/uomd/assets/icons/items/iron_oath_seal.png` |
| [ ] | `alchemy_core` | Alchemy Core | ascension | 4★ | `games/uomd/assets/icons/items/alchemy_core.png` |
| [ ] | `bellglass_shard` | Bellglass Shard | ascension | 4★ | `games/uomd/assets/icons/items/bellglass_shard.png` |
| [ ] | `blacksmith_rivet` | Blacksmith Rivet | equipment_xp | 3★ | `games/uomd/assets/icons/items/blacksmith_rivet.png` |
| [ ] | `forge_dust` | Forge Dust | crafting | 4★ | `games/uomd/assets/icons/items/forge_dust.png` |
| [ ] | `tactical_notes` | Tactical Notes | skill_rank | 3★ | `games/uomd/assets/icons/items/tactical_notes.png` |
| [ ] | `hymn_leaves` | Hymn Leaves | skill_rank | 4★ | `games/uomd/assets/icons/items/hymn_leaves.png` |
| [ ] | `memory_shard` | Memory Shard | duplicate_progression | 4★ | `games/uomd/assets/icons/items/memory_shard.png` |
| [ ] | `universal_memory_shard` | Universal Memory Shard | duplicate_progression | 4★ | `games/uomd/assets/icons/items/universal_memory_shard.png` |
| [ ] | `reliquary_medal` | Reliquary Medal | boss_shop | 4★ | `games/uomd/assets/icons/items/reliquary_medal.png` |
| [ ] | `t3_charm_blueprint` | T3 Accessory Blueprint | crafting | 4★ | `games/uomd/assets/icons/items/t3_charm_blueprint.png` |
| [ ] | `sun_eclipse_token` | Sun-Eclipse Event Token | event_exchange | 4★ | `games/uomd/assets/icons/items/sun_eclipse_token.png` |
| [ ] | `unwritten_hour_cinder` | Cinder of the Unwritten Hour | accessory_reroll_token | 5★ | `games/uomd/assets/icons/items/unwritten_hour_cinder.png` |

### D2. Para ve puanlar (P1)
| ✓ | Kimlik | Ad | Teslim | Not |
| --- | --- | --- | --- | --- |
| [ ] | `eclipse_token` | Bell's Remains (ana para) | `games/uomd/assets/icons/currency/eclipse_token.png` | §I.2 `icon_token` ile aynı çizim, büyük ve ayrıntılı |
| [ ] | `bell_tolls` | Bell Tolls (çağırma takası) | `games/uomd/assets/icons/currency/bell_tolls.png` | Küçük bronz çan + çentik |
| [ ] | `ration` | Ration (savaş enerjisi) | `games/uomd/assets/icons/currency/ration.png` | Kumanya çantası / ekmek + mum |
| [ ] | `account_xp` | Hesap deneyimi | `games/uomd/assets/icons/currency/account_xp.png` | Açık kitap üstünde ışık |
| [ ] | `patrol_gold` | Devriye ganimeti | `games/uomd/assets/icons/currency/patrol_gold.png` | Kese |
| [ ] | `arena_points` | Arena puanı | `games/uomd/assets/icons/currency/arena_points.png` | Çapraz kılıç arması |
| [ ] | `pass_points` | Sezon kartı puanı | `games/uomd/assets/icons/currency/pass_points.png` | Mühürlü şerit |

### D3. Silah türleri (P2)
| ✓ | Kimlik | Ad | Teslim |
| --- | --- | --- | --- |
| [ ] | `arming_sword` | Arming Sword | `games/uomd/assets/icons/weapon_types/arming_sword.png` |
| [ ] | `bell_focus` | Bell Focus | `games/uomd/assets/icons/weapon_types/bell_focus.png` |
| [ ] | `alchemy_mortar` | Alchemy Mortar | `games/uomd/assets/icons/weapon_types/alchemy_mortar.png` |
| [ ] | `axe_shield` | Axe and Buckler | `games/uomd/assets/icons/weapon_types/axe_shield.png` |
| [ ] | `shortbow` | Shortbow | `games/uomd/assets/icons/weapon_types/shortbow.png` |
| [ ] | `reliquary_staff` | Reliquary Staff | `games/uomd/assets/icons/weapon_types/reliquary_staff.png` |
| [ ] | `twin_daggers` | Twin Daggers | `games/uomd/assets/icons/weapon_types/twin_daggers.png` |
| [ ] | `healer_staff` | Healer Staff | `games/uomd/assets/icons/weapon_types/healer_staff.png` |
| [ ] | `spear` | Spear | `games/uomd/assets/icons/weapon_types/spear.png` |
| [ ] | `astrolabe_folio` | Astrolabe Folio | `games/uomd/assets/icons/weapon_types/astrolabe_folio.png` |
| [ ] | `longbow` | Longbow | `games/uomd/assets/icons/weapon_types/longbow.png` |
| [ ] | `lute_sling` | Lute and Sling | `games/uomd/assets/icons/weapon_types/lute_sling.png` |
| [ ] | `glaive_shield` | Glaive and Shield | `games/uomd/assets/icons/weapon_types/glaive_shield.png` |
| [ ] | `ritual_lantern` | Ritual Lantern | `games/uomd/assets/icons/weapon_types/ritual_lantern.png` |
| [ ] | `glass_focus` | Glass Focus | `games/uomd/assets/icons/weapon_types/glass_focus.png` |
| [ ] | `hatchet_trap` | Hatchet and Trap | `games/uomd/assets/icons/weapon_types/hatchet_trap.png` |
| [ ] | `thorn_crook` | Thorn Crook | `games/uomd/assets/icons/weapon_types/thorn_crook.png` |
| [ ] | `tidal_censer` | Tidal Censer | `games/uomd/assets/icons/weapon_types/tidal_censer.png` |
| [ ] | `hammer_shield` | Hammer and Shield | `games/uomd/assets/icons/weapon_types/hammer_shield.png` |
| [ ] | `spear_horn` | Spear and Signal Horn | `games/uomd/assets/icons/weapon_types/spear_horn.png` |

### D4. İmza silahları — her kahramanın 5★ silahı (P2)
Silahın kendisi, 3/4 açı, kahramanın chibisindeki silahla aynı tasarım ama ayrıntılı.

| ✓ | Kimlik | Ad | Sahibi | Tür | Teslim |
| --- | --- | --- | --- | --- | --- |
| [ ] | `weapon_mahmut_signature` | The Crestless Oath | Mahmut | Arming Sword | `games/uomd/assets/icons/weapons/weapon_mahmut_signature.png` |
| [ ] | `weapon_fadyme_signature` | The Hour Between Bells | Fadyme | Bell Focus | `games/uomd/assets/icons/weapons/weapon_fadyme_signature.png` |
| [ ] | `weapon_kera_voss_signature` | Redoubt's Last Vial | Kera Voss | Alchemy Mortar | `games/uomd/assets/icons/weapons/weapon_kera_voss_signature.png` |
| [ ] | `weapon_brin_alder_signature` | Alderwall's Promise | Brin Alder | Axe and Buckler | `games/uomd/assets/icons/weapons/weapon_brin_alder_signature.png` |
| [ ] | `weapon_nixie_vale_signature` | Windneedle Wayfinder | Nixie Vale | Shortbow | `games/uomd/assets/icons/weapons/weapon_nixie_vale_signature.png` |
| [ ] | `weapon_aveline_last_vigil` | Lantern of the Last Vigil | Sister Aveline | Reliquary Staff | `games/uomd/assets/icons/weapons/weapon_aveline_last_vigil.png` |
| [ ] | `weapon_sable_broken_bell` | Quietus at the Broken Bell | Sable Wren | Twin Daggers | `games/uomd/assets/icons/weapons/weapon_sable_broken_bell.png` |
| [ ] | `weapon_tilda_fen_signature` | Salt-Road Remedies | Tilda Fen | Healer Staff | `games/uomd/assets/icons/weapons/weapon_tilda_fen_signature.png` |
| [ ] | `weapon_rikka_ember_signature` | Procession's First Spark | Rikka Ember | Spear | `games/uomd/assets/icons/weapons/weapon_rikka_ember_signature.png` |
| [ ] | `weapon_mirel_unwritten_ledger` | The Unwritten Ledger | Mirel Quill | Astrolabe Folio | `games/uomd/assets/icons/weapons/weapon_mirel_unwritten_ledger.png` |
| [ ] | `weapon_odelia_pike_signature` | Breakwater's Eye | Odelia Pike | Longbow | `games/uomd/assets/icons/weapons/weapon_odelia_pike_signature.png` |
| [ ] | `weapon_pippa_bell_signature` | A Song Kept in Brass | Pippa Bell | Lute and Sling | `games/uomd/assets/icons/weapons/weapon_pippa_bell_signature.png` |
| [ ] | `weapon_nara_gatewarden_promise` | Gatewarden's Promise | Nara Vell | Glaive and Shield | `games/uomd/assets/icons/weapons/weapon_nara_gatewarden_promise.png` |
| [ ] | `weapon_clem_marr_signature` | The Name Beneath Stone | Clem Marr | Ritual Lantern | `games/uomd/assets/icons/weapons/weapon_clem_marr_signature.png` |
| [ ] | `weapon_vespera_last_hour` | Mirror of the Last Hour | Vespera Wisp | Glass Focus | `games/uomd/assets/icons/weapons/weapon_vespera_last_hour.png` |
| [ ] | `weapon_hana_birch_signature` | Stillbark Snare | Hana Birch | Hatchet and Trap | `games/uomd/assets/icons/weapons/weapon_hana_birch_signature.png` |
| [ ] | `weapon_thistle_roe_signature` | Garden Before Winter | Thistle Roe | Thorn Crook | `games/uomd/assets/icons/weapons/weapon_thistle_roe_signature.png` |
| [ ] | `weapon_iona_mist_signature` | Safe Harbor Lantern | Iona Mist | Tidal Censer | `games/uomd/assets/icons/weapons/weapon_iona_mist_signature.png` |
| [ ] | `weapon_jori_flint_signature` | Furnace Door's Rivet | Jori Flint | Hammer and Shield | `games/uomd/assets/icons/weapons/weapon_jori_flint_signature.png` |
| [ ] | `weapon_marek_vane_signature` | March Without a Banner | Marek Vane | Spear and Signal Horn | `games/uomd/assets/icons/weapons/weapon_marek_vane_signature.png` |
| [ ] | `weapon_garrick_cinder_signature` | The Sixty-First Minute | Garrick Cinder | Glaive and Shield | `games/uomd/assets/icons/weapons/weapon_garrick_cinder_signature.png` |
| [ ] | `weapon_corbin_locke_signature` | Seventh Sluice Anchor | Corbin Locke | Spear | `games/uomd/assets/icons/weapons/weapon_corbin_locke_signature.png` |
| [ ] | `weapon_cassian_thorne_signature` | Clapperless Verdict | Cassian Thorne | Arming Sword | `games/uomd/assets/icons/weapons/weapon_cassian_thorne_signature.png` |
| [ ] | `weapon_dorian_kesk_signature` | Seven-Notch Seal-Iron | Dorian Kesk | Twin Daggers | `games/uomd/assets/icons/weapons/weapon_dorian_kesk_signature.png` |
| [ ] | `weapon_rowan_reed_signature` | Wayshrine's Last Wick | Rowan Reed | Ritual Lantern | `games/uomd/assets/icons/weapons/weapon_rowan_reed_signature.png` |

Not: 3★ ve 4★ silahlar (160 adet) kendi simgesi yerine **silah türü simgesini** (D3) nadirlik çerçevesiyle kullanır.

### D5. Zırhlar (P2)
Üç zırh ailesi × dört desen; nadirlik (3/4/5★) çerçeveyle gösterilir, simge aynı kalır.

| ✓ | Kimlik | Ad | Teslim |
| --- | --- | --- | --- |
| [ ] | `armor_mail_01` | Wayfarer's Guild Mail | `games/uomd/assets/icons/armor/armor_mail_01.png` |
| [ ] | `armor_mail_02` | Ashbound Guild Mail | `games/uomd/assets/icons/armor/armor_mail_02.png` |
| [ ] | `armor_mail_03` | Lantern-Keeper's Guild Mail | `games/uomd/assets/icons/armor/armor_mail_03.png` |
| [ ] | `armor_mail_04` | Last Road Guild Mail | `games/uomd/assets/icons/armor/armor_mail_04.png` |
| [ ] | `armor_padded_01` | Wayfarer's Padded Roadcoat | `games/uomd/assets/icons/armor/armor_padded_01.png` |
| [ ] | `armor_padded_02` | Ashbound Padded Roadcoat | `games/uomd/assets/icons/armor/armor_padded_02.png` |
| [ ] | `armor_padded_03` | Lantern-Keeper's Padded Roadcoat | `games/uomd/assets/icons/armor/armor_padded_03.png` |
| [ ] | `armor_padded_04` | Last Road Padded Roadcoat | `games/uomd/assets/icons/armor/armor_padded_04.png` |
| [ ] | `armor_plate_01` | Wayfarer's Bellwrought Plate | `games/uomd/assets/icons/armor/armor_plate_01.png` |
| [ ] | `armor_plate_02` | Ashbound Bellwrought Plate | `games/uomd/assets/icons/armor/armor_plate_02.png` |
| [ ] | `armor_plate_03` | Lantern-Keeper's Bellwrought Plate | `games/uomd/assets/icons/armor/armor_plate_03.png` |
| [ ] | `armor_plate_04` | Last Road Bellwrought Plate | `games/uomd/assets/icons/armor/armor_plate_04.png` |

### D6. Aksesuar setleri (P2)
Her set için kolye ve yüzük (set temasını taşıyan).

| ✓ | Set | Ad | Kolye | Yüzük |
| --- | --- | --- | --- | --- |
| [ ] | `ash_maw_hide` | Ash-Maw Hide | `games/uomd/assets/icons/accessories/ash_maw_hide_necklace.png` | `games/uomd/assets/icons/accessories/ash_maw_hide_ring.png` |
| [ ] | `widow_verdict` | Widow's Verdict | `games/uomd/assets/icons/accessories/widow_verdict_necklace.png` | `games/uomd/assets/icons/accessories/widow_verdict_ring.png` |
| [ ] | `road_captain_oath` | Road Captain's Oath | `games/uomd/assets/icons/accessories/road_captain_oath_necklace.png` | `games/uomd/assets/icons/accessories/road_captain_oath_ring.png` |
| [ ] | `red_vial_residue` | Red Vial Residue | `games/uomd/assets/icons/accessories/red_vial_residue_necklace.png` | `games/uomd/assets/icons/accessories/red_vial_residue_ring.png` |
| [ ] | `bridgewarden_plating` | Bridgewarden Plating | `games/uomd/assets/icons/accessories/bridgewarden_plating_necklace.png` | `games/uomd/assets/icons/accessories/bridgewarden_plating_ring.png` |
| [ ] | `nameless_gallery` | Nameless Gallery | `games/uomd/assets/icons/accessories/nameless_gallery_necklace.png` | `games/uomd/assets/icons/accessories/nameless_gallery_ring.png` |
| [ ] | `first_eclipse` | First Eclipse | `games/uomd/assets/icons/accessories/first_eclipse_necklace.png` | `games/uomd/assets/icons/accessories/first_eclipse_ring.png` |

### D7. Durum etkileri (P1)
128×128; çerçeve yok; **olumlu** etkiler altın-yeşil tonlu, **olumsuz** etkiler kırmızı-mor tonlu (oyun ayrıca yeşil/kırmızı
köşe ekler).

| ✓ | Kimlik | Anlam | Teslim |
| --- | --- | --- | --- |
| [x] | `burn` | Yanık (her tur hasar, ateş) | `games/uomd/assets/icons/status/burn.png` |
| [x] | `venom` | Zehir (her tur hasar) | `games/uomd/assets/icons/status/venom.png` |
| [x] | `decay` | Çürüme (her tur hasar, iyileşmeyi azaltır) | `games/uomd/assets/icons/status/decay.png` |
| [x] | `soaked` | Islanma (Tide; tepkimeye açık) | `games/uomd/assets/icons/status/soaked.png` |
| [x] | `fracture` | Kırılma (savunma düşer) | `games/uomd/assets/icons/status/fracture.png` |
| [x] | `dread` | Dehşet (hasar ve odak kazanımı düşer) | `games/uomd/assets/icons/status/dread.png` |
| [x] | `break` | Kırık duruş (boss sersemleme penceresi) | `games/uomd/assets/icons/status/break.png` |
| [x] | `taunt` | Kışkırtma (saldırıyı üstüne çeker) | `games/uomd/assets/icons/status/taunt.png` |
| [x] | `soul_link` | Ruh bağı (hasarı paylaşır) | `games/uomd/assets/icons/status/soul_link.png` |
| [x] | `gust` | Rüzgâr (sıra gecikir) | `games/uomd/assets/icons/status/gust.png` |
| [x] | `trail_mark` | İz işareti (hedef öncelik) | `games/uomd/assets/icons/status/trail_mark.png` |
| [x] | `duel_mark` | Düello işareti | `games/uomd/assets/icons/status/duel_mark.png` |
| [x] | `stoneguard` | Taş muhafız (hasar azaltma) | `games/uomd/assets/icons/status/stoneguard.png` |
| [x] | `dawnward` | Şafak koruması (kalkan/arınma) | `games/uomd/assets/icons/status/dawnward.png` |
| [x] | `sanctuary` | Sığınak (iyileşme + hasar azaltma) | `games/uomd/assets/icons/status/sanctuary.png` |
| [x] | `shield` | Kalkan (emilen hasar) | `games/uomd/assets/icons/status/shield.png` |
| [x] | `defense_down` | Savunma düşüşü | `games/uomd/assets/icons/status/defense_down.png` |
| [x] | `attack_down` | Saldırı düşüşü | `games/uomd/assets/icons/status/attack_down.png` |
| [x] | `attack_up` | Saldırı artışı | `games/uomd/assets/icons/status/attack_up.png` |
| [x] | `defense_up` | Savunma artışı | `games/uomd/assets/icons/status/defense_up.png` |
| [x] | `speed_up` | Hız artışı | `games/uomd/assets/icons/status/speed_up.png` |
| [x] | `speed_down` | Hız düşüşü | `games/uomd/assets/icons/status/speed_down.png` |
| [x] | `healing_received_down` | Alınan iyileşme düşer | `games/uomd/assets/icons/status/healing_received_down.png` |
| [x] | `status_immunity` | Duruma bağışıklık | `games/uomd/assets/icons/status/status_immunity.png` |
| [x] | `redirect` | Hasar yönlendirme (koruyucu) | `games/uomd/assets/icons/status/redirect.png` |
| [x] | `stun` | Sersem (sıra kaybı) | `games/uomd/assets/icons/status/stun.png` |
| [x] | `regen` | Yenilenme (her tur iyileşme) | `games/uomd/assets/icons/status/regen.png` |
| [x] | `focus_up` | Odak kazanımı artar | `games/uomd/assets/icons/status/focus_up.png` |

### D8. Rol/sınıf simgeleri (P1)
| ✓ | Kimlik | Anlam | Kullanan roller | Teslim |
| --- | --- | --- | --- | --- |
| [ ] | `vanguard` | Öncü / tank (kalkan) | tank, tank_bruiser, tank_support, guard, harpoon_vanguard, reliquary_templar | `games/uomd/assets/icons/roles/vanguard.png` |
| [ ] | `striker` | Vurucu (kılıç) | bruiser_dps, siege_breaker_dps, counter_dps | `games/uomd/assets/icons/roles/striker.png` |
| [ ] | `assassin` | Suikastçı (hançer) | assassin_dps | `games/uomd/assets/icons/roles/assassin.png` |
| [ ] | `ranger` | Okçu (yay) | ranged_dps, debuff_archer | `games/uomd/assets/icons/roles/ranger.png` |
| [ ] | `caster` | Büyücü (asa + yıldız) | alchemist_dps, mage_dps, support_dps, cipher_debuffer_dps | `games/uomd/assets/icons/roles/caster.png` |
| [ ] | `healer` | Şifacı (fener + damla) | healer, healer_support | `games/uomd/assets/icons/roles/healer.png` |
| [ ] | `support` | Destek (çan / bayrak) | buffer, buffer_bard, control_buffer, shrine_support | `games/uomd/assets/icons/roles/support.png` |
| [ ] | `hexer` | Lanetçi (göz) | debuffer | `games/uomd/assets/icons/roles/hexer.png` |

### D9. Beceri simgeleri (P3)
Her kahramanın 4 becerisi (temel, aktif, pasif, ultimate). Becerinin adına ve kahramanın silahına uygun sahne; element rengi
baskın; ultimate simgeleri daha parlak ve yoğun.

| ✓ | Kimlik | Ad | Kahraman | Tür | Teslim |
| --- | --- | --- | --- | --- | --- |
| [ ] | `mahmut_basic_oathless_cut` | Oathless Cut | Mahmut | basic | `games/uomd/assets/icons/skills/mahmut_basic_oathless_cut.png` |
| [ ] | `mahmut_active_broken_crest_guard` | Broken Crest Guard | Mahmut | active | `games/uomd/assets/icons/skills/mahmut_active_broken_crest_guard.png` |
| [ ] | `mahmut_passive_a_knight_s_debt` | A Knight's Debt | Mahmut | passive | `games/uomd/assets/icons/skills/mahmut_passive_a_knight_s_debt.png` |
| [ ] | `mahmut_ultimate_last_wall_at_dusk` | Last Wall at Dusk | Mahmut | ultimate | `games/uomd/assets/icons/skills/mahmut_ultimate_last_wall_at_dusk.png` |
| [ ] | `fadyme_basic_veilglass_thorn` | Veilglass Thorn | Fadyme | basic | `games/uomd/assets/icons/skills/fadyme_basic_veilglass_thorn.png` |
| [ ] | `fadyme_active_borrowed_hour` | Borrowed Hour | Fadyme | active | `games/uomd/assets/icons/skills/fadyme_active_borrowed_hour.png` |
| [ ] | `fadyme_passive_a_smile_kept` | A Smile Kept | Fadyme | passive | `games/uomd/assets/icons/skills/fadyme_passive_a_smile_kept.png` |
| [ ] | `fadyme_ultimate_the_bell_that_forgets` | The Bell That Forgets | Fadyme | ultimate | `games/uomd/assets/icons/skills/fadyme_ultimate_the_bell_that_forgets.png` |
| [ ] | `kera_voss_basic_flask_flick` | Flask Flick | Kera Voss | basic | `games/uomd/assets/icons/skills/kera_voss_basic_flask_flick.png` |
| [ ] | `kera_voss_active_cinder_tonic` | Cinder Tonic | Kera Voss | active | `games/uomd/assets/icons/skills/kera_voss_active_cinder_tonic.png` |
| [ ] | `kera_voss_passive_measure_twice` | Measure Twice | Kera Voss | passive | `games/uomd/assets/icons/skills/kera_voss_passive_measure_twice.png` |
| [ ] | `kera_voss_ultimate_redoubt_reaction` | Redoubt Reaction | Kera Voss | ultimate | `games/uomd/assets/icons/skills/kera_voss_ultimate_redoubt_reaction.png` |
| [ ] | `brin_alder_basic_rootsplitter` | Rootsplitter | Brin Alder | basic | `games/uomd/assets/icons/skills/brin_alder_basic_rootsplitter.png` |
| [ ] | `brin_alder_active_oakbrace` | Oakbrace | Brin Alder | active | `games/uomd/assets/icons/skills/brin_alder_active_oakbrace.png` |
| [ ] | `brin_alder_passive_hold_the_gate` | Hold the Gate | Brin Alder | passive | `games/uomd/assets/icons/skills/brin_alder_passive_hold_the_gate.png` |
| [ ] | `brin_alder_ultimate_alderwall` | Alderwall | Brin Alder | ultimate | `games/uomd/assets/icons/skills/brin_alder_ultimate_alderwall.png` |
| [ ] | `nixie_vale_basic_windneedle` | Windneedle | Nixie Vale | basic | `games/uomd/assets/icons/skills/nixie_vale_basic_windneedle.png` |
| [ ] | `nixie_vale_active_crossdraft_shot` | Crossdraft Shot | Nixie Vale | active | `games/uomd/assets/icons/skills/nixie_vale_active_crossdraft_shot.png` |
| [ ] | `nixie_vale_passive_trail_mark` | Trail Mark | Nixie Vale | passive | `games/uomd/assets/icons/skills/nixie_vale_passive_trail_mark.png` |
| [ ] | `nixie_vale_ultimate_hawk_over_the_pass` | Hawk Over the Pass | Nixie Vale | ultimate | `games/uomd/assets/icons/skills/nixie_vale_ultimate_hawk_over_the_pass.png` |
| [ ] | `sister_aveline_basic_mercy_staff` | Mercy Staff | Sister Aveline | basic | `games/uomd/assets/icons/skills/sister_aveline_basic_mercy_staff.png` |
| [ ] | `sister_aveline_active_quiet_benediction` | Quiet Benediction | Sister Aveline | active | `games/uomd/assets/icons/skills/sister_aveline_active_quiet_benediction.png` |
| [ ] | `sister_aveline_passive_candle_remains` | Candle Remains | Sister Aveline | passive | `games/uomd/assets/icons/skills/sister_aveline_passive_candle_remains.png` |
| [ ] | `sister_aveline_ultimate_matins_at_the_last_door` | Matins at the Last Door | Sister Aveline | ultimate | `games/uomd/assets/icons/skills/sister_aveline_ultimate_matins_at_the_last_door.png` |
| [ ] | `sable_wren_basic_wren_s_point` | Wren's Point | Sable Wren | basic | `games/uomd/assets/icons/skills/sable_wren_basic_wren_s_point.png` |
| [ ] | `sable_wren_active_cut_the_thread` | Cut the Thread | Sable Wren | active | `games/uomd/assets/icons/skills/sable_wren_active_cut_the_thread.png` |
| [ ] | `sable_wren_passive_no_footprint` | No Footprint | Sable Wren | passive | `games/uomd/assets/icons/skills/sable_wren_passive_no_footprint.png` |
| [ ] | `sable_wren_ultimate_name_taken_in_silence` | Name Taken in Silence | Sable Wren | ultimate | `games/uomd/assets/icons/skills/sable_wren_ultimate_name_taken_in_silence.png` |
| [ ] | `tilda_fen_basic_reedstaff_tap` | Reedstaff Tap | Tilda Fen | basic | `games/uomd/assets/icons/skills/tilda_fen_basic_reedstaff_tap.png` |
| [ ] | `tilda_fen_active_marsh_poultice` | Marsh Poultice | Tilda Fen | active | `games/uomd/assets/icons/skills/tilda_fen_active_marsh_poultice.png` |
| [ ] | `tilda_fen_passive_patient_hands` | Patient Hands | Tilda Fen | passive | `games/uomd/assets/icons/skills/tilda_fen_passive_patient_hands.png` |
| [ ] | `tilda_fen_ultimate_rain_on_the_salt_road` | Rain on the Salt Road | Tilda Fen | ultimate | `games/uomd/assets/icons/skills/tilda_fen_ultimate_rain_on_the_salt_road.png` |
| [ ] | `rikka_ember_basic_bellpoint_thrust` | Bellpoint Thrust | Rikka Ember | basic | `games/uomd/assets/icons/skills/rikka_ember_basic_bellpoint_thrust.png` |
| [ ] | `rikka_ember_active_furnace_lunge` | Furnace Lunge | Rikka Ember | active | `games/uomd/assets/icons/skills/rikka_ember_active_furnace_lunge.png` |
| [ ] | `rikka_ember_passive_marching_heat` | Marching Heat | Rikka Ember | passive | `games/uomd/assets/icons/skills/rikka_ember_passive_marching_heat.png` |
| [ ] | `rikka_ember_ultimate_procession_of_sparks` | Procession of Sparks | Rikka Ember | ultimate | `games/uomd/assets/icons/skills/rikka_ember_ultimate_procession_of_sparks.png` |
| [ ] | `mirel_quill_basic_inkline` | Inkline | Mirel Quill | basic | `games/uomd/assets/icons/skills/mirel_quill_basic_inkline.png` |
| [ ] | `mirel_quill_active_margin_note` | Margin Note | Mirel Quill | active | `games/uomd/assets/icons/skills/mirel_quill_active_margin_note.png` |
| [ ] | `mirel_quill_passive_corrected_record` | Corrected Record | Mirel Quill | passive | `games/uomd/assets/icons/skills/mirel_quill_passive_corrected_record.png` |
| [ ] | `mirel_quill_ultimate_decree_of_the_unfallen` | Decree of the Unfallen | Mirel Quill | ultimate | `games/uomd/assets/icons/skills/mirel_quill_ultimate_decree_of_the_unfallen.png` |
| [ ] | `odelia_pike_basic_saltmark_arrow` | Saltmark Arrow | Odelia Pike | basic | `games/uomd/assets/icons/skills/odelia_pike_basic_saltmark_arrow.png` |
| [ ] | `odelia_pike_active_undertow_pin` | Undertow Pin | Odelia Pike | active | `games/uomd/assets/icons/skills/odelia_pike_active_undertow_pin.png` |
| [ ] | `odelia_pike_passive_read_the_current` | Read the Current | Odelia Pike | passive | `games/uomd/assets/icons/skills/odelia_pike_passive_read_the_current.png` |
| [ ] | `odelia_pike_ultimate_breakwater_volley` | Breakwater Volley | Odelia Pike | ultimate | `games/uomd/assets/icons/skills/odelia_pike_ultimate_breakwater_volley.png` |
| [ ] | `pippa_bell_basic_plucked_note` | Plucked Note | Pippa Bell | basic | `games/uomd/assets/icons/skills/pippa_bell_basic_plucked_note.png` |
| [ ] | `pippa_bell_active_rally_refrain` | Rally Refrain | Pippa Bell | active | `games/uomd/assets/icons/skills/pippa_bell_active_rally_refrain.png` |
| [ ] | `pippa_bell_passive_encore` | Encore! | Pippa Bell | passive | `games/uomd/assets/icons/skills/pippa_bell_passive_encore.png` |
| [ ] | `pippa_bell_ultimate_a_song_for_the_long_road` | A Song for the Long Road | Pippa Bell | ultimate | `games/uomd/assets/icons/skills/pippa_bell_ultimate_a_song_for_the_long_road.png` |
| [ ] | `nara_vell_basic_vellian_bash` | Vellian Bash | Nara Vell | basic | `games/uomd/assets/icons/skills/nara_vell_basic_vellian_bash.png` |
| [ ] | `nara_vell_active_shelter_angle` | Shelter Angle | Nara Vell | active | `games/uomd/assets/icons/skills/nara_vell_active_shelter_angle.png` |
| [ ] | `nara_vell_passive_familiar_footsteps` | Familiar Footsteps | Nara Vell | passive | `games/uomd/assets/icons/skills/nara_vell_passive_familiar_footsteps.png` |
| [ ] | `nara_vell_ultimate_the_narrow_gate` | The Narrow Gate | Nara Vell | ultimate | `games/uomd/assets/icons/skills/nara_vell_ultimate_the_narrow_gate.png` |
| [ ] | `clem_marr_basic_chalk_scratch` | Chalk Scratch | Clem Marr | basic | `games/uomd/assets/icons/skills/clem_marr_basic_chalk_scratch.png` |
| [ ] | `clem_marr_active_grave_index` | Grave Index | Clem Marr | active | `games/uomd/assets/icons/skills/clem_marr_active_grave_index.png` |
| [ ] | `clem_marr_passive_keep_the_names` | Keep the Names | Clem Marr | passive | `games/uomd/assets/icons/skills/clem_marr_passive_keep_the_names.png` |
| [ ] | `clem_marr_ultimate_epitaph_in_reverse` | Epitaph in Reverse | Clem Marr | ultimate | `games/uomd/assets/icons/skills/clem_marr_ultimate_epitaph_in_reverse.png` |
| [ ] | `vespera_wisp_basic_wisp_spark` | Wisp Spark | Vespera Wisp | basic | `games/uomd/assets/icons/skills/vespera_wisp_basic_wisp_spark.png` |
| [ ] | `vespera_wisp_active_pale_orbit` | Pale Orbit | Vespera Wisp | active | `games/uomd/assets/icons/skills/vespera_wisp_active_pale_orbit.png` |
| [ ] | `vespera_wisp_passive_candle_eater` | Candle-Eater | Vespera Wisp | passive | `games/uomd/assets/icons/skills/vespera_wisp_passive_candle_eater.png` |
| [ ] | `vespera_wisp_ultimate_procession_of_pale_lights` | Procession of Pale Lights | Vespera Wisp | ultimate | `games/uomd/assets/icons/skills/vespera_wisp_ultimate_procession_of_pale_lights.png` |
| [ ] | `hana_birch_basic_short_hatchet` | Short Hatchet | Hana Birch | basic | `games/uomd/assets/icons/skills/hana_birch_basic_short_hatchet.png` |
| [ ] | `hana_birch_active_set_the_snare` | Set the Snare | Hana Birch | active | `games/uomd/assets/icons/skills/hana_birch_active_set_the_snare.png` |
| [ ] | `hana_birch_passive_still_as_bark` | Still as Bark | Hana Birch | passive | `games/uomd/assets/icons/skills/hana_birch_passive_still_as_bark.png` |
| [ ] | `hana_birch_ultimate_birchline_ambush` | Birchline Ambush | Hana Birch | ultimate | `games/uomd/assets/icons/skills/hana_birch_ultimate_birchline_ambush.png` |
| [ ] | `thistle_roe_basic_seedshot` | Seedshot | Thistle Roe | basic | `games/uomd/assets/icons/skills/thistle_roe_basic_seedshot.png` |
| [ ] | `thistle_roe_active_windgrown_herb` | Windgrown Herb | Thistle Roe | active | `games/uomd/assets/icons/skills/thistle_roe_active_windgrown_herb.png` |
| [ ] | `thistle_roe_passive_shelter_leaves` | Shelter Leaves | Thistle Roe | passive | `games/uomd/assets/icons/skills/thistle_roe_passive_shelter_leaves.png` |
| [ ] | `thistle_roe_ultimate_garden_before_winter` | Garden Before Winter | Thistle Roe | ultimate | `games/uomd/assets/icons/skills/thistle_roe_ultimate_garden_before_winter.png` |
| [ ] | `iona_mist_basic_mistlit_touch` | Mistlit Touch | Iona Mist | basic | `games/uomd/assets/icons/skills/iona_mist_basic_mistlit_touch.png` |
| [ ] | `iona_mist_active_fogbound_remedy` | Fogbound Remedy | Iona Mist | active | `games/uomd/assets/icons/skills/iona_mist_active_fogbound_remedy.png` |
| [ ] | `iona_mist_passive_lantern_watch` | Lantern Watch | Iona Mist | passive | `games/uomd/assets/icons/skills/iona_mist_passive_lantern_watch.png` |
| [ ] | `iona_mist_ultimate_safe_harbor_in_fog` | Safe Harbor in Fog | Iona Mist | ultimate | `games/uomd/assets/icons/skills/iona_mist_ultimate_safe_harbor_in_fog.png` |
| [ ] | `jori_flint_basic_hammer_tap` | Hammer Tap | Jori Flint | basic | `games/uomd/assets/icons/skills/jori_flint_basic_hammer_tap.png` |
| [ ] | `jori_flint_active_forgeguard` | Forgeguard | Jori Flint | active | `games/uomd/assets/icons/skills/jori_flint_active_forgeguard.png` |
| [ ] | `jori_flint_passive_hot_rivet` | Hot Rivet | Jori Flint | passive | `games/uomd/assets/icons/skills/jori_flint_passive_hot_rivet.png` |
| [ ] | `jori_flint_ultimate_furnace_door` | Furnace Door | Jori Flint | ultimate | `games/uomd/assets/icons/skills/jori_flint_ultimate_furnace_door.png` |
| [ ] | `marek_vane_basic_vane_s_measure` | Vane's Measure | Marek Vane | basic | `games/uomd/assets/icons/skills/marek_vane_basic_vane_s_measure.png` |
| [ ] | `marek_vane_active_broken_meter` | Broken Meter | Marek Vane | active | `games/uomd/assets/icons/skills/marek_vane_active_broken_meter.png` |
| [ ] | `marek_vane_passive_watchman_s_rhythm` | Watchman's Rhythm | Marek Vane | passive | `games/uomd/assets/icons/skills/marek_vane_passive_watchman_s_rhythm.png` |
| [ ] | `marek_vane_ultimate_march_without_a_banner` | March Without a Banner | Marek Vane | ultimate | `games/uomd/assets/icons/skills/marek_vane_ultimate_march_without_a_banner.png` |
| [ ] | `garrick_cinder_basic_cinder_thrust` | Cinder Thrust | Garrick Cinder | basic | `games/uomd/assets/icons/skills/garrick_cinder_basic_cinder_thrust.png` |
| [ ] | `garrick_cinder_active_furnace_breach` | Furnace Breach | Garrick Cinder | active | `games/uomd/assets/icons/skills/garrick_cinder_active_furnace_breach.png` |
| [ ] | `garrick_cinder_passive_the_sixty_first_minute` | The Sixty-First Minute | Garrick Cinder | passive | `games/uomd/assets/icons/skills/garrick_cinder_passive_the_sixty_first_minute.png` |
| [ ] | `garrick_cinder_ultimate_pyre_at_the_outer_gate` | Pyre at the Outer Gate | Garrick Cinder | ultimate | `games/uomd/assets/icons/skills/garrick_cinder_ultimate_pyre_at_the_outer_gate.png` |
| [ ] | `corbin_locke_basic_gaff_hook` | Gaff Hook | Corbin Locke | basic | `games/uomd/assets/icons/skills/corbin_locke_basic_gaff_hook.png` |
| [ ] | `corbin_locke_active_undertow_drag` | Undertow Drag | Corbin Locke | active | `games/uomd/assets/icons/skills/corbin_locke_active_undertow_drag.png` |
| [ ] | `corbin_locke_passive_sluice_warden_s_anchor` | Sluice-Warden's Anchor | Corbin Locke | passive | `games/uomd/assets/icons/skills/corbin_locke_passive_sluice_warden_s_anchor.png` |
| [ ] | `corbin_locke_ultimate_open_the_floodgates` | Open the Floodgates | Corbin Locke | ultimate | `games/uomd/assets/icons/skills/corbin_locke_ultimate_open_the_floodgates.png` |
| [ ] | `cassian_thorne_basic_vigil_cleave` | Vigil Cleave | Cassian Thorne | basic | `games/uomd/assets/icons/skills/cassian_thorne_basic_vigil_cleave.png` |
| [ ] | `cassian_thorne_active_sanctuary_of_the_door` | Sanctuary of the Door | Cassian Thorne | active | `games/uomd/assets/icons/skills/cassian_thorne_active_sanctuary_of_the_door.png` |
| [ ] | `cassian_thorne_passive_belfry_oath` | Belfry Oath | Cassian Thorne | passive | `games/uomd/assets/icons/skills/cassian_thorne_passive_belfry_oath.png` |
| [ ] | `cassian_thorne_ultimate_bell_without_a_clapper` | Bell Without a Clapper | Cassian Thorne | ultimate | `games/uomd/assets/icons/skills/cassian_thorne_ultimate_bell_without_a_clapper.png` |
| [ ] | `dorian_kesk_basic_hot_wax_cut` | Hot Wax Cut | Dorian Kesk | basic | `games/uomd/assets/icons/skills/dorian_kesk_basic_hot_wax_cut.png` |
| [ ] | `dorian_kesk_active_forged_warrant` | Forged Warrant | Dorian Kesk | active | `games/uomd/assets/icons/skills/dorian_kesk_active_forged_warrant.png` |
| [ ] | `dorian_kesk_passive_seven_notch_cipher` | Seven-Notch Cipher | Dorian Kesk | passive | `games/uomd/assets/icons/skills/dorian_kesk_passive_seven_notch_cipher.png` |
| [ ] | `dorian_kesk_ultimate_broken_seal_of_the_chancery` | Broken Seal of the Chancery | Dorian Kesk | ultimate | `games/uomd/assets/icons/skills/dorian_kesk_ultimate_broken_seal_of_the_chancery.png` |
| [ ] | `rowan_reed_basic_warming_spark` | Warming Spark | Rowan Reed | basic | `games/uomd/assets/icons/skills/rowan_reed_basic_warming_spark.png` |
| [ ] | `rowan_reed_active_recut_the_name` | Recut the Name | Rowan Reed | active | `games/uomd/assets/icons/skills/rowan_reed_active_recut_the_name.png` |
| [ ] | `rowan_reed_passive_candle_in_the_rain` | Candle in the Rain | Rowan Reed | passive | `games/uomd/assets/icons/skills/rowan_reed_passive_candle_in_the_rain.png` |
| [ ] | `rowan_reed_ultimate_lanterns_along_the_wayshrine` | Lanterns Along the Wayshrine | Rowan Reed | ultimate | `games/uomd/assets/icons/skills/rowan_reed_ultimate_lanterns_along_the_wayshrine.png` |

### D10. Gezinme simgeleri (P1)
Ana ekranın sol sütunundaki ve alt gezinmedeki her düğmenin kendi simgesi (başka simge ödünç alınmaz).

| ✓ | Kimlik | Anlam | Teslim |
| --- | --- | --- | --- |
| [ ] | `home` | Ana sayfa / sığınak | `games/uomd/assets/icons/nav/home.png` |
| [ ] | `company` | Şirket (kahramanlar) | `games/uomd/assets/icons/nav/company.png` |
| [ ] | `party` | Takım dizilişi | `games/uomd/assets/icons/nav/party.png` |
| [ ] | `armory` | Cephanelik | `games/uomd/assets/icons/nav/armory.png` |
| [ ] | `chapters` | Bölümler / yolculuk | `games/uomd/assets/icons/nav/chapters.png` |
| [ ] | `summon` | Çağırma (çan) | `games/uomd/assets/icons/nav/summon.png` |
| [ ] | `rewards` | Ödüller | `games/uomd/assets/icons/nav/rewards.png` |
| [ ] | `mail` | Posta | `games/uomd/assets/icons/nav/mail.png` |
| [ ] | `tasks` | Görevler | `games/uomd/assets/icons/nav/tasks.png` |
| [ ] | `events` | Etkinlikler | `games/uomd/assets/icons/nav/events.png` |
| [ ] | `battle_pass` | Sezon kartı | `games/uomd/assets/icons/nav/battle_pass.png` |
| [ ] | `patrol` | Devriye (AFK) | `games/uomd/assets/icons/nav/patrol.png` |
| [ ] | `trials` | Sınavlar / arena | `games/uomd/assets/icons/nav/trials.png` |
| [ ] | `shop` | Dükkân | `games/uomd/assets/icons/nav/shop.png` |
| [ ] | `chronicle` | Vakayiname / hikâye | `games/uomd/assets/icons/nav/chronicle.png` |
| [ ] | `settings` | Ayarlar | `games/uomd/assets/icons/nav/settings.png` |
| [ ] | `account` | Hesap | `games/uomd/assets/icons/nav/account.png` |
| [ ] | `library` | Kütüphane / arşiv | `games/uomd/assets/icons/nav/library.png` |

### D11. Arayüz yardımcıları (P0)
Yazı tipinde olmayan karakterlerin (★ ☆ 🔒 ✓ ⚠ ♥ ⚡ ⇄) yerine; bazıları 64×64 da teslim edilir (küçük kullanım).

| ✓ | Kimlik | Anlam | Teslim |
| --- | --- | --- | --- |
| [x] | `star_filled` | Nadirlik yıldızı (dolu) — ★ karakteri yazı tipinde yok | `games/uomd/assets/icons/ui/star_filled.png` |
| [x] | `star_empty` | Nadirlik yıldızı (boş) | `games/uomd/assets/icons/ui/star_empty.png` |
| [x] | `lock` | Kilit (kilitli içerik) | `games/uomd/assets/icons/ui/lock.png` |
| [x] | `check` | Onay işareti (tamamlandı) | `games/uomd/assets/icons/ui/check.png` |
| [x] | `warning` | Uyarı | `games/uomd/assets/icons/ui/warning.png` |
| [x] | `heart` | Bağ / sevgi | `games/uomd/assets/icons/ui/heart.png` |
| [x] | `lightning` | Hız / hızlı oynatma | `games/uomd/assets/icons/ui/lightning.png` |
| [x] | `swap` | Değiştir | `games/uomd/assets/icons/ui/swap.png` |
| [x] | `red_dot` | Bildirim noktası (24 px, kırmızı-altın) | `games/uomd/assets/icons/ui/red_dot.png` |
| [x] | `plus` | Artı (satın al / ekle) | `games/uomd/assets/icons/ui/plus.png` |
| [x] | `minus` | Eksi | `games/uomd/assets/icons/ui/minus.png` |
| [x] | `close` | Kapat (X) | `games/uomd/assets/icons/ui/close.png` |
| [x] | `back` | Geri oku | `games/uomd/assets/icons/ui/back.png` |
| [x] | `info` | Bilgi (i) | `games/uomd/assets/icons/ui/info.png` |
| [x] | `clock` | Süre / sayaç | `games/uomd/assets/icons/ui/clock.png` |
| [x] | `auto` | AUTO düğmesi simgesi | `games/uomd/assets/icons/ui/auto.png` |
| [x] | `speed_2x` | 2× hız | `games/uomd/assets/icons/ui/speed_2x.png` |
| [x] | `target` | Hedef işareti (savaş) | `games/uomd/assets/icons/ui/target.png` |
| [x] | `gift` | Hediye / paket | `games/uomd/assets/icons/ui/gift.png` |
| [x] | `new` | YENİ rozeti (yazısız rozet zemini) | `games/uomd/assets/icons/ui/new.png` |

## E. Çağırma
### E1. Havuz afişleri (P0)
Her havuz kendi afiş yuvasını gösterir; çizim gelene kadar orada yer tutucu var.
2592×1080 WebP; öne çıkan karakter sağ-orta büyük (boyun üstü değil, diz üstü kadraj), havuz temasına uygun mekân,
sol üçte bir sade (oyun yazıları oraya koyar), sağ alt 900×300 boş (1×/10× düğmeleri).

| ✓ | Havuz | Konu | Teslim |
| --- | --- | --- | --- |
| [x] | `beginner_first_vigil` | Başlangıç: Mahmut ve Fadyme sığınak kapısında, ilk nöbet | `games/uomd/assets/banners/beginner_first_vigil.webp` |
| [x] | `hall_of_ancestors` | Kalıcı karakter havuzu: ata heykelleri salonu, birçok kahramanın silüeti | `games/uomd/assets/banners/hall_of_ancestors.webp` |
| [x] | `hall_of_armaments_weapons` | Kalıcı silah havuzu: duvarda asılı silahlar, demirci ışığı | `games/uomd/assets/banners/hall_of_armaments_weapons.webp` |
| [x] | `oath_01_sister` | Öne çıkan: Sister Aveline (Dawn), kendi imza silahıyla | `games/uomd/assets/banners/oath_01_sister.webp` |
| [x] | `oath_01_weapon` | Silah havuzu: Lantern of the Last Vigil ortada, sahibi arka planda gölge | `games/uomd/assets/banners/oath_01_weapon.webp` |
| [x] | `oath_02_sable` | Öne çıkan: Sable Wren (Veil), kendi imza silahıyla | `games/uomd/assets/banners/oath_02_sable.webp` |
| [x] | `oath_02_weapon` | Silah havuzu: Quietus at the Broken Bell ortada, sahibi arka planda gölge | `games/uomd/assets/banners/oath_02_weapon.webp` |
| [x] | `oath_03_nara` | Öne çıkan: Nara Vell (Stone), kendi imza silahıyla | `games/uomd/assets/banners/oath_03_nara.webp` |
| [x] | `oath_03_weapon` | Silah havuzu: Gatewarden's Promise ortada, sahibi arka planda gölge | `games/uomd/assets/banners/oath_03_weapon.webp` |
| [x] | `oath_04_mirel` | Öne çıkan: Mirel Quill (Dawn), kendi imza silahıyla | `games/uomd/assets/banners/oath_04_mirel.webp` |
| [x] | `oath_04_weapon` | Silah havuzu: The Unwritten Ledger ortada, sahibi arka planda gölge | `games/uomd/assets/banners/oath_04_weapon.webp` |
| [x] | `oath_05_vespera` | Öne çıkan: Vespera Wisp (Veil), kendi imza silahıyla | `games/uomd/assets/banners/oath_05_vespera.webp` |
| [x] | `oath_05_weapon` | Silah havuzu: Mirror of the Last Hour ortada, sahibi arka planda gölge | `games/uomd/assets/banners/oath_05_weapon.webp` |
| [x] | `oath_06_garrick` | Öne çıkan: Garrick Cinder (Ember), kendi imza silahıyla | `games/uomd/assets/banners/oath_06_garrick.webp` |
| [x] | `oath_06_weapon` | Silah havuzu: The Sixty-First Minute ortada, sahibi arka planda gölge | `games/uomd/assets/banners/oath_06_weapon.webp` |
| [x] | `oath_07_corbin` | Öne çıkan: Corbin Locke (Tide), kendi imza silahıyla | `games/uomd/assets/banners/oath_07_corbin.webp` |
| [x] | `oath_07_weapon` | Silah havuzu: Seventh Sluice Anchor ortada, sahibi arka planda gölge | `games/uomd/assets/banners/oath_07_weapon.webp` |

### E2. Kahraman tam boy çizimleri (P2: ilk 7, P3: kalanlar)
1600×2400 saydam; çağırma sonucu, kahraman ayrıntı ekranı ve ana ekranda kullanılır. Chibi değil, normal oran (7–8 baş),
VN portreleriyle aynı yüz ve kıyafet.

| ✓ | Kimlik | Ad | Öncelik | Teslim |
| --- | --- | --- | --- | --- |
| [ ] | `mahmut` | Mahmut | P3 | `games/uomd/art_src/full/mahmut.png` |
| [ ] | `fadyme` | Fadyme | P3 | `games/uomd/art_src/full/fadyme.png` |
| [ ] | `kera_voss` | Kera Voss | P3 | `games/uomd/art_src/full/kera_voss.png` |
| [ ] | `brin_alder` | Brin Alder | P3 | `games/uomd/art_src/full/brin_alder.png` |
| [ ] | `nixie_vale` | Nixie Vale | P3 | `games/uomd/art_src/full/nixie_vale.png` |
| [ ] | `sister_aveline` | Sister Aveline | P2 | `games/uomd/art_src/full/sister_aveline.png` |
| [ ] | `sable_wren` | Sable Wren | P2 | `games/uomd/art_src/full/sable_wren.png` |
| [ ] | `tilda_fen` | Tilda Fen | P3 | `games/uomd/art_src/full/tilda_fen.png` |
| [ ] | `rikka_ember` | Rikka Ember | P3 | `games/uomd/art_src/full/rikka_ember.png` |
| [ ] | `mirel_quill` | Mirel Quill | P2 | `games/uomd/art_src/full/mirel_quill.png` |
| [ ] | `odelia_pike` | Odelia Pike | P3 | `games/uomd/art_src/full/odelia_pike.png` |
| [ ] | `pippa_bell` | Pippa Bell | P3 | `games/uomd/art_src/full/pippa_bell.png` |
| [ ] | `nara_vell` | Nara Vell | P2 | `games/uomd/art_src/full/nara_vell.png` |
| [ ] | `clem_marr` | Clem Marr | P3 | `games/uomd/art_src/full/clem_marr.png` |
| [ ] | `vespera_wisp` | Vespera Wisp | P2 | `games/uomd/art_src/full/vespera_wisp.png` |
| [ ] | `hana_birch` | Hana Birch | P3 | `games/uomd/art_src/full/hana_birch.png` |
| [ ] | `thistle_roe` | Thistle Roe | P3 | `games/uomd/art_src/full/thistle_roe.png` |
| [ ] | `iona_mist` | Iona Mist | P3 | `games/uomd/art_src/full/iona_mist.png` |
| [ ] | `jori_flint` | Jori Flint | P3 | `games/uomd/art_src/full/jori_flint.png` |
| [ ] | `marek_vane` | Marek Vane | P3 | `games/uomd/art_src/full/marek_vane.png` |
| [ ] | `garrick_cinder` | Garrick Cinder | P2 | `games/uomd/art_src/full/garrick_cinder.png` |
| [ ] | `corbin_locke` | Corbin Locke | P2 | `games/uomd/art_src/full/corbin_locke.png` |
| [ ] | `cassian_thorne` | Cassian Thorne | P3 | `games/uomd/art_src/full/cassian_thorne.png` |
| [ ] | `dorian_kesk` | Dorian Kesk | P3 | `games/uomd/art_src/full/dorian_kesk.png` |
| [ ] | `rowan_reed` | Rowan Reed | P3 | `games/uomd/art_src/full/rowan_reed.png` |

## F. Portreler (P3)
Hikâyede konuşan üç yan karakter. §L biçimi (768×1152, ifade başına tek resim, `games/uomd/art/portraits/<id>/<ifade>.webp`);
en az üç ifade: `composed`, `uneasy`, `warm`.

| ✓ | Kimlik | Kim | Teslim |
| --- | --- | --- | --- |
| [x] | `alchemist` | Kasaba simyacısı (orta yaş, önlüklü, cam şişeler) | `games/uomd/art/portraits/alchemist/` |
| [x] | `refugee_woman` | Mülteci kadın (yorgun, şal, çocuk yüzü yok) | `games/uomd/art/portraits/refugee_woman/` |
| [x] | `shrine_keeper` | Yol tapınağı bekçisi (yaşlı, fener, cübbe) | `games/uomd/art/portraits/shrine_keeper/` |

## G. Uygulama ve mağaza (P1 — 2026-11-22: ilk AAB'nin simgesi ve Play mağaza sayfası bunlarsız çıkamaz; §I.5'in kalan 5 şeridinden sonra, Bölüm 3'ten ÖNCE al)
| ✓ | Kimlik | İçerik | Boyut | Teslim |
| --- | --- | --- | --- | --- |
| [x] | `logo` | Oyun logosu "Unaware of My Demise" (yazılı tek görsel bu; `art_manifest.json` `logo` girdisinin dosyası yok) | 2048×1024 saydam | `games/uomd/art_src/branding/logo.png` |
| [x] | `adaptive_fg` | Android uyarlanabilir simge ön plan (çan + kül, merkez 66 dp güvenli alan) | 432×432 saydam | `games/uomd/art_src/branding/ic_launcher_foreground.png` |
| [x] | `adaptive_bg` | Uyarlanabilir simge arka plan (koyu mor doku) | 432×432 | `games/uomd/art_src/branding/ic_launcher_background.png` |
| [x] | `monochrome` | Tek renk simge (Android 13 temalı) | 432×432 saydam beyaz | `games/uomd/art_src/branding/ic_launcher_monochrome.png` |
| [x] | `feature_graphic` | Google Play öne çıkan görsel (yazısız) | 1024×500 | `games/uomd/art_src/branding/feature_graphic.png` |

## H. Etkinlik görselleri (P1 — PLAN §17 D12)
Her etkinliğin `art_key`'i bir afiş ister; aşağıdakiler bugünkü etkinlik ve bütün etkinliklerin ortak parçalarıdır.

| ✓ | Kimlik | İçerik | Boyut | Teslim |
| --- | --- | --- | --- | --- |
| [ ] | `event_ashen_vigil_s1` | "Ashen Vigil — Season I" afişi: çan kulesi yolu, gece nöbeti, külde fenerler; sol üçte bir sade | 2592×1080 WebP | `games/uomd/assets/banners/event_ashen_vigil_s1.webp` |
| [ ] | `event_strip_ashen_vigil_s1` | Ana ekran etkinlik şeridi (aynı tema, yatay dar) | 1200×300 WebP | `games/uomd/assets/banners/event_strip_ashen_vigil_s1.webp` |
| [ ] | `event_frame` | Etkinlik ekranı çerçeve süsü (köşe çanları, yazısız) | 1920×1080 PNG saydam | `games/uomd/art_src/ui/event_frame.png` |
| [ ] | `calendar_stamp` | Giriş takvimi "alındı" damgası (mum mührü) | 256×256 | `games/uomd/assets/icons/ui/calendar_stamp.png` |
| [ ] | `calendar_day_frame` | Takvim gün kutusu zemini (bugün / alınmış / gelecek: üç ayrı dosya `_today`, `_done`, `_future`) | 256×320 | `games/uomd/art_src/ui/calendar_day_frame_today.png` |
| [ ] | `event_shop_shelf` | Etkinlik dükkânı raf zemini (ürün kartlarının arkası) | 1600×900 PNG | `games/uomd/art_src/ui/event_shop_shelf.png` |
| [ ] | `event_stage_map` | Etkinlik aşama haritası arka planı (çan kulesi yolu, 6 durak yeri boş) | 2592×1080 WebP | `games/uomd/assets/banners/event_stage_map_ashen_vigil_s1.webp` |
| [ ] | `milestone_chest` | Birikimli ödül sandığı (kapalı / açık: `_closed`, `_open`) | 256×256 | `games/uomd/assets/icons/ui/milestone_chest_closed.png` |
| [ ] | `event_tab_objectives` | Etkinlik sekme simgesi: Hedefler (mühürlü liste) | 128×128 | `games/uomd/assets/icons/ui/event_tab_objectives.png` |
| [ ] | `event_tab_stages` | Etkinlik sekme simgesi: Aşamalar (çan kulesi yolu, kılıç) | 128×128 | `games/uomd/assets/icons/ui/event_tab_stages.png` |
| [ ] | `event_tab_shop` | Etkinlik sekme simgesi: Dükkân (terazi + jeton) | 128×128 | `games/uomd/assets/icons/ui/event_tab_shop.png` |
| [ ] | `event_tab_calendar` | Etkinlik sekme simgesi: Takvim (mum mühürlü sayfa) | 128×128 | `games/uomd/assets/icons/ui/event_tab_calendar.png` |
| [ ] | `event_node_story` | Etkinlik aşama düğümü: hikâye (açık kitap) | 160×160 | `games/uomd/assets/icons/ui/event_node_story.png` |
| [ ] | `event_node_battle` | Etkinlik aşama düğümü: savaş (çapraz kılıç) | 160×160 | `games/uomd/assets/icons/ui/event_node_battle.png` |
| [ ] | `event_node_boss` | Etkinlik aşama düğümü: patron (boynuzlu kafatası, kırmızı) | 160×160 | `games/uomd/assets/icons/ui/event_node_boss.png` |
| [ ] | `shop_sold_out_stamp` | Dükkân "tükendi" damgası (yazısız, çapraz mühür) | 256×256 | `games/uomd/assets/icons/ui/shop_sold_out_stamp.png` |
| [ ] | `event_story_bg_ashen_vigil_1` | Ashen Vigil hikâye arka planı 1: gece çan kulesi içi, fenerler | 2592×1080 WebP | `games/uomd/assets/bg_event_ashen_vigil_1.webp` |
| [ ] | `event_story_bg_ashen_vigil_2` | Ashen Vigil hikâye arka planı 2: kül kaplı köprü, şafak öncesi | 2592×1080 WebP | `games/uomd/assets/bg_event_ashen_vigil_2.webp` |

Yeni her etkinlik için aynı set: `event_<kimlik>` afiş + `event_strip_<kimlik>` şerit + etkinlik parası simgesi (`games/uomd/assets/icons/items/<para_kimliği>.png`, 256×256) + gerekirse iki hikâye arka planı. Sekme ve düğüm simgeleri bütün etkinliklerde ortak.

### H.2 Eski projeden gelen yan hikâye etkinlikleri (P2 — PLAN §17 D13)
Sekiz hikâye (yedi etkinlik; A Borrowed Chair, One Dish One Name'in devamı) oyuna bağlandı. 28 mekân arka planı §J.2'de (öneki
`aw_ bc_ dr_ lt_ od_ or_ tl_ tw_` olanlar), Ash Circle §M'de. Burada: her etkinliğin afişi ve ana ekran şeridi (§H ilk tablo ile aynı
boyut ve kural: sol üçte bir sade, yazısız) ve hikâyede konuşan 13 yan karakter (§L biçimi, en az `composed`, `uneasy`, `warm`;
şimdilik yalnız adlarıyla konuşuyorlar).

| ✓ | Kimlik | İçerik | Boyut | Teslim |
| --- | --- | --- | --- | --- |
| [ ] | `event_last_traveler` | "For the Last Traveler" afişi: orman geçidinde gece, yolcuya bırakılan işaretler ve küçük bir fener; Brin ile Nixie yolu hazırlıyor | 2592×1080 WebP | `games/uomd/assets/banners/event_last_traveler.webp` |
| [ ] | `event_strip_last_traveler` | "For the Last Traveler" ana ekran şeridi (aynı tema, yatay dar) | 1200×300 WebP | `games/uomd/assets/banners/event_strip_last_traveler.webp` |
| [ ] | `event_somewhere_dry` | "Somewhere Dry" afişi: sığınakta ıslanmış keten emanet defteri, kuru masa, Mirel ve Aveline mum ışığında | 2592×1080 WebP | `games/uomd/assets/banners/event_somewhere_dry.webp` |
| [ ] | `event_strip_somewhere_dry` | "Somewhere Dry" ana ekran şeridi (aynı tema, yatay dar) | 1200×300 WebP | `games/uomd/assets/banners/event_strip_somewhere_dry.webp` |
| [ ] | `event_one_dish_one_name` | "One Dish, One Name" afişi: Oakhaven meydanında uzun hasat sofraları, her konuk bir tabak ve bir isim getiriyor; Pippa sofrada | 2592×1080 WebP | `games/uomd/assets/banners/event_one_dish_one_name.webp` |
| [ ] | `event_strip_one_dish_one_name` | "One Dish, One Name" ana ekran şeridi (aynı tema, yatay dar) | 1200×300 WebP | `games/uomd/assets/banners/event_strip_one_dish_one_name.webp` |
| [ ] | `event_archive_watch` | "Archive Watch" afişi: arşivde vaka panosu, iplerle bağlı notlar, dört karakterin gölgesi; taktik canlandırma havası | 2592×1080 WebP | `games/uomd/assets/banners/event_archive_watch.webp` |
| [ ] | `event_strip_archive_watch` | "Archive Watch" ana ekran şeridi (aynı tema, yatay dar) | 1200×300 WebP | `games/uomd/assets/banners/event_strip_archive_watch.webp` |
| [ ] | `event_two_labels` | "Two Labels" afişi: tuz yolu kıyısında sevkiyat arabası, iki etiketli şişe, liman pazarı; Kera ve Tilda | 2592×1080 WebP | `games/uomd/assets/banners/event_two_labels.webp` |
| [ ] | `event_strip_two_labels` | "Two Labels" ana ekran şeridi (aynı tema, yatay dar) | 1200×300 WebP | `games/uomd/assets/banners/event_strip_two_labels.webp` |
| [ ] | `event_open_road` | "An Open Road" afişi: güvenli yan rotada yardım noktası, erzak panosu, gönüllülere devredilen iş; Nara ve Marek | 2592×1080 WebP | `games/uomd/assets/banners/event_open_road.webp` |
| [ ] | `event_strip_open_road` | "An Open Road" ana ekran şeridi (aynı tema, yatay dar) | 1200×300 WebP | `games/uomd/assets/banners/event_strip_open_road.webp` |
| [ ] | `event_those_who_watch` | "Those Who Watch" afişi: tutulma günü sırt yolu ve teras, fenerler, gökyüzünde kararan güneş; Clem, Vespera, Thistle | 2592×1080 WebP | `games/uomd/assets/banners/event_those_who_watch.webp` |
| [ ] | `event_strip_those_who_watch` | "Those Who Watch" ana ekran şeridi (aynı tema, yatay dar) | 1200×300 WebP | `games/uomd/assets/banners/event_strip_those_who_watch.webp` |
| [ ] | `bc_householder` | Portre: Ödünç sandalyenin sahibi, Oakhaven'lı ev sahibi (orta yaş, önlük, sıcak ama ölçülü) | §L biçimi: `composed`, `uneasy`, `warm` | `games/uomd/art/portraits/bc_householder/` |
| [ ] | `lt_traveler` | Portre: Geçitten geçen son yolcu (yorgun, sırt yükü, yol pelerini) | §L biçimi: `composed`, `uneasy`, `warm` | `games/uomd/art/portraits/lt_traveler/` |
| [ ] | `oakhaven_innkeeper` | Portre: Oakhaven hancısı (kasaba hanının sahibi; Crownfall'dan beri parasız yemek veriyor) | §L biçimi: `composed`, `uneasy`, `warm` | `games/uomd/art/portraits/oakhaven_innkeeper/` |
| [ ] | `od_helper` | Portre: Şölen yardımcısı (genç, kollar sıvalı, tabak yığını) | §L biçimi: `composed`, `uneasy`, `warm` | `games/uomd/art/portraits/od_helper/` |
| [ ] | `od_guest` | Portre: Şölen konuğu (çekingen, sade giysi, elinde bir kâse) | §L biçimi: `composed`, `uneasy`, `warm` | `games/uomd/art/portraits/od_guest/` |
| [ ] | `or_volunteer` | Portre: Yardım noktası gönüllüsü (köylü, kalın eldiven, erzak sandığı) | §L biçimi: `composed`, `uneasy`, `warm` | `games/uomd/art/portraits/or_volunteer/` |
| [ ] | `dr_carrier` | Portre: Emanet getiren taşıyıcı (ıslak pelerin, keten bohça, endişeli) | §L biçimi: `composed`, `uneasy`, `warm` | `games/uomd/art/portraits/dr_carrier/` |
| [ ] | `tw_guide` | Portre: Tutulma yolunun rehberi (yerli, deneyimli, değnek ve yol işaretleri) | §L biçimi: `composed`, `uneasy`, `warm` | `games/uomd/art/portraits/tw_guide/` |
| [ ] | `tw_lantern_carrier` | Portre: Fener taşıyıcı (genç, uzun direkli fener, kararlı) | §L biçimi: `composed`, `uneasy`, `warm` | `games/uomd/art/portraits/tw_lantern_carrier/` |
| [ ] | `red_vial_agent` | Portre: Red Vial defter ajanı (şık ama soğuk, defter ve mühür; Two Labels'ın karşıt tarafı) | §L biçimi: `composed`, `uneasy`, `warm` | `games/uomd/art/portraits/red_vial_agent/` |
| [ ] | `tl_carter` | Portre: Arabacı (tuz yolu arabacısı, yıpranmış şapka, dizginler) | §L biçimi: `composed`, `uneasy`, `warm` | `games/uomd/art/portraits/tl_carter/` |
| [ ] | `tl_patient` | Portre: Klinik hastası (sargılı, battaniye, utangaç) | §L biçimi: `composed`, `uneasy`, `warm` | `games/uomd/art/portraits/tl_patient/` |
| [ ] | `tl_baker` | Portre: Liman fırıncısı (unlu önlük, ekmek küreği, pratik) | §L biçimi: `composed`, `uneasy`, `warm` | `games/uomd/art/portraits/tl_baker/` |

### H.3 Modlar (P2 — PLAN §18 E4–E8)
Kaynak avı/ekipman zindanı, Pilgrim's Trial, Oath Hunt ve Guild Dispatch oyunda. Ash Circle'ın arena, işaret ve boss resimleri §M'de,
iki avlu işçisinin (Mera Holt, Tovin Reed) portreleri §L'de; burada tehlike alanlarının çerçeve + şekil simgeleri (tasarım:
"never_color_only"; şimdi yalnız renk). Afişler §H ilk tablo kuralıyla (yazısız, sol üçte bir sade).

| ✓ | Kimlik | İçerik | Boyut | Teslim |
| --- | --- | --- | --- | --- |
| [ ] | `mode_hunts` | Kaynak avı sekme simgesi (av çantası + tüy) | 128×128 | `games/uomd/assets/icons/ui/mode_hunts.png` |
| [ ] | `mode_gear_dungeon` | Ekipman zindanı sekme simgesi (örs + kilitli kapı) | 128×128 | `games/uomd/assets/icons/ui/mode_gear_dungeon.png` |
| [ ] | `mode_pilgrim` | Pilgrim's Trial sekme simgesi (hacı asası + 10 basamak) | 128×128 | `games/uomd/assets/icons/ui/mode_pilgrim.png` |
| [ ] | `mode_oath_hunt` | Oath Hunt sekme simgesi (kırık yemin mührü + kılıç) | 128×128 | `games/uomd/assets/icons/ui/mode_oath_hunt.png` |
| [ ] | `mode_dispatch` | Guild Dispatch sekme simgesi (mühürlü mektup + yol haritası) | 128×128 | `games/uomd/assets/icons/ui/mode_dispatch.png` |
| [ ] | `banner_pilgrim_trial` | Pilgrim's Trial afişi: uzun hac yolunda on taş basamak, uzakta çan kulesi, şafak | 2592×1080 WebP | `games/uomd/assets/banners/mode_pilgrim_trial.webp` |
| [ ] | `banner_oath_hunt` | Oath Hunt afişi: haftanın bossu gölgede, yemin mühürleri yerde, kırmızı ay | 2592×1080 WebP | `games/uomd/assets/banners/mode_oath_hunt.webp` |
| [ ] | `ac_zone_marks` | Ash Circle tehlike alanı çerçeveleri ve şekil simgeleri: daire, koni, şerit, hamle çizgisi (kesik kenarlı uyarı + dolu etkin), su (yavaşlatır, mavi dalga) — renk körü dostu | 256×256 × 10 | `games/uomd/art_src/ash_circle/zone_<şekil>_<uyarı|etkin>.png`\|etkin>.png` |

## I. Arayüz kiti (P0) — sıfırdan (2026-11-14 sıfırlama)
Hepsi `games/uomd/assets/ui_kit/<ad>.png`, RGBA. 9 dilimli parçaların kenar payı `games/uomd/assets/ui_kit/theme.json`'daki
`border` değeridir: köşe süsü o payın içinde kalsın, orta alan düz ve gerilebilir olsun. Çizim gelene kadar oyun aynı adla
koyu panel + altın kenar yer tutucusu çizer (`uomd_engine/rendering/gpu.py` `placeholder_image`).

### I.1 Çerçeveler ve paneller
| ✓ | Kimlik | Boyut | İçerik | Teslim |
| --- | --- | --- | --- | --- |
| [x] | `panel_normal` | 256×256 | Ana panel (koyu mor-siyah zemin, ince altın kenar, köşelerde küçük çan süsü); 9 dilim kenarı 64 px | `games/uomd/assets/ui_kit/panel_normal.png` | **Düzeltildi (Codex, 2026-11-15): §0.2 #1 + 2; sarkan çan yok, köşe kıvrımı en fazla 12 px içeride; dış saydam pay 0; ölçü ve 9 dilim payı aynı.**
| [x] | `panel_hot` | 256×256 | Vurgulu panel (aynı çerçeve, kenar daha parlak altın) | `games/uomd/assets/ui_kit/panel_hot.png` | **Düzeltildi (Codex, 2026-11-15): §0.2 #1 + 2; sarkan çan yok, köşe kıvrımı en fazla 12 px içeride; dış saydam pay 0; ölçü ve 9 dilim payı aynı.**
| [x] | `panel_active` | 256×256 | Seçili panel (altın kenar + içe doğru sıcak ışıma) | `games/uomd/assets/ui_kit/panel_active.png` | **Düzeltildi (Codex, 2026-11-15): §0.2 #1 + 2; sarkan çan yok, köşe kıvrımı en fazla 12 px içeride; dış saydam pay 0; ölçü ve 9 dilim payı aynı.**
| [x] | `panel_dim` | 256×256 | Karartma paneli (yarı saydam siyah-mor, kenarsız; diyalog arkası) | `games/uomd/assets/ui_kit/panel_dim.png` | _Not (Claude, 2026-11-15): oyun karartmayı bu dokunun rengiyle düz dolgu çiziyor (yuvarlak köşeler tam ekranda görünüyordu); yeniden çizim gerekmez._
| [x] | `button_primary` | 320×88 | Ana düğme (altın kenarlı mum mührü kırmızısı; 9 dilim kenarı 28/18 px) | `games/uomd/assets/ui_kit/button_primary.png` | **Düzeltildi (Codex, 2026-11-15): §0.2 #2; dış saydam pay 0; ölçü ve 9 dilim payı aynı.**
| [x] | `button_secondary` | 320×88 | İkincil düğme (koyu zemin, ince gümüş-altın kenar) | `games/uomd/assets/ui_kit/button_secondary.png` | **Düzeltildi (Codex, 2026-11-15): §0.2 #2; dış saydam pay 0; ölçü ve 9 dilim payı aynı.**
| [x] | `button_tab_active` | 256×88 | Seçili sekme | `games/uomd/assets/ui_kit/button_tab_active.png` | **Düzeltildi (Codex, 2026-11-15): §0.2 #2; dış saydam pay 0; ölçü ve 9 dilim payı aynı.**
| [x] | `button_tab_inactive` | 256×88 | Seçili olmayan sekme | `games/uomd/assets/ui_kit/button_tab_inactive.png` | **Düzeltildi (Codex, 2026-11-15): §0.2 #2; dış saydam pay 0; ölçü ve 9 dilim payı aynı.**
| [x] | `frame_card_3star` | 256×320 | 3★ kart çerçevesi (bronz) | `games/uomd/assets/ui_kit/frame_card_3star.png` | **Düzeltildi (Codex, 2026-11-15): §0.2 #2; dış saydam pay 0; ölçü ve 9 dilim payı aynı.**
| [x] | `frame_card_4star` | 256×320 | 4★ kart çerçevesi (mor-gümüş) | `games/uomd/assets/ui_kit/frame_card_4star.png` | **Düzeltildi (Codex, 2026-11-15): §0.2 #2; dış saydam pay 0; ölçü ve 9 dilim payı aynı.**
| [x] | `frame_card_5star` | 256×320 | 5★ kart çerçevesi (altın, çan süslü) | `games/uomd/assets/ui_kit/frame_card_5star.png` | **Düzeltildi (Codex, 2026-11-15): §0.2 #2; dış saydam pay 0; ölçü ve 9 dilim payı aynı.**
| [x] | `badge_pill` | 192×64 | Hap rozet zemini (sayı/etiket arkası) | `games/uomd/assets/ui_kit/badge_pill.png` | **Düzeltildi (Codex, 2026-11-15): §0.2 #2; dış saydam pay 0; ölçü ve 9 dilim payı aynı.**
| [x] | `progress_frame` | 320×44 | İlerleme çubuğu çerçevesi | `games/uomd/assets/ui_kit/progress_frame.png` | **Düzeltildi (Codex, 2026-11-15): §0.2 #2; dış saydam pay 0; ölçü ve 9 dilim payı aynı.**
| [x] | `divider_bell` | 640×88 | Ortasında küçük çan olan yatay ayırıcı | `games/uomd/assets/ui_kit/divider_bell.png` |
| [x] | `logo_master` | 320×148 | Oyun logosu küçük boy (başlık ekranı; §G logo ile aynı çizim) | `games/uomd/assets/ui_kit/logo_master.png` |
| [x] | `uikit_corner_bell_chain` | 311×419 | Sol üst köşe süsü: zincirden sarkan çan | `games/uomd/assets/ui_kit/uikit_corner_bell_chain.png` |
| [x] | `uikit_corner_bell_chain_right` | 311×419 | Aynı süsün sağ köşe aynası | `games/uomd/assets/ui_kit/uikit_corner_bell_chain_right.png` |
| [x] | `notice_dot` | 64×64 | Bildirim noktası (kırmızı-altın damla); Ash Circle'da XP/atış noktası olarak da kullanılır | `games/uomd/assets/ui_kit/notice_dot.png` |

### I.2 Küçük arayüz simgeleri (96×96)
| ✓ | Kimlik | İçerik | Teslim |
| --- | --- | --- | --- |
| [x] | `icon_el_ember` | Ember element simgesi (§1 element rengi) | `games/uomd/assets/ui_kit/icon_el_ember.png` |
| [x] | `icon_el_tide` | Tide element simgesi (§1 element rengi) | `games/uomd/assets/ui_kit/icon_el_tide.png` |
| [x] | `icon_el_gale` | Gale element simgesi (§1 element rengi) | `games/uomd/assets/ui_kit/icon_el_gale.png` |
| [x] | `icon_el_stone` | Stone element simgesi (§1 element rengi) | `games/uomd/assets/ui_kit/icon_el_stone.png` |
| [x] | `icon_el_veil` | Veil element simgesi (§1 element rengi) | `games/uomd/assets/ui_kit/icon_el_veil.png` |
| [x] | `icon_el_dawn` | Dawn element simgesi (§1 element rengi) | `games/uomd/assets/ui_kit/icon_el_dawn.png` |
| [x] | `icon_nav_sanctuary` | Gezinme: Sığınak (ana ekran) | `games/uomd/assets/ui_kit/icon_nav_sanctuary.png` |
| [x] | `icon_nav_journey` | Gezinme: Yolculuk (bölümler) | `games/uomd/assets/ui_kit/icon_nav_journey.png` |
| [x] | `icon_nav_companions` | Gezinme: Yoldaşlar | `games/uomd/assets/ui_kit/icon_nav_companions.png` |
| [x] | `icon_nav_summon` | Gezinme: Çağırma (çan) | `games/uomd/assets/ui_kit/icon_nav_summon.png` |
| [x] | `icon_nav_records` | Gezinme: Kayıtlar (kitap) | `games/uomd/assets/ui_kit/icon_nav_records.png` |
| [x] | `icon_nav_settings` | Gezinme: Ayarlar (mühür) | `games/uomd/assets/ui_kit/icon_nav_settings.png` |
| [x] | `icon_skill_basic` | Beceri türü: temel saldırı | `games/uomd/assets/ui_kit/icon_skill_basic.png` |
| [x] | `icon_skill_active` | Beceri türü: aktif | `games/uomd/assets/ui_kit/icon_skill_active.png` |
| [x] | `icon_skill_ultimate` | Beceri türü: ultimate | `games/uomd/assets/ui_kit/icon_skill_ultimate.png` |
| [x] | `icon_bell` | Çan (Bell's Remains para birimi küçük simgesi) | `games/uomd/assets/ui_kit/icon_bell.png` |
| [x] | `icon_seal` | Mum mührü | `games/uomd/assets/ui_kit/icon_seal.png` |
| [x] | `icon_token` | Etkinlik jetonu | `games/uomd/assets/ui_kit/icon_token.png` |

### I.3 Canlı arayüz kareleri (P2)
Sekiz karelik döngüler, her kare 320×320 ayrı dosya (`_01` … `_08`), saydam.
| ✓ | Kimlik | İçerik | Teslim |
| --- | --- | --- | --- |
| [ ] | `anim_bell` | Sallanan çan (ana ekran köşesi) | `games/uomd/assets/ui_kit/anim_bell_01.png` `games/uomd/assets/ui_kit/anim_bell_02.png` `games/uomd/assets/ui_kit/anim_bell_03.png` `games/uomd/assets/ui_kit/anim_bell_04.png` `games/uomd/assets/ui_kit/anim_bell_05.png` `games/uomd/assets/ui_kit/anim_bell_06.png` `games/uomd/assets/ui_kit/anim_bell_07.png` `games/uomd/assets/ui_kit/anim_bell_08.png` |
| [ ] | `anim_corona` | Dönen ışık tacı (çağırma düğmesi) | `games/uomd/assets/ui_kit/anim_corona_01.png` `games/uomd/assets/ui_kit/anim_corona_02.png` `games/uomd/assets/ui_kit/anim_corona_03.png` `games/uomd/assets/ui_kit/anim_corona_04.png` `games/uomd/assets/ui_kit/anim_corona_05.png` `games/uomd/assets/ui_kit/anim_corona_06.png` `games/uomd/assets/ui_kit/anim_corona_07.png` `games/uomd/assets/ui_kit/anim_corona_08.png` |

### I.4 Parçacık dokuları (P3)
512×512, siyah değil **saydam** zemin, beyaz çekirdek (oyun renklendirir, toplamalı çizer). Gelene kadar kod yumuşak bir ışık noktası üretir.
| ✓ | Kimlik | İçerik | Teslim |
| --- | --- | --- | --- |
| [ ] | `vfx_flare` | Yumuşak ışık parlaması (kül/ateş böceği parçacığı) | `games/uomd/assets/ui_kit/vfx_flare.png` |
| [ ] | `vfx_star_spark` | Dört köşeli yıldız kıvılcımı | `games/uomd/assets/ui_kit/vfx_star_spark.png` |
| [ ] | `vfx_rune_ring` | Rün halkası (çağırma) | `games/uomd/assets/ui_kit/vfx_rune_ring.png` |
| [ ] | `vfx_slash` | Tek savuruş yayı | `games/uomd/assets/ui_kit/vfx_slash.png` |
| [ ] | `vfx_sunburst` | Güneş patlaması ışınları | `games/uomd/assets/ui_kit/vfx_sunburst.png` |
| [ ] | `uikit_vfx_corona_ring` | Taç halkası (başlık/çağırma parıltısı) | `games/uomd/assets/ui_kit/uikit_vfx_corona_ring.png` |

### I.5 Ultimate kesme şeritleri (P1)
1920×360 RGBA: kahramanın yüzü/üst gövdesi yatay bantta, element rengi arka ışık; ultimate başlarken ekranı yatay keser.
| ✓ | Kimlik | Kahraman | Teslim |
| --- | --- | --- | --- |
| [x] | `cutin_band_mahmut` | Mahmut | `games/uomd/assets/ui_kit/cutin_band_mahmut.png` |
| [x] | `cutin_band_fadyme` | Fadyme | `games/uomd/assets/ui_kit/cutin_band_fadyme.png` |
| [x] | `cutin_band_kera_voss` | Kera Voss | `games/uomd/assets/ui_kit/cutin_band_kera_voss.png` |
| [x] | `cutin_band_brin_alder` | Brin Alder | `games/uomd/assets/ui_kit/cutin_band_brin_alder.png` |
| [x] | `cutin_band_nixie_vale` | Nixie Vale | `games/uomd/assets/ui_kit/cutin_band_nixie_vale.png` |
| [x] | `cutin_band_sister_aveline` | Sister Aveline | `games/uomd/assets/ui_kit/cutin_band_sister_aveline.png` |
| [x] | `cutin_band_sable_wren` | Sable Wren | `games/uomd/assets/ui_kit/cutin_band_sable_wren.png` |
| [x] | `cutin_band_tilda_fen` | Tilda Fen | `games/uomd/assets/ui_kit/cutin_band_tilda_fen.png` |
| [x] | `cutin_band_rikka_ember` | Rikka Ember | `games/uomd/assets/ui_kit/cutin_band_rikka_ember.png` |
| [x] | `cutin_band_mirel_quill` | Mirel Quill | `games/uomd/assets/ui_kit/cutin_band_mirel_quill.png` |
| [x] | `cutin_band_odelia_pike` | Odelia Pike | `games/uomd/assets/ui_kit/cutin_band_odelia_pike.png` |
| [x] | `cutin_band_pippa_bell` | Pippa Bell | `games/uomd/assets/ui_kit/cutin_band_pippa_bell.png` |
| [x] | `cutin_band_nara_vell` | Nara Vell | `games/uomd/assets/ui_kit/cutin_band_nara_vell.png` |
| [x] | `cutin_band_clem_marr` | Clem Marr | `games/uomd/assets/ui_kit/cutin_band_clem_marr.png` |
| [x] | `cutin_band_vespera_wisp` | Vespera Wisp | `games/uomd/assets/ui_kit/cutin_band_vespera_wisp.png` |
| [x] | `cutin_band_hana_birch` | Hana Birch | `games/uomd/assets/ui_kit/cutin_band_hana_birch.png` |
| [x] | `cutin_band_thistle_roe` | Thistle Roe | `games/uomd/assets/ui_kit/cutin_band_thistle_roe.png` |
| [x] | `cutin_band_iona_mist` | Iona Mist | `games/uomd/assets/ui_kit/cutin_band_iona_mist.png` |
| [x] | `cutin_band_jori_flint` | Jori Flint | `games/uomd/assets/ui_kit/cutin_band_jori_flint.png` |
| [x] | `cutin_band_marek_vane` | Marek Vane | `games/uomd/assets/ui_kit/cutin_band_marek_vane.png` |
| [x] | `cutin_band_garrick_cinder` | Garrick Cinder | `games/uomd/assets/ui_kit/cutin_band_garrick_cinder.png` |
| [x] | `cutin_band_corbin_locke` | Corbin Locke | `games/uomd/assets/ui_kit/cutin_band_corbin_locke.png` |
| [x] | `cutin_band_cassian_thorne` | Cassian Thorne | `games/uomd/assets/ui_kit/cutin_band_cassian_thorne.png` |
| [x] | `cutin_band_dorian_kesk` | Dorian Kesk | `games/uomd/assets/ui_kit/cutin_band_dorian_kesk.png` |
| [x] | `cutin_band_rowan_reed` | Rowan Reed | `games/uomd/assets/ui_kit/cutin_band_rowan_reed.png` |

## J. Arka planlar (P0–P2) — sıfırdan
1920×1080, WebP (kalite 90) ya da PNG; yazı yok, karakter yok (karakterleri oyun koyar). Alt üçte bir sade (diyalog kutusu),
ufuk çizgisi ekranın ~%55'inde (chibiler oraya basar). Mekân tarifleri: `docs/art_bible/locations.md`; bölümün havası
hikâye metninden (`games/uomd/content/**/story/*.json`, satırdaki ilk sahne adı aşağıda).

### J.1 Ekran arka planları (P0)
| ✓ | Dosya | İçerik | Teslim |
| --- | --- | --- | --- |
| [x] | `bg_title_cathedral.png` | Başlık ekranı: yıkık katedral, dev çan, mum ışığı; orta alt boş (logo ve düğme) | `games/uomd/assets/bg_title_cathedral.png` |
| [x] | `bg_ui_hub_sanctuary.png` | Ana ekran (Sığınak): çan kulesi avlusu, akşam; orta zemin boş (iki chibi orada durur) | `games/uomd/assets/bg_ui_hub_sanctuary.png` |
| [x] | `bg_ui_gacha_summon_altar.png` | Çağırma: çanlar sunağı, yerde rün çemberi, yukarıdan ışık | `games/uomd/assets/bg_ui_gacha_summon_altar.png` |
| [x] | `bg_sol_world_map_part1.webp` | Part I dünya haritası (yazısız; 7 bölge, `docs/art_bible/locations.md` §1) | `games/uomd/assets/bg_sol_world_map_part1.webp` |

### J.2 Hikâye ve savaş mekânları (kampanya P1, yan etkinlik P2)
| ✓ | Mekân | Öncelik | İlk sahne | Teslim |
| --- | --- | --- | --- | --- |
| [x] | `altar_east_passage` | P1 | yan hikâye: Lanterns | `games/uomd/assets/bg_sol_altar_east_passage.webp` |
| [x] | `altar_field_infirmary` | P1 | yan hikâye: The Clinic Door | `games/uomd/assets/bg_sol_altar_field_infirmary.webp` |
| [x] | `altar_first_eclipse` | P1 | The Stair of Seven Chains | `games/uomd/assets/bg_sol_altar_first_eclipse.webp` |
| [x] | `altar_first_eclipse_outer_dais` | P1 | The Words He Did Not Know | `games/uomd/assets/bg_sol_altar_first_eclipse_outer_dais.webp` |
| [x] | `altar_first_eclipse_reflection` | P1 | The Hour That Remained | `games/uomd/assets/bg_sol_altar_first_eclipse_reflection.webp` |
| [x] | `altar_outer_stair` | P1 | yan hikâye: The Barricade Was My Idea | `games/uomd/assets/bg_sol_altar_outer_stair.webp` |
| [x] | `altar_round_archive` | P1 | yan hikâye: Witnesses, Not Sacrifices | `games/uomd/assets/bg_sol_altar_round_archive.webp` |
| [x] | `ashen_estate_conservatory` | P1 | yan hikâye: Honest Prognosis | `games/uomd/assets/bg_sol_ashen_estate_conservatory.webp` |
| [x] | `ashen_estate_gallery` | P1 | yan hikâye: Copyist | `games/uomd/assets/bg_sol_ashen_estate_gallery.webp` |
| [x] | `ashen_estate_ruins` | P1 | Separate Roads | `games/uomd/assets/bg_sol_ashen_estate_ruins.webp` |
| [x] | `ashen_estate_servants_wing` | P1 | yan hikâye: The Servants' Door | `games/uomd/assets/bg_sol_ashen_estate_servants_wing.webp` |
| [x] | `aw_case_board` | P2 | An Answer Worth Keeping | `games/uomd/assets/bg_sol_aw_case_board.webp` |
| [x] | `bc_house_door` | P2 | Carrying without a Chorus | `games/uomd/assets/bg_sol_bc_house_door.webp` |
| [x] | `bridge_far_bank` | P1 | Watch Kept | `games/uomd/assets/bg_sol_bridge_far_bank.webp` |
| [x] | `bridge_forsaken` | P1 | A Banner in the Fog | `games/uomd/assets/bg_sol_bridge_forsaken.webp` |
| [x] | `bridge_gate` | P1 | yan hikâye: The Measure | `games/uomd/assets/bg_sol_bridge_gate.webp` |
| [x] | `bridge_signal_tower` | P1 | yan hikâye: Sealed Delivery | `games/uomd/assets/bg_sol_bridge_signal_tower.webp` |
| [x] | `cathedral_saint_luthos` | P1 | What We Did Not Say | `games/uomd/assets/bg_sol_cathedral_saint_luthos.webp` |
| [x] | `dr_dry_room` | P2 | Page Numbers Outward | `games/uomd/assets/bg_sol_dr_dry_room.webp` |
| [x] | `dr_refuge_desk` | P2 | The Damp Edge | `games/uomd/assets/bg_sol_dr_refuge_desk.webp` |
| [x] | `dr_refuge_passage` | P2 | A Passage for Readers | `games/uomd/assets/bg_sol_dr_refuge_passage.webp` |
| [x] | `eastern_highland_road` | P1 | The Estate Road | `games/uomd/assets/bg_sol_eastern_highland_road.webp` |
| [x] | `eastern_ravine_road` | P1 | Fog in the Ravine | `games/uomd/assets/bg_sol_eastern_ravine_road.webp` |
| [x] | `eastern_village_square` | P1 | yan hikâye: Retraction | `games/uomd/assets/bg_sol_eastern_village_square.webp` |
| [x] | `estate_ashen_lord` | P1 | The Servants’ Entrance | `games/uomd/assets/bg_sol_estate_ashen_lord.webp` |
| [x] | `forest_edge_road` | P1 | The Tower Across the Fields | `games/uomd/assets/bg_sol_forest_edge_road.webp` |
| [x] | `forest_whispering_ash` | P1 | The First Step | `games/uomd/assets/bg_sol_forest_whispering_ash.webp` |
| [x] | `forgotten_stone_crossing` | P1 | A Road Forgotten | `games/uomd/assets/bg_sol_forgotten_stone_crossing.webp` |
| [x] | `highland_ridge` | P1 | A Safe Edge | `games/uomd/assets/bg_sol_highland_ridge.webp` |
| [x] | `highland_village` | P1 | A Sound Kept in Someone’s Words | `games/uomd/assets/bg_sol_highland_village.webp` |
| [x] | `kiln_town` | P1 | yan hikâye: Procession for the Missing | `games/uomd/assets/bg_sol_kiln_town.webp` |
| [x] | `lowland_refuge` | P1 | yan hikâye: Two Roofs | `games/uomd/assets/bg_sol_lowland_refuge.webp` |
| [x] | `lowland_refuge_road` | P1 | yan hikâye: Last Cart | `games/uomd/assets/bg_sol_lowland_refuge_road.webp` |
| [x] | `lt_brace_bank` | P2 | The Footing | `games/uomd/assets/bg_sol_lt_brace_bank.webp` |
| [x] | `lt_forest_junction` | P2 | Not All on One Shoulder | `games/uomd/assets/bg_sol_lt_forest_junction.webp` |
| [x] | `lt_forest_passage` | P2 | The Open Passage | `games/uomd/assets/bg_sol_lt_forest_passage.webp` |
| [x] | `lt_scout_bend` | P2 | The Turn in the Leaves | `games/uomd/assets/bg_sol_lt_scout_bend.webp` |
| [x] | `mountain_crater_rim` | P1 | The Crown-Shaped Crater | `games/uomd/assets/bg_sol_mountain_crater_rim.webp` |
| [x] | `mountain_lower_pass` | P1 | yan hikâye: Keep Up | `games/uomd/assets/bg_sol_mountain_lower_pass.webp` |
| [x] | `oakhaven_forge` | P1 | yan hikâye: Forge Gate | `games/uomd/assets/bg_sol_oakhaven_forge.webp` |
| [x] | `oakhaven_inn` | P1 | The Sealed Order | `games/uomd/assets/bg_sol_oakhaven_inn.webp` |
| [x] | `oakhaven_refuge` | P1 | yan hikâye: Vale | `games/uomd/assets/bg_sol_oakhaven_refuge.webp` |
| [x] | `oakhaven_square` | P1 | One of the Returning Chairs | `games/uomd/assets/bg_sol_oakhaven_square.webp` |
| [x] | `od_outer_lane` | P2 | Before the Last Load | `games/uomd/assets/bg_sol_od_outer_lane.webp` |
| [x] | `od_song_corner` | P2 | A Name That Fits | `games/uomd/assets/bg_sol_od_song_corner.webp` |
| [x] | `od_storehouse_lane` | P2 | The Storehouse Turn | `games/uomd/assets/bg_sol_od_storehouse_lane.webp` |
| [x] | `od_table_work` | P2 | Under the Table | `games/uomd/assets/bg_sol_od_table_work.webp` |
| [x] | `or_relief_stop` | P2 | Beyond the Crossing | `games/uomd/assets/bg_sol_or_relief_stop.webp` |
| [x] | `or_safe_approach` | P2 | The Remaining Threat | `games/uomd/assets/bg_sol_or_safe_approach.webp` |
| [x] | `or_supply_board` | P2 | Where the Next Cloth Waits | `games/uomd/assets/bg_sol_or_supply_board.webp` |
| [x] | `or_waiting_lane` | P2 | Walk It Once | `games/uomd/assets/bg_sol_or_waiting_lane.webp` |
| [x] | `orchard_lowlands` | P1 | Orchard Country | `games/uomd/assets/bg_sol_orchard_lowlands.webp` |
| [x] | `river_city_gates` | P1 | Up Into the Light | `games/uomd/assets/bg_sol_river_city_gates.webp` |
| [x] | `salt_road_coast` | P1 | The Coast Road | `games/uomd/assets/bg_sol_salt_road_coast.webp` |
| [x] | `shelter_courtyard_dusk` | P1 | A Roof Before Dawn | `games/uomd/assets/bg_sol_shelter_courtyard_dusk.webp` |
| [x] | `tl_archive_yard` | P2 | Four Handles | `games/uomd/assets/bg_sol_tl_archive_yard.webp` |
| [x] | `tl_clinic_table` | P2 | The Door Stays Open | `games/uomd/assets/bg_sol_tl_clinic_table.webp` |
| [x] | `tl_coast_path` | P2 | The Steps That Remain | `games/uomd/assets/bg_sol_tl_coast_path.webp` |
| [x] | `tl_harbor_lane` | P2 | Nothing Owed | `games/uomd/assets/bg_sol_tl_harbor_lane.webp` |
| [x] | `tl_harbor_square` | P2 | A Place to Put It Down | `games/uomd/assets/bg_sol_tl_harbor_square.webp` |
| [x] | `tl_load_road` | P2 | The Cart with No Driver | `games/uomd/assets/bg_sol_tl_load_road.webp` |
| [x] | `tl_salt_fork` | P2 | Two Roads, One Delivery | `games/uomd/assets/bg_sol_tl_salt_fork.webp` |
| [x] | `tw_lower_path` | P2 | The Next Small Group | `games/uomd/assets/bg_sol_tw_lower_path.webp` |
| [x] | `tw_ridge_path` | P2 | The Open Turn | `games/uomd/assets/bg_sol_tw_ridge_path.webp` |
| [x] | `tw_terrace_path` | P2 | The Firm Approach | `games/uomd/assets/bg_sol_tw_terrace_path.webp` |
| [x] | `tw_upper_turn` | P2 | Where to Watch | `games/uomd/assets/bg_sol_tw_upper_turn.webp` |
| [x] | `undercity_antidote_archive` | P1 | Three Cases, No New Attack | `games/uomd/assets/bg_sol_undercity_antidote_archive.webp` |
| [x] | `undercity_archive_room` | P1 | yan hikâye: Rubbings | `games/uomd/assets/bg_sol_undercity_archive_room.webp` |
| [x] | `undercity_cistern` | P1 | yan hikâye: Names on the Water | `games/uomd/assets/bg_sol_undercity_cistern.webp` |
| [x] | `undercity_cistern_stairs` | P1 | yan hikâye: Chalk Arrows | `games/uomd/assets/bg_sol_undercity_cistern_stairs.webp` |
| [x] | `undercity_market` | P1 | yan hikâye: Honest Labels | `games/uomd/assets/bg_sol_undercity_market.webp` |
| [x] | `undercity_red_vial_ward` | P1 | yan hikâye: Mother's Prayer Book | `games/uomd/assets/bg_sol_undercity_red_vial_ward.webp` |
| [x] | `undercity_subterranean` | P1 | Stairs Below the Cistern | `games/uomd/assets/bg_sol_undercity_subterranean.webp` |
| [x] | `village_oakhaven` | P1 | The Empty Orchard | `games/uomd/assets/bg_sol_village_oakhaven.webp` |

## K. Prolog sahneleri (P1)
1920×1080 WebP; sinematik, yazısız, ressamca; prologda metnin arkasında yavaşça kayar (kenarlarda 5 % taşma payı bırak).
Konu sırası prolog metnindedir (`games/uomd/content/base/entry/`).
| ✓ | Kare | İçerik | Teslim |
| --- | --- | --- | --- |
| [ ] | `beginning` | Başlangıç: kül yağan yol, iki küçük figür uzakta | `games/uomd/assets/still_sol_prologue_beginning.webp` |
| [ ] | `ordinary_days` | Sıradan günler: köy, pazar, güneş | `games/uomd/assets/still_sol_prologue_ordinary_days.webp` |
| [ ] | `throne_wars` | Taht savaşları: sancaklar, yanan şehir silueti | `games/uomd/assets/still_sol_prologue_throne_wars.webp` |
| [ ] | `crownfall` | Taç düşüşü: kırık taç, çökmüş taht salonu | `games/uomd/assets/still_sol_prologue_crownfall.webp` |
| [ ] | `hours` | Saatler: duran saat kuleleri, çanlar | `games/uomd/assets/still_sol_prologue_hours.webp` |
| [ ] | `names` | İsimler: taşa kazınmış adlar, mumlar | `games/uomd/assets/still_sol_prologue_names.webp` |
| [ ] | `roads` | Yollar: ayrılan patikalar, kül fırtınası | `games/uomd/assets/still_sol_prologue_roads.webp` |
| [ ] | `search` | Arayış: fenerle karanlıkta yürüyen gölge | `games/uomd/assets/still_sol_prologue_search.webp` |
| [ ] | `reunion` | Kavuşma: Mahmut ve Fadyme yolda karşılaşır (sırtları dönük, uzak plan) | `games/uomd/assets/still_sol_prologue_reunion.webp` |

## L. Hikâye (VN) portreleri — 7 temel ifade
Diz üstü tam figür, **768×1152 RGBA**, saydam zemin, yüz üst üçte birde, ayaklar kadraj dışında; aynı karakterin yedi dosyası
aynı kıyafet, aynı ölçek ve aynı duruşta, yalnız yüz + eller değişir. Teslim: `games/uomd/art/portraits/<kimlik>/<ifade>.webp`.
İfadeler: `composed` (sakin), `warm` (gülümseme), `firm` (kararlı), `uneasy` (tedirgin/korkmuş), `sad` (üzgün), `angry` (öfkeli/meydan
okuyan), `surprised` (şaşkın). Hikâyedeki diğer ~200 duygu bunlardan birine düşer (`build_portrait_emotions.py` eş-anlam tablosu).
Manifesti (`build_portrait_emotions.py`) Claude yeniler; oyunda kemikli nefes/eğilme animasyonu motor tarafından uygulanır,
resme poz verme.
| ✓ | Kimlik | Kim | Öncelik | Tasarım kaynağı | Teslim |
| --- | --- | --- | --- | --- | --- |
| [x] | `mahmut` | Mahmut | P0 | `docs/art_bible/character_locks.md` §2 | `games/uomd/art/portraits/mahmut/composed.webp` `games/uomd/art/portraits/mahmut/warm.webp` `games/uomd/art/portraits/mahmut/firm.webp` `games/uomd/art/portraits/mahmut/uneasy.webp` `games/uomd/art/portraits/mahmut/sad.webp` `games/uomd/art/portraits/mahmut/angry.webp` `games/uomd/art/portraits/mahmut/surprised.webp` |
| [x] | `fadyme` | Fadyme | P0 | `docs/art_bible/heroes/fadyme.md` | `games/uomd/art/portraits/fadyme/composed.webp` `games/uomd/art/portraits/fadyme/warm.webp` `games/uomd/art/portraits/fadyme/firm.webp` `games/uomd/art/portraits/fadyme/uneasy.webp` `games/uomd/art/portraits/fadyme/sad.webp` `games/uomd/art/portraits/fadyme/angry.webp` `games/uomd/art/portraits/fadyme/surprised.webp` |
| [x] | `kera_voss` | Kera Voss | P1 | `docs/art_bible/heroes/kera_voss.md` | `games/uomd/art/portraits/kera_voss/composed.webp` `games/uomd/art/portraits/kera_voss/warm.webp` `games/uomd/art/portraits/kera_voss/firm.webp` `games/uomd/art/portraits/kera_voss/uneasy.webp` `games/uomd/art/portraits/kera_voss/sad.webp` `games/uomd/art/portraits/kera_voss/angry.webp` `games/uomd/art/portraits/kera_voss/surprised.webp` |
| [x] | `brin_alder` | Brin Alder | P1 | `docs/art_bible/heroes/brin_alder.md` | `games/uomd/art/portraits/brin_alder/composed.webp` `games/uomd/art/portraits/brin_alder/warm.webp` `games/uomd/art/portraits/brin_alder/firm.webp` `games/uomd/art/portraits/brin_alder/uneasy.webp` `games/uomd/art/portraits/brin_alder/sad.webp` `games/uomd/art/portraits/brin_alder/angry.webp` `games/uomd/art/portraits/brin_alder/surprised.webp` |
| [x] | `nixie_vale` | Nixie Vale | P1 | `docs/art_bible/heroes/nixie_vale.md` | `games/uomd/art/portraits/nixie_vale/composed.webp` `games/uomd/art/portraits/nixie_vale/warm.webp` `games/uomd/art/portraits/nixie_vale/firm.webp` `games/uomd/art/portraits/nixie_vale/uneasy.webp` `games/uomd/art/portraits/nixie_vale/sad.webp` `games/uomd/art/portraits/nixie_vale/angry.webp` `games/uomd/art/portraits/nixie_vale/surprised.webp` |
| [x] | `sister_aveline` | Sister Aveline | P1 | `docs/art_bible/heroes/sister_aveline.md` | `games/uomd/art/portraits/sister_aveline/composed.webp` `games/uomd/art/portraits/sister_aveline/warm.webp` `games/uomd/art/portraits/sister_aveline/firm.webp` `games/uomd/art/portraits/sister_aveline/uneasy.webp` `games/uomd/art/portraits/sister_aveline/sad.webp` `games/uomd/art/portraits/sister_aveline/angry.webp` `games/uomd/art/portraits/sister_aveline/surprised.webp` |
| [x] | `sable_wren` | Sable Wren | P1 | `docs/art_bible/heroes/sable_wren.md` | `games/uomd/art/portraits/sable_wren/composed.webp` `games/uomd/art/portraits/sable_wren/warm.webp` `games/uomd/art/portraits/sable_wren/firm.webp` `games/uomd/art/portraits/sable_wren/uneasy.webp` `games/uomd/art/portraits/sable_wren/sad.webp` `games/uomd/art/portraits/sable_wren/angry.webp` `games/uomd/art/portraits/sable_wren/surprised.webp` |
| [x] | `tilda_fen` | Tilda Fen | P1 | `docs/art_bible/heroes/tilda_fen.md` | `games/uomd/art/portraits/tilda_fen/composed.webp` `games/uomd/art/portraits/tilda_fen/warm.webp` `games/uomd/art/portraits/tilda_fen/firm.webp` `games/uomd/art/portraits/tilda_fen/uneasy.webp` `games/uomd/art/portraits/tilda_fen/sad.webp` `games/uomd/art/portraits/tilda_fen/angry.webp` `games/uomd/art/portraits/tilda_fen/surprised.webp` |
| [x] | `rikka_ember` | Rikka Ember | P1 | `docs/art_bible/heroes/rikka_ember.md` | `games/uomd/art/portraits/rikka_ember/composed.webp` `games/uomd/art/portraits/rikka_ember/warm.webp` `games/uomd/art/portraits/rikka_ember/firm.webp` `games/uomd/art/portraits/rikka_ember/uneasy.webp` `games/uomd/art/portraits/rikka_ember/sad.webp` `games/uomd/art/portraits/rikka_ember/angry.webp` `games/uomd/art/portraits/rikka_ember/surprised.webp` |
| [x] | `mirel_quill` | Mirel Quill | P1 | `docs/art_bible/heroes/mirel_quill.md` | `games/uomd/art/portraits/mirel_quill/composed.webp` `games/uomd/art/portraits/mirel_quill/warm.webp` `games/uomd/art/portraits/mirel_quill/firm.webp` `games/uomd/art/portraits/mirel_quill/uneasy.webp` `games/uomd/art/portraits/mirel_quill/sad.webp` `games/uomd/art/portraits/mirel_quill/angry.webp` `games/uomd/art/portraits/mirel_quill/surprised.webp` |
| [x] | `odelia_pike` | Odelia Pike | P1 | `docs/art_bible/heroes/odelia_pike.md` | `games/uomd/art/portraits/odelia_pike/composed.webp` `games/uomd/art/portraits/odelia_pike/warm.webp` `games/uomd/art/portraits/odelia_pike/firm.webp` `games/uomd/art/portraits/odelia_pike/uneasy.webp` `games/uomd/art/portraits/odelia_pike/sad.webp` `games/uomd/art/portraits/odelia_pike/angry.webp` `games/uomd/art/portraits/odelia_pike/surprised.webp` |
| [x] | `pippa_bell` | Pippa Bell | P1 | `docs/art_bible/heroes/pippa_bell.md` | `games/uomd/art/portraits/pippa_bell/composed.webp` `games/uomd/art/portraits/pippa_bell/warm.webp` `games/uomd/art/portraits/pippa_bell/firm.webp` `games/uomd/art/portraits/pippa_bell/uneasy.webp` `games/uomd/art/portraits/pippa_bell/sad.webp` `games/uomd/art/portraits/pippa_bell/angry.webp` `games/uomd/art/portraits/pippa_bell/surprised.webp` |
| [x] | `nara_vell` | Nara Vell | P1 | `docs/art_bible/heroes/nara_vell.md` | `games/uomd/art/portraits/nara_vell/composed.webp` `games/uomd/art/portraits/nara_vell/warm.webp` `games/uomd/art/portraits/nara_vell/firm.webp` `games/uomd/art/portraits/nara_vell/uneasy.webp` `games/uomd/art/portraits/nara_vell/sad.webp` `games/uomd/art/portraits/nara_vell/angry.webp` `games/uomd/art/portraits/nara_vell/surprised.webp` |
| [x] | `clem_marr` | Clem Marr | P1 | `docs/art_bible/heroes/clem_marr.md` | `games/uomd/art/portraits/clem_marr/composed.webp` `games/uomd/art/portraits/clem_marr/warm.webp` `games/uomd/art/portraits/clem_marr/firm.webp` `games/uomd/art/portraits/clem_marr/uneasy.webp` `games/uomd/art/portraits/clem_marr/sad.webp` `games/uomd/art/portraits/clem_marr/angry.webp` `games/uomd/art/portraits/clem_marr/surprised.webp` |
| [x] | `vespera_wisp` | Vespera Wisp | P1 | `docs/art_bible/heroes/vespera_wisp.md` | `games/uomd/art/portraits/vespera_wisp/composed.webp` `games/uomd/art/portraits/vespera_wisp/warm.webp` `games/uomd/art/portraits/vespera_wisp/firm.webp` `games/uomd/art/portraits/vespera_wisp/uneasy.webp` `games/uomd/art/portraits/vespera_wisp/sad.webp` `games/uomd/art/portraits/vespera_wisp/angry.webp` `games/uomd/art/portraits/vespera_wisp/surprised.webp` |
| [x] | `hana_birch` | Hana Birch | P1 | `docs/art_bible/heroes/hana_birch.md` | `games/uomd/art/portraits/hana_birch/composed.webp` `games/uomd/art/portraits/hana_birch/warm.webp` `games/uomd/art/portraits/hana_birch/firm.webp` `games/uomd/art/portraits/hana_birch/uneasy.webp` `games/uomd/art/portraits/hana_birch/sad.webp` `games/uomd/art/portraits/hana_birch/angry.webp` `games/uomd/art/portraits/hana_birch/surprised.webp` |
| [x] | `thistle_roe` | Thistle Roe | P1 | `docs/art_bible/heroes/thistle_roe.md` | `games/uomd/art/portraits/thistle_roe/composed.webp` `games/uomd/art/portraits/thistle_roe/warm.webp` `games/uomd/art/portraits/thistle_roe/firm.webp` `games/uomd/art/portraits/thistle_roe/uneasy.webp` `games/uomd/art/portraits/thistle_roe/sad.webp` `games/uomd/art/portraits/thistle_roe/angry.webp` `games/uomd/art/portraits/thistle_roe/surprised.webp` |
| [x] | `iona_mist` | Iona Mist | P1 | `docs/art_bible/heroes/iona_mist.md` | `games/uomd/art/portraits/iona_mist/composed.webp` `games/uomd/art/portraits/iona_mist/warm.webp` `games/uomd/art/portraits/iona_mist/firm.webp` `games/uomd/art/portraits/iona_mist/uneasy.webp` `games/uomd/art/portraits/iona_mist/sad.webp` `games/uomd/art/portraits/iona_mist/angry.webp` `games/uomd/art/portraits/iona_mist/surprised.webp` |
| [x] | `jori_flint` | Jori Flint | P1 | `docs/art_bible/heroes/jori_flint.md` | `games/uomd/art/portraits/jori_flint/composed.webp` `games/uomd/art/portraits/jori_flint/warm.webp` `games/uomd/art/portraits/jori_flint/firm.webp` `games/uomd/art/portraits/jori_flint/uneasy.webp` `games/uomd/art/portraits/jori_flint/sad.webp` `games/uomd/art/portraits/jori_flint/angry.webp` `games/uomd/art/portraits/jori_flint/surprised.webp` |
| [x] | `marek_vane` | Marek Vane | P1 | `docs/art_bible/heroes/marek_vane.md` | `games/uomd/art/portraits/marek_vane/composed.webp` `games/uomd/art/portraits/marek_vane/warm.webp` `games/uomd/art/portraits/marek_vane/firm.webp` `games/uomd/art/portraits/marek_vane/uneasy.webp` `games/uomd/art/portraits/marek_vane/sad.webp` `games/uomd/art/portraits/marek_vane/angry.webp` `games/uomd/art/portraits/marek_vane/surprised.webp` |
| [ ] | `garrick_cinder` | Garrick Cinder | P1 | `docs/art_bible/heroes/garrick_cinder.md` | `games/uomd/art/portraits/garrick_cinder/composed.webp` `games/uomd/art/portraits/garrick_cinder/warm.webp` `games/uomd/art/portraits/garrick_cinder/firm.webp` `games/uomd/art/portraits/garrick_cinder/uneasy.webp` `games/uomd/art/portraits/garrick_cinder/sad.webp` `games/uomd/art/portraits/garrick_cinder/angry.webp` `games/uomd/art/portraits/garrick_cinder/surprised.webp` |
| [ ] | `corbin_locke` | Corbin Locke | P1 | `docs/art_bible/heroes/corbin_locke.md` | `games/uomd/art/portraits/corbin_locke/composed.webp` `games/uomd/art/portraits/corbin_locke/warm.webp` `games/uomd/art/portraits/corbin_locke/firm.webp` `games/uomd/art/portraits/corbin_locke/uneasy.webp` `games/uomd/art/portraits/corbin_locke/sad.webp` `games/uomd/art/portraits/corbin_locke/angry.webp` `games/uomd/art/portraits/corbin_locke/surprised.webp` |
| [ ] | `cassian_thorne` | Cassian Thorne | P1 | `docs/art_bible/heroes/cassian_thorne.md` | `games/uomd/art/portraits/cassian_thorne/composed.webp` `games/uomd/art/portraits/cassian_thorne/warm.webp` `games/uomd/art/portraits/cassian_thorne/firm.webp` `games/uomd/art/portraits/cassian_thorne/uneasy.webp` `games/uomd/art/portraits/cassian_thorne/sad.webp` `games/uomd/art/portraits/cassian_thorne/angry.webp` `games/uomd/art/portraits/cassian_thorne/surprised.webp` |
| [ ] | `dorian_kesk` | Dorian Kesk | P1 | `docs/art_bible/heroes/dorian_kesk.md` | `games/uomd/art/portraits/dorian_kesk/composed.webp` `games/uomd/art/portraits/dorian_kesk/warm.webp` `games/uomd/art/portraits/dorian_kesk/firm.webp` `games/uomd/art/portraits/dorian_kesk/uneasy.webp` `games/uomd/art/portraits/dorian_kesk/sad.webp` `games/uomd/art/portraits/dorian_kesk/angry.webp` `games/uomd/art/portraits/dorian_kesk/surprised.webp` |
| [ ] | `rowan_reed` | Rowan Reed | P1 | `docs/art_bible/heroes/rowan_reed.md` | `games/uomd/art/portraits/rowan_reed/composed.webp` `games/uomd/art/portraits/rowan_reed/warm.webp` `games/uomd/art/portraits/rowan_reed/firm.webp` `games/uomd/art/portraits/rowan_reed/uneasy.webp` `games/uomd/art/portraits/rowan_reed/sad.webp` `games/uomd/art/portraits/rowan_reed/angry.webp` `games/uomd/art/portraits/rowan_reed/surprised.webp` |
| [x] | `lady_yseldra_vale` | Lady Yseldra Vale (Bell-Widow'un insan hâli) | P2 | `docs/art_bible/character_locks.md` §10, `docs/art_bible/enemies.md` | `games/uomd/art/portraits/lady_yseldra_vale/composed.webp` `games/uomd/art/portraits/lady_yseldra_vale/warm.webp` `games/uomd/art/portraits/lady_yseldra_vale/firm.webp` `games/uomd/art/portraits/lady_yseldra_vale/uneasy.webp` `games/uomd/art/portraits/lady_yseldra_vale/sad.webp` `games/uomd/art/portraits/lady_yseldra_vale/angry.webp` `games/uomd/art/portraits/lady_yseldra_vale/surprised.webp` |
| [x] | `lord_cael_veyr` | Lord Cael Veyr (yalnız hikâye, maskeli soylu) | P2 | `docs/art_bible/character_locks.md` §10, `docs/art_bible/enemies.md` | `games/uomd/art/portraits/lord_cael_veyr/composed.webp` `games/uomd/art/portraits/lord_cael_veyr/warm.webp` `games/uomd/art/portraits/lord_cael_veyr/firm.webp` `games/uomd/art/portraits/lord_cael_veyr/uneasy.webp` `games/uomd/art/portraits/lord_cael_veyr/sad.webp` `games/uomd/art/portraits/lord_cael_veyr/angry.webp` `games/uomd/art/portraits/lord_cael_veyr/surprised.webp` |
| [x] | `marshal_oren` | Marshal Oren | P2 | `docs/art_bible/character_locks.md` §10, `docs/art_bible/enemies.md` | `games/uomd/art/portraits/marshal_oren/composed.webp` `games/uomd/art/portraits/marshal_oren/warm.webp` `games/uomd/art/portraits/marshal_oren/firm.webp` `games/uomd/art/portraits/marshal_oren/uneasy.webp` `games/uomd/art/portraits/marshal_oren/sad.webp` `games/uomd/art/portraits/marshal_oren/angry.webp` `games/uomd/art/portraits/marshal_oren/surprised.webp` |
| [x] | `rusk` | Captain Rusk | P2 | `docs/art_bible/character_locks.md` §10, `docs/art_bible/enemies.md` | `games/uomd/art/portraits/rusk/composed.webp` `games/uomd/art/portraits/rusk/warm.webp` `games/uomd/art/portraits/rusk/firm.webp` `games/uomd/art/portraits/rusk/uneasy.webp` `games/uomd/art/portraits/rusk/sad.webp` `games/uomd/art/portraits/rusk/angry.webp` `games/uomd/art/portraits/rusk/surprised.webp` |
| [x] | `red_vial_matron` | The Red Vial Matron | P2 | `docs/art_bible/character_locks.md` §10, `docs/art_bible/enemies.md` | `games/uomd/art/portraits/red_vial_matron/composed.webp` `games/uomd/art/portraits/red_vial_matron/warm.webp` `games/uomd/art/portraits/red_vial_matron/firm.webp` `games/uomd/art/portraits/red_vial_matron/uneasy.webp` `games/uomd/art/portraits/red_vial_matron/sad.webp` `games/uomd/art/portraits/red_vial_matron/angry.webp` `games/uomd/art/portraits/red_vial_matron/surprised.webp` |
| [x] | `ashen_lord_wraith` | The Ashen Lord's Wraith | P2 | `docs/art_bible/character_locks.md` §10, `docs/art_bible/enemies.md` | `games/uomd/art/portraits/ashen_lord_wraith/composed.webp` `games/uomd/art/portraits/ashen_lord_wraith/warm.webp` `games/uomd/art/portraits/ashen_lord_wraith/firm.webp` `games/uomd/art/portraits/ashen_lord_wraith/uneasy.webp` `games/uomd/art/portraits/ashen_lord_wraith/sad.webp` `games/uomd/art/portraits/ashen_lord_wraith/angry.webp` `games/uomd/art/portraits/ashen_lord_wraith/surprised.webp` |
| [x] | `eclipse_construct` | Eclipse Construct | P2 | `docs/art_bible/character_locks.md` §10, `docs/art_bible/enemies.md` | `games/uomd/art/portraits/eclipse_construct/composed.webp` `games/uomd/art/portraits/eclipse_construct/warm.webp` `games/uomd/art/portraits/eclipse_construct/firm.webp` `games/uomd/art/portraits/eclipse_construct/uneasy.webp` `games/uomd/art/portraits/eclipse_construct/sad.webp` `games/uomd/art/portraits/eclipse_construct/angry.webp` `games/uomd/art/portraits/eclipse_construct/surprised.webp` |
| [ ] | `ac_mera_holt` | Mera Holt, kömür avlusunun ustabaşı (orta yaş kadın, isli önlük, defter, temkinli bakış) | P2 | Ash Circle hikâyesi (`narrative/04_Events/Planned_Realtime/ash_circle`) | `games/uomd/art/portraits/ac_mera_holt/composed.webp` `games/uomd/art/portraits/ac_mera_holt/warm.webp` `games/uomd/art/portraits/ac_mera_holt/firm.webp` `games/uomd/art/portraits/ac_mera_holt/uneasy.webp` `games/uomd/art/portraits/ac_mera_holt/sad.webp` `games/uomd/art/portraits/ac_mera_holt/angry.webp` `games/uomd/art/portraits/ac_mera_holt/surprised.webp` |
| [ ] | `ac_tovin_reed` | Tovin Reed, genç avlu işçisi (kömür tozlu, kalın eldiven, tedirgin) | P2 | Ash Circle hikâyesi (`narrative/04_Events/Planned_Realtime/ash_circle`) | `games/uomd/art/portraits/ac_tovin_reed/composed.webp` `games/uomd/art/portraits/ac_tovin_reed/warm.webp` `games/uomd/art/portraits/ac_tovin_reed/firm.webp` `games/uomd/art/portraits/ac_tovin_reed/uneasy.webp` `games/uomd/art/portraits/ac_tovin_reed/sad.webp` `games/uomd/art/portraits/ac_tovin_reed/angry.webp` `games/uomd/art/portraits/ac_tovin_reed/surprised.webp` |

## M. Ash Circle (P2)
Kuşbakışı ¾ açı, kömür avlusu teması (`narrative/04_Events/Planned_Realtime/ash_circle`). Teslim `games/uomd/art/<dosya>` (oyun
`assets/approved_art/<dosya>` adıyla ister, çözücü `games/uomd/art/`'ta bulur).
| ✓ | Dosya | İçerik | Boyut | Teslim |
| --- | --- | --- | --- | --- |
| [ ] | `bg_sol_ac_arena_ground.webp` | Arena zemini: kömür tozu, raylar, isli taş; döşenebilir, belirgin odak yok | 1448×1086 | `games/uomd/art/bg_sol_ac_arena_ground.webp` |
| [ ] | `ui_sol_ac_landmark_gate.webp` | Avlu işareti: gate (tek nesne, saydam) | 512×512 | `games/uomd/art/ui_sol_ac_landmark_gate.webp` |
| [ ] | `ui_sol_ac_landmark_cart.webp` | Avlu işareti: cart (tek nesne, saydam) | 512×512 | `games/uomd/art/ui_sol_ac_landmark_cart.webp` |
| [ ] | `ui_sol_ac_landmark_cistern.webp` | Avlu işareti: cistern (tek nesne, saydam) | 512×512 | `games/uomd/art/ui_sol_ac_landmark_cistern.webp` |
| [ ] | `ui_sol_ac_landmark_dispatch.webp` | Avlu işareti: dispatch (tek nesne, saydam) | 512×512 | `games/uomd/art/ui_sol_ac_landmark_dispatch.webp` |
| [ ] | `ui_sol_ac_landmark_kiln.webp` | Avlu işareti: kiln (tek nesne, saydam) | 512×512 | `games/uomd/art/ui_sol_ac_landmark_kiln.webp` |
| [ ] | `ui_sol_ac_landmark_ledger.webp` | Avlu işareti: ledger (tek nesne, saydam) | 512×512 | `games/uomd/art/ui_sol_ac_landmark_ledger.webp` |
| [ ] | `ui_sol_ac_landmark_pit.webp` | Avlu işareti: pit (tek nesne, saydam) | 512×512 | `games/uomd/art/ui_sol_ac_landmark_pit.webp` |
| [ ] | `ui_sol_ac_landmark_shelter.webp` | Avlu işareti: shelter (tek nesne, saydam) | 512×512 | `games/uomd/art/ui_sol_ac_landmark_shelter.webp` |
| [ ] | `ui_sol_ac_landmark_weighbridge.webp` | Avlu işareti: weighbridge (tek nesne, saydam) | 512×512 | `games/uomd/art/ui_sol_ac_landmark_weighbridge.webp` |
| [ ] | `ui_sol_ac_boss_cart_hauler.webp` | Bölüm bossu: cart hauler (tek figür, aşağıya bakan ¾, saydam) | 512×512 | `games/uomd/art/ui_sol_ac_boss_cart_hauler.webp` |
| [ ] | `ui_sol_ac_boss_charcoal_carrier.webp` | Bölüm bossu: charcoal carrier (tek figür, aşağıya bakan ¾, saydam) | 512×512 | `games/uomd/art/ui_sol_ac_boss_charcoal_carrier.webp` |
| [ ] | `ui_sol_ac_boss_kiln_tender.webp` | Bölüm bossu: kiln tender (tek figür, aşağıya bakan ¾, saydam) | 512×512 | `games/uomd/art/ui_sol_ac_boss_kiln_tender.webp` |
| [ ] | `ui_sol_ac_boss_last_load.webp` | Bölüm bossu: last load (tek figür, aşağıya bakan ¾, saydam) | 512×512 | `games/uomd/art/ui_sol_ac_boss_last_load.webp` |
| [ ] | `ui_sol_ac_boss_ledger_clerk.webp` | Bölüm bossu: ledger clerk (tek figür, aşağıya bakan ¾, saydam) | 512×512 | `games/uomd/art/ui_sol_ac_boss_ledger_clerk.webp` |
| [ ] | `ui_sol_ac_boss_pit_digger.webp` | Bölüm bossu: pit digger (tek figür, aşağıya bakan ¾, saydam) | 512×512 | `games/uomd/art/ui_sol_ac_boss_pit_digger.webp` |
| [ ] | `ui_sol_ac_boss_road_hound.webp` | Bölüm bossu: road hound (tek figür, aşağıya bakan ¾, saydam) | 512×512 | `games/uomd/art/ui_sol_ac_boss_road_hound.webp` |
| [ ] | `ui_sol_ac_boss_scale_minder.webp` | Bölüm bossu: scale minder (tek figür, aşağıya bakan ¾, saydam) | 512×512 | `games/uomd/art/ui_sol_ac_boss_scale_minder.webp` |
| [ ] | `ui_sol_ac_boss_shelter_warden.webp` | Bölüm bossu: shelter warden (tek figür, aşağıya bakan ¾, saydam) | 512×512 | `games/uomd/art/ui_sol_ac_boss_shelter_warden.webp` |
| [ ] | `ui_sol_ac_boss_sluice_turner.webp` | Bölüm bossu: sluice turner (tek figür, aşağıya bakan ¾, saydam) | 512×512 | `games/uomd/art/ui_sol_ac_boss_sluice_turner.webp` |
