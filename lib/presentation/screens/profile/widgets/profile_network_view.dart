import 'package:flutter/material.dart';
import '../../../../data/models/trait_model.dart';

class ProfileNetworkView extends StatelessWidget {
  const ProfileNetworkView({Key? key}) : super(key: key);

  Widget _buildNetworkBubble(TraitModel trait) {
    const double itemHeight = 40;
    const double itemWidth = 120;

    return Container(
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

  @override
  Widget build(BuildContext context) {
    final networkTraits = [
      TraitModel(
        id: '1',
        name: 'Mentors',
        iconData: '0xe559',
        value: 'Mentors',
        category: 'network',
        displayOrder: 0,
      ),
      TraitModel(
        id: '2',
        name: 'Peers',
        iconData: '0xe7ef',
        value: 'Peers',
        category: 'network',
        displayOrder: 1,
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: networkTraits.map(_buildNetworkBubble).toList(),
      ),
    );
  }
}
