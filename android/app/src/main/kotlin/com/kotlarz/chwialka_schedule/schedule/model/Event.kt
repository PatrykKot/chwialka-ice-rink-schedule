package com.kotlarz.chwialka_schedule.schedule.model

data class Event(
        val starting: Time,
        val name: String,
        val ending: Time
)