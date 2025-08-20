import 'dart:convert';

import 'package:portal/models/event_model.dart';
import 'package:portal/service/api_list.dart';
import 'package:portal/service/web_service.dart';

enum PaymentMethod { qpay, hipay, monpay, monpayqr, simple, mcredit, socialpay, tdbm }

class Price {
  int? amt;
  String? currency;
  Price({this.amt, this.currency});
  Price.fromJson(Map<String, dynamic> json) {
    amt = json['amount'];
    currency = json['currency'];
  }
}

class Ticket {
  String? id;
  String? eventId;
  String? type;
  bool? isSeat;
  bool? isHighDemand;
  String? name;
  String? nameEn;
  String? desc;
  String? descEn;
  Price? sellPrice;
  int? total;
  int? avl;
  int? sold;
  int? royalty;
  String? startDate;
  String? endDate;
  bool? isHidden;
  bool? isDeleted;
  List<dynamic> acceptablePaymentMethod;
  List<dynamic> seats;
  List<dynamic>? hideSoldNumbers;
  Price? actualPrice;
  String? color;

  Ticket(
      {this.id,
      this.eventId,
      this.type,
      this.isSeat,
      this.isHighDemand,
      this.name,
      this.nameEn,
      this.desc,
      this.descEn,
      this.sellPrice,
      this.total,
      this.avl,
      this.sold,
      this.royalty,
      this.startDate,
      this.endDate,
      this.isHidden,
      this.actualPrice,
      this.isDeleted,
      this.color,
      required this.seats,
      required this.acceptablePaymentMethod,
      this.hideSoldNumbers});
  factory Ticket.fromJson(Map<String, dynamic> json) {
    Price price = Price.fromJson(json['sellPrice']);
    Price? actualPrice;
    if (json['actualPrice'] != null) {
      actualPrice = Price.fromJson(json['actualPrice']);
    }
    List<String> acceptablePaymentMethods = [];
    List<String> seatsRaw = [];

    return Ticket(
        id: json['_id'],
        eventId: json['eventId'],
        type: json['type'],
        isSeat: json['isSeat'],
        isHighDemand: json['isHighDemand'],
        name: json['name'],
        nameEn: json['name_en'],
        desc: json['description'],
        descEn: json['description_en'],
        sellPrice: price,
        total: json['total'],
        avl: json['available'],
        sold: json['sold_cnt'],
        royalty: json['royalty'],
        startDate: json['startDate'],
        endDate: json['endDate'],
        isHidden: json['isHidden'],
        color: json['color'],
        isDeleted: json['isDeleted'],
        hideSoldNumbers: json['hideSoldNumber'],
        seats: json['seatIds'] ?? seatsRaw,
        actualPrice: actualPrice,
        acceptablePaymentMethod: json['acceptablePaymentMethods'] ?? acceptablePaymentMethods);
  }
}

class EventDuration {
  int? day;
  int? hour;
  int? min;
  EventDuration({this.day, this.hour, this.min});
  EventDuration.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    hour = json['hour'];
    min = json['min'];
  }
}

class Socials {
  String? type;
  String? link;

  Socials({this.type, this.link});
  Socials.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    link = json['link'];
  }
}

class Collaborate {
  String? role;
  String? username;
  String? displayName;
  String? profileImage;
  List<Socials>? socials;
  Collaborate({this.role, this.username, this.displayName, this.profileImage, this.socials});

  factory Collaborate.fromJson(Map<String, dynamic> json) {
    Iterable rawSocials = json['userId']['socials'] ?? [];
    List<Socials> socialList = rawSocials.isEmpty ? [] : rawSocials.map((data) => Socials.fromJson(data)).toList();

    return Collaborate(
        role: json['role'],
        username: json['userId']['username'],
        displayName: json['userId']['display_name'],
        profileImage: json['userId']['profile_image'],
        socials: socialList);
  }
}

class Sponsore {
  String? role;
  String? username;
  String? displayName;
  String? profileImage;
  Sponsore({this.role, this.username, this.displayName, this.profileImage});
  Sponsore.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    username = json['userId']['username'];
    displayName = json['userId']['display_name'];
    profileImage = json['userId']['profile_image'];
  }
}

class EventDetail {
  String? id;
  String? name;
  dynamic description;
  dynamic descriptionEn;
  String? coverImage;
  String? featurePhoto;
  String? startDate;
  Location? location;
  EventDuration? eventDuration;
  List<Collaborate>? collaborateList;
  List<Sponsore>? sponsoreList;
  DateTime? date;
  List<Ticket>? tickets;
  List<dynamic> acceptablePaymentMethod;
  List<dynamic>? ebarimt;
  EventDetail({
    this.id,
    this.name,
    this.description,
    this.descriptionEn,
    this.coverImage,
    this.startDate,
    this.location,
    this.eventDuration,
    this.collaborateList,
    this.sponsoreList,
    this.date,
    this.tickets,
    this.featurePhoto,
    this.ebarimt,
    required this.acceptablePaymentMethod,
  });
  factory EventDetail.fromJson(Map<String, dynamic> json) {
    DateTime dateTime = DateTime.parse(json['startDate']).toLocal();
    Location loc = Location.fromJson(json['location']);
    EventDuration eventDuration = json['duration'] == null ? EventDuration() : EventDuration.fromJson(json['duration']);
    Iterable rawCollabList = json['collaboratedBy'];
    Iterable rawSponsorList = json['sponsoredBy'];
    Iterable rawTickets = json['ticketTemplates'];

    List<Collaborate> listCol = rawCollabList.map((data) => Collaborate.fromJson(data)).toList();
    List<Sponsore> listSpo = rawSponsorList.map((data) => Sponsore.fromJson(data)).toList();
    List<Ticket> tickets = [];

    tickets = rawTickets.map((data) => Ticket.fromJson(data)).toList();
    tickets.removeWhere((item) => (item.isHidden ?? false) || (item.isDeleted ?? false));

    List<dynamic> methods = [];
    return EventDetail(
        id: json['_id'],
        name: json['name'],
        description: json['description'],
        descriptionEn: json['description_en'],
        coverImage: json['cover_image'],
        featurePhoto: json['cover_image_v'],
        startDate: json['startDate'],
        location: loc,
        date: dateTime,
        eventDuration: eventDuration,
        collaborateList: listCol,
        sponsoreList: listSpo,
        tickets: tickets,
        acceptablePaymentMethod: json['acceptablePaymentMethods'] ?? methods,
        ebarimt: json['ebarimt']);
  }
  static Resource<EventDetail> get eventDetail {
    return Resource(
        url: APILIST.eventDetail,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          EventDetail detail = EventDetail.fromJson(result);
          return detail;
        });
  }
}
