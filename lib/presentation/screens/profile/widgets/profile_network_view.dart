import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../data/models/traits/trait_type_model.dart';
import '../../../../data/models/traits/user_trait_model.dart';
import '../../../../domain/repositories/trait_repository.dart';

class ProfileNetworkView extends StatefulWidget {
  const ProfileNetworkView({Key? key}) : super(key: key);

  @override
  State<ProfileNetworkView> createState() => _ProfileNetworkViewState();
}

class _ProfileNetworkViewState extends State<ProfileNetworkView> {
  List<TraitTypeModel> _networkTraitTypes = [];

  @override
  void initState() {
    super.initState();
    _loadNetworkTraits();
  }

  Future<void> _loadNetworkTraits() async {
    final traitTypes = await GetIt.instance<TraitRepository>().getTraitTypes();
    if (mounted) {
      setState(() {
        _networkTraitTypes = traitTypes
            .where((type) => type.category == 'network')
            .toList();
      });
    }
  }

  Widget _buildNetworkBubble(TraitTypeModel traitType) {
    const double itemHeight = 40;
    const double itemWidth = 120;

    IconData? _parseIconData(String iconData) {
      try {
        final codePoint = int.parse(iconData, radix: 16);
        return IconData(codePoint, fontFamily: 'MaterialIcons');
      } catch (e) {
        return null;
      }
    }

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
                _parseIconData(traitType.iconData) ?? Icons.star,
                color: Colors.white,
                size: itemHeight * 0.6,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                traitType.name,
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _networkTraitTypes.map(_buildNetworkBubble).toList(),
      ),
    );
  }
}
