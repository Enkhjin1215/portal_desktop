import 'dart:convert';

import 'package:portal/service/api_list.dart';
import 'package:portal/service/web_service.dart';

class EventChildren {
  String? id;
  String? startDate;
  EventChildren({this.id, this.startDate});
  EventChildren.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    startDate = json['startDate'];
  }
  static Resource<List<EventChildren>> get eventList {
    return Resource(
        url: APILIST.eventChildren,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          Iterable list = result;
          List<EventChildren> eventList = list.map((data) => EventChildren.fromJson(data)).toList();
          return eventList;
        });
  }
}
