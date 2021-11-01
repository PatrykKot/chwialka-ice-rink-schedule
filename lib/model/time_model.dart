class TimeModel {
  int hour;
  int minute;

  TimeModel({required this.hour, required this.minute});

  int toMinutes() {
    return hour * 60 + minute;
  }

  static TimeModel fromMinutes(int minutes) {
    return TimeModel(hour: (minutes / 60).floor(), minute: minutes % 60);
  }
}
