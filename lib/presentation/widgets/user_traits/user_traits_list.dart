import 'package:flutter/material.dart';
import '../../../data/models/traits/trait_type_model.dart';
import '../../../data/models/traits/user_trait_model.dart';
import 'expanding_trait_button.dart';
import 'user_trait_chip.dart';

class UserTraitsList extends StatelessWidget {
  final List<TraitTypeModel> traitTypes;
  final List<UserTraitModel> traits;
  final Function(TraitTypeModel traitType, String value) onTraitSelected;
  final double height;
  final double itemWidth;
  final double itemHeight;
  final double spacing;

  const UserTraitsList({
    super.key,
    required this.traitTypes,
    required this.traits,
    required this.onTraitSelected,
    this.height = 120,
    this.itemWidth = 120,
    this.itemHeight = 40,
    this.spacing = 8,
  });

  Widget _buildAddTraitChip() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: spacing / 2),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: itemHeight,
          maxHeight: itemHeight,
        ),
        child: ExpandingTraitButton(
          traitTypes: traitTypes,
          height: itemHeight,
          onTraitSelected: onTraitSelected,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemHeight,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: traits.length + 1, // +1 for add button
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildAddTraitChip();
            }
            final trait = traits[index - 1];
            final traitType = traitTypes.firstWhere(
              (t) => t.id == trait.traitTypeId,
              orElse: () => throw Exception('Trait type not found'),
            );
            return UserTraitChip(
              trait: trait,
              traitType: traitType,
              width: itemWidth,
              height: itemHeight,
              spacing: spacing,
            );
          },
        ),
      ),
    );
  }
}
