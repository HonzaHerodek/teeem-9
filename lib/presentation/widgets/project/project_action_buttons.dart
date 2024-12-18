import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/project_model.dart';
import '../../../presentation/screens/feed/feed_bloc/feed_bloc.dart';
import '../../../presentation/screens/feed/feed_bloc/feed_event.dart';
import 'square_action_button.dart';
import 'project_post_selection_service.dart';

class ProjectActionButtons extends StatelessWidget {
  final ProjectModel project;
  final String? currentUserId;
  final ProjectPostSelectionService service;

  const ProjectActionButtons({
    super.key,
    required this.project,
    required this.currentUserId,
    required this.service,
  });

  Widget _buildSelectionModeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SquareActionButton(
          icon: Icons.add_circle_outline,
          onPressed: () {
            // TODO: Implement add post action
          },
          size: 40,
        ),
        const SizedBox(width: 40),
        SquareActionButton(
          icon: Icons.add_box_outlined,
          onPressed: () {
            // TODO: Implement add sub-project action
          },
          size: 40,
        ),
      ],
    );
  }

  Widget _buildLikeButton(BuildContext context) {
    final isLiked = currentUserId != null && project.likes.contains(currentUserId);

    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : Colors.white,
        size: 32,
      ),
      onPressed: () {
        if (currentUserId == null) return;

        if (isLiked) {
          context.read<FeedBloc>().add(FeedProjectUnliked(project.id));
        } else {
          context.read<FeedBloc>().add(FeedProjectLiked(project.id));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Center(
        child: service.isSelectionMode
            ? _buildSelectionModeButtons()
            : _buildLikeButton(context),
      ),
    );
  }
}
