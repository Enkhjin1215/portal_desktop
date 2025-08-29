import 'dart:convert';

import 'package:portal/service/api_list.dart';
import 'package:portal/service/web_service.dart';

class Location {
  String? name;
  String? desc;
  String? hallPlan;
  var lng;
  var lat;

  Location({this.name, this.desc, this.hallPlan, this.lng, this.lat});

  Location.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    desc = json['description'];
    hallPlan = json['hall_plan'];
    lng = json['longitude'];
    lat = json['latitude'];
  }
}

class EventModel {
  String? id;
  String? name;
  dynamic desc;
  String? startDate;
  Location? location;
  String? coverImage;
  dynamic? descEn;
  DateTime? date;
  List<dynamic>? tags;

  EventModel({this.id, this.name, this.desc, this.startDate, this.location, this.coverImage, this.descEn, this.date, this.tags});

  factory EventModel.fromJson(Map<String, dynamic> json) {
    DateTime dateTime = DateTime.parse(json['startDate']);
    Location loc = Location.fromJson(json['location']);
    return EventModel(
        id: json['_id'],
        name: json['name'],
        desc: json['description'],
        startDate: json['startDate'],
        location: loc,
        coverImage: json['cover_image'],
        descEn: json['description_en'],
        tags: json['tags'],
        date: dateTime);
  }
  static Resource<List<EventModel>> get eventList {
    return Resource(
        url: APILIST.eventList,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          Iterable list = result;
          List<EventModel> eventList = list.map((data) => EventModel.fromJson(data)).toList();
          return eventList;
        });
  }
}

// class Events {
//   String? id;
//   List<EventModel>? events;
//   int? count;

//   Events({this.id, this.count, this.events});

//   factory Events.fromJson(Map<String, dynamic> json) {
//     Iterable rawList = json['events'];
//     List<EventModel> list = rawList.map((data) => EventModel.fromJson(data)).toList();
//     return Events(id: json['_id'], count: json['count'], events: list);
//   }

// }
