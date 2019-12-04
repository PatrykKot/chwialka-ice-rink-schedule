class EventModel {
  Time starting;
  String name;
  Time ending;

  EventModel({this.starting, this.name, this.ending});

  static EventModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    EventModel bean = EventModel();
    bean.ending = Time.fromMap(map['ending']);
    bean.name = map['name'];
    bean.starting = Time.fromMap(map['starting']);
    return bean;
  }

  Map toJson() => {
        "ending": ending,
        "name": name,
        "starting": starting,
      };
}

class Time {
  int hour;
  int minute;

  Time({this.hour, this.minute});

  static Time fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    Time bean = Time();
    bean.hour = map['hour'];
    bean.minute = map['minute'];
    return bean;
  }

  Map toJson() => {
        "hour": hour,
        "minute": minute,
      };
}
