import 'package:flutter/foundation.dart';
import '../../../data/models/traits/trait_type_model.dart';
import '../../../data/models/traits/user_trait_model.dart';

@immutable
abstract class TraitsState {
  const TraitsState();
}

class TraitsInitial extends TraitsState {
  const TraitsInitial();
}

class TraitsLoading extends TraitsState {
  const TraitsLoading();
}

class TraitsLoaded extends TraitsState {
  final List<TraitTypeModel> traitTypes;
  final List<UserTraitModel> userTraits;
  
  const TraitsLoaded({
    required this.traitTypes,
    required this.userTraits,
  });
}

class TraitAdded extends TraitsState {
  final UserTraitModel trait;
  
  const TraitAdded(this.trait);
}

class TraitRemoved extends TraitsState {
  final String traitId;
  
  const TraitRemoved(this.traitId);
}

class TraitsError extends TraitsState {
  final String message;
  
  const TraitsError(this.message);
}
