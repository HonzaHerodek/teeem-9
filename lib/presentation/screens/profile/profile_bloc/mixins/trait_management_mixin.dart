import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/app_exception.dart';
import '../../../../../data/models/trait_model.dart';
import '../profile_event.dart';
import '../profile_state.dart';
import '../../../../../domain/repositories/user_repository.dart';

mixin TraitManagementMixin on Bloc<ProfileEvent, ProfileState> {
  UserRepository get userRepository;

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
      // Create updated user with new trait
      final updatedTraits = [...state.user!.traits, event.trait];
      final updatedUser = state.user!.copyWith(traits: updatedTraits);

      // Update user in repository
      await userRepository.updateUser(updatedUser);

      // Update state with new user data
      emit(state.copyWith(
        user: updatedUser,
        error: null,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e is AppException ? e.message : 'Failed to add trait',
        isLoading: false,
      ));
    }
  }
}
