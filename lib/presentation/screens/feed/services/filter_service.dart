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
      case FilterType.traits:
        // Filter posts based on trait matching
        if (_searchQuery.isNotEmpty) {
          filteredPosts = filteredPosts.where((post) {
            // Check if any of the post's targeting traits match the search query
            final traits = [
              ...(post.targetingCriteria?.interests ?? []),
              ...(post.targetingCriteria?.skills ?? [])
            ];
            return traits.any((trait) => 
              trait.toLowerCase().contains(_searchQuery)
            );
          }).toList();
        }
        break;
      
      case FilterType.none:
      default:
        // When no filter is selected, only apply basic search if query exists
        if (_searchQuery.isNotEmpty) {
          filteredPosts = filteredPosts.where((post) =>
            post.title.toLowerCase().contains(_searchQuery) ||
            post.description.toLowerCase().contains(_searchQuery)
          ).toList();
        }
        break;
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
