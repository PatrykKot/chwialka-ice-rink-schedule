import 'package:chwialka_ice_rink_schedule_mobile/model/day_model.dart';
import 'package:chwialka_ice_rink_schedule_mobile/model/schedule_model.dart';
import 'package:chwialka_ice_rink_schedule_mobile/service/ice_rink_event_service.dart';
import 'package:chwialka_ice_rink_schedule_mobile/widget/day_tab.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var loading = false;
  final schedules = <ScheduleModel>[];

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

    final fetchedSchedules = await iceRinkScheduleService.fetchSchedules();

    setState(() {
      schedules.clear();
      schedules.addAll(fetchedSchedules);
      loading = false;
    });

    var initialDayIndex = 0;
    final todayDays = flattenedDays.where((day) => isToday(day));
    if (todayDays.isNotEmpty) {
      initialDayIndex = flattenedDays.indexOf(todayDays.first);
    }

    pageViewController = PageController(initialPage: initialDayIndex);
  }

  bool isToday(DayModel dayModel) {
    final now = DateTime.now();
    final date = findDate(dayModel);

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  List<DayModel> get flattenedDays {
    return schedules.expand((schedule) => schedule.days).toList();
  }

  DateTime findDate(DayModel dayModel) {
    final schedule =
        schedules.firstWhere((schedule) => schedule.days.contains(dayModel));
    final dateMilis =
        schedule.start + schedule.days.indexOf(dayModel) * 3600000 * 24;
    return DateTime.fromMillisecondsSinceEpoch(dateMilis);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harmonogram lodowiska'),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : PageView.builder(
              controller: pageViewController,
              itemCount: flattenedDays.length,
              itemBuilder: (context, index) {
                var day = flattenedDays[index];
                return DayTab(dayModel: day, date: findDate(day));
              }),
    );
  }
}
