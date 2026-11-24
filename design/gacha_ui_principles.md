# Gacha arayüzü ve deneyimi — UOMD ilkeleri (M15 D9, 2026-11-12)

Bu not, türün başarılı örneklerinin incelenmesinden (oyuna özgü ayrıntılar yerelde, git dışında) ve açık kaynaklardan
çıkardığımız **genel** ilkeleri kendi cümlelerimizle toplar. Sayılar 1920×1080 tasarım çözünürlüğü içindir (UOMD
`logical_size` ile aynı). Kaynak oyunun kodu, görseli, metni kullanılmaz.

## 1. Her ekranın iskeleti
1. **Sol üst: geri + ana sayfa.** İki düğme yan yana, görünen yükseklik ~76, dokunma alanı ~140×130. Her alt ekranda
   aynı yerde; ana sayfa düğmesi derin menülerden tek dokunuşla çıkarır.
2. **Sağ üst: o ekranın para birimleri.** Hap biçimi ~228×44, simge haptan taşar, sayı ~26 pt, "+" satın almaya götürür.
   Mağazada o mağazanın parası ve yenilenme süresi gösterilir.
3. **Pencere kapatma (X) sağ üstte**, görünen ~44 px ama dokunma alanı ~140×140.
4. **Bildirim noktası** düğmenin sağ üst köşesinde, 20–30 px; yeni/alınacak bir şey varsa yanar, alınınca söner.
5. Süreli her şeyin yanında kalan süre (havuz bitişi, mağaza yenilenmesi, posta süresi, etkinlik).

## 2. Ölçüler
- Dokunma alanı en az ~112 px (1080p; p10 80). Küçük simgelere görünmez büyük alan ekle, simgeyi büyütme.
- Düğme ortancası ~270×112; birincil eylem (onay, çekiş) ~420–470 × 104–110.
- Yazı: gövde 28–30 pt; başlık 40–48 pt; büyük sayılar 36+ pt; süs alt yazıları 12–16 pt. Okunması gereken hiçbir şey
  18 pt'nin altında değil.
- Arka plan görselleri 2592×1080 (21:9'a kadar) ya da daha büyük çizilir; arayüz 1920×1080 güvenli alanda kalır.
- Pencere arkası karartma: siyah, saydamlık 0,5–0,6 (onay), ~0,7 (sonuç ekranı), 1,0 (tören/geçiş).

## 3. Hareket
- **Açılış ~0,67 sn, kapanış ~0,17 sn.** Giriş gösterişli, çıkış anında; oyuncu bir yere giderken bekletilmez.
- Sekme/sayfa değişimi ~0,67 sn; seçme ~0,6 sn; kilit açılışı ~1,0 sn; ödül alma 0,67–1,0 sn; ışıma/nefes döngüleri 1 sn.
- Ekranlar arası geçişte siyahtan açılış (D4'te yapıldı).

## 4. Ana ekran (K12)
- Seçili kahraman/sığınak görseli tam ekran, ortası boş; arayüz iki kenara toplanır.
- Bir kenarda 4–6 yuvarlak simge (posta, görevler, depo, mağaza, kahraman değiştir; ~112 px, ~120 px arayla).
- Öbür kenarda **en büyük öğe "Savaş/Bölümler"** (~320×370), altında **"Çağırma"** (~420×180), aralarda küçük ikinciller.
- Altta kahramanın sözü (seslendirme altyazısı). Bir "arayüzü gizle" düğmesi görseli temiz gösterir.
- Etkinlik afişleri küçük, kaydırılabilir bir şeritte.

## 5. Çağırma ekranı
- Para kazandıran ekran, en çok emek verilen ekran olmalı: her havuzun kendi görseli; karakter görseli katmanlı
  (kaydırırken derinlik).
- **1× ve 10× düğmeleri yan yana, aynı boyda (~423×110)**, fiyat düğmenin içinde; önce bilet harcanır.
- Görünür olması gerekenler: havuzun bitiş süresi, garanti sayacı ("X/80"), öne çıkan karakter(ler), sahip olunan para.
- **İki dokunuşta ulaşılan yasal sayfalar:** "Olasılıklar" (her nadirlik ve her öğe için yüzde, yumuşak/sert garanti,
  öne çıkan şansı, kayıp garantisi) ve "Geçmiş" (sayfalı, tarih + sonuç + havuz). Değerler sunucudan gelir.
- Akış: giriş (~0,8 sn) → çağırma animasyonu (~5–6 sn, **dokunarak atlanabilir**) → nadirliğe göre sonuç (~2,5 sn; en üst
  nadirlikte ek ~2 sn tören) → 10'lu sonuç ızgarası (dokun → kapan).
- En yüksek nadirliğin ipucu animasyon sırasında verilir (renk), sonuç ekranında tören uzar; düşük nadirlikler hızlı geçer.

## 6. Ödül ve onay
- **Ödül töreni:** tam ekran karartma + parçacık, başlık ("Alındı"), ödüller ızgarada (~270×256 hücre), "kapatmak için
  dokun". Nadir ödülde daha uzun.
- **Onay kutusu:** ekranı enine kesen bir şerit (pencere değil), metin ~36 pt, iki büyük düğme (~470×104): iptal solda,
  onay sağda. Para harcatan her eylemde (çekiş, satın alma, değişim) neyin ne kadara alındığı yazar.

## 7. Diğer ekranlar
- **Bölümler:** bölüm seçimi yatay; aşama haritası yatay kaydırılır, büyük "Gir" düğmesi sağda, hikâye tekrar izleme
  ayrı düğme.
- **Görevler:** üstte başlangıç / günlük / haftalık sekmeleri; her satırda ilerleme + ödül + "al".
- **Mağaza:** solda dikey kategori listesi; ürün kartı ~332×355 (görsel, ad, kalan stok, fiyat altta).
- **Posta:** sol liste, sağ ayrıntı; "hepsini al" + "okunanları sil"; süre uyarısı.
- **Giriş ödülü:** ay takvimi; bugünün ödülü vurgulu.
- **Sezon kartı:** solda ödül karakterinin büyük görseli, sağda seviye çubuğu + ödül ızgarası + "hepsini al".
- **Kahraman:** görsel tam ekran; solda sınıf/öğe ve özellikler; sağda seviye, rütbe ve dikey eylem düğmeleri.
- **Savaş sonucu:** karartma ~0,7; solda kahraman zafer pozu, sağda sonuç + yıldız hedefleri + ödüller.

## 8. Gacha kuralları ve yasa
- Tür standardı: temel en üst nadirlik oranı %1,5–2,5; yumuşak garanti (son ~10–15 çekişte oran hızla artar); sert garanti
  70–90; öne çıkan şansı %50–55 + kayıp garantisi; bir sürümde ücretsiz oyuncu yaklaşık bir sert garanti kadar çekiş
  biriktirir. UOMD (`server/packages/economy/src/banner.ts`): %2,5, 65'ten sonra +6 puan, 80'de kesin, %55 + kayıp
  garantisi, Bell Tolls takası, 20 çekişlik başlangıç havuzu. Bu tür standardıyla uyumlu.
- **Zorunlu:** Google Play ve App Store, rastgele ödül veren her mekanizmada her ödül türünün olasılığını satın almadan önce
  göstermeyi istiyor. Güney Kore bütün olasılıkların oyunda, reklamda ve sitede açıklanmasını yasa olarak istiyor.
  Japonya'da set tamamlatan zincir çekiliş (kompu gacha) yasak. Reşit olmayanlara harcama sınırı bazı ülkelerde var.
- Pity sayacının hangi havuzlar arasında taşındığı havuzun üstünde açıkça yazmalı (türde en çok kafa karıştıran konu).

## 9. UOMD'de eksikler (D9 iş listesi)
| # | Eksik | Nerede |
| --- | --- | --- |
| 1 | **Oran penceresi elle yazılmış ve yanlış** ("5-Star: 2.0%" sabit; sınırlı havuz %2,5; yumuşak garanti, öne çıkan şansı, öğe başına oran yok). Sunucudaki banner yapılandırmasından üretilmeli | `data_screens.GothicSummonAltarUI.open_rates_modal` |
| 2 | Sol üst geri + ana sayfa yok: geri alt çubukta, ana sayfa üst sekmelerde | `uomd_engine/hub_screen.py` |
| 3 | Görünmez büyük dokunma alanı kuralı yok (motor) | `uomd_engine/ui.py` |
| 4 | Açılış/kapanış süreleri tek bir kurala bağlı değil (açılış ~0,67 / kapanış ~0,17) | `SceneManager.fade_in`, hub ekranları |
| 5 | Havuz bitiş süresi, mağaza yenilenme süresi görünmüyor (sunucudan gelmeli) | çağırma, mağaza |
| 6 | Çağırma animasyonu + nadirliğe göre tören + 10'lu sonuç ızgarası (dokun-atla) | `scenes/summon.scene.json` |
| 7 | Ödül töreni penceresi tek tip değil | ortak parça |
| 8 | Ana ekran (K12) | Hub |

## 10. Gacha yapılandırması: türde olup bizde olmayan parametreler (2026-11-12, ikinci referans incelemesi)
UOMD `BannerConfig` bugün: oran, yumuşak/sert garanti, öne çıkan şansı + kayıp garantisi, 4★ her 10'da, fiyat, hesap başına
sınır, Bell Tolls takası. Türün canlı örneklerinde **veri olarak** ayarlanabilen ve bizde olmayanlar:
- **Kilometre taşı ödülleri:** havuzda N, M, … çekişte birikimli ödüller (oyuncu ekranda ilerlemeyi görür).
- **N çekişten sonra ücretsiz 10'lu**, **S'den başlayıp her K çekişte otomatik ödül**, **N'de bir kerelik ödül**.
- **N çekişten sonra paket seç** (seçmeli ödül).
- **Havuz başına toplam çekiş sınırı** ve **yalnız 10'lu izin** bayrağı; **indirimli 10'lu** fiyatı.
- **Birden çok ödeme kalemi** (önce havuza özel bilet, sonra genel bilet, sonra ana para), havuza özel süreli bilet.
- **Çekiş başına yan ödül** (her çekişte küçük bir para).
- **Yumuşak garanti paylaşımı** havuz türü düzeyinde açıkça bayrak (bizde `pityGroup` aynı işi görüyor) ve 5★ için ayrı
  yumuşak garanti.
- **Kopya dönüşümü sunucuda** ve iki aşamalı: potansiyel dolmadan önce bir ödül, dolduktan sonra başka bir ödül; sonuçta
  `isNew` + "ilk kez alındı" ödülü. Karakter çekişleri silah havuzu parası da verir.
- **Havuz sunumu veride:** havuza özel arayüz düzeni, video + ses, renkler, sekme görseli, sıralama, **"önce dene"
  sıçraması**; karakter başına çıkış sahnesi.
- **Havuz önerisi:** koşula göre (yeni oyuncu, eksik rol…) oyuncuya havuz öneren kural tablosu.
- **Çıkış animasyonu en yüksek nadirliğe göre seçilir**; nadir durumlarda "sürpriz" efekti.
- Sunucu, oyuncu başına havuz durumunu (toplam, her sayaç, alınan kilometre taşları, ücretsiz 10'lu, kişisel kapanma
  zamanı) **tek mesajda** gönderir; ekran hepsini buradan okur (bizim "ekran veri uydurmaz" kuralımızla aynı).

## 11. Canlı oyun sistemleri kontrol listesi
| Sistem | Türde görülen | UOMD |
| --- | --- | --- |
| Bildirim noktası | "Okundu" sunucuda (belge, ses, posta, görev) **veya** istemcide hesap başına; kaydırma listesinde ekran dışındaki noktayı kenarda gösterme; aylık kart noktası için "bir sonraki gösterim zamanı" | kontrol edilecek |
| Sezon kartı | Ücretsiz / ücretli / premium izler, seviye exp'i, kilometre taşı seviyeleri, **son seviyeden sonra tekrarlayan ödül**, seviye satın alma, görevlerde sıçrama bağlantısı | yok |
| Giriş ödülü | Ay takvimi, "önemli gün" ayrı pencere, otomatik alma | var (`rewards`) |
| Mağaza | Grup/kanal, yenilenme döngüsü, kilitliyken de göster + neden, ürün sınırı ve sınır yenilenmesi, indirim etiketi, **n'inci elle yenilemenin fiyatı**, aylık kart | kısmen (`shop`) |
| Hediye paketleri | Ücretsiz paket, dinamik öncelik/etiket, tükenince gizle | yok |
| Posta | Şablon, süre, gönderen, ödül; "hepsini al" | kontrol edilecek |
| Cüzdan | Para kazanma/harcama kaydını oyuncu görebilir | sunucuda defter var |
| İsim | Ad + hassas kelime kontrolü sunucuda | kontrol edilecek |
| Öğretici | Aynı ipucunun klavye / kumanda / dokunmatik için ayrı metni | yok |

## 12. Ayarlar kontrol listesi (oyuncuya sunulanlar)
Ses: ana, müzik, efekt, seslendirme, ortam, arayüz ayrı; **uygulama arka plandayken ses düzeyi**. Dil: metin ve
seslendirme dili ayrı; alt yazı seçeneği. Konfor: **kamera sarsıntısı gücü**, titreşim türü/gücü, hasar sayılarını göster,
efekt yoğunluğu (takım arkadaşı efektleri), **göz koruma** (parlaklık, renk sıcaklığı), parlaklık/kontrast/doygunluk,
hareket bulanıklığı. Görüntü: kalite hazır ayarı + tek tek ayarlar, kare hızı sınırı. Kumanda: ölü bölge, hedef kilidi.
UOMD'de ilk taramada bulunmayanlar: kamera sarsıntısı gücü, arka planda ses, göz koruma.

## 13. Motor için arayüz bileşenleri (türün kullandığı, UOMD'de ilk taramada bulunmayanlar)
- Sanal/geri dönüştürülen liste (yüzlerce öğe: kahraman, eşya, posta).
- Yuvarlanan sayı (para, hasar, puan) ve yüzde sayacı.
- Can çubuğunda geride kalan iz (hasar sonrası gecikmeli azalan ikinci dolgu).
- Tuş/kumanda ipucu simgeleri.
- Durum denetleyicisi: bir öğenin adlı durumları (normal/seçili/kilitli/tükendi) birden çok özelliği ve animasyonu
  birlikte değiştirir; ekran kodunda tek tek özellik ayarlamak yerine.
- Var olanlar: güvenli alan (`app.py`), paralaks (`nodes2d`), bulanıklık (`gothic_ui_vfx`), toast (`hub_screen`).
