import 'package:flutter/material.dart';
import '../../../data/models/traits/trait_type_model.dart';
import '../../../data/models/traits/user_trait_model.dart';
import 'expanding_trait_button.dart';
import 'expanding_search_button.dart';
import 'user_trait_chip.dart';

class UserTraitsList extends StatefulWidget {
  final List<TraitTypeModel> traitTypes;
  final List<UserTraitModel> traits;
  final Function(TraitTypeModel traitType, String value) onTraitSelected;
  final double height;
  final double itemHeight;

  const UserTraitsList({
    super.key,
    required this.traitTypes,
    required this.traits,
    required this.onTraitSelected,
    this.height = 120,
    this.itemHeight = 40,
  });

  @override
  State<UserTraitsList> createState() => _UserTraitsListState();
}

class _UserTraitsListState extends State<UserTraitsList> {
  String _searchText = '';

  List<UserTraitModel> get _filteredTraits {
    if (_searchText.isEmpty) return widget.traits;
    return widget.traits.where((trait) {
      final traitType = widget.traitTypes.firstWhere(
        (t) => t.id == trait.traitTypeId,
        orElse: () => throw Exception('Trait type not found'),
      );
      return traitType.name.toLowerCase().contains(_searchText.toLowerCase()) ||
          trait.value.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();
  }

  Widget _buildSearchButton() {
    return SizedBox(
      width: 48,
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: widget.itemHeight,
            maxHeight: widget.itemHeight,
          ),
          child: ExpandingSearchButton(
            height: widget.itemHeight,
            onSearch: (text) => setState(() => _searchText = text),
          ),
        ),
      ),
    );
  }

  Widget _buildAddTraitButton() {
    return SizedBox(
      width: 48,
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: widget.itemHeight,
            maxHeight: widget.itemHeight,
          ),
          child: ExpandingTraitButton(
            traitTypes: widget.traitTypes,
            height: widget.itemHeight,
            onTraitSelected: widget.onTraitSelected,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate available width for each trait
        final availableWidth = constraints.maxWidth;
        final buttonSpace = 48.0 * 2 + 8.0; // Two buttons + spacing
        final remainingWidth = availableWidth - buttonSpace;
        final itemCount = _filteredTraits.length;
        
        // Calculate adaptive item width
        final minItemWidth = 80.0; // Minimum width for readability
        final maxItemWidth = 120.0; // Maximum width to maintain compact look
        final calculatedWidth = remainingWidth / (itemCount == 0 ? 1 : itemCount);
        final itemWidth = calculatedWidth.clamp(minItemWidth, maxItemWidth);

        return SizedBox(
          height: widget.itemHeight,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.only(left: 4),
              itemCount: _filteredTraits.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildAddTraitButton();
                }
                if (index == 1) {
                  return _buildSearchButton();
                }
                final trait = _filteredTraits[index - 2];
                final traitType = widget.traitTypes.firstWhere(
                  (t) => t.id == trait.traitTypeId,
                  orElse: () => throw Exception('Trait type not found'),
                );
                return UserTraitChip(
                  trait: trait,
                  traitType: traitType,
                  width: itemWidth,
                  height: widget.itemHeight,
                  spacing: 4,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
