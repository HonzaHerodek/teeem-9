import 'package:flutter/material.dart';
import '../../../../../data/models/traits/trait_type_model.dart';
import '../../../../../data/models/traits/user_trait_model.dart';
import '../../../../widgets/user_traits/user_trait_chip.dart';
import '../../controllers/feed_header_controller.dart';
import 'feed_header_filters_section.dart';

class FeedHeaderTraitsSection extends StatelessWidget {
  final FeedHeaderController headerController;

  const FeedHeaderTraitsSection({
    super.key,
    required this.headerController,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildTraitList() {
      if (headerController.state.selectedTraitType == null) {
        // Show trait type categories
        final traitChips = headerController.traitTypes.map((traitType) {
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
            spacing: 7.5, // Reduced from 15 to 7.5
          );
        }).toList();

        return FeedHeaderFiltersSection(
          headerController: headerController,
          spacing: 7.5, // Reduced from 15 to 7.5
          children: traitChips,
        );
      }

      // Show trait values for selected type
      final selectedType = headerController.state.selectedTraitType!;
      final traitValueChips = [
        // Back button as first chip
        UserTraitChip(
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
          spacing: 7.5, // Reduced from 15 to 7.5
        ),
        // Trait value chips
        ...selectedType.possibleValues.map((value) {
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
            spacing: 7.5, // Reduced from 15 to 7.5
          );
        }),
      ];

      return FeedHeaderFiltersSection(
        headerController: headerController,
        spacing: 7.5, // Reduced from 15 to 7.5
        children: traitValueChips,
      );
    }

    return buildTraitList();
  }
}
