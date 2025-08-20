import 'dart:convert';

import 'package:portal/service/api_list.dart';
import 'package:portal/service/web_service.dart';

class TicketModel {
  List<EventMetas>? eventMetas;
  String? sId;
  String? username;
  List<Tickets>? tickets;

  TicketModel({this.eventMetas, this.sId, this.username, this.tickets});

  TicketModel.fromJson(Map<String, dynamic> json) {
    if (json['eventMetas'] != null) {
      eventMetas = <EventMetas>[];
      json['eventMetas'].forEach((v) {
        eventMetas!.add(EventMetas.fromJson(v));
      });
    }
    sId = json['_id'];
    username = json['username'];
    if (json['tickets'] != null) {
      tickets = <Tickets>[];
      json['tickets'].forEach((v) {
        tickets!.add(Tickets.fromJson(v));
      });
    }
  }
}

class EventMetas {
  String? sId;
  String? name;
  String? coverImage;
  String? coverImageV;
  String? startDate;
  Location? location;
  String? endDate;

  EventMetas({this.sId, this.name, this.coverImage, this.coverImageV, this.startDate, this.location, this.endDate});

  EventMetas.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    coverImage = json['cover_image'];
    coverImageV = json['cover_image_v'];
    startDate = json['startDate'];
    location = json['location'] != null ? new Location.fromJson(json['location']) : null;
    endDate = json['endDate'] ?? "";
  }
}

class Location {
  String? name;
  String? description;
  String? hallPlan;
  String? link;

  Location({this.name, this.description, this.hallPlan, this.link});

  Location.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    hallPlan = json['hall_plan'];
    link = json['link'];
  }
}

class Tickets {
  String? sId;
  String? eventId;
  String? ownerId;
  TemplateId? templateId;
  String? type;
  bool? isUsed;
  bool? isListed;
  bool? isDivided;
  String? createdAt;
  String? qrText;
  String? id;
  String? seatId;

  Tickets(
      {this.sId,
      this.eventId,
      this.ownerId,
      this.templateId,
      this.type,
      this.isUsed,
      this.createdAt,
      this.isDivided,
      this.qrText,
      this.id,
      this.seatId});

  Tickets.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    eventId = json['eventId'];
    ownerId = json['ownerId'];
    templateId = json['templateId'] != null ? TemplateId.fromJson(json['templateId']) : null;
    type = json['type'];
    isUsed = json['isUsed'];
    createdAt = json['createdAt'];
    qrText = json['qrText'];
    id = json['id'];
    seatId = json['seatId'] ?? "";
    isListed = json['isListed'] ?? false;
    isDivided = json['isDivided'];
  }
}

class TemplateId {
  String? sId;
  String? name;
  String? id;
  int? seatCnt;

  TemplateId({this.sId, this.name, this.id, this.seatCnt});

  TemplateId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    id = json['id'];
    seatCnt = json['seat_cnt'];
  }
}

class TicketList {
  TicketModel? item;

  TicketList({this.item});

  factory TicketList.fromJson(Map<String, dynamic> json) {
    TicketModel? item = TicketModel.fromJson(json);
    return TicketList(item: item);
  }

  static Resource<TicketList> get ticketList {
    return Resource(
        url: APILIST.ticketList,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          TicketList mTicketModel = TicketList.fromJson(result);
          return mTicketModel;
        });
  }
}
