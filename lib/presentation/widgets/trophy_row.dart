import 'package:flutter/material.dart';
import '../../data/models/trophy_model.dart';

class TrophyRow extends StatefulWidget {
  final List<Trophy> trophies;
  final Function(bool)? onExpanded;

  const TrophyRow({
    Key? key,
    required this.trophies,
    this.onExpanded,
  }) : super(key: key);

  @override
  State<TrophyRow> createState() => _TrophyRowState();
}

class _TrophyRowState extends State<TrophyRow> {
  bool _expanded = false;

  Widget _buildTrophyIcon(Trophy trophy, {double size = 24.0}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: trophy.isAchieved
            ? [
                BoxShadow(
                  color: trophy.color.withOpacity(0.15),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.emoji_events,
            color: Colors.grey[800],
            size: size,
          ),
          if (trophy.isAchieved)
            Icon(
              Icons.emoji_events,
              color: trophy.color.withOpacity(0.9),
              size: size,
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String category) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        category,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 11,
          fontWeight: FontWeight.w300,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTrophyRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...widget.trophies.take(8).map((trophy) {
            final size = trophy.isAchieved ? 28.0 : 20.0;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _buildTrophyIcon(trophy, size: size),
            );
          }),
          if (widget.trophies.length > 8)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                '+${widget.trophies.length - 8}',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExpandedTrophies() {
    final Map<String, List<Trophy>> categorizedTrophies = {};
    for (var trophy in widget.trophies) {
      if (!categorizedTrophies.containsKey(trophy.category)) {
        categorizedTrophies[trophy.category] = [];
      }
      categorizedTrophies[trophy.category]!.add(trophy);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final rowWidth = constraints.maxWidth - 32;
        final cardWidth = (rowWidth / 2.2).floor().toDouble();
        final spacing = 8.0;

        return Container(
          constraints: const BoxConstraints(maxHeight: 400),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var category in categorizedTrophies.keys) ...[
                  _buildCategoryHeader(category),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          ...categorizedTrophies[category]!.map((trophy) => 
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: SizedBox(
                                width: cardWidth,
                                child: _buildTrophyCard(trophy),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrophyCard(Trophy trophy) {
    return Card(
      elevation: trophy.isAchieved ? 4 : 1,
      color: trophy.isAchieved
          ? Color.lerp(Colors.black, trophy.color, 0.15)
          : Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: trophy.isAchieved
                    ? Color.lerp(Colors.black, trophy.color, 0.2)
                    : Colors.black26,
                shape: BoxShape.circle,
                boxShadow: trophy.isAchieved
                    ? [
                        BoxShadow(
                          color: trophy.color.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: _buildTrophyIcon(trophy, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              trophy.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: trophy.isAchieved ? trophy.color : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              trophy.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color:
                        trophy.isAchieved ? Colors.white70 : Colors.grey[600],
                    fontSize: 11,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
                widget.onExpanded?.call(_expanded);
              });
            },
            child: _buildTrophyRow(),
          ),
        ),
        if (_expanded)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: _buildExpandedTrophies(),
          ),
      ],
    );
  }
}
