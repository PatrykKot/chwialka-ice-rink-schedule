import 'day_model.dart';

class ScheduleModel {
  int start;
  List<DayModel> days;

  ScheduleModel({required this.start, required this.days});

  static ScheduleModel fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
        start: map['start'],
        days: [...(map['days'] as List).map((o) => DayModel.fromMap(o))]);
  }

  Map toJson() => {"start": start, "days": days};
}
