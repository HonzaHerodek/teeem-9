import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/traits/trait_type_model.dart';
import '../../../data/models/traits/user_trait_model.dart';
import '../../../domain/repositories/trait_repository.dart';
import 'traits_event.dart';
import 'traits_state.dart';

class TraitsBloc extends Bloc<TraitsEvent, TraitsState> {
  final TraitRepository _traitRepository;

  TraitsBloc(this._traitRepository) : super(const TraitsInitial()) {
    on<LoadTraits>(_onLoadTraits);
    on<AddTrait>(_onAddTrait);
    on<RemoveTrait>(_onRemoveTrait);
    on<UpdateTraitOrder>(_onUpdateTraitOrder);
  }

  Future<void> _onLoadTraits(LoadTraits event, Emitter<TraitsState> emit) async {
    try {
      emit(const TraitsLoading());
      
      // Load both trait types and user traits concurrently
      // Load trait types and user traits concurrently with proper typing
      final results = await Future.wait<List<dynamic>>([
        _traitRepository.getTraitTypes(),
        _traitRepository.getUserTraits(event.userId),
      ]);
      
      emit(TraitsLoaded(
        traitTypes: results[0] as List<TraitTypeModel>,
        userTraits: results[1] as List<UserTraitModel>,
      ));
    } catch (e) {
      emit(TraitsError(e.toString()));
    }
  }

  Future<void> _onAddTrait(AddTrait event, Emitter<TraitsState> emit) async {
    if (state is! TraitsLoaded) {
      return; // Only allow adding traits when in loaded state
    }

    final currentState = state as TraitsLoaded;
    
    try {
      print('TraitsBloc - Adding trait - Type: ${event.traitType.name}, Value: ${event.value}'); // Debug log
      
      // Add the trait
      final trait = await _traitRepository.addUserTrait(
        userId: event.userId,
        traitTypeId: event.traitType.id,
        value: event.value,
      );

      print('TraitsBloc - Trait added successfully: ${trait.id}'); // Debug log

      // Get updated user traits
      final updatedUserTraits = await _traitRepository.getUserTraits(event.userId);
      
      print('TraitsBloc - Loaded ${updatedUserTraits.length} user traits after addition'); // Debug log
      
      // Emit single updated state
      emit(TraitsLoaded(
        traitTypes: currentState.traitTypes,
        userTraits: updatedUserTraits,
      ));
    } catch (e) {
      print('Error adding trait: $e'); // Debug log
      emit(TraitsError(e.toString()));
      // Restore previous state after error
      emit(currentState);
    }
  }

  Future<void> _onRemoveTrait(RemoveTrait event, Emitter<TraitsState> emit) async {
    try {
      await _traitRepository.removeUserTrait(
        userId: event.userId,
        traitId: event.traitId,
      );
      
      // Emit removed state first
      emit(TraitRemoved(event.traitId));
      
      // Then reload all traits to get updated list
      add(LoadTraits(event.userId));
    } catch (e) {
      emit(TraitsError(e.toString()));
    }
  }

  Future<void> _onUpdateTraitOrder(UpdateTraitOrder event, Emitter<TraitsState> emit) async {
    try {
      await _traitRepository.updateTraitOrder(
        userId: event.userId,
        traitIds: event.traitIds,
      );
      
      // Reload traits to get updated order
      add(LoadTraits(event.userId));
    } catch (e) {
      emit(TraitsError(e.toString()));
    }
  }
}
