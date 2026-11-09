/// Alıntı veri modeli ve kategori listeleri.
///
/// İleride çoklu dil (multi-language) desteği eklenebilmesi için
/// [QuoteCategory] içinde `locale` alanı bulunur. Şimdilik sadece 'tr' kullanılır.
/// Yeni bir dil eklemek için ilgili kategoriye `locale: 'en'` ile yeni liste ekleyin.
library;

// ---------------------------------------------------------------------------
// Model
// ---------------------------------------------------------------------------

/// Tek bir alıntıyı temsil eder.
class Quote {
  final String text;
  final String author;

  const Quote({required this.text, required this.author});

  /// JSON/Map'ten oluşturma — ileride JSON dosyasından okumak için hazır.
  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      text: map['text'] as String,
      author: map['author'] as String,
    );
  }

  Map<String, dynamic> toMap() => {'text': text, 'author': author};
}

/// Bir kategoriyi ve o kategoriye ait alıntıları temsil eder.
class QuoteCategory {
  final String id;          // Benzersiz anahtar: 'existentialist', 'stoic', 'motivation'
  final String label;       // Kullanıcıya gösterilecek ad
  final String icon;        // Emoji ikonu
  final String locale;      // Dil kodu: 'tr', 'en', ...
  final List<Quote> quotes;

  const QuoteCategory({
    required this.id,
    required this.label,
    required this.icon,
    this.locale = 'tr',
    required this.quotes,
  });
}

// ---------------------------------------------------------------------------
// Veri — Türkçe (tr)
// ---------------------------------------------------------------------------

/// Tüm kategoriler. İleride `locale` bazlı filtreleme yapılabilir.
final List<QuoteCategory> allCategories = [
  _existentialistCategory,
  _stoicCategory,
  _motivationCategory,
];

// ---- Varoluşçu / Felsefi ----
const _existentialistCategory = QuoteCategory(
  id: 'existentialist',
  label: 'Varoluşçu / Felsefi',
  icon: '🌌',
  locale: 'tr',
  quotes: [
    Quote(
      text: 'Hayatın anlamını aramak yerine, hayata anlam katmak gerekir.',
      author: 'Albert Camus',
    ),
    Quote(
      text: 'Sisifos\'u mutlu hayal etmeliyiz.',
      author: 'Albert Camus',
    ),
    Quote(
      text: 'Özgürlük, insanın kendini seçtiği şeydir.',
      author: 'Jean-Paul Sartre',
    ),
    Quote(
      text: 'Varoluş özden önce gelir.',
      author: 'Jean-Paul Sartre',
    ),
    Quote(
      text: 'Kaygı, özgürlüğün baş dönmesidir.',
      author: 'Søren Kierkegaard',
    ),
    Quote(
      text: 'Hayat ancak geriye bakarak anlaşılabilir; ama ileriye bakarak yaşanmalıdır.',
      author: 'Søren Kierkegaard',
    ),
    Quote(
      text: 'İki şey ruhu hayranlık ve saygıyla doldurur: üstümdeki yıldızlı gökyüzü ve içimdeki ahlak yasası.',
      author: 'Immanuel Kant',
    ),
    Quote(
      text: 'Başkalarını araç olarak değil, her zaman amaç olarak gör.',
      author: 'Immanuel Kant',
    ),
    Quote(
      text: 'Düşünmekten korkmayan tek kişi, gerçekten düşünen kişidir.',
      author: 'Bertrand Russell',
    ),
    Quote(
      text: 'Sorun şu ki, dünyada aptallar kendinden emin, akıllılar ise kuşku dolu.',
      author: 'Bertrand Russell',
    ),
    Quote(
      text: 'Tanrı öldü. Onu biz öldürdük.',
      author: 'Friedrich Nietzsche',
    ),
    Quote(
      text: 'Seni öldürmeyen şey güçlendirir.',
      author: 'Friedrich Nietzsche',
    ),
    Quote(
      text: 'İnsan, bir ip gibidir; hayvan ile üstinsan arasına gerilmiş bir ip.',
      author: 'Friedrich Nietzsche',
    ),
    Quote(
      text: 'Dilin sınırları dünyamın sınırlarıdır.',
      author: 'Ludwig Wittgenstein',
    ),
    Quote(
      text: 'İnsan, özgürlüğe mahkumdur.',
      author: 'Jean-Paul Sartre',
    ),
  ],
);

// ---- Stoacı ----
const _stoicCategory = QuoteCategory(
  id: 'stoic',
  label: 'Stoacı',
  icon: '🏛️',
  locale: 'tr',
  quotes: [
    Quote(
      text: 'Kontrolün dışında olan şeyler için endişelenme; kontrolündeki şeylere odaklan.',
      author: 'Epiktetos',
    ),
    Quote(
      text: 'Mutluluk, dışarıda değil, senin içindedir.',
      author: 'Epiktetos',
    ),
    Quote(
      text: 'Bizi rahatsız eden olaylar değil, olaylara bakış açımızdır.',
      author: 'Epiktetos',
    ),
    Quote(
      text: 'Her yeni gün, hayatını değiştirmek için yeni bir şanstır.',
      author: 'Marcus Aurelius',
    ),
    Quote(
      text: 'Başkaları hakkında düşünmeye harcadığın zamanı kendini geliştirmeye harca.',
      author: 'Marcus Aurelius',
    ),
    Quote(
      text: 'Engel, yol olur.',
      author: 'Marcus Aurelius',
    ),
    Quote(
      text: 'Kendi düşüncelerini kontrol etmeyi öğren, yoksa düşünceler seni kontrol eder.',
      author: 'Marcus Aurelius',
    ),
    Quote(
      text: 'Gerçek zenginlik, az şeyle yetinmektir.',
      author: 'Seneca',
    ),
    Quote(
      text: 'Hayat kısadır, ama eğer nasıl yaşayacağını bilirsen yeterince uzundur.',
      author: 'Seneca',
    ),
    Quote(
      text: 'Şanslı olmayı beklemek yerine, şansını kendin yarat.',
      author: 'Seneca',
    ),
    Quote(
      text: 'En büyük zafer, kendi kendini yenmektir.',
      author: 'Platon',
    ),
    Quote(
      text: 'Erdemli bir hayat, doğayla uyum içinde yaşamaktır.',
      author: 'Zenon',
    ),
    Quote(
      text: 'Acı çekmek, yanlış beklentilerin sonucudur.',
      author: 'Epiktetos',
    ),
    Quote(
      text: 'Sabahları kalk ve bugün yapacağın iyi şeyleri düşün.',
      author: 'Marcus Aurelius',
    ),
    Quote(
      text: 'Kadere boyun eğen bilge, kaderi yaratan cesurdur.',
      author: 'Seneca',
    ),
  ],
);

// ---- Motivasyon ----
const _motivationCategory = QuoteCategory(
  id: 'motivation',
  label: 'Motivasyon',
  icon: '🔥',
  locale: 'tr',
  quotes: [
    Quote(
      text: 'Rüzgar esmezse kürek çek.',
      author: 'Latin Atasözü',
    ),
    Quote(
      text: 'Bin kilometrelik bir yolculuk bile tek bir adımla başlar.',
      author: 'Lao Tzu',
    ),
    Quote(
      text: 'Yaşamak, nadir bulunan en güzel şeydir. Çoğu insan sadece var olur.',
      author: 'Oscar Wilde',
    ),
    Quote(
      text: 'Gelecek, bugün ne yaptığına bağlıdır.',
      author: 'Mahatma Gandhi',
    ),
    Quote(
      text: 'Başarısızlık, başarının baharatıdır.',
      author: 'Truman Capote',
    ),
    Quote(
      text: 'Yara almadan savaş kazanılmaz.',
      author: 'Türk Atasözü',
    ),
    Quote(
      text: 'Her gün yeni bir başlangıçtır.',
      author: 'Anonim',
    ),
    Quote(
      text: 'İnsanın hayatındaki en büyük zafer, düştüğü yerden kalkmasıdır.',
      author: 'Nelson Mandela',
    ),
    Quote(
      text: 'Hayal gücü bilgiden daha önemlidir.',
      author: 'Albert Einstein',
    ),
    Quote(
      text: 'Yapabileceğine inanırsan, yarı yoldasındır.',
      author: 'Theodore Roosevelt',
    ),
    Quote(
      text: 'Tek sınır, kendi aklına koyduğun sınırdır.',
      author: 'Anonim',
    ),
    Quote(
      text: 'Dünle beraber gitti, düne ait ne varsa. Bugün yeni bir şey söylemek lazım.',
      author: 'Mevlana',
    ),
    Quote(
      text: 'Karanlıktan şikayet etme, bir mum yak.',
      author: 'Konfüçyüs',
    ),
    Quote(
      text: 'İnsan aklının alabileceği ve inanabileceği her şeyi başarabilir.',
      author: 'Napoleon Hill',
    ),
    Quote(
      text: 'Büyük işler, küçük adımların toplamıdır.',
      author: 'Anonim',
    ),
  ],
);
