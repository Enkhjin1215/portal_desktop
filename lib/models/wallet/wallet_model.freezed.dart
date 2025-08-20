// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Wallet _$WalletFromJson(Map<String, dynamic> json) {
  return _wallet.fromJson(json);
}

/// @nodoc
mixin _$Wallet {
  @JsonKey(name: '_id')
  String get id =>
      throw _privateConstructorUsedError; // Map the _id JSON field to the id property
  int get available => throw _privateConstructorUsedError;
  int get pending => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Wallet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletCopyWith<Wallet> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletCopyWith<$Res> {
  factory $WalletCopyWith(Wallet value, $Res Function(Wallet) then) =
      _$WalletCopyWithImpl<$Res, Wallet>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      int available,
      int pending,
      int total,
      bool isDeleted,
      String type,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$WalletCopyWithImpl<$Res, $Val extends Wallet>
    implements $WalletCopyWith<$Res> {
  _$WalletCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? available = null,
    Object? pending = null,
    Object? total = null,
    Object? isDeleted = null,
    Object? type = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as int,
      pending: null == pending
          ? _value.pending
          : pending // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$walletImplCopyWith<$Res> implements $WalletCopyWith<$Res> {
  factory _$$walletImplCopyWith(
          _$walletImpl value, $Res Function(_$walletImpl) then) =
      __$$walletImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      int available,
      int pending,
      int total,
      bool isDeleted,
      String type,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$walletImplCopyWithImpl<$Res>
    extends _$WalletCopyWithImpl<$Res, _$walletImpl>
    implements _$$walletImplCopyWith<$Res> {
  __$$walletImplCopyWithImpl(
      _$walletImpl _value, $Res Function(_$walletImpl) _then)
      : super(_value, _then);

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? available = null,
    Object? pending = null,
    Object? total = null,
    Object? isDeleted = null,
    Object? type = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$walletImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as int,
      pending: null == pending
          ? _value.pending
          : pending // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$walletImpl with DiagnosticableTreeMixin implements _wallet {
  const _$walletImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.available,
      required this.pending,
      required this.total,
      required this.isDeleted,
      required this.type,
      this.createdAt,
      this.updatedAt});

  factory _$walletImpl.fromJson(Map<String, dynamic> json) =>
      _$$walletImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
// Map the _id JSON field to the id property
  @override
  final int available;
  @override
  final int pending;
  @override
  final int total;
  @override
  final bool isDeleted;
  @override
  final String type;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Wallet(id: $id, available: $available, pending: $pending, total: $total, isDeleted: $isDeleted, type: $type, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Wallet'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('available', available))
      ..add(DiagnosticsProperty('pending', pending))
      ..add(DiagnosticsProperty('total', total))
      ..add(DiagnosticsProperty('isDeleted', isDeleted))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$walletImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.available, available) ||
                other.available == available) &&
            (identical(other.pending, pending) || other.pending == pending) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, available, pending, total,
      isDeleted, type, createdAt, updatedAt);

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$walletImplCopyWith<_$walletImpl> get copyWith =>
      __$$walletImplCopyWithImpl<_$walletImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$walletImplToJson(
      this,
    );
  }
}

abstract class _wallet implements Wallet {
  const factory _wallet(
      {@JsonKey(name: '_id') required final String id,
      required final int available,
      required final int pending,
      required final int total,
      required final bool isDeleted,
      required final String type,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$walletImpl;

  factory _wallet.fromJson(Map<String, dynamic> json) = _$walletImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id; // Map the _id JSON field to the id property
  @override
  int get available;
  @override
  int get pending;
  @override
  int get total;
  @override
  bool get isDeleted;
  @override
  String get type;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$walletImplCopyWith<_$walletImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
