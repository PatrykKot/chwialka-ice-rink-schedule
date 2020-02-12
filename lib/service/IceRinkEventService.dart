import 'dart:convert';

import 'package:chwialka_schedule/model/ScheduleModel.dart';
import 'package:flutter/services.dart';

class IceRinkScheduleService {
  static const platform =
      const MethodChannel("com.kotlarz.chwialkaschedule.events");

  Future<List<ScheduleModel>> fetchSchedules() async {
    final String result = await platform.invokeMethod("");
    final List<dynamic> json = jsonDecode(result);

    final schedules = List<ScheduleModel>();

    json.forEach((scheduleJson) {
      schedules.add(ScheduleModel.fromMap(scheduleJson));
    });

    return schedules;
  }
}
