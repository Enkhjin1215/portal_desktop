import 'dart:convert';

import 'package:portal/service/api_list.dart';
import 'package:portal/service/web_service.dart';

class EventImage {
  String? coverImage;
  String? id;
  EventImage({this.coverImage, this.id});
  factory EventImage.fromJson(Map<String, dynamic> json) {
    return EventImage(coverImage: json['cover_image_v'], id: json['_id']);
  }
  static Resource<List<EventImage>> get getImages {
    return Resource(
        url: APILIST.featuredImage,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          Iterable list = result['events'] ?? result['list'];
          List<EventImage> images = list.map((e) => EventImage.fromJson(e)).toList();
          return images;
        });
  }
}
