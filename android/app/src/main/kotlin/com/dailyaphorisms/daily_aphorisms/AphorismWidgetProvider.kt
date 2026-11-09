package com.dailyaphorisms.daily_aphorisms

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Android ana ekran widget provider'ı.
 *
 * home_widget paketi [HomeWidgetProvider] sınıfını sağlar.
 * Flutter tarafından [HomeWidget.saveWidgetData()] ile yazılan veriler
 * burada [SharedPreferences] üzerinden okunur ve [RemoteViews]'a yansıtılır.
 */
class AphorismWidgetProvider : HomeWidgetProvider() {

    /**
     * Widget güncellendiğinde çağrılır.
     * Flutter tarafında kaydedilen `quote_text` ve `quote_author` değerlerini
     * okuyarak XML layout'taki TextView'lere yazar.
     */
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.aphorism_widget)

            // Flutter tarafından kaydedilen verileri oku
            val quoteText = widgetData.getString("quote_text", "Bir kategori seçin…")
            val quoteAuthor = widgetData.getString("quote_author", "")

            // TextView'lere yaz
            views.setTextViewText(R.id.quote_text, quoteText)
            views.setTextViewText(R.id.quote_author, quoteAuthor)

            // Widget'ı güncelle
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
