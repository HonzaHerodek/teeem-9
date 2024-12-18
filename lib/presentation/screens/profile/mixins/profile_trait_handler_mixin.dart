import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../profile_bloc/profile_bloc.dart';
import '../profile_bloc/profile_event.dart';
import '../../../../data/models/trait_model.dart';
import 'profile_trait_state_mixin.dart';

/// Handles UI operations for trait management
mixin ProfileTraitHandlerMixin<T extends StatefulWidget> on State<T>, ProfileTraitStateMixin<T> {
  Future<void> handleTraitAdded(BuildContext context, TraitModel trait) async {
    // Prevent multiple simultaneous trait additions
    if (isProcessingTrait) {
      print('[ProfileTraitHandler] Already processing a trait, ignoring');
      return;
    }

    startTraitOperation();
    final completer = Completer<void>();
    
    try {
      print('[ProfileTraitHandler] Starting trait addition: ${trait.category}:${trait.name}:${trait.value}');
      
      // Setup state listener before adding trait
      await listenToTraitUpdates(context, trait, completer);

      // Add the trait after setting up listener
      print('[ProfileTraitHandler] Dispatching trait addition event');
      context.read<ProfileBloc>().add(ProfileTraitAdded(trait));
      
      // Wait for completion with timeout
      await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print('[ProfileTraitHandler] Timeout while adding trait');
          throw TimeoutException('Failed to add trait: timeout');
        },
      );
      
      if (!mounted) return;

      // Success path - show success message and close dialog
      print('[ProfileTraitHandler] Trait addition completed successfully');
      
      // Use a post-frame callback to ensure the state is stable
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ${trait.name} trait'),
            backgroundColor: Colors.green,
          ),
        );

        // Close dialog after showing success message
        Navigator.of(context).pop();
      });
      
    } catch (e) {
      print('[ProfileTraitHandler] Error handling trait addition: $e');
      if (!mounted) return;
      
      // Error path - refresh profile and show error
      context.read<ProfileBloc>().add(const ProfileStarted());
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      endTraitOperation();
    }
  }
}
