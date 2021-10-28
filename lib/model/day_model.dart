import 'event_model.dart';

class DayModel {
  List<EventModel> events;

  DayModel({required this.events});

  static DayModel fromMap(Map<String, dynamic> map) {
    return DayModel(
        events: [...(map['events'] as List).map((o) => EventModel.fromMap(o))]);
  }

  Map toJson() => {"events": events};
}
