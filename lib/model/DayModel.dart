import 'package:chwialka_schedule/model/EventModel.dart';

class DayModel {
  List<EventModel> events;

  DayModel({this.events});

  static DayModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    DayModel bean = DayModel();
    bean.events = List()
      ..addAll((map['events'] as List ?? []).map((o) => EventModel.fromMap(o)));
    return bean;
  }

  Map toJson() => {"events": events};
}
