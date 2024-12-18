import 'package:flutter/material.dart';
import '../../../data/models/traits/trait_type_model.dart';

class AddTraitDialog extends StatefulWidget {
  final List<TraitTypeModel> traitTypes;
  final Function(TraitTypeModel traitType, String value) onTraitSelected;

  const AddTraitDialog({
    super.key,
    required this.traitTypes,
    required this.onTraitSelected,
  });

  @override
  State<AddTraitDialog> createState() => _AddTraitDialogState();
}

class _AddTraitDialogState extends State<AddTraitDialog> {
  TraitTypeModel? selectedTraitType;
  String? selectedValue;

  IconData? _parseIconData(String iconData) {
    try {
      final codePoint = int.parse(iconData, radix: 16);
      return IconData(codePoint, fontFamily: 'MaterialIcons');
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Trait'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trait Type Selection
          DropdownButtonFormField<TraitTypeModel>(
            value: selectedTraitType,
            decoration: const InputDecoration(
              labelText: 'Select Trait Type',
            ),
            items: widget.traitTypes.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Row(
                  children: [
                    Icon(_parseIconData(type.iconData) ?? Icons.star),
                    const SizedBox(width: 8),
                    Text(type.name),
                  ],
                ),
              );
            }).toList(),
            onChanged: (type) {
              setState(() {
                selectedTraitType = type;
                selectedValue = null;
              });
            },
          ),
          const SizedBox(height: 16),
          // Value Selection
          if (selectedTraitType != null)
            DropdownButtonFormField<String>(
              value: selectedValue,
              decoration: const InputDecoration(
                labelText: 'Select Value',
              ),
              items: selectedTraitType!.possibleValues.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
              },
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: selectedTraitType != null && selectedValue != null
              ? () => widget.onTraitSelected(selectedTraitType!, selectedValue!)
              : null,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
