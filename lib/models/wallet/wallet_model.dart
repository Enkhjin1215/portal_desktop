import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'wallet_model.freezed.dart';
part 'wallet_model.g.dart';

@freezed
class Wallet with _$Wallet {
  const factory Wallet({
    @JsonKey(name: '_id') required String id, // Map the _id JSON field to the id property
    required int available,
    required int pending,
    required int total,
    required bool isDeleted,
    required String type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _wallet;

  factory Wallet.fromJson(Map<String, Object?> json) => _$WalletFromJson(json);
}
