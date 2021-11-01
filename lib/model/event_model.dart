import 'time_model.dart';

class EventModel {
  TimeModel starting;
  String name;
  TimeModel ending;

  EventModel(
      {required this.starting, required this.name, required this.ending});

  bool includesIn(TimeModel timeModel) {
    final timeModelMinutes = timeModel.toMinutes();
    final startingMinutes = starting.toMinutes();
    final endingMinutes = ending.toMinutes();
    return startingMinutes < timeModelMinutes &&
        endingMinutes > timeModelMinutes;
  }
}
