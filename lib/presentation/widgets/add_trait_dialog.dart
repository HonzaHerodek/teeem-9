import 'package:flutter/material.dart';
import '../../core/services/trait_service.dart';
import '../../data/models/trait_model.dart';

class AddTraitDialog extends StatefulWidget {
  final Function(TraitModel) onTraitAdded;

  const AddTraitDialog({
    Key? key,
    required this.onTraitAdded,
  }) : super(key: key);

  @override
  State<AddTraitDialog> createState() => _AddTraitDialogState();
}

class _AddTraitDialogState extends State<AddTraitDialog> {
  String? _selectedCategory;
  TraitModel? _selectedTrait;
  final TextEditingController _valueController = TextEditingController();
  List<TraitModel> _availableTraits = [];

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  void _updateAvailableTraits() {
    if (_selectedCategory != null) {
      setState(() {
        _availableTraits = TraitService.getTraitsForCategory(_selectedCategory!);
        _selectedTrait = null;
        _valueController.clear();
      });
      print('[AddTraitDialog] Available traits for $_selectedCategory: $_availableTraits');
    }
  }

  String _generateUniqueId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final id = '${_selectedCategory}_$timestamp';
    print('[AddTraitDialog] Generated ID: $id');
    return id;
  }

  void _handleTraitAdded() {
    print('[AddTraitDialog] Handling trait addition...');
    print('[AddTraitDialog] Selected category: $_selectedCategory');
    print('[AddTraitDialog] Selected trait: ${_selectedTrait?.name}');
    print('[AddTraitDialog] Value: ${_valueController.text}');

    if (_selectedCategory != null &&
        _selectedTrait != null &&
        _valueController.text.isNotEmpty) {
      print('[AddTraitDialog] Creating new trait...');
      
      // Create a new trait with a unique ID
      final newTrait = TraitModel(
        id: _generateUniqueId(),
        name: _selectedTrait!.name,
        iconData: _selectedTrait!.iconData,
        value: _valueController.text,
        category: _selectedCategory!,
        displayOrder: _selectedTrait!.displayOrder,
      );
      
      print('[AddTraitDialog] New trait created: ${newTrait.id} - ${newTrait.category}:${newTrait.name}:${newTrait.value}');
      
      // Ensure the callback is called
      try {
        print('[AddTraitDialog] Calling onTraitAdded callback...');
        widget.onTraitAdded(newTrait);
        print('[AddTraitDialog] Callback executed successfully');
        
        print('[AddTraitDialog] Closing dialog...');
        Navigator.pop(context);
        print('[AddTraitDialog] Dialog closed');
      } catch (e) {
        print('[AddTraitDialog] Error in trait added callback: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding trait: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      print('[AddTraitDialog] Cannot add trait: missing required fields');
      print('  Category: ${_selectedCategory != null}');
      print('  Trait: ${_selectedTrait != null}');
      print('  Value: ${_valueController.text.isNotEmpty}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = TraitService.getAvailableCategories();
    print('[AddTraitDialog] Building dialog, available categories: $categories');

    return Dialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Trait',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              dropdownColor: Colors.grey[850],
              style: const TextStyle(color: Colors.white),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(
                    category.toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                print('[AddTraitDialog] Category selected: $value');
                setState(() {
                  _selectedCategory = value;
                });
                _updateAvailableTraits();
              },
            ),
            const SizedBox(height: 16),
            if (_selectedCategory != null) ...[
              DropdownButtonFormField<TraitModel>(
                value: _selectedTrait,
                decoration: const InputDecoration(
                  labelText: 'Trait',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                dropdownColor: Colors.grey[850],
                style: const TextStyle(color: Colors.white),
                items: _availableTraits.map((trait) {
                  return DropdownMenuItem(
                    value: trait,
                    child: Text(
                      trait.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  print('[AddTraitDialog] Trait selected: ${value?.name}');
                  setState(() {
                    _selectedTrait = value;
                    if (value != null) {
                      _valueController.text = value.value;
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _valueController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Value',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: (value) {
                  print('[AddTraitDialog] Value changed: $value');
                  setState(() {}); // Trigger rebuild to update Add button state
                },
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    print('[AddTraitDialog] Cancel pressed');
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _selectedCategory != null &&
                          _selectedTrait != null &&
                          _valueController.text.isNotEmpty
                      ? _handleTraitAdded
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
