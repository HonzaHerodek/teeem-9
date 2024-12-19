import 'package:flutter/material.dart';
import '../../../data/models/traits/trait_type_model.dart';
import '../../../data/models/traits/user_trait_model.dart';

class UserTraitChip extends StatelessWidget {
  final UserTraitModel trait;
  final TraitTypeModel traitType;
  final double? width;
  final double height;
  final double spacing;
  final bool isSelected;
  final VoidCallback? onTap;

  const UserTraitChip({
    super.key,
    required this.trait,
    required this.traitType,
    this.width,
    this.height = 35,
    this.spacing = 15,
    this.isSelected = false,
    this.onTap,
  });

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? _calculateChipWidth(),
        height: height,
        margin: EdgeInsets.only(right: spacing / 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.white.withOpacity(isSelected ? 0.2 : 0.15),
              Colors.white.withOpacity(isSelected ? 0.15 : 0.1),
            ],
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(height / 2),
            bottomRight: Radius.circular(height / 2),
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: height,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.white.withOpacity(0.25),
                    Colors.white.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(height / 2),
                  bottomRight: Radius.circular(height / 2),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  _parseIconData(traitType.iconData) ?? Icons.star,
                  color: Colors.white,
                  size: height * 0.6,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text(
                      '${traitType.name}: ',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      trait.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateChipWidth() {
    // Measure type name
    final typeTextSpan = TextSpan(
      text: '${traitType.name}: ',
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: 11,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.3,
      ),
    );
    final typeTextPainter = TextPainter(
      text: typeTextSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    // Measure value
    final valueTextSpan = TextSpan(
      text: trait.value,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );
    final valueTextPainter = TextPainter(
      text: valueTextSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    // Calculate total width:
    // icon width (height) + horizontal padding (24) + type width + value width + extra padding (16)
    return height + 24 + typeTextPainter.width + valueTextPainter.width + 16;
  }
}
