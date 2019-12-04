import 'dart:convert';

import 'package:chwialka_schedule/model/EventModel.dart';
import 'package:flutter/services.dart';

class IceRinkEventService {
  static const platform =
      const MethodChannel("com.kotlarz.chwialkaschedule.events");

  Future<List<List<EventModel>>> fetchEvents() async {
    final String result = await platform.invokeMethod("");
    final List<dynamic> json = jsonDecode(result);

    final days = List<List<EventModel>>();

    json.forEach((dayEvents) {
      final events = List<EventModel>();

      final List<dynamic> list = dayEvents;
      list.forEach((eventJson) {
        final event = EventModel.fromMap(eventJson);
        events.add(event);
      });

      days.add(events);
    });

    return days;
  }
}
