import 'dart:convert';

import 'package:portal/service/api_list.dart';
import 'package:portal/service/web_service.dart';

class SteamUser {
  final String steamid;
  final int communityVisibilityState;
  final int profileState;
  final String personaName;
  final int commentPermission;
  final String profileUrl;
  final String avatar;
  final String avatarMedium;
  final String avatarFull;
  final String avatarHash;
  final int personaState;
  final String? realName;
  final String primaryClanId;
  final int timeCreated;
  final int personaStateFlags;
  final String? locCountryCode;
  final String? locStateCode;

  SteamUser({
    required this.steamid,
    required this.communityVisibilityState,
    required this.profileState,
    required this.personaName,
    required this.commentPermission,
    required this.profileUrl,
    required this.avatar,
    required this.avatarMedium,
    required this.avatarFull,
    required this.avatarHash,
    required this.personaState,
    this.realName,
    required this.primaryClanId,
    required this.timeCreated,
    required this.personaStateFlags,
    this.locCountryCode,
    this.locStateCode,
  });

  factory SteamUser.fromJson(Map<String, dynamic> json) {
    return SteamUser(
      steamid: json['steamid'],
      communityVisibilityState: json['communityvisibilitystate'],
      profileState: json['profilestate'],
      personaName: json['personaname'],
      commentPermission: json['commentpermission'],
      profileUrl: json['profileurl'],
      avatar: json['avatar'],
      avatarMedium: json['avatarmedium'],
      avatarFull: json['avatarfull'],
      avatarHash: json['avatarhash'],
      personaState: json['personastate'],
      realName: json['realname'],
      primaryClanId: json['primaryclanid'],
      timeCreated: json['timecreated'],
      personaStateFlags: json['personastateflags'],
      locCountryCode: json['loccountrycode'],
      locStateCode: json['locstatecode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steamid': steamid,
      'communityvisibilitystate': communityVisibilityState,
      'profilestate': profileState,
      'personaname': personaName,
      'commentpermission': commentPermission,
      'profileurl': profileUrl,
      'avatar': avatar,
      'avatarmedium': avatarMedium,
      'avatarfull': avatarFull,
      'avatarhash': avatarHash,
      'personastate': personaState,
      'realname': realName,
      'primaryclanid': primaryClanId,
      'timecreated': timeCreated,
      'personastateflags': personaStateFlags,
      'loccountrycode': locCountryCode,
      'locstatecode': locStateCode,
    };
  }

  static Resource<SteamUser> get steamCheckAcc {
    return Resource(
        url: APILIST.steamCheckAccount,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          SteamUser mTicketModel = SteamUser.fromJson(result);
          return mTicketModel;
        });
  }
}
