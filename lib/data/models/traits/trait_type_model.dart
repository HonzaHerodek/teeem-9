import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trait_type_model.g.dart';

@immutable
@JsonSerializable()
class TraitTypeModel {
  final String id;
  final String name;
  @JsonKey(name: 'icon_data')
  final String iconData;
  final String category;
  @JsonKey(defaultValue: [])
  final List<String> possibleValues;
  @JsonKey(defaultValue: 0)
  final int displayOrder;

  const TraitTypeModel({
    required this.id,
    required this.name,
    required this.iconData,
    required this.category,
    required this.possibleValues,
    required this.displayOrder,
  });

  factory TraitTypeModel.fromJson(Map<String, dynamic> json) =>
      _$TraitTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$TraitTypeModelToJson(this);

  TraitTypeModel copyWith({
    String? id,
    String? name,
    String? iconData,
    String? category,
    List<String>? possibleValues,
    int? displayOrder,
  }) {
    return TraitTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconData: iconData ?? this.iconData,
      category: category ?? this.category,
      possibleValues: possibleValues ?? this.possibleValues,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TraitTypeModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          iconData == other.iconData &&
          category == category &&
          possibleValues == possibleValues &&
          displayOrder == displayOrder;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      iconData.hashCode ^
      category.hashCode ^
      possibleValues.hashCode ^
      displayOrder.hashCode;
}
