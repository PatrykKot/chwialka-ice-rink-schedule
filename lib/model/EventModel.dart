import 'package:chwialka_schedule/model/TimeModel.dart';

class EventModel {
  TimeModel starting;
  String name;
  TimeModel ending;

  EventModel({this.starting, this.name, this.ending});

  static EventModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    EventModel bean = EventModel();
    bean.ending = TimeModel.fromMap(map['ending']);
    bean.name = map['name'];
    bean.starting = TimeModel.fromMap(map['starting']);
    return bean;
  }

  Map toJson() => {
        "ending": ending,
        "name": name,
        "starting": starting,
      };
}
