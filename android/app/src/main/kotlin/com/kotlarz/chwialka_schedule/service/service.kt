package com.kotlarz.chwialka_schedule.service

import com.itextpdf.text.Rectangle
import com.itextpdf.text.pdf.PdfReader
import com.itextpdf.text.pdf.parser.FilteredTextRenderListener
import com.itextpdf.text.pdf.parser.LocationTextExtractionStrategy
import com.itextpdf.text.pdf.parser.PdfTextExtractor
import com.itextpdf.text.pdf.parser.RegionTextRenderFilter
import org.jsoup.Jsoup
import java.net.URL

data class Event(
        val starting: Time,
        val name: String,
        val ending: Time
)

data class Time(
        val hour: Int,
        val minute: Int
)

fun toEvents(text: String): List<Event> {
    val lines = text.split('\n')
            .map { it.trim() }

    var index = 0
    val events = mutableListOf<Event>()

    try {
        while (true) {
            var starting: Time
            while (true) {
                val timeLine = lines[index]
                val tempTime = parseTime(timeLine)
                index++

                if (tempTime == null) {
                    continue
                } else {
                    starting = tempTime
                    break
                }
            }

            val names = LinkedHashSet<String>()
            names.add(lines[index])
            index++

            while (true) {
                if (parseTime(lines[index]) == null) {
                    names.add(lines[index])
                    index++
                } else {
                    break
                }
            }

            var ending: Time
            while (true) {
                val timeLine = lines[index]
                val tempTime = parseTime(timeLine)
                index++

                if (tempTime == null) {
                    continue
                } else {
                    ending = tempTime
                    break
                }
            }

            events.add(
                    Event(
                            starting = starting,
                            ending = ending,
                            name = names.joinToString(" ")
                    )
            )
        }
    } catch (ex: IndexOutOfBoundsException) {
    }

    return events
}

fun parseTime(text: String): Time? {
    val regex = Regex("\\d{1,2}:\\d{2}")
    val stringHour = regex.find(text)

    return if (stringHour != null) {
        val split = stringHour.value.split(":")
        Time(split[0].toInt(), split[1].toInt())
    } else {
        null
    }
}

fun parseToRawDays(pdfBytes: ByteArray): List<String> {
    val reader = PdfReader(pdfBytes)

    val offset = 245f
    val columnWidth = 145f
    val days = mutableListOf<String>()

    for (index in 0..6) {
        val start = offset + index * columnWidth
        val end = offset + (index + 1) * columnWidth

        val filter = RegionTextRenderFilter(Rectangle(start, 0f, end, 1850f))
        val strategy = FilteredTextRenderListener(LocationTextExtractionStrategy(), filter)

        val text = PdfTextExtractor.getTextFromPage(reader, 1, strategy)
        days.add(text)
    }

    return days
}

fun fetchPdfBytes(): ByteArray {
    val pdfPath = Jsoup.parse(URL("https://chwialka.poznan.pl/lodowisko/harmonogram-lodowiska/").readText())
            .getElementsByClass("entry-content")
            .first()
            .getElementsByTag("a")
            .first()
            .attr("href")
    return URL(pdfPath).readBytes()
}