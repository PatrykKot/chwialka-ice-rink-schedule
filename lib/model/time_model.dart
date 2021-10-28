class TimeModel {
  int hour;
  int minute;

  TimeModel({required this.hour, required this.minute});

  static TimeModel fromMap(Map<String, dynamic> map) {
    return TimeModel(hour: map['hour'], minute: map['minute']);
  }

  Map toJson() => {
    "hour": hour,
    "minute": minute,
  };
}