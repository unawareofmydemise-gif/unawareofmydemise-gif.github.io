# Referans incelemesi — Reverse: 1999 (M15 D8, 2026-11-12)

Amaç: savaşın, ana ekranın, çağırmanın ve hikâye sahnesinin **nasıl hissettirdiğini** sayılarla öğrenmek ve UOMD'yi bu
sayılardan, kendi kodumuzla yazmak. Bu not yalnız davranış ve ölçü içerir; Reverse: 1999'un kodu, görseli, sesi ya da metni
UOMD'ye girmez (PLAN §177). Çıkarılan ham veri depo dışında: `.cache/r1999/` (git'e girmez).

## 1. Ne okunabildi, ne okunamadı

| Kaynak | Durum | Not |
| --- | --- | --- |
| Oyun mantığı (Lua bayt kodu, `luabytes/*.dat`) | **Şifreli** — açılmadı | Kural: koruma aşılmaz |
| Veri tabloları (`configs/datacfg_*.dat`), dil dosyaları | **Şifreli** — açılmadı | Hasar formülü, beceri sayıları, gacha oranları burada; bilinmiyor |
| IL2CPP üst verisi (`global-metadata.dat`) | Dosya boş (0 bayt) | Kod adları da yok |
| Varlık listesi (`configs/allmanifest.dat`) | Düz (gzip JSON) | 8.730 paket, 131.965 varlık yolu |
| Unity paketleri (`bundles/*.dat`, 8.534) | Düz | Başta 1–6 bayt dolgu, sonra standart UnityFS; paket dosya adı = md5(paket adı) |
| Videolar (227 mp4), sesler (Wwise bnk/wem) | Düz | Bakıldı, sayılar aşağıda |

Okunan paketler: beceri zaman çizelgeleri (`rolestimeline`, 3.300 çizelge, 72.786 nesne), beceri kamera animasyonları
(`effects/cameraanim`, 4.360 klip), savaş/ana ekran/çağırma/hikâye arayüz prefab'ları ve animasyonları, ana ekran ve çağırma
sahneleri.

## 2. Savaş: bir becerinin içi

Her beceri bir zaman çizelgesidir (30 FPS ile yazılmış; %7'si 60 FPS). Çizelgede paralel izler var. Gördüğümüz iz türleri
(sıklık sırasıyla): vuruş kararı (hasarın düştüğü an ve payı), büyü/vuruş efekti, ses efekti + seslendirme, beceri hareketi,
kamera, karakter hareketi, diğer karakterleri gizle/göster, can çubuğunu ve arayüzü gizle, sonraki beceriye bağlanma noktası,
katman sırası, uçan mermi. **Vuruş donması (hit-stop) neredeyse yok: 3.300 çizelgenin 8'inde.**

### 2.1 Süreler (saniye; p10 / ortanca / p90)

| | Kahraman | Düşman |
| --- | --- | --- |
| Beceri 1 toplam | 2,0 / **3,2** / 4,2 | 1,6 / **2,3** / 3,5 |
| Beceri 2 toplam | 2,1 / **3,4** / 4,3 | 1,7 / **2,4** / 3,7 |
| Ultimate toplam | 2,9 / **10,0** / 13,1 | 2,1 / **3,0** / 5,9 |
| İlk vuruş (beceri) | 0,7 / **1,4–1,7** / 2,4 | 0,5 / **1,0** / 1,6 |
| İlk vuruş (ultimate) | 0,8 / **5,8** / 10,0 | 0,7 / **1,4** / 2,9 |

- Kahraman becerisi ~3,3 sn, düşmanınki ~2,3 sn: **düşman sırası belirgin biçimde daha kısa**, oyuncu kendi hamlesini izler,
  düşmanınkini geçer.
- Kahraman ultimate'i ~10 sn'lik bir sinematik: ilk hasar ortalama 5,8 sn'de düşüyor, öncesi kurulum (kamera, hazırlık, poz).
- Son vuruştan becerinin bitişine 1,3 sn (p10 0,8, p90 1,9): vuruştan sonra "nefes" payı.

### 2.2 Hasar birkaç vuruşa bölünür, son vuruş en ağır

Becerilerin ~%58'i tek vuruş. Çok vuruşlularda paylar hep 1,0'a tamamlanır ve sonuncusu en büyüktür:

| Bölünme | Beceri 1 | Ultimate |
| --- | --- | --- |
| 1,0 | 488 | 329 |
| 0,3 + 0,3 + 0,4 | 70 | 60 |
| 0,5 + 0,5 | 58 | 13 |
| 0,4 + 0,6 | 31 | 17 |
| 0,2 × 3 + 0,4 | 13 | 32 |
| 0,1 × 6 + 0,4 | — | 13 |

Vuruşlar arası: ortanca **0,20 sn** (p10 0,10, p90 0,60); ultimate'te 0,23 sn.

### 2.3 Ağırlık nasıl veriliyor (donma yerine)

- **Her becerinin kendi kamerası var:** becerilerin %97'sinde, ultimate'lerin %96'sında. Kamera klibi ortalama 2,6 sn
  (ultimate 3,9 sn, uç 10,9 sn). Kamera çoğunlukla **yatay kayıyor**: ortanca 1,1 birim, p90 5,5; dikey ve derinlik hareketi
  çoğunlukla 0. Ultimate'lerin %64'ü sonda kamerayı "standart uzaklığa" geri getiren bir iz kullanıyor.
- **Sahne sadeleşiyor:** beceri sırasında diğer karakterler gizleniyor (beceri 1'de %25, beceri 2'de %36, ultimate'te %46),
  can çubukları ve arayüz gizleniyor (%31–37; ultimate'te %63 ve **0. saniyede**). Ultimate'lerin %31'inde savaş sahnesi
  tümüyle gizlenip özel bir sahneye geçiliyor (ortanca 1,6 sn'de).
- **Öne atılma kısa ve doğrusal:** hareket klipleri ortanca 0,30 sn (p10 0,1, p90 0,7), %95'i doğrusal. Mesafe sahne
  birimiyle 3–8 (rakibin önüne gidiş).
- **Hızlandırma/yavaşlatma çok az:** bazı becerilerde bütün beceri 1,2–1,4× hızlı oynatılıyor; ultimate'lerin %2'sinde
  ~0,2 sn'lik 0,35–0,5× yavaşlatma (darbe anı).
- **Zincirleme:** sonraki beceri, bu beceri bitmeden ortalama **0,85 sn önce** başlayabiliyor (p10 1,5, p90 0,45 sn önce).
  Aynı beceri art arda geldiğinde ayrı, daha kısa bir bağlama izi var (~0,2 sn geçiş). Sıra boşlukla değil, üst üste binerek
  akıyor.

### 2.4 Savaş arayüzü (1920×1080 referans)

- Eldeki kartlar **altta, sağa yaslı tek sıra**: alan 1890×317, kart hücresi 220×256, aralık 0. Kartın kendisi 160×250
  (ultimate kartı 194×314, daha büyük).
- Oynanan/sıradaki kart **ortanın üstünde** (merkezden +256 px), 350×347.
- Düğmeler (AUTO, hız, menü) sağ üstte yatay sıra; tur/düşman bilgisi sol üstte dikey sıra.
- Animasyon süreleri: kart çıkışı 0,60 sn, kart seçme 0,57 sn, kart birleşip yükselme 1,0 sn, tur başlığı 0,53 sn, savaş
  düğmelerinin girişi 0,47 sn, beceri bilgi kartı giriş/çıkış 0,40/0,43 sn, zafer 1,0 sn, yenilgi 1,37 sn.

## 3. Ana ekran (K12 için)

- Arka planda **canlı bir karakter** tam ekran; ekran düğmeleri iki kenara toplanmış, ortası boş.
- Sol: 316×828'lik dikey şerit, 5 yuvarlak simge düğme (112×112, ~120 px arayla): posta, görevler, depo, mağaza, karakter
  değiştir; en altta "arayüzü gizle" düğmesi.
- Sağ: büyük **Savaş** kartı (324×372) üstte; altında **Çağırma** (420×180) ve bir geniş düğme (376×148); aralarda daha küçük
  ikincil düğmeler (karakterler, oda, hikâye).
- Sol üst: oyuncu bilgisi + para birimleri. Sağ üst: ayarlar.
- Altta karakterin sözleri iki satır altyazı (ana dil + İngilizce), tam genişlik.
- Açılış animasyonu 4,5 sn; ana ekrandaki karakter değişimi 0,75 sn öne gelme + 1,0 sn arka plan geçişi.

**UOMD'ye öneri (K12):** Hub'ı düğme tablosundan bu düzene çevirmek: sığınak resmi + seçili kahraman tam ekran, solda simge
sütunu, sağda büyük "Chapters/Savaş" ve "Summon" kartları, altta kahramanın sözü. Bu, K12'deki "ışıyan yerler + alt sekme"
önerisinden daha az iş ve daha yakın bir örnek.

## 4. Çağırma

Sahne animasyonları: giriş 0,83 sn → ana çağırma animasyonu 5,83 sn → nadirliğe göre sonuç kartı 2,5 sn (dört nadirliğin
hepsinde aynı süre, farkı efekt veriyor); en üst nadirlikte ek 2,23 sn'lik özel efekt. Her nadirliğin kendi "ortaya çıkış
(3 aşama) + patlama + dönme" efekt seti var; parçacık sistemleri çoğunlukla 1–2 sn. Arayüz: çağırma ekranı giriş 0,5 sn,
çıkış 0,17 sn, havuz değiştirme 0,67–0,8 sn.

## 5. Hikâye sahnesi

- Konuşma kutusu tam genişlik, 1920×230; arka plan resmi ekrandan büyük (3000×1946) ve kaydırılarak/yakınlaştırılarak
  kullanılıyor (D2'deki kamera hareketi kararımızla aynı yön).
- Sahne geçişleri için hazır efekt listesi: sayfa çevirme, RGB kayması, bozulma (glitch), radyal bulanıklık, CRT, eskiz,
  yağlı boya, vinyet, renk ters çevirme, ekran ikiye bölünme, zaman donması; ve dört hazır ışık tonu (yumuşak mavi, gergin
  turuncu ×2, gergin gümüş).
- Bölüm açılış/kapanış kartları ayrı animasyon; "başlığı yazarak açma" animasyonu 1–2 sn, kapanış 4–8 sn.

## 6. Ses ve video

- Ses Wwise'la: beceri başına ayrı ses bankası (kahraman becerisi, kostüm becerisi, kahraman ana sesleri, canavar sesleri ayrı),
  savaş arayüzü ve vuruş sesleri ayrı bankalarda; prolog ve etkinlik müzikleri bölüm bölüm.
- 227 video: bölüm/etkinlik açılışları, tanıtım videoları; birkaç ultimate de video oynatıyor (ultimate'lerin %3'ü).

## 7. UOMD'ye çıkarımlar (D7 ve K12)

Şu anki UOMD savaşı: bir hamle = 0,16 sn atılma + 0,08 sn bekleme + 0,20 sn dönüş (~0,45 sn), tek vuruş, 0,08 sn vuruş donması.
Reverse: 1999'daki bir kahraman hamlesi ~3,3 sn sürüyor ve ağırlığı başka yerden geliyor. D7 için öneri:

1. **Elle sırada kahraman becerisi ~2,5–3,5 sn**, ilk vuruş ~1,2–1,5 sn'de; **düşman becerisi ~2,0–2,5 sn**, ilk vuruş ~1 sn'de.
2. **Hasarı bölmek:** çok vuruşlu becerilerde 0,3/0,3/0,4 ya da 0,2×3/0,4 gibi paylar, vuruşlar arası 0,2 sn, son vuruş en
   ağır (en büyük sayı, en büyük sarsıntı).
3. **Vuruş donmasını bırakmak ya da çok kısaltmak**, yerine beceri başına kamera: hedefe doğru yatay kayma + hafif yakınlaşma,
   beceri bitince standart kadraja dönüş.
4. **Beceri sırasında sahneyi sadeleştirmek:** isim/can kutularını ve beceriye katılmayan birimleri soldurmak; ultimate'te
   arayüzü 0. saniyede kapatmak.
5. **Ultimate ~6–10 sn** (kurulum → tek büyük vuruş ya da 4–7 vuruşluk seri), ilk hasar yarıdan sonra. **AUTO açıkken**
   ultimate sinematiğini atla, becerileri 1,2–1,4× oynat (K13: AUTO düz akar).
6. **Üst üste bindirme:** sonraki hamle, öncekinin bitmesinden ~0,8 sn önce başlasın; böylece uzun beceriler sırayı
   yavaşlatmaz.
7. **Kart eli:** altta tek sıra, kart ~160×250 (1920×1080'de), ultimate kartı ~%20 büyük; seçilen/oynanan kart ortanın
   üstünde büyür; kart çıkış 0,6 sn, seçim 0,57 sn.

Bilinmeyenler (şifreli tablolarda): hasar formülü, kartların nasıl birleştiği/yükseldiği kuralı, hamle (AP) sayıları,
çağırma oranları. Bunlar UOMD'nin kendi tasarım kararları olarak kalır.
