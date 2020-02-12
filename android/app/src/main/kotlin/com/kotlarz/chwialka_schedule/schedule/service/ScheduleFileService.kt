package com.kotlarz.chwialka_schedule.schedule.service

import com.kotlarz.chwialka_schedule.schedule.model.ScheduleFile
import org.jsoup.Jsoup
import java.net.URL

class ScheduleFileService {
    fun fetchFiles(): List<ScheduleFile> {
        return Jsoup.parse(URL("https://chwialka.poznan.pl/lodowisko/harmonogram-lodowiska/").readText())
                .getElementsByClass("entry-content")
                .first()
                .getElementsByClass("wp-caption")
                .map {
                    val pdfPath = it.getElementsByTag("a").first().attr("href")
                    val name = it.getElementsByTag("p").first().text().replace("grafik lodowiska", "").trim()

                    ScheduleFile(
                            name = name,
                            content = URL(pdfPath).readBytes()
                    )
                }
    }
}