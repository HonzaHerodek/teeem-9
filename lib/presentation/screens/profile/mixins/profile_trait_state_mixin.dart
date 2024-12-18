import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../profile_bloc/profile_bloc.dart';
import '../profile_bloc/profile_event.dart';
import '../profile_bloc/profile_state.dart';
import '../../../../data/models/trait_model.dart';

/// Handles state management for trait operations
mixin ProfileTraitStateMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription<ProfileState>? _traitSubscription;
  bool _isProcessingTrait = false;
  bool _wasLoading = false;
  TraitModel? _pendingTrait;

  bool get isProcessingTrait => _isProcessingTrait;

  @override
  void dispose() {
    _cleanupSubscription();
    super.dispose();
  }

  void _cleanupSubscription() async {
    await _traitSubscription?.cancel();
    _traitSubscription = null;
    _isProcessingTrait = false;
    _wasLoading = false;
    _pendingTrait = null;
  }

  Future<void> listenToTraitUpdates(
    BuildContext context,
    TraitModel trait,
    Completer<void> completer,
  ) async {
    print('[ProfileTraitState] Starting to listen for trait updates');
    print('[ProfileTraitState] Waiting for trait: ${trait.category}:${trait.name}:${trait.value}');
    
    _pendingTrait = trait;
    
    _traitSubscription = context.read<ProfileBloc>().stream.listen(
      (state) async {
        print('[ProfileTraitState] State update:');
        print('  Loading: ${state.isLoading}');
        print('  HasError: ${state.hasError}');
        print('  Traits count: ${state.user?.traits.length}');
        if (state.user?.traits.isNotEmpty == true) {
          print('  Current traits: ${state.user?.traits.map((t) => '${t.category}:${t.name}:${t.value}')}');
        }
        
        if (state.hasError) {
          if (!completer.isCompleted) {
            print('[ProfileTraitState] Error in state: ${state.error}');
            completer.completeError(state.error ?? 'Failed to add trait');
          }
          await Future.delayed(const Duration(milliseconds: 100));
          _cleanupSubscription();
          return;
        }

        // Track loading state transition
        if (state.isLoading) {
          _wasLoading = true;
          return;
        }

        // Only proceed if we've seen a loading state and now it's complete
        if (_wasLoading && !state.isLoading && state.user != null && _pendingTrait != null) {
          final traitExists = state.user!.traits.any((t) => 
            t.id == _pendingTrait!.id && 
            t.category == _pendingTrait!.category &&
            t.name == _pendingTrait!.name &&
            t.value == _pendingTrait!.value
          );
          
          print('[ProfileTraitState] Loading complete, checking trait existence:');
          print('  Trait exists: $traitExists');
          print('  Looking for: ${_pendingTrait!.category}:${_pendingTrait!.name}:${_pendingTrait!.value}');
          print('  Current traits: ${state.user!.traits.map((t) => '${t.category}:${t.name}:${t.value}')}');
          
          if (traitExists && !completer.isCompleted) {
            print('[ProfileTraitState] Trait successfully added');
            completer.complete();
            // Add delay before cleanup to ensure state propagation
            await Future.delayed(const Duration(milliseconds: 300));
            if (mounted) {
              _cleanupSubscription();
            }
          } else if (!traitExists && !completer.isCompleted) {
            print('[ProfileTraitState] Trait not found after loading completed');
            completer.completeError('Failed to add trait: trait not found after update');
            await Future.delayed(const Duration(milliseconds: 100));
            if (mounted) {
              _cleanupSubscription();
            }
          }
        }
      },
      onError: (error) async {
        print('[ProfileTraitState] Stream error: $error');
        if (!completer.isCompleted) {
          completer.completeError(error.toString());
        }
        await Future.delayed(const Duration(milliseconds: 100));
        if (mounted) {
          _cleanupSubscription();
        }
      },
      cancelOnError: false,
    );

    return completer.future;
  }

  void startTraitOperation() {
    _isProcessingTrait = true;
    _wasLoading = false;
    _pendingTrait = null;
  }

  void endTraitOperation() {
    _cleanupSubscription();
  }
}
