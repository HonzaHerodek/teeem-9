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
  final double itemHeight;

  const UserTraitsList({
    super.key,
    required this.traitTypes,
    required this.traits,
    required this.onTraitSelected,
    this.itemHeight = 40,
  });

  @override
  State<UserTraitsList> createState() => _UserTraitsListState();
}

class _UserTraitsListState extends State<UserTraitsList> {
  String _searchText = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
    return Container(
      margin: const EdgeInsets.only(right: 4),
      constraints: const BoxConstraints(
        minWidth: 48,
        maxWidth: 260,
      ),
      child: ExpandingSearchButton(
        height: widget.itemHeight,
        onSearch: (text) => setState(() => _searchText = text),
      ),
    );
  }

  Widget _buildAddTraitButton() {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      constraints: const BoxConstraints(
        minWidth: 48,
        maxWidth: 260,
      ),
      child: ExpandingTraitButton(
        traitTypes: widget.traitTypes,
        height: widget.itemHeight,
        onTraitSelected: widget.onTraitSelected,
      ),
    );
  }

  List<List<Widget>> _organizeTraitsInRows(BoxConstraints constraints) {
    final minItemWidth = 80.0;
    final maxItemWidth = 120.0;
    final spacing = 4.0;
    final buttonWidth = 48.0 + spacing;
    final itemWidth = maxItemWidth.clamp(minItemWidth, maxItemWidth);

    // Create trait widgets
    final traitWidgets = _filteredTraits.map((trait) {
      final traitType = widget.traitTypes.firstWhere(
        (t) => t.id == trait.traitTypeId,
        orElse: () => throw Exception('Trait type not found'),
      );

      return UserTraitChip(
        trait: trait,
        traitType: traitType,
        width: itemWidth,
        height: widget.itemHeight,
        spacing: spacing,
      );
    }).toList();

    // Initialize rows for traits
    List<List<Widget>> rows = [[], [], []];

    // Calculate how many items can fit in each row
    final firstRowCapacity =
        ((constraints.maxWidth - buttonWidth) / (itemWidth + spacing)).floor();
    final secondRowCapacity =
        ((constraints.maxWidth - buttonWidth) / (itemWidth + spacing)).floor();
    final thirdRowCapacity =
        (constraints.maxWidth / (itemWidth + spacing)).floor();

    // Distribute traits to fill rows from left to right
    var remainingTraits = [...traitWidgets];

    // Fill first row
    if (remainingTraits.isNotEmpty) {
      final count = remainingTraits.length.clamp(0, firstRowCapacity);
      rows[0].addAll(remainingTraits.take(count));
      remainingTraits = remainingTraits.skip(count).toList();
    }

    // Fill second row
    if (remainingTraits.isNotEmpty) {
      final count = remainingTraits.length.clamp(0, secondRowCapacity);
      rows[1].addAll(remainingTraits.take(count));
      remainingTraits = remainingTraits.skip(count).toList();
    }

    // Fill third row
    if (remainingTraits.isNotEmpty) {
      rows[2].addAll(remainingTraits);
    }

    return rows;
  }

  Widget _buildRow(List<Widget> traits, Widget? button) {
    return SizedBox(
      height: widget.itemHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (button != null) button,
          ...traits,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final traitRows = _organizeTraitsInRows(constraints);

        return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow(traitRows[0], _buildSearchButton()),
                  const SizedBox(height: 4),
                  _buildRow(traitRows[1], _buildAddTraitButton()),
                  if (traitRows[2].isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _buildRow(traitRows[2], null),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
