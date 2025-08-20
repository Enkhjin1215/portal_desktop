import 'dart:convert';

import 'package:portal/service/api_list.dart';
import 'package:portal/service/web_service.dart';

class CounterEvent {
  String? id;
  String? name;
  String? image;
  String? endDate;
  CounterEvent({this.id, this.name, this.image, this.endDate});
  factory CounterEvent.fromJson(Map<String, dynamic> json) {
    return CounterEvent(id: json['_id'], name: json['name'], image: json['banner_image_url'], endDate: json['endDate']);
  }
  static Resource<List<CounterEvent>> get getTournaments {
    return Resource(
        url: APILIST.csox,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          Iterable list = result;
          List<CounterEvent> finalList = list.map((e) => CounterEvent.fromJson(e)).toList();
          return finalList;
        });
  }
}
