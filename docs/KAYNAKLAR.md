# Dış kaynaklar: araçlar, eklentiler, referans repolar

> Kural: Bir kaynak ancak **bu bulut ortamında denenip çalıştığı görüldükten sonra** projeye eklenir. Her satırdaki "test"
> sütunu, 2026-11-24'te gerçekten yapılan denemeyi yazar.

## 1. Projeye eklenenler

### Godot eklentileri (`game/addons/`, sürüm sabit, repoya dahil)

| Eklenti | Sürüm | Lisans | Ne için | Test |
|---|---|---|---|---|
| [GUT](https://github.com/bitwes/Gut) | 9.7.1 | MIT | Birim testleri (`tools/test.sh`) | Ekransız çalıştı; başarısız testte çıkış kodu 1 ✅ |
| [Phantom Camera](https://github.com/ramokz/phantom-camera) | 0.12 | MIT | Keşif / diyalog / savaş kameraları | Kamera hedef konuma geçti ✅ (editördeki güncelleme kontrolü kapatıldı) |
| [Dialogue Manager](https://github.com/nathanhoad/godot_dialogue_manager) | 4.2.0 | MIT | Dallanan diyaloglar (`.dialogue` metin dosyaları) | Koşullu satırlar dahil derlendi ve okundu ✅ |
| [Godot State Charts](https://github.com/derkork/godot-statecharts) | 0.22.5 | MIT | Savaş akışı, keşif/diyalog/savaş modları | Olayla durum değişti ✅ |

### Python araçları (`/opt/uomd-tools/venv`, `tools/bootstrap.sh` kurar)

| Araç | Sürüm | Ne için | Test |
|---|---|---|---|
| [Graphify](https://github.com/Graphify-Labs/graphify) (`graphifyy[mcp]`) | 0.9.118 | Kod bilgi grafiği, sorgu; Claude yeteneği `/graphify` | Repo 2 sn'de tarandı; sorgu çalıştı ✅ |
| GDScript çıkarıcımız (`tools/graph/gdscript_extract.py`) | — | Graphify GDScript desteklemiyor; `.gd`/`.tscn` grafiği | GDQuest RPG: 82 dosya, 438 düğüm; sorgu doğru dosyayı buldu ✅ |
| [gdtoolkit](https://github.com/Scony/godot-gdscript-toolkit) | 4.5.0 | `gdlint`, `gdformat` (kod kalitesi) | Kendi kodumuzda gerçek sorunlar yakaladı ✅ |
| [fake-bpy-module](https://github.com/nutti/fake-bpy-module) (5.2) | 20260730 | Blender API tip tanımları (doğru `bpy` kodu yazmak için okunur) | Kuruldu (yalnız `.pyi` dosyaları) ✅ |

### Blender eklentisi

| Eklenti | Sürüm | Lisans | Ne için | Test |
|---|---|---|---|---|
| [MPFB2](https://github.com/makehumancommunity/mpfb2) (MakeHuman) | 2.0.10 | Kod GPL-3, varlıklar **CC0** | Anime gövde tabanının başlangıç noktası: temiz topoloji + 53 kemikli oyun iskeleti | 0,5 sn'de gövde + iskelet; glTF → Godot'a 53 kemik, deri bağlarıyla geçti ✅ |

GPL notu: MPFB kodu yalnız Blender'da üretim sırasında çalışır; oyuna giden şey ürettiği model (CC0 varlıklardan türetilmiş)
dir. Oyun kodu MPFB'ye bağlanmaz.

## 2. Salt okunur referans repolar (`tools/fetch_refs.sh` → `vendor/`, git'e girmez)

| Repo | Sürüm | Lisans | Neden |
|---|---|---|---|
| [GDQuest Open RPG](https://github.com/gdquest-demos/godot-open-rpg) | 0.4.0 | MIT | Godot 4'te sıra tabanlı savaş: aktif sıra kuyruğu, savaşçı animasyonları, sıra çubuğu arayüzü |
| [godot-demo-projects](https://github.com/godotengine/godot-demo-projects) | 4.7 | MIT | Resmi örnekler: 3D, arayüz, mobil, shader |
| [MPFB2](https://github.com/makehumancommunity/mpfb2) | 2.0.10 | GPL-3/CC0 | MPFB'yi betikle kullanmak için kaynak kod ve örnekler |

## 3. Değerlendirilip eklenmeyenler

| Aday | Karar | Neden |
|---|---|---|
| [Dialogic](https://github.com/dialogic-godot/dialogic) | ❌ | GDQuest RPG içindeki sürümü Godot 4.7'de derlenmedi (ayrıştırma hataları). Dialogue Manager aynı işi görüyor ve 4.7'de çalıştı. |
| [gdUnit4](https://github.com/MikeSchulze/gdUnit4) | ⏸ | GUT ile aynı işi görüyor; iki test çatısı gereksiz. |
| [godot-vrm / MToon](https://github.com/V-Sekai/godot-vrm) | ⏸ | VRM biçimini kullanmıyoruz; toon shader'ı kendimiz yazacağız. Gerekirse shader referansı olarak okunur. |
| Godot MCP sunucuları ([Coding-Solo](https://github.com/Coding-Solo/godot-mcp), [godot-ai](https://github.com/hi-godot/godot-ai) …) | ⏸ | Çoğu açık bir Godot editörü (arayüz) bekliyor. Biz Godot'u doğrudan komut satırından yönetiyoruz (içe aktarma, betik, test, ekran görüntüsü); ek bir katmana gerek yok. |
| Blender MCP | ⏸ | Aynı neden: arayüzlü Blender bekliyor; biz `bpy` betiklerini doğrudan çalıştırıyoruz. |
| MB-Lab | ⏸ | MPFB2 daha güncel, CC0 varlıklı ve betikle kullanımı doğrulandı. |
| Görselden 3D servisleri (Meshy, Tripo) | ❌ | Sahip kararı: modeller Claude tarafından elle (kodla) yapılacak. |

## 4. Sonra değerlendirilecekler

| Aday | Ne zaman |
|---|---|
| Terrain3D (GDExtension arazi) | Keşif haritaları aşamasında; mobil performansı denenmeli |
| Beehave / LimboAI (davranış ağaçları) | Düşman yapay zekâsı basit kalmazsa |
| GodotSteam | PC yayın aşamasında |
| CMU hareket yakalama verisi (BVH) | Animasyon aşamasında; lisans ve iskelete aktarma denenmeli |
