import 'time_model.dart';

class EventModel {
  TimeModel starting;
  String name;
  TimeModel ending;

  EventModel(
      {required this.starting, required this.name, required this.ending});

  static EventModel fromMap(Map<String, dynamic> map) {
    return EventModel(
        name: map['name'],
        starting: TimeModel.fromMap(map['starting']),
        ending: TimeModel.fromMap(map['ending']));
  }

  Map toJson() => {
        "ending": ending,
        "name": name,
        "starting": starting,
      };
}
