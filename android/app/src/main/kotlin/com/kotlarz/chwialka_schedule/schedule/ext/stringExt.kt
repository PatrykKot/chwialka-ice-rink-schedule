import com.kotlarz.chwialka_schedule.schedule.model.Time

fun String.toTime(): Time? {
    val regex = Regex("\\d{1,2}:\\d{2}")
    val stringHour = regex.find(this)

    return if (stringHour != null) {
        val split = stringHour.value.split(":")
        Time(split[0].toInt(), split[1].toInt())
    } else {
        null
    }
}