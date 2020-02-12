import 'package:chwialka_schedule/model/DayModel.dart';
import 'package:chwialka_schedule/model/EventModel.dart';
import 'package:chwialka_schedule/model/ScheduleModel.dart';
import 'package:chwialka_schedule/service/IceRinkEventService.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var loading = false;
  final schedules = List<ScheduleModel>();

  final scheduleService = IceRinkScheduleService();
  var pageViewController = PageController();

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }

  init() async {
    setState(() {
      loading = true;
    });

    final fetchedSchedules = await scheduleService.fetchSchedules();

    setState(() {
      schedules.clear();
      schedules.addAll(fetchedSchedules);
      loading = false;
    });

    final currentDayIndex =
        flattenedDays.indexOf(flattenedDays.firstWhere((day) => isToday(day)));
    pageViewController = PageController(initialPage: currentDayIndex);
  }

  List<DayModel> get flattenedDays {
    return schedules.expand((schedule) => schedule.days).toList();
  }

  int findDayOfTheWeek(DayModel dayModel) {
    final schedule =
        schedules.firstWhere((schedule) => schedule.days.contains(dayModel));
    return schedule.days.indexOf(dayModel);
  }

  DateTime findDate(DayModel dayModel) {
    final schedule =
        schedules.firstWhere((schedule) => schedule.days.contains(dayModel));
    final dateMilis =
        schedule.start + schedule.days.indexOf(dayModel) * 3600000 * 24;
    return DateTime.fromMillisecondsSinceEpoch(dateMilis);
  }

  String findDateText(DayModel dayModel) {
    final date = findDate(dayModel);
    return '${date.day.toString()} ${monthName(date.month - 1)}';
  }

  bool isToday(DayModel dayModel) {
    final date = findDate(dayModel);
    final now = DateTime.now();

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
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
    ][month];
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Harmonogram lodowiska'),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : PageView.builder(
              controller: pageViewController,
              itemCount: flattenedDays.length,
              itemBuilder: (context, index) =>
                  createPage(flattenedDays[index])),
    );
  }

  Widget createPage(DayModel dayModel) {
    return Column(
      children: <Widget>[
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: MediaQuery.of(context).size.width,
          child: Card(
            color: isToday(dayModel) ? Colors.green : null,
            child: ListTile(
              leading: Icon(Icons.today),
              title: Text(
                dayOfTheWeekName(findDayOfTheWeek(dayModel)),
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text(findDateText(dayModel)),
              trailing: isToday(dayModel)
                  ? Text(
                      'Dziś',
                      style: TextStyle(fontSize: 18),
                    )
                  : null,
            ),
          ),
        ),
        Expanded(child: createEventsList(dayModel.events)),
      ],
    );
  }

  Widget createEventsList(List<EventModel> events) {
    return ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Ink(
            color: event.name.contains('Ślizgawka')
                ? Theme.of(context).accentColor
                : Theme.of(context).backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '${event.starting.hour}:${event.starting.minute.toString().padRight(2, '0')}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: event.name.contains('Ślizgawka')
                              ? Colors.black
                              : Colors.white,
                          fontSize: 18),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          event.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              color: event.name.contains('Ślizgawka')
                                  ? Colors.black
                                  : Colors.white),
                        ),
                      ),
                    ),
                    Text(
                        '${event.ending.hour}:${event.ending.minute.toString().padRight(2, '0')}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: event.name.contains('Ślizgawka')
                                ? Colors.black
                                : Colors.white,
                            fontSize: 18))
                  ]),
            ),
          );
        });
  }
}
