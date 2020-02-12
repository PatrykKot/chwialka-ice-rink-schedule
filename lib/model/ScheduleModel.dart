import 'package:chwialka_schedule/model/DayModel.dart';

class ScheduleModel {
  int start;
  List<DayModel> days;

  ScheduleModel({this.start, this.days});

  static ScheduleModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ScheduleModel bean = ScheduleModel();
    bean.start = map['start'];
    bean.days = List()
      ..addAll(
          (map['days'] as List ?? []).map((o) => DayModel.fromMap(o)));
    return bean;
  }

  Map toJson() => {
    "start": start,
    "days": days
  };
}