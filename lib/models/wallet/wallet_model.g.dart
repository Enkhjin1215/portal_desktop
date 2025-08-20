// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$walletImpl _$$walletImplFromJson(Map<String, dynamic> json) => _$walletImpl(
      id: json['_id'] as String,
      available: (json['available'] as num).toInt(),
      pending: (json['pending'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      isDeleted: json['isDeleted'] as bool,
      type: json['type'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$walletImplToJson(_$walletImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'available': instance.available,
      'pending': instance.pending,
      'total': instance.total,
      'isDeleted': instance.isDeleted,
      'type': instance.type,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
