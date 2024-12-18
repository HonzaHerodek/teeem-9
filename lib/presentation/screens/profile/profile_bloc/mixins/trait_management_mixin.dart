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
      ));
      return;
    }

    try {
      print('[TraitManagementMixin] Starting trait addition');
      print('[TraitManagementMixin] New trait: ${event.trait.category}:${event.trait.name}:${event.trait.value}');
      print('[TraitManagementMixin] Current traits: ${state.user!.traits.map((t) => '${t.category}:${t.name}:${t.value}')}');
      
      // Validate trait
      if (state.user!.traits.any((t) => 
        t.id == event.trait.id && 
        t.category == event.trait.category &&
        t.name == event.trait.name)) {
        emit(state.copyWith(
          error: 'Trait already exists',
        ));
        return;
      }
      
      // Set loading state
      emit(state.copyWith(
        isLoading: true,
        error: null,
      ));

      // Create updated user with new trait
      final updatedTraits = [...state.user!.traits, event.trait];
      
      // Sort traits by category and display order
      updatedTraits.sort((a, b) {
        final categoryCompare = a.category.compareTo(b.category);
        if (categoryCompare != 0) return categoryCompare;
        return a.displayOrder.compareTo(b.displayOrder);
      });
      
      final updatedUser = state.user!.copyWith(traits: updatedTraits);
      print('[TraitManagementMixin] Updated user traits before repository update: ${updatedUser.traits.map((t) => '${t.category}:${t.name}:${t.value}')}');

      // Update repository
      print('[TraitManagementMixin] Updating repository with new trait');
      await userRepository.updateUser(updatedUser);
      
      print('[TraitManagementMixin] Updated repository, fetching fresh data');

      // Fetch fresh user data to ensure consistency
      final refreshedUser = await userRepository.getCurrentUser();
      if (refreshedUser == null) {
        throw AppException('Failed to refresh user data');
      }

      print('[TraitManagementMixin] Refreshed user traits: ${refreshedUser.traits.map((t) => '${t.category}:${t.name}:${t.value}')}');

      // Verify the trait was added
      final traitExists = refreshedUser.traits.any((t) => 
        t.id == event.trait.id && 
        t.name == event.trait.name && 
        t.value == event.trait.value
      );

      if (!traitExists) {
        throw AppException('Failed to verify trait addition');
      }

      // Force a state update with the refreshed data
      emit(state.copyWith(isLoading: false));
      emit(state.copyWith(
        user: refreshedUser,
        error: null,
      ));

      print('[TraitManagementMixin] Final state update complete');
      print('[TraitManagementMixin] Final traits count: ${refreshedUser.traits.length}');
      print('[TraitManagementMixin] Final traits: ${refreshedUser.traits.map((t) => '${t.category}:${t.name}:${t.value}')}');

    } catch (e) {
      print('[TraitManagementMixin] Error adding trait: $e');
      
      // Revert to original state on error
      emit(state.copyWith(
        isLoading: false,
        error: e is AppException ? e.message : 'Failed to add trait',
        user: state.user, // Ensure we keep the original user state
      ));

      // Re-throw to ensure the error is propagated
      rethrow;
    }
  }
}
