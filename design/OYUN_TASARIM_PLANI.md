# Unaware of My Demise — Oyun Tasarım ve Üretim Planı (v0.1)

> Durum: taslak, sahiple tartışılıyor. Hikâye ve dünya için tek kaynak: [`OYUN_BILGI_DOKUMANI.md`](OYUN_BILGI_DOKUMANI.md).

> **Düzenleme sözleşmesi (2026-11-24):** Üretimi Gemini 4 Carbon Orchestrator devralıyor (`AGENTS.md`). Bu belge **yaşayan** bir tasarım belgesidir: orkestratör
> oynanış, savaş sayıları, UI, harita ve seviye tasarımı, kamera, VFX, ilerleme eğrisi ve performans bütçeleri konusunda **kendisi karar verip** burayı ve
> `docs/ILERLEME.md` karar günlüğünü günceller. **Sahibin kilitli kararları** (§0: gacha, sıra tabanlı savaş, Godot 4, anime toon; hikâye kanonu; Part II sırları)
> sahibe sorulmadan değişmez. Hedef platform: sahibin son yönergesine göre Android öncelikli (önceki "önce PC" kararıyla ilişkisi `docs/ILERLEME.md` açık soru 2).
> Bu belgede "Claude" ya da "yapay zekâ ekibi" geçen yerler, üretimi yapan ajan(lar) anlamında okunur.

## 0. Verilen kararlar

| Konu | Karar |
|---|---|
| Neyi istemiyoruz | Eski oyunun **menü ağırlıklı** yapısı. "Oyun gibi oyun" olmalı: yürünen, keşfedilen bir dünya. |
| Gelir modeli | **Gacha kalıyor.** Sürekli güncellenen canlı oyun (live service). |
| Savaş | **Sıra tabanlı**, Honkai: Star Rail tarzı. Gerçek zamanlı yok. |
| Motor | **Godot 4** |
| Platform | Önce **PC**, sonra **Android**. Ekran düzeni ve kontroller baştan ikisine göre tasarlanır. |
| Üretim ekibi | Claude: Sonnet 5.5 yürütücü, Opus 5.5 / Fable 5.2 danışman (advisor). Tüm asset'ler bu sistem ve onun çağırdığı araçlarla üretilir. |

## 1. Oyun türü ve çekirdek döngü

**Tür:** 3D keşif + sıra tabanlı parti savaşı + hikâye odaklı gacha RPG.

```
Bölüm haritasında yürü ─▶ Haritadaki düşmana dokun (ilk vuruş avantajı) ─▶ Sıra tabanlı savaş
        ▲                                                                       │
        │                                                                       ▼
Kampa dön: yoldaşlarla konuş, yemin defterinden çağır, ekip kur ◀── Ödül, hikâye sahnesi, yeni bölge
```

- **Keşif:** Her bölüm (Kül Ormanı, Katedral, Oakhaven, …) yürünebilir bir 3D harita. Haritada NPC'ler, sandıklar, küçük
  bulmacalar ve haritada görünen düşmanlar bulunur. Bulmacalar temaya bağlıdır: silinmiş bir adı kabuğa geri oymak, çanı
  doğru sırayla susturmak, kayıp bir kaydın parçalarını toplamak.
- **Kamp (merkez alan):** Menülerin yerini alan, yürünebilir bir yer. Ekranlar menüden değil, kamptaki yerlerden açılır.
  Ateşin başı ekip ve yoldaş ekranını, mabetteki **yemin defteri** çağırma (gacha) ekranını, Jori'nin örsü
  ekipman ve güçlendirme ekranını açar. Yoldaşlar kampta dolaşır, üstüne gelince konuşur ve yoldaş hikâyesini açar.
- **Hızlı menü:** Gezinme kolaylığı için tek tuş/tek dokunuşla açılan bir menü yine olur. Ama oyunun ana yüzü dünya,
  menü yalnızca kısayol.

## 2. Savaş sistemi (Star Rail tarzı, UOMD'ye uyarlanmış)

| Sistem | Açıklama | Eski oyundan karşılığı |
|---|---|---|
| **Hıza göre sıra çizelgesi** | Ekranın kenarında kimin ne zaman oynayacağı görünür. | Yeni |
| **4 kişilik parti** | Sahada 4 karakter. | 5v5 dizilişin yerini alır |
| **Temel / Yetenek / Ultimate** | Temel saldırı ortak puan kazandırır, yetenek puan harcar. Ultimate enerji dolunca sıra beklemeden kullanılır. | Basic / Active / Ultimate korunur |
| **Ortak puan: "Yemin Puanı"** | Partinin paylaştığı yetenek puanı. | Focus'un yerini alır |
| **6 element + kırılma** | Düşmanın zayıf olduğu elementlerle vurunca dayanıklılık barı kırılır; düşman sersemler, sırası geri itilir. | Stone, Veil, Dawn, Ember, Tide, Gale korunur |
| **Pasifler ve durum etkileri** | Dread, kalkan, koruma, Stoneguard… | Mevcut tasarımlar uyarlanır |

**UOMD'ye özgü öneri — Çan Sayacı:** Bazı karşılaşmalarda çan belirli turlarda çalar ve o anda sahnede bir şey değişir
(düşman güçlenir, bir karakterin adı "silinir", yani bir tur oynayamaz). Oyuncu çanı durdurmak için belli hedefleri (çan
taşıyıcısı, zincir) önceliklendirir. Hikâyenin ana metaforu böylece mekaniğe dönüşür. Bosslarda (Çan Dul'u, Tutulma
Yapıtı) merkezi mekanik olur.

Mevcut 25 kahramanın yetenek verileri `data/` altında. Yeni sisteme çevrilirken temel / aktif / pasif / ultimate yapısı ve
yetenek adları korunur; çarpanlar yeniden dengelenir.

## 3. Hikâye sunumu

- **Önerilen yöntem: 3D sahne + 2D portre.** Diyaloglarda karakterler 3D dünyada durur, kamera yaklaşır. Konuşma kutusunda
  ise mevcut 2D ifade çizimleri kullanılır. Elimizde hazır 198 portre var ve en yüksek kaliteli asset'lerimiz bunlar.
  Önemli anlar (açılış mektubu, itiraf, Cael twisti) ayrıca kamera hareketli 3D ara sahne olur.
- Fadyme'nin iç sesleri ayrı bir görsel dille gösterilir (farklı renk ve yazı tipi). Başlığın anlamı buna dayanıyor, o yüzden
  bu dil baştan oturtulmalı.
- Seslendirme: mevcut Japonca kayıtlar korunur; yenileri aynı TTS hattıyla üretilir.

## 4. Görsel yön

- **Sanat tarzı:** Anime cel/toon gölgeleme + kontur çizgisi, sıcak mum ışığı ile soğuk kül ve sis karşıtlığı. Renk dili
  mevcut art bible ve 2D çizimlerden alınır.
- **Karakter oranı:** Karar bekliyor (bkz. §9). Seçenekler:
  - **A — Tam boy anime** (Star Rail gibi). En etkileyici sonuç, ama yapay zekâ ile üretimi en zor seçenek.
  - **B — Stilize / hafif chibi** (2,5–3 baş boyu). Görselden 3D üretim araçları bunu çok daha temiz çıkarır, mobilde daha
    hafiftir ve eski oyunun chibi diliyle uyumludur.
- **Arka planlar:** Mevcut 75 boyalı arka plan, 3D haritalarda uzak manzara, gökyüzü ve renk referansı olarak kullanılır.

## 5. Asset üretim hattı (yapay zekâ ekibi için)

> **GÜNCELLEME (2026-11-24): aşağıdaki 2. ve 3. aşamalar (Meshy / Tripo ile görselden 3D ve otomatik rig) GEÇERSİZDİR.** Sahip kararı: 3D modeller bu servislerle değil,
> **Blender Python betikleriyle elle (kodla) üretilir**, ortak anime gövde tabanı ve ortak iskelet üzerinden (bkz. `docs/ALTYAPI.md` §4–5, `docs/KAYNAKLAR.md` §3,
> `docs/YOL_HARITASI.md` T1.1). Aşağıdaki tablo tarihsel taslak olarak bırakıldı; diğer aşamalar (Gemini ile referans, toon shader, görsel kontrol) geçerli.

Claude doğrudan resim veya 3D model çizemez. Bunu yapan araçları çağırır, çıktıyı kontrol eder ve düzeltir. Hat:

| Aşama | Araç | Kim / nasıl |
|---|---|---|
| 1. Konsept ve turnaround (ön / yan / arka) | **Gemini görsel modeli** (API anahtarı ortamda var) — mevcut portreler referans görsel olarak verilir | Claude istemi yazar, sonucu görüp seçer |
| 2. Görselden 3D model | **Meshy** veya **Tripo** (API, ücretli hesap gerekir). Alternatif: açık kaynak Hunyuan3D / TRELLIS (GPU gerekir) | Claude API'yi çağırır |
| 3. Otomatik rig ve animasyon | Meshy / Tripo otomatik rig + hazır animasyon kütüphanesi | Karakter başına ~10 animasyon: bekleme, yürüme, koşu, temel saldırı, yetenek, ultimate, hasar alma, yenilgi, zafer, konuşma |
| 4. Temizlik ve stil | **Blender** (ekransız, Python betiği ile): ölçek, pivot, poligon azaltma, toon malzeme, kontur, glTF dışa aktarma | Claude betik yazar ve bulut ortamında çalıştırır |
| 5. Oyuna alma | **Godot 4**: glTF içe aktarma, toon shader | Claude |
| 6. Görsel kontrol | Godot ekransız çalıştırılır, ekran görüntüsü alınır, Claude görüntüye bakar; sorun varsa 1–4'e döner | Otomatik döngü |
| Efektler (VFX) | Godot shader + parçacık sistemleri, kodla yazılır | Claude. Çizim gerektirmez; yapay zekâ hattına en uygun kısım |
| Arayüz | Godot Theme + Claude'un elle yazdığı SVG ikon ve çerçeveler + mevcut `art/ui` + gerektiğinde Gemini | Claude |
| Ses | Mevcut müzik ve efektler; yeni seslendirme Gemini TTS | Claude |

**Gerçekçi beklenti:** Prop'lar, düşmanlar ve çevre parçaları bu hatta iyi sonuç verir. **Kahraman karakterlerin yüzü ve
saçı en riskli kısım.** Yapay zekâ ile üretilen 3D modellerde dokuya gömülü ışık, dağınık topoloji ve ifade (blendshape)
eksikliği sık görülür. Bu yüzden ilk iş **dikey kesit testi:** Fadyme ve Mahmut tüm hattan geçirilir, Godot'ta yan yana
render alınır, kaliteyi birlikte değerlendiririz. Karakter oranı (§4) ve araç seçimi bu testten sonra kesinleşir.

## 6. UI / UX planı

**İlkeler**
1. **Önce dünya, sonra menü.** Her ekranın kampta ya da haritada fiziksel bir karşılığı vardır.
2. **Tek kod, iki platform.** Godot'ta tek arayüz. Yerleşim 16:9 PC ekranından 20:9 telefona kadar ölçeklenir. Fare,
   klavye, oyun kolu ve dokunmatik baştan desteklenir. Dokunma hedefleri en az 48 px, telefon çentikleri için güvenli alan
   bırakılır.
3. **Az ama okunur HUD.** Savaşta yalnız sıra çizelgesi, parti kartları, yetenek düğmeleri ve Yemin Puanı.
4. **Hareket bir anlam taşır.** Çan çalınca arayüz bir an titrer; silinen bir ad mürekkep gibi akar. Animasyon süreleri kısa
   tutulur (150–300 ms). Ayarlarda "hareketi azalt" seçeneği bulunur.
5. **Gacha şeffaflığı.** Oranlar, garanti sayacı ve çekim geçmişi tek dokunuşla görülür. Kurallar `gacha_ui_principles.md`
   §8'de.

**Görsel dil:** Mürdüm, kül grisi ve mum altını; gotik serif başlıklar (Cinzel / Cormorant) ve okunur gövde metni (Alegreya
Sans). Çerçevelerde çan ve zincir motifi. Hepsi mevcut `design_system.md` ve `art/ui` kitinden türetilir.

**Ekran listesi (ilk sürüm):** Başlık · Keşif HUD'ı · Diyalog · Savaş · Ekip / yoldaş detayı · Yemin defteri (çağırma) ve
çağırma animasyonu · Envanter / ekipman · Görevler ve hikâye kaydı · Kayıtlar (lore kodeksi) · Etkinlik · Mağaza · Ayarlar.

**Süreç:** Her ekran için önce bir tel kafes (wireframe) taslağı hazırlanıp onaylanır, sonra Godot'ta kurulur. Hem PC hem
telefon çözünürlüğünde ekran görüntüsü alınarak kontrol edilir.

## 7. Canlı oyun mimarisi (ileriye dönük)

- Karakterler, yetenekler, banner'lar, etkinlikler ve diyaloglar **veri dosyası** olarak tutulur. Yeni içerik çoğunlukla
  kod değil veri güncellemesi olur.
- Godot kaynak paketleri (`.pck`) ile içerik yamaları yapılabilir. Android'de mağaza kurallarına uyulur: indirilen
  paketler kod değil yalnız veri ve asset içerir.
- Hesap, çekim geçmişi ve satın alma için sunucu gerekir. Bu karar ilk oynanabilir sürümden sonra verilir; o zamana kadar
  her şey yerelde çalışır.

## 8. Yol haritası

| Aşama | İçerik | Çıktı |
|---|---|---|
| 0 — Dikey kesit testi | Fadyme ve Mahmut tüm üretim hattından geçer | Godot'ta iki karakterin render'ı; stil ve araç kararı |
| 1 — Prototip | Godot projesi; tek harita (Kül Ormanı), yürüme, bir düşmanla Star Rail tarzı savaş, gri kutu (greybox) arayüz | Tarayıcıda oynanabilir sürüm |
| 2 — Dikey dilim | Öğretici + Bölüm 1 eksiksiz: hikâye, 4–5 karakter, kamp, yemin defteri | Gerçek kalitede ilk 30 dakika |
| 3 — Part I | 7 bölüm, 25 kahraman, tüm bosslar | PC sürümü |
| 4 — Android | Dokunmatik ayarları, performans, mağaza | Android sürümü |
| 5 — Canlı | Etkinlikler, yeni kahramanlar, Part II | Güncellemeler |

## 9. Açık kararlar

1. Karakter oranı: tam boy anime mi, stilize / hafif chibi mi? (Dikey kesit testinden sonra.)
2. ~~Görselden 3D servisi: Meshy mi, Tripo mu?~~ **Kapandı:** modeller elle, kodla üretilecek (sahip kararı; §5 güncelleme notu).
3. Diyalogda 2D portre + 3D sahne yöntemi onaylanıyor mu?
4. Çan Sayacı mekaniği.
5. Kampta hangi yerin hangi ekranı açacağı.
