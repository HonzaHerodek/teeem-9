import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/repositories/post_repository.dart';
import '../../../domain/repositories/project_repository.dart';
import '../../../core/services/rating_service.dart';
import 'feed_bloc/feed_bloc.dart';
import 'feed_bloc/feed_event.dart';
import 'services/filter_service.dart';
import 'widgets/feed_view.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedBloc(
        postRepository: getIt<PostRepository>(),
        projectRepository: getIt<ProjectRepository>(),
        authRepository: getIt<AuthRepository>(),
        filterService: getIt<FilterService>(),
        ratingService: getIt<RatingService>(),
      )..add(const FeedStarted()),
      child: const FeedView(),
    );
  }
}
