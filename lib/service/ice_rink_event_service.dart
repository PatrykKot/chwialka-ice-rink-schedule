import 'package:chwialka_ice_rink_schedule_mobile/model/day_model.dart';
import 'package:chwialka_ice_rink_schedule_mobile/model/event_model.dart';
import 'package:chwialka_ice_rink_schedule_mobile/model/schedule_model.dart';
import 'package:chwialka_ice_rink_schedule_mobile/model/time_model.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

final iceRinkScheduleService = IceRinkScheduleService();

class IceRinkScheduleService {
  Future<List<ScheduleModel>> fetchSchedules() async {
    final response = await http.get(
        Uri.parse("https://posir.poznan.pl/obiekty/chwialka/lodowisko/grafik"));
    if (response.statusCode == 200) {
      return parseSchedule(response);
    }

    throw Exception();
  }

  List<ScheduleModel> parseSchedule(http.Response response) {
    final document = parse(response.body);
    final iceRinkContainer =
        document.getElementsByClassName("grafik-lodowisko")[0];
    final trs = iceRinkContainer.getElementsByTagName("tr");
    trs.removeAt(0);

    final days = List.generate(7, (index) => DayModel(events: []));

    var checkedTimeMinutes = 6 * 60 + 30;
    for (final tr in trs) {
      final checkedTimeModel = TimeModel.fromMinutes(checkedTimeMinutes);

      var tdIterator = 2;
      final tds = tr.getElementsByTagName("td");

      for (final day in days) {
        final dayIndex = days.indexOf(day);
        if (!day.events.any((event) => event.includesIn(checkedTimeModel))) {
          final td = tds[tdIterator];

          if (td.attributes.containsKey("rowspan")) {
            EventModel event = parseEvent(td, checkedTimeMinutes);

            days[dayIndex].events.add(event);
          }

          tdIterator++;
        }
      }

      checkedTimeMinutes += 15;
    }

    return [ScheduleModel(start: getStartingDay(document), days: days)];
  }

  EventModel parseEvent(Element td, int timeMinutes) {
    final rowspan = int.parse(td.attributes["rowspan"]!);
    final minutes = rowspan * 15;
    final ending = timeMinutes + minutes;

    final event = EventModel(
        starting: TimeModel.fromMinutes(timeMinutes),
        ending: TimeModel.fromMinutes(ending),
        name: td.text.trim());
    return event;
  }

  int getStartingDay(Document document) {
    final th = document
        .getElementsByClassName("grafik-lodowisko")[0]
        .getElementsByTagName("th")[2];
    final rawDate = th.text.split("\n")[1];
    final day = int.parse(rawDate.split(" ")[0]);
    final month = fromRomanMoth(rawDate.split(" ")[1]);

    final now = DateTime.now();
    final year = now.month >= month ? now.year : now.year - 1;

    return DateTime(year, month, day).millisecondsSinceEpoch;
  }

  int fromRomanMoth(String romanMonth) {
    switch (romanMonth) {
      case "I":
        return 1;
      case "II":
        return 2;
      case "III":
        return 3;
      case "IV":
        return 4;
      case "V":
        return 5;
      case "VI":
        return 6;
      case "VII":
        return 7;
      case "VIII":
        return 8;
      case "IX":
        return 9;
      case "X":
        return 10;
      case "XI":
        return 11;
      case "XII":
        return 12;
      default:
        throw Exception("Unknown roman month $romanMonth");
    }
  }
}
