class TimeModel {
  int hour;
  int minute;

  TimeModel({this.hour, this.minute});

  static TimeModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    TimeModel bean = TimeModel();
    bean.hour = map['hour'];
    bean.minute = map['minute'];
    return bean;
  }

  Map toJson() => {
    "hour": hour,
    "minute": minute,
  };
}