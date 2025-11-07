# Rota İstiklal

Rota İstiklal, Türkiye Cumhuriyeti’nin kuruluş sürecini daha iyi anlamak isteyen herkes için hazırlanmış bir mobil uygulamadır.
Uygulama, Atatürk’ün özlü sözlerinden başlayarak, Atatürk ve silah arkadaşlarının biyografilerine yer verir.
Ayrıca etkileşimli Kurtuluş Savaşı haritası ve Atatürk bilgi testi ile kullanıcıların tarihî süreci daha iyi anlamalarını sağlar.

## 📸 Uygulama Tanıtım Videosu [GOGLE DRİVE VİDEO](https://drive.google.com/file/d/1rDO4arpM-yutUDckR_EYVlxwnLrouuex/view?usp=sharing)

## 🎯 Proje Amacı ve Kapsamı

Bu proje, Atatürk’ün liderliğinde gerçekleşen Türk Kurtuluş Savaşı’nı dijital bir deneyimle anlatmayı hedefler.
Uygulama, kullanıcıların tarihi olayları daha etkileşimli bir şekilde öğrenmelerine olanak tanır.
Tarih, teknoloji ve eğitim temalarını bir araya getirerek hem öğretici hem de ilgi çekici bir deneyim sunar.

## 🛠️ Kullanılan Teknolojiler

| Kategori | Teknoloji | Açıklama |
| :--- | :--- | :--- |
| **Geliştirme Ortamı** | `Flutter` | Uygulamanın arayüzü, harita entegrasyonu ve etkileşimli özelliklerinin geliştirilmesi. |
| **Yapay Zekâ** | `Google Gemini API` | Dinamik soru üretimi ve içerik desteği. |
| **Harita Entegrasyonu** | `Google Maps Flutter` | Kurtuluş Savaşı dönemindeki önemli bölgeleri ve olayları harita üzerinde etkileşimli biçimde gösterir. |
| **Veri Entegrasyonu** | `Wikipedia API` | Haritada seçilen şehir veya olay hakkında Wikipedia üzerinden otomatik bilgi çekimi. |

## ✨ Uygulama Özellikleri

* **Atatürk’ün Özlü Sözleri:** Atatürk’ün ilham verici sözlerini modern bir arayüzde keşfedin.

* **Biyografiler:** Wikipedia API dan çekilen verilerle Mustafa Kemal Atatürk ve silah arkadaşlarının kısa, anlaşılır biyografileri yer alır.

* **Etkileşimli Harita:** Harita üzerinde önemli savaş bölgeleri ve stratejik noktalar gösterilir.Kullanıcı, harita üzerindeki noktalara tıklayarak o bölgeyle ilgili tarihsel bilgileri görebilir.Google Maps API kullanılarak etkileşimli ve dinamik bir deneyim sağlanır.

* **Atatürk Bilgi Testi:** Kullanıcıların öğrendiklerini pekiştirmesi amacıyla yapay zekâ destekli test sistemi oluşturulmuştur.Sorular, Google Gemini API üzerinden otomatik olarak üretilir.Cevaplar anında değerlendirilir, doğru şık yeşil – yanlış şık kırmızı olarak işaretlenir.Test sonunda kullanıcıya toplam doğru sayısı gösterilir ve isteğe bağlı olarak testi tekrar çözebilir.

## 📂 Proje Dosya Yapısı 

```plaintext
Rotaİstiklal/
├── assets/
├── lib/
│   ├── pages/
│   │   ├── ana_sayfa.dart
│   │   ├── harita_sayfasi.dart
│   │   ├── quiz_sayfasi.dart
│   │   ├── biyografi_sayfasi.dart
│   ├── services/
│   │   └── wikipedia_service.dart
│   └── main.dart
├── pubspec.yaml
├── .gitignore
└── README.md

