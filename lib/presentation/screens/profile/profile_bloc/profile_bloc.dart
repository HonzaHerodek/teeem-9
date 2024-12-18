import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../../../../domain/repositories/post_repository.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/services/rating_service.dart';
import '../../../../core/services/logger_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'mixins/trait_management_mixin.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> with TraitManagementMixin {
  @override
  final UserRepository userRepository;
  final PostRepository postRepository;
  final RatingService ratingService;
  final LoggerService _logger = LoggerService();

  ProfileBloc({
    required this.userRepository,
    required this.postRepository,
    required this.ratingService,
  }) : super(const ProfileState()) {
    on<ProfileStarted>(_onProfileStarted);
    on<ProfileRefreshed>(_onProfileRefreshed);
    on<ProfilePostsRequested>(_onProfilePostsRequested);
    on<ProfileRatingReceived>(_onProfileRatingReceived);
    on<ProfileTraitAdded>(handleTraitAdded); // Use the mixin's implementation
    on<ProfilePostUnsaved>(_onProfilePostUnsaved);
  }

  Future<void> _onProfileStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final currentUser = await userRepository.getCurrentUser();
      if (currentUser == null) {
        throw AppException('User not found');
      }

      final userPosts = await postRepository.getPosts(userId: currentUser.id);
      final ratingStats = await ratingService.getUserRatingStats(currentUser.id);

      emit(state.copyWith(
        isLoading: false,
        user: currentUser,
        userPosts: userPosts,
        ratingStats: ratingStats,
        error: null,
      ));
    } catch (e) {
      _logger.e('Error in ProfileBloc._onProfileStarted', error: e);
      emit(state.copyWith(
        isLoading: false,
        error: e is AppException ? e.message : 'Failed to load profile',
      ));
    }
  }

  Future<void> _onProfileRefreshed(
    ProfileRefreshed event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final currentUser = await userRepository.getCurrentUser();
      if (currentUser == null) {
        throw AppException('User not found');
      }

      final userPosts = await postRepository.getPosts(userId: currentUser.id);
      final ratingStats = await ratingService.getUserRatingStats(currentUser.id);

      emit(state.copyWith(
        isLoading: false,
        user: currentUser,
        userPosts: userPosts,
        ratingStats: ratingStats,
        error: null,
      ));
    } catch (e) {
      _logger.e('Error in ProfileBloc._onProfileRefreshed', error: e);
      emit(state.copyWith(
        isLoading: false,
        error: e is AppException ? e.message : 'Failed to refresh profile',
      ));
    }
  }

  Future<void> _onProfilePostsRequested(
    ProfilePostsRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      if (state.user == null) {
        throw AppException('User not found');
      }

      final userPosts = await postRepository.getPosts(userId: state.user!.id);
      emit(state.copyWith(userPosts: userPosts, error: null));
    } catch (e) {
      _logger.e('Error in ProfileBloc._onProfilePostsRequested', error: e);
      emit(state.copyWith(
        error: e is AppException ? e.message : 'Failed to load posts',
      ));
    }
  }

  Future<void> _onProfileRatingReceived(
    ProfileRatingReceived event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      if (state.user == null) {
        throw AppException('User not found');
      }

      await ratingService.rateUser(state.user!.id, event.raterId, event.rating);
      final ratingStats = await ratingService.getUserRatingStats(state.user!.id);

      emit(state.copyWith(
        ratingStats: ratingStats,
        error: null,
      ));
    } catch (e) {
      _logger.e('Error in ProfileBloc._onProfileRatingReceived', error: e);
      emit(state.copyWith(
        error: e is AppException ? e.message : 'Failed to update rating',
      ));
    }
  }

  Future<void> _onProfilePostUnsaved(
    ProfilePostUnsaved event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      if (state.user == null) {
        throw AppException('User not found');
      }

      final updatedPosts = state.userPosts.where((post) => post.id != event.postId).toList();

      emit(state.copyWith(
        userPosts: updatedPosts,
        error: null,
      ));

      await postRepository.unsavePost(event.postId, state.user!.id);
    } catch (e) {
      _logger.e('Error in ProfileBloc._onProfilePostUnsaved', error: e);
      emit(state.copyWith(
        error: e is AppException ? e.message : 'Failed to unsave post',
      ));
    }
  }
}
