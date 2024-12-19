import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/traits/trait_type_model.dart';
import '../../../data/models/traits/user_trait_model.dart';
import '../../bloc/traits/traits_bloc.dart';
import '../../bloc/traits/traits_event.dart';
import '../../bloc/traits/traits_state.dart';
import 'user_traits_list.dart';

class UserTraits extends StatelessWidget {
  final String userId;
  final double height;
  final double itemWidth;
  final double itemHeight;
  final double spacing;

  const UserTraits({
    super.key,
    required this.userId,
    this.height = 120,
    this.itemWidth = 120,
    this.itemHeight = 40,
    this.spacing = 8,
  });

  void _handleTraitSelected(BuildContext context, TraitTypeModel traitType, String value) {
    print('Selected trait - Type: ${traitType.name}, Value: $value'); // Debug log
    
    context.read<TraitsBloc>().add(
      AddTrait(
        userId: userId,
        traitType: traitType,
        value: value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TraitsBloc, TraitsState>(
      listener: (context, state) {
        if (state is TraitAdded) {
          print('Trait added event received: ${state.trait.value}'); // Debug log
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added trait: ${state.trait.value}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is TraitsError) {
          print('Trait error received: ${state.message}'); // Debug log
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is TraitsLoaded) {
          print('Traits loaded: ${state.userTraits.length} traits'); // Debug log
        }
      },
      builder: (context, state) {
        // Initial load of traits
        if (state is TraitsInitial) {
          context.read<TraitsBloc>().add(LoadTraits(userId));
          return const SizedBox.shrink();
        }

        // Loading state
        if (state is TraitsLoading) {
          return SizedBox(
            height: itemHeight,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Error state
        if (state is TraitsError) {
          return SizedBox(
            height: itemHeight,
            child: Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        // Loaded state
        if (state is TraitsLoaded) {
          return UserTraitsList(
            traitTypes: state.traitTypes,
            traits: state.userTraits,
            onTraitSelected: (traitType, value) => _handleTraitSelected(context, traitType, value),
            height: height,
            itemWidth: itemWidth,
            itemHeight: itemHeight,
            spacing: spacing,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
