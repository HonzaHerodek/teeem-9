import 'package:flutter/foundation.dart';
import '../../../data/models/traits/trait_type_model.dart';

@immutable
abstract class TraitsEvent {
  const TraitsEvent();
}

class LoadTraits extends TraitsEvent {
  final String userId;
  
  const LoadTraits(this.userId);
}

class AddTrait extends TraitsEvent {
  final String userId;
  final TraitTypeModel traitType;
  final String value;
  
  const AddTrait({
    required this.userId,
    required this.traitType,
    required this.value,
  });
}

class RemoveTrait extends TraitsEvent {
  final String userId;
  final String traitId;
  
  const RemoveTrait({
    required this.userId,
    required this.traitId,
  });
}

class UpdateTraitOrder extends TraitsEvent {
  final String userId;
  final List<String> traitIds;
  
  const UpdateTraitOrder({
    required this.userId,
    required this.traitIds,
  });
}
