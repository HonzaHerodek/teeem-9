import 'package:flutter/material.dart';
import '../../../../../data/models/traits/trait_type_model.dart';
import '../../../../../data/models/traits/user_trait_model.dart';
import '../../../../widgets/user_traits/user_trait_chip.dart';
import '../../controllers/feed_header_controller.dart';

class FeedHeaderTraitsSection extends StatelessWidget {
  final FeedHeaderController headerController;

  const FeedHeaderTraitsSection({
    super.key,
    required this.headerController,
  });

  @override
  Widget build(BuildContext context) {
    if (!headerController.state.isSearchVisible) {
      return const SizedBox.shrink();
    }

    // If no trait type is selected, show categories and trait types
    if (headerController.state.selectedTraitType == null) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: headerController.traitTypes.length,
        itemBuilder: (context, index) {
          final traitType = headerController.traitTypes[index];
          return UserTraitChip(
            trait: UserTraitModel(
              id: traitType.id,
              traitTypeId: traitType.id,
              value: traitType.name,
              displayOrder: 0,
            ),
            traitType: traitType,
            isSelected: false,
            canEditType: false,
            canEditValue: true,
            onTraitValueEdit: (trait) {
              headerController.selectTraitValue(trait.value);
            },
            onTap: () => headerController.selectTraitType(traitType),
            spacing: 15,
          );
        },
      );
    }

    // If a trait type is selected, show its possible values
    final selectedType = headerController.state.selectedTraitType!;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: selectedType.possibleValues.length + 1, // +1 for back button
      itemBuilder: (context, index) {
        if (index == 0) {
          // Back button as first chip
          return UserTraitChip(
            trait: UserTraitModel(
              id: 'back',
              traitTypeId: 'back',
              value: 'Back',
              displayOrder: 0,
            ),
            traitType: TraitTypeModel(
              id: 'back',
              name: '',
              iconData: 'e5c4', // arrow_back icon
              category: '',
              possibleValues: const [],
              displayOrder: 0,
            ),
            canEditType: false,
            canEditValue: true,
            onTraitValueEdit: (trait) {
              headerController.selectTraitValue(trait.value);
            },
            onTap: () => headerController.selectTraitType(null),
            spacing: 15,
          );
        }

        final value = selectedType.possibleValues[index - 1];
        return UserTraitChip(
          trait: UserTraitModel(
            id: selectedType.id,
            traitTypeId: selectedType.id,
            value: value,
            displayOrder: 0,
          ),
          traitType: selectedType,
          isSelected: false,
          canEditType: false,
          canEditValue: true,
          onTraitValueEdit: (trait) {
            headerController.selectTraitValue(trait.value);
          },
          onTap: () {
            headerController.selectTraitValue(value);
          },
          spacing: 15,
        );
      },
    );
  }
}
