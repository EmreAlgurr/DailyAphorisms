/// home_widget paketi üzerinden Flutter ↔ Android widget haberleşme servisi.
///
/// * Seçili kategoriyi SharedPreferences'a kaydeder.
/// * Tarih bazlı deterministik söz hesaplar (aynı gün = aynı söz).
/// * `HomeWidget.updateWidget()` ile native widget'ı tetikler.
library;

import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/quotes_data.dart';

/// Android tarafındaki widget provider'ın tam sınıf adı.
const String _androidWidgetName =
    'com.dailyaphorisms.daily_aphorisms.AphorismWidgetProvider';

/// SharedPreferences anahtarları — native taraf da aynı anahtarları kullanır.
class WidgetKeys {
  static const String selectedCategory = 'selected_category';
  static const String quoteText = 'quote_text';
  static const String quoteAuthor = 'quote_author';
  static const String lastUpdateDate = 'last_update_date';
}

class WidgetService {
  WidgetService._();

  // ---------- Kategori Seçimi ----------

  /// Seçili kategori ID'sini kaydeder ve widget'ı günceller.
  static Future<void> selectCategory(String categoryId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(WidgetKeys.selectedCategory, categoryId);

    // Günün sözünü hemen hesapla & widget'a bas
    await _computeAndPushQuote(categoryId);
  }

  /// Daha önce kaydedilen kategori ID'sini döner. Yoksa `null`.
  static Future<String?> getSelectedCategory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(WidgetKeys.selectedCategory);
  }

  // ---------- Günün Sözü ----------

  /// Tarih bazlı deterministik söz seçimi.
  ///
  /// `dayOfYear % quotes.length` formülü sayesinde
  /// aynı gün aynı söz gösterilir ve her gün otomatik değişir.
  static Quote getDailyQuote(List<Quote> quotes) {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final index = dayOfYear % quotes.length;
    return quotes[index];
  }

  /// Verilen kategoriye ait günün sözünü hesaplar,
  /// SharedPreferences + HomeWidget verilerine yazar ve widget'ı günceller.
  static Future<void> _computeAndPushQuote(String categoryId) async {
    final category = allCategories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => allCategories.first,
    );

    final quote = getDailyQuote(category.quotes);

    // home_widget'ın paylaşılan veri deposuna yaz
    await HomeWidget.saveWidgetData<String>(
      WidgetKeys.quoteText,
      quote.text,
    );
    await HomeWidget.saveWidgetData<String>(
      WidgetKeys.quoteAuthor,
      '— ${quote.author}',
    );
    await HomeWidget.saveWidgetData<String>(
      WidgetKeys.lastUpdateDate,
      DateTime.now().toIso8601String(),
    );

    // Native widget'ı güncelle
    await HomeWidget.updateWidget(
      androidName: _androidWidgetName,
    );
  }

  /// Uygulama açılışında veya gece yarısı güncellemesinde çağrılır.
  /// Daha önce bir kategori seçilmişse widget'ı günceller.
  static Future<void> refreshWidgetIfNeeded() async {
    final categoryId = await getSelectedCategory();
    if (categoryId != null) {
      await _computeAndPushQuote(categoryId);
    }
  }
}
