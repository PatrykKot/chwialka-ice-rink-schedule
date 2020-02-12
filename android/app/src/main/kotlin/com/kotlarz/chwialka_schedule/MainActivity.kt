package com.kotlarz.chwialka_schedule

import android.os.Bundle
import com.google.gson.Gson
import com.kotlarz.chwialka_schedule.schedule.service.ScheduleFileService
import com.kotlarz.chwialka_schedule.schedule.service.ScheduleParser
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlin.concurrent.thread

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.kotlarz.chwialkaschedule.events"

    private val scheduleFileService = ScheduleFileService()

    private val scheduleParser = ScheduleParser()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)


        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { _, result ->
            thread {
                try {
                    val files = scheduleFileService.fetchFiles()
                    val schedules = files.map { scheduleParser.parse(it) }

                    runOnUiThread {
                        result.success(Gson().toJson(schedules))
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
