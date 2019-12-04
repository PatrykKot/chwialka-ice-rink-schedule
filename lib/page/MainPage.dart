import 'package:chwialka_schedule/model/EventModel.dart';
import 'package:chwialka_schedule/service/IceRinkEventService.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var loading = false;
  final events = List<List<EventModel>>();

  final eventService = IceRinkEventService();

  @override
  void initState() {
    super.initState();

    init();
  }

  init() async {
    setState(() {
      loading = true;
    });

    final fetchedEvents = await eventService.fetchEvents();

    setState(() {
      events.clear();
      events.addAll(fetchedEvents);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: DateTime.now().weekday - 1,
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Harmonogram ślizgawki'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(child: Text('Pn')),
              Tab(child: Text('Wt')),
              Tab(child: Text('Śr')),
              Tab(child: Text('Cz')),
              Tab(child: Text('Pt')),
              Tab(child: Text('Sb')),
              Tab(child: Text('Nd'))
            ],
          ),
        ),
        body: TabBarView(
          children: loading
              ? [0, 1, 2, 3, 4, 5, 6]
                  .map((_) => Center(
                        child: CircularProgressIndicator(),
                      ))
                  .toList()
              : events.map((dayEvents) {
                  return ListView.builder(
                      itemCount: dayEvents.length,
                      itemBuilder: (context, index) {
                        final event = dayEvents[index];
                        return Ink(
                          color: event.name.contains('Ślizgawka')
                              ? Theme.of(context).accentColor
                              : Theme.of(context).backgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Text(
                                        event.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                event.name.contains('Ślizgawka')
                                                    ? Colors.black
                                                    : Colors.white),
                                      ),
                                    ),
                                  ),
                                  Text(
                                      '${event.ending.hour}:${event.ending.minute.toString().padRight(2, '0')}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              event.name.contains('Ślizgawka')
                                                  ? Colors.black
                                                  : Colors.white,
                                          fontSize: 18))
                                ]),
                          ),
                        );
                      });
                }).toList(),
        ),
      ),
    );
  }
}
