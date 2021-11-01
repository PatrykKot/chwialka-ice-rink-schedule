import 'package:chwialka_ice_rink_schedule_mobile/model/day_model.dart';
import 'package:flutter/material.dart';

import 'event_tile.dart';

class DayTab extends StatelessWidget {
  const DayTab({Key? key, required this.dayModel, required this.date})
      : super(key: key);

  final DayModel dayModel;

  final DateTime date;

  bool isToday(DayModel dayModel) {
    final now = DateTime.now();

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String findDateText(DayModel dayModel) {
    return '${date.day.toString()} ${monthName(date.month - 1)}';
  }

  String monthName(int month) {
    return [
      'styczeń',
      'luty',
      'marzec',
      'kwiecień',
      'maj',
      'czerwiec',
      'lipiec',
      'sierpień',
      'październik',
      'listopad',
      'grudzień'
    ][month - 1];
  }

  String dayOfTheWeekName(int dayOfTheWeek) {
    return [
      'Poniedziałek',
      'Wtorek',
      'Środa',
      'Czwartek',
      'Piątek',
      'Sobota',
      'Niedziela'
    ][dayOfTheWeek];
  }

  @override
  Widget build(BuildContext context) {
    var today = isToday(dayModel);

    return Column(
      children: <Widget>[
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: MediaQuery.of(context).size.width,
          child: Card(
            color: today ? Colors.green : null,
            child: ListTile(
              leading: const Icon(Icons.today),
              title: Text(
                dayOfTheWeekName(date.weekday - 1),
                style: const TextStyle(fontSize: 18),
              ),
              subtitle: Text(findDateText(dayModel)),
              trailing: today
                  ? const Text(
                      'Dziś',
                      style: TextStyle(fontSize: 18),
                    )
                  : null,
            ),
          ),
        ),
        Expanded(
            child: ListView.builder(
                itemCount: dayModel.events.length,
                itemBuilder: (context, index) {
                  final event = dayModel.events[index];
                  return DayTile(event: event);
                })),
      ],
    );
  }
}
