import 'package:flutter/material.dart';
import '../../../../data/models/trait_model.dart';
import '../../../../core/services/trait_service.dart';
import '../../../widgets/add_trait_dialog.dart';

class ProfileTraitsView extends StatelessWidget {
  final List<TraitModel> traits;
  final Function(TraitModel) onTraitAdded;
  final bool isLoading;

  const ProfileTraitsView({
    Key? key,
    required this.traits,
    required this.onTraitAdded,
    this.isLoading = false,
  }) : super(key: key);

  Widget _buildTraitBubble(TraitModel trait) {
    const double itemHeight = 40;
    const double itemWidth = 120;

    return Container(
      key: ValueKey(trait.id), // Add key for proper widget updates
      width: itemWidth,
      height: itemHeight,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(itemHeight / 2),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: itemHeight,
            height: itemHeight,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(itemHeight / 2),
            ),
            child: Center(
              child: Icon(
                IconData(int.parse(trait.iconData), fontFamily: 'MaterialIcons'),
                color: Colors.white,
                size: itemHeight * 0.6,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                trait.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTraitDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AddTraitDialog(
        onTraitAdded: (trait) {
          print('[ProfileTraitsView] New trait added: ${trait.id}');
          onTraitAdded(trait);
        },
      ),
    );
  }

  Widget _buildTraitCategory(String category, List<TraitModel> categoryTraits, BuildContext context) {
    return Column(
      key: ValueKey('category_$category'), // Add key for proper widget updates
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 4),
          child: Text(
            category.toUpperCase(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              ...categoryTraits.map(_buildTraitBubble),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                onPressed: isLoading ? null : () => _showAddTraitDialog(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('[ProfileTraitsView] Building with ${traits.length} traits, isLoading: $isLoading');
    
    final availableCategories = TraitService.getAvailableCategories();
    final traitsByCategory = <String, List<TraitModel>>{};
    
    for (var category in availableCategories) {
      traitsByCategory[category] = [];
    }
    
    for (var trait in traits) {
      print('[ProfileTraitsView] Processing trait: ${trait.id} - ${trait.name}:${trait.value}');
      traitsByCategory[trait.category]?.add(trait);
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container( // Wrap in Container with key for proper animation
        key: ValueKey('traits_container_${traits.length}'),
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var entry in traitsByCategory.entries)
                  if (entry.value.isNotEmpty)
                    _buildTraitCategory(entry.key, entry.value, context),
                if (traits.isEmpty)
                  Center(
                    child: TextButton.icon(
                      onPressed: isLoading ? null : () => _showAddTraitDialog(context),
                      icon: const Icon(Icons.add, color: Colors.amber),
                      label: const Text(
                        'Add your first trait',
                        style: TextStyle(color: Colors.amber),
                      ),
                    ),
                  ),
              ],
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
