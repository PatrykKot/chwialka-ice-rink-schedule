package com.kotlarz.chwialka_schedule.schedule.service

import com.itextpdf.text.Rectangle
import com.itextpdf.text.pdf.PdfReader
import com.itextpdf.text.pdf.parser.FilteredTextRenderListener
import com.itextpdf.text.pdf.parser.LocationTextExtractionStrategy
import com.itextpdf.text.pdf.parser.PdfTextExtractor
import com.itextpdf.text.pdf.parser.RegionTextRenderFilter
import com.kotlarz.chwialka_schedule.schedule.model.*
import toTime
import java.lang.RuntimeException
import java.util.*
import kotlin.collections.LinkedHashSet

class ScheduleParser {
    fun parse(scheduleFile: ScheduleFile): Schedule {
        val rawDays = toRawDays(scheduleFile.content)
        val days = rawDays.map { Day(toEvents(it)) }

        return Schedule(toStartDate(scheduleFile.name), days)
    }

    private fun toRawDays(pdfBytes: ByteArray): List<String> {
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

    private fun toEvents(text: String): List<Event> {
        val lines = text.split('\n')
                .map { it.trim() }

        var index = 0
        val events = mutableListOf<Event>()

        try {
            while (true) {
                var starting: Time
                while (true) {
                    val timeLine = lines[index]
                    val tempTime = timeLine.toTime()
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
                    if (lines[index].toTime() == null) {
                        names.add(lines[index])
                        index++
                    } else {
                        break
                    }
                }

                var ending: Time
                while (true) {
                    val timeLine = lines[index]
                    val tempTime = timeLine.toTime()
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

    private fun toStartDate(text: String): Long {
        val parts = text.split("-")
        val firstPart = parts[0]
        val secondPart = parts[1]

        var secondPartMonth = secondPart.split(" ")[1].trim().toLowerCase()
        var firstPartMonth = secondPartMonth
        if (firstPart.contains(" ")) {
            firstPartMonth = firstPart.split(" ")[1].trim().toLowerCase()
        }

        val monthStart = toMonthNumber(firstPartMonth)
        val monthEnd = toMonthNumber(secondPartMonth)
        val dayStart = firstPart.split(" ")[0].toInt()
        var year = Calendar.getInstance().get(Calendar.YEAR)

        if (monthStart > monthEnd) {
            year--
        }

        return GregorianCalendar(year, monthStart, dayStart).time.time
    }

    private fun toMonthNumber(text: String): Int {
        if (text.startsWith("sty")) {
            return 0
        }

        if (text.startsWith("lut")) {
            return 1
        }

        if (text.startsWith("mar")) {
            return 2
        }

        if (text.startsWith("kwi")) {
            return 3
        }

        if (text.startsWith("maj")) {
            return 4
        }

        if (text.startsWith("czer")) {
            return 5
        }

        if (text.startsWith("lip")) {
            return 6
        }

        if (text.startsWith("sier")) {
            return 7
        }

        if (text.startsWith("wrze")) {
            return 8
        }

        if (text.startsWith("paź")) {
            return 9
        }

        if (text.startsWith("lis")) {
            return 10
        }

        if (text.startsWith("gru")) {
            return 11
        }

        throw RuntimeException()
    }
}