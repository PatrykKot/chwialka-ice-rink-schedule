import 'package:chwialka_ice_rink_schedule_mobile/model/event_model.dart';
import 'package:flutter/material.dart';

class DayTile extends StatelessWidget {
  const DayTile({Key? key, required this.event}) : super(key: key);

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    var isSlizgawka = event.name.contains('Ślizgawka');

    return Ink(
      color: isSlizgawka
          ? Theme.of(context).colorScheme.secondary
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
                    color: isSlizgawka ? Colors.black : Colors.white,
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
                        color: isSlizgawka ? Colors.black : Colors.white),
                  ),
                ),
              ),
              Text(
                  '${event.ending.hour}:${event.ending.minute.toString().padRight(2, '0')}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSlizgawka ? Colors.black : Colors.white,
                      fontSize: 18))
            ]),
      ),
    );
  }
}
