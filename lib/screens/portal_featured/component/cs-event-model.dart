import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:portal/service/api_list.dart';
import 'package:portal/service/web_service.dart';

class CSGOCase {
  String? id;
  String? name;
  String? bannerImageUrl;
  String? bannerImageUrlV;
  bool? openFree;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;
  int? v;
  List<CSGOItem>? templates;

  CSGOCase({
    this.id,
    this.name,
    this.bannerImageUrl,
    this.bannerImageUrlV,
    this.openFree,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.templates,
  });

  factory CSGOCase.fromJson(Map<String, dynamic> json) {
    return CSGOCase(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      bannerImageUrl: json['banner_image_url'],
      bannerImageUrlV: json['banner_image_url_v'],
      openFree: json['openFree'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      templates: json['templates'] != null ? List<CSGOItem>.from(json['templates'].map((x) => CSGOItem.fromJson(x))) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['banner_image_url'] = bannerImageUrl;
    data['banner_image_url_v'] = bannerImageUrlV;
    data['openFree'] = openFree;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    if (templates != null) {
      data['templates'] = templates!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    return data;
  }

  static Resource<CSGOCase> get getCase {
    return Resource(
        url: APILIST.csox,
        parse: (response) {
          final result = json.decode(utf8.decode(response.bodyBytes));
          CSGOCase case1 = CSGOCase.fromJson(result);
          return case1;
        });
  }

  // Helper method to check if case is currently active
  bool get isActive {
    if (startDate == null || endDate == null) return false;

    final now = DateTime.now();
    final start = DateTime.parse(startDate!);
    final end = DateTime.parse(endDate!);

    return now.isAfter(start) && now.isBefore(end);
  }

  // Helper method to get total available items
  int get totalAvailableItems {
    if (templates == null) return 0;
    return templates!.fold(0, (sum, item) => sum + (item.available ?? 0));
  }

  // Helper method to get total items
  int get totalItems {
    if (templates == null) return 0;
    return templates!.fold(0, (sum, item) => sum + (item.total ?? 0));
  }
}

class CSGOItem {
  String? id;
  String? csId;
  String? type;
  String? name;
  String? imageUrl;
  int? available;
  int? total;
  String? createdAt;
  String? updatedAt;

  CSGOItem({
    this.id,
    this.csId,
    this.type,
    this.name,
    this.imageUrl,
    this.available,
    this.total,
    this.createdAt,
    this.updatedAt,
  });

  factory CSGOItem.fromJson(Map<String, dynamic> json) {
    return CSGOItem(
      id: json['_id'],
      csId: json['csId'],
      type: json['type'],
      name: json['name'],
      imageUrl: json['image_url'],
      available: json['available'] ?? 0,
      total: json['total'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['csId'] = csId;
    data['type'] = type;
    data['name'] = name;
    data['image_url'] = imageUrl;
    data['available'] = available;
    data['total'] = total;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  // Helper method to check if item is available
  bool get isAvailable => (available ?? 0) > 0;

  // Helper method to get availability percentage
  double get availabilityPercentage {
    if (total == null || total == 0) return 0.0;
    return ((available ?? 0) / total!) * 100;
  }

  // Helper method to get rarity color based on type
  Color get rarityColor {
    switch (type?.toLowerCase()) {
      case 'common':
        return const Color(0xFFb0c3d9); // Light Blue
      case 'industrial':
        return const Color(0xFF5e98d9); // Blue
      case 'mil-spec':
        return const Color(0xFF4b69ff); // Dark Blue
      case 'restricted':
        return const Color(0xFF8847ff); // Purple
      case 'classified':
        return const Color(0xFFd32ce6); // Pink
      case 'covert':
        return const Color(0xFFeb4b4b); // Red
      case 'rare special item':
        return const Color(0xFFFFD700); // Gold
      default:
        return const Color(0xFFb0c3d9); // Default to common
    }
  }

  // Helper method to get readable rarity name
  String get rarityName {
    switch (type?.toLowerCase()) {
      case 'common':
        return 'Consumer Grade';
      case 'uncommon':
        return 'Industrial Grade';
      case 'rare':
        return 'Mil-Spec';
      case 'epic':
        return 'Restricted';
      case 'legendary':
        return 'Classified';
      case 'mythical':
        return 'Covert';
      case 'exceedingly_rare':
        return 'Exceedingly Rare';
      default:
        return 'Unknown';
    }
  }
}
