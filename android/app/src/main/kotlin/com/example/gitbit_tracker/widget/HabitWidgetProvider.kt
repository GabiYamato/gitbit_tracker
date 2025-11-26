package com.example.gitbit_tracker.widget

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import com.example.gitbit_tracker.R
import es.antonborri.home_widget.HomeWidgetPlugin

class HabitWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.habit_widget)
            
            // Get shared preferences
            val widgetData = HomeWidgetPlugin.getData(context)
            val habitCount = widgetData.getInt("habit_count", 0)
            
            if (habitCount == 0) {
                views.setViewVisibility(R.id.habits_container, android.view.View.GONE)
                views.setViewVisibility(R.id.empty_view, android.view.View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.habits_container, android.view.View.VISIBLE)
                views.setViewVisibility(R.id.empty_view, android.view.View.GONE)
                
                // Note: For simplicity, we're showing a basic view
                // In a production app, you would use RemoteViewsService for a list
            }
            
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}
