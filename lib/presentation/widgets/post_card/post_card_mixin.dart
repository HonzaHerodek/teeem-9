import 'package:flutter/material.dart';
import '../../../data/models/traits/trait_type_model.dart';
import '../../../domain/repositories/trait_repository.dart';
import '../../../core/di/injection.dart';
import '../../../data/models/post_model.dart';

mixin PostCardMixin<T extends StatefulWidget> on State<T> {
  int currentStep = 0;
  bool isHeaderExpanded = false;
  bool showMiniatures = false;
  late List<PostStep> allSteps;
  late AnimationController miniatureAnimation;
  final PageController pageController = PageController();
  static const double shrunkHeaderHeight = 60.0;
  double headerAnimationValue = 0.0;
  List<TraitTypeModel>? traitTypes;

  @override
  void dispose() {
    miniatureAnimation.dispose();
    pageController.dispose();
    super.dispose();
  }

  void handleHeaderExpandChange(bool expanded) {
    setState(() {
      isHeaderExpanded = expanded;
      if (expanded) {
        miniatureAnimation.forward();
      } else {
        miniatureAnimation.reverse();
      }
    });
  }

  void handleTransformToMiniatures() {
    setState(() => showMiniatures = true);
  }

  void handleTransformToDots() {
    setState(() => showMiniatures = false);
  }

  void handleStepSelected(int index) {
    setState(() => currentStep = index);
  }

  bool get shouldShowHeader {
    return currentStep == 0 || currentStep == allSteps.length - 1;
  }

  bool get isFirstOrLastStep {
    return currentStep == 0 || currentStep == allSteps.length - 1;
  }

  Future<void> loadTraitTypes() async {
    try {
      final types = await getIt<TraitRepository>().getTraitTypes();
      if (mounted) {
        setState(() {
          traitTypes = types;
        });
      }
    } catch (e) {
      debugPrint('Error loading trait types: $e');
    }
  }
}
