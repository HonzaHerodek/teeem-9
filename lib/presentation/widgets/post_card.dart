import 'package:flutter/material.dart';
import '../../data/models/post_model.dart';
import 'post_header.dart';
import 'step_indicators/step_dots.dart';
import 'step_indicators/step_miniatures.dart';
import 'post_card/post_card_decoration.dart';
import 'post_card/post_card_mixin.dart';
import 'post_card/post_step_content.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final String? currentUserId;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final Function(double) onRate;

  const PostCard({
    super.key,
    required this.post,
    required this.currentUserId,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onRate,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin, PostCardMixin {
  @override
  void initState() {
    super.initState();
    loadTraitTypes();
    allSteps = [
      PostStep(
        id: '${widget.post.id}_intro',
        title: widget.post.title,
        description: widget.post.description,
        type: StepType.text,
        content: {'text': widget.post.description},
      ),
      ...widget.post.steps,
      PostStep(
        id: '${widget.post.id}_outro',
        title: 'Rate and Share',
        description: 'Rate and share this post',
        type: StepType.text,
        content: {'text': ''},
      ),
    ];

    miniatureAnimation = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width - 32;
    final headerHeight = isHeaderExpanded ? size * 0.75 : PostCardMixin.shrunkHeaderHeight;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      width: size,
      height: size,
      decoration: PostCardDecoration.circularGradient(size),
      child: Container(
        decoration: PostCardDecoration.circularClip,
        clipBehavior: Clip.antiAlias,
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                animation: miniatureAnimation,
                builder: (context, child) {
                  final contentOpacity = 1.0 - headerAnimationValue;
                  final slideOffset = size * 0.2 * headerAnimationValue;
                  
                  return Transform.translate(
                    offset: Offset(0, slideOffset),
                    child: Opacity(
                      opacity: contentOpacity,
                      child: IgnorePointer(
                        ignoring: isHeaderExpanded,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return PageView.builder(
                              controller: pageController,
                              itemCount: allSteps.length,
                              onPageChanged: handleStepSelected,
                              itemBuilder: (context, index) => PostStepContent(
                                index: index,
                                totalSteps: allSteps.length,
                                post: widget.post,
                                currentUserId: widget.currentUserId,
                                onLike: widget.onLike,
                                onShare: widget.onShare,
                                onRate: widget.onRate,
                                constraints: constraints,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              if (shouldShowHeader)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: headerHeight,
                  child: PostHeader(
                    username: widget.post.username,
                    userProfileImage: widget.post.userProfileImage,
                    steps: allSteps,
                    currentStep: currentStep,
                    isExpanded: isHeaderExpanded,
                    onExpandChanged: handleHeaderExpandChange,
                    userId: widget.post.userId,
                    currentPostId: widget.post.id,
                    traitTypes: traitTypes ?? [],
                    userTraits: widget.post.userTraits,
                    rating: widget.post.ratingStats.averageRating,
                    onAnimationChanged: (value) {
                      setState(() {
                        headerAnimationValue = value;
                      });
                    },
                  ),
                ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                bottom: 24,
                left: 0,
                right: 0,
                child: isHeaderExpanded ||
                        (showMiniatures && !isFirstOrLastStep)
                    ? StepMiniatures(
                        steps: allSteps,
                        currentStep: currentStep,
                        onExpand: () => handleHeaderExpandChange(false),
                        onTransformToDots:
                            showMiniatures ? handleTransformToDots : null,
                        pageController: pageController,
                      )
                    : StepDots(
                        steps: allSteps,
                        currentStep: currentStep,
                        onExpand: () => handleHeaderExpandChange(true),
                        onMiniaturize: handleTransformToMiniatures,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
