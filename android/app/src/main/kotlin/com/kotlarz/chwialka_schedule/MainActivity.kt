package com.kotlarz.chwialka_schedule

import android.os.Bundle
import com.google.gson.Gson
import com.kotlarz.chwialka_schedule.service.fetchPdfBytes
import com.kotlarz.chwialka_schedule.service.parseToRawDays
import com.kotlarz.chwialka_schedule.service.toEvents
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlin.concurrent.thread


class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.kotlarz.chwialkaschedule.events"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)


        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
            thread {
                try {
                    val bytes = fetchPdfBytes()
                    val rawDays = parseToRawDays(bytes)
                    val events = rawDays.map { toEvents(it) }

                    runOnUiThread {
                        result.success(Gson().toJson(events))
                    }
                } catch (ex: Exception) {
                    runOnUiThread {
                        result.error("Cannot fetch events", ex.message, ex)
                    }
                }
            }
        }
    }
}
