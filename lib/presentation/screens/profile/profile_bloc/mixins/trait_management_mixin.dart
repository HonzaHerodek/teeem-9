import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../core/errors/app_exception.dart';
import '../../../../../data/models/traits/user_trait_model.dart';
import '../../../../../domain/repositories/trait_repository.dart';
import '../../../../../domain/repositories/user_repository.dart';
import '../profile_event.dart';
import '../profile_state.dart';

mixin TraitManagementMixin on Bloc<ProfileEvent, ProfileState> {
  UserRepository get userRepository;
  final TraitRepository _traitRepository = GetIt.instance<TraitRepository>();

  Future<void> handleTraitAdded(
    ProfileTraitAdded event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.user == null) {
      emit(state.copyWith(
        error: 'User not found',
        isLoading: false,
      ));
      return;
    }

    try {
      print('TraitManagementMixin - Adding trait for user: ${state.user!.id}'); // Debug log
      emit(state.copyWith(isLoading: true));

      // Add trait using trait repository
      final trait = await _traitRepository.addUserTrait(
        userId: state.user!.id,
        traitTypeId: event.trait.traitTypeId,
        value: event.trait.value,
      );

      print('TraitManagementMixin - Trait added: ${trait.value}'); // Debug log

      // Refresh user data to get updated traits
      final updatedUser = await userRepository.getUserById(state.user!.id);
      if (updatedUser != null) {
        print('TraitManagementMixin - Updated user traits count: ${updatedUser.traits.length}'); // Debug log
        
        // Update state with new user data
        emit(state.copyWith(
          user: updatedUser,
          error: null,
          isLoading: false,
        ));

        // Trigger a profile refresh to ensure all data is in sync
        add(const ProfileRefreshed());
      }
    } catch (e) {
      print('TraitManagementMixin - Error adding trait: $e'); // Debug log
      emit(state.copyWith(
        error: e is AppException ? e.message : 'Failed to add trait',
        isLoading: false,
      ));
    }
  }
}
