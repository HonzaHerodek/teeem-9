import '../../../../data/models/post_model.dart';
import '../../../../data/models/user_model.dart';
import '../models/filter_type.dart';

class FilterService {
  FilterType _currentFilter = FilterType.none;
  String _searchQuery = '';

  FilterType get currentFilter => _currentFilter;

  void setFilter(FilterType filter) {
    _currentFilter = filter;
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
  }

  List<PostModel> filterPosts(List<PostModel> posts, UserModel currentUser) {
    // First apply targeting criteria filter
    var filteredPosts = posts.where((post) => _shouldShowPost(post, currentUser)).toList();

    // Then apply the selected filter type
    switch (_currentFilter) {
      case FilterType.group:
        filteredPosts = filteredPosts.where((post) {
          final interests = post.targetingCriteria?.interests?.length ?? 0;
          final skills = post.targetingCriteria?.skills?.length ?? 0;
          return interests > 2 || skills > 2;
        }).toList();
        break;
      
      case FilterType.pair:
        filteredPosts = filteredPosts.where((post) {
          final interests = post.targetingCriteria?.interests?.length ?? 0;
          final skills = post.targetingCriteria?.skills?.length ?? 0;
          return interests == 2 || skills == 2;
        }).toList();
        break;
      
      case FilterType.self:
        filteredPosts = filteredPosts.where((post) {
          if (post.userId == currentUser.id) return true;
          final interests = post.targetingCriteria?.interests?.length ?? 0;
          final skills = post.targetingCriteria?.skills?.length ?? 0;
          return interests <= 1 && skills <= 1;
        }).toList();
        break;
      
      case FilterType.none:
      default:
        break;
    }

    // Apply search query if present
    if (_searchQuery.isNotEmpty) {
      filteredPosts = filteredPosts.where((post) =>
        post.title.toLowerCase().contains(_searchQuery) ||
        post.description.toLowerCase().contains(_searchQuery)
      ).toList();
    }

    return filteredPosts;
  }

  bool _shouldShowPost(PostModel post, UserModel currentUser) {
    // Check if post is active
    if (post.status != PostStatus.active) {
      return false;
    }

    // Check targeting criteria
    if (post.targetingCriteria != null &&
        currentUser.targetingCriteria != null) {
      if (!post.isTargetedTo(currentUser.targetingCriteria!)) {
        return false;
      }
    }

    return true;
  }
}
