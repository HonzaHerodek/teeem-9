import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_trait_model.g.dart';

@immutable
@JsonSerializable()
class UserTraitModel {
  final String id;
  @JsonKey(name: 'trait_type_id')
  final String traitTypeId;
  final String value;
  @JsonKey(defaultValue: 0)
  final int displayOrder;

  const UserTraitModel({
    required this.id,
    required this.traitTypeId,
    required this.value,
    required this.displayOrder,
  });

  factory UserTraitModel.fromJson(Map<String, dynamic> json) =>
      _$UserTraitModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserTraitModelToJson(this);

  UserTraitModel copyWith({
    String? id,
    String? traitTypeId,
    String? value,
    int? displayOrder,
  }) {
    return UserTraitModel(
      id: id ?? this.id,
      traitTypeId: traitTypeId ?? this.traitTypeId,
      value: value ?? this.value,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserTraitModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          traitTypeId == other.traitTypeId &&
          value == other.value &&
          displayOrder == displayOrder;

  @override
  int get hashCode =>
      id.hashCode ^
      traitTypeId.hashCode ^
      value.hashCode ^
      displayOrder.hashCode;
}
