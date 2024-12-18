import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../data/models/traits/trait_type_model.dart';
import '../../data/models/traits/user_trait_model.dart';
import '../../domain/repositories/trait_repository.dart';

class AddTraitDialog extends StatefulWidget {
  final Function(UserTraitModel) onTraitAdded;

  const AddTraitDialog({
    Key? key,
    required this.onTraitAdded,
  }) : super(key: key);

  @override
  State<AddTraitDialog> createState() => _AddTraitDialogState();
}

class _AddTraitDialogState extends State<AddTraitDialog> {
  final TraitRepository _traitRepository = GetIt.instance<TraitRepository>();
  String? _selectedCategory;
  TraitTypeModel? _selectedTraitType;
  String? _selectedValue;
  List<TraitTypeModel> _traitTypes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTraitTypes();
  }

  Future<void> _loadTraitTypes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final traitTypes = await _traitRepository.getTraitTypes();
      if (mounted) {
        setState(() {
          _traitTypes = traitTypes;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading trait types: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Set<String> get _categories {
    return _traitTypes.map((t) => t.category).toSet();
  }

  List<TraitTypeModel> _getTraitTypesForCategory(String category) {
    return _traitTypes.where((t) => t.category == category).toList();
  }

  void _handleTraitAdded() {
    if (_selectedTraitType != null && _selectedValue != null) {
      final newTrait = UserTraitModel(
        id: 'trait_${DateTime.now().millisecondsSinceEpoch}',
        traitTypeId: _selectedTraitType!.id,
        value: _selectedValue!,
        displayOrder: 0, // Will be set by repository
      );
      
      widget.onTraitAdded(newTrait);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else ...[
              // Category Dropdown
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
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(
                      category.toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                    _selectedTraitType = null;
                    _selectedValue = null;
                  });
                },
              ),
              const SizedBox(height: 16),
              if (_selectedCategory != null) ...[
                // Trait Type Dropdown
                DropdownButtonFormField<TraitTypeModel>(
                  value: _selectedTraitType,
                  decoration: const InputDecoration(
                    labelText: 'Trait Type',
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
                  items: _getTraitTypesForCategory(_selectedCategory!).map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(
                        type.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTraitType = value;
                      _selectedValue = null;
                    });
                  },
                ),
                const SizedBox(height: 16),
                if (_selectedTraitType != null)
                  DropdownButtonFormField<String>(
                    value: _selectedValue,
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
                    dropdownColor: Colors.grey[850],
                    style: const TextStyle(color: Colors.white),
                    items: _selectedTraitType!.possibleValues.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value;
                      });
                    },
                  ),
              ],
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _selectedTraitType != null && _selectedValue != null
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
