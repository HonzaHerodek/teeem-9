import 'package:flutter/material.dart';
import '../../../data/models/project_model.dart';
import 'square_action_button.dart';
import 'project_post_selection_service.dart';

class ProjectHeader extends StatelessWidget {
  final ProjectModel project;
  final ProjectPostSelectionService service;
  final VoidCallback? onTap;
  final Function(BuildContext) onSettingsPressed;

  const ProjectHeader({
    super.key,
    required this.project,
    required this.service,
    required this.onTap,
    required this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: service.isSelectionMode ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                project.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            SquareActionButton(
              icon: service.isSelectionMode ? Icons.check : Icons.settings,
              onPressed: () => onSettingsPressed(context),
              size: 40,
            ),
          ],
        ),
      ),
    );
  }
}
