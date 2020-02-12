package com.kotlarz.chwialka_schedule.schedule.model

data class Schedule(
        val start: Long,
        val days: List<Day>
)