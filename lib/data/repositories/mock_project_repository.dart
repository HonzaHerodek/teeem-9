import '../../domain/repositories/project_repository.dart';
import '../models/project_model.dart';
import '../models/post_model.dart';
import '../models/rating_model.dart';
import '../models/trait_model.dart';

class MockProjectRepository implements ProjectRepository {
  final List<ProjectModel> _projects = [
    ProjectModel(
      id: '1',
      name: 'Photography Collection',
      description: 'A collection of my best photography work from 2023',
      creatorId: 'user1',
      postIds: ['photo1', 'photo2', 'photo3'],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now(),
    ),
    ProjectModel(
      id: '2',
      name: 'Travel Adventures',
      description: 'Documenting my travels across Europe',
      creatorId: 'user1',
      postIds: ['travel1', 'travel2'],
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  final List<PostModel> _mockPosts = [
    PostModel(
      id: 'photo1',
      userId: 'user1',
      username: 'PhotoMaster',
      userProfileImage: 'https://example.com/avatar1.jpg',
      title: 'Sunset at Golden Gate',
      description: 'Capturing the magical moment of sunset in San Francisco',
      steps: [
        PostStep(
          id: 'step1',
          type: StepType.image,
          title: 'Golden Gate Sunset',
          imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
        )
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      likes: [],
      comments: [],
      status: PostStatus.published,
      ratings: [],
      userTraits: [],
    ),
    PostModel(
      id: 'photo2',
      userId: 'user1',
      username: 'PhotoMaster',
      userProfileImage: 'https://example.com/avatar1.jpg',
      title: 'Mountain Landscape',
      description: 'Breathtaking view of the alpine mountains',
      steps: [
        PostStep(
          id: 'step1',
          type: StepType.image,
          title: 'Alpine Peaks',
          imageUrl: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
        )
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      likes: [],
      comments: [],
      status: PostStatus.published,
      ratings: [],
      userTraits: [],
    ),
    PostModel(
      id: 'photo3',
      userId: 'user1',
      username: 'PhotoMaster',
      userProfileImage: 'https://example.com/avatar1.jpg',
      title: 'City Lights',
      description: 'Night photography of urban landscapes',
      steps: [
        PostStep(
          id: 'step1',
          type: StepType.image,
          title: 'City at Night',
          imageUrl: 'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
        )
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      likes: [],
      comments: [],
      status: PostStatus.published,
      ratings: [],
      userTraits: [],
    ),
    PostModel(
      id: 'travel1',
      userId: 'user1',
      username: 'TravelBlogger',
      userProfileImage: 'https://example.com/avatar1.jpg',
      title: 'Paris Street Scene',
      description: 'Exploring the charming streets of Paris',
      steps: [
        PostStep(
          id: 'step1',
          type: StepType.image,
          title: 'Parisian Cafe',
          imageUrl: 'https://images.unsplash.com/photo-1549144511-f099e773c147?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1374&q=80',
        )
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
      likes: [],
      comments: [],
      status: PostStatus.published,
      ratings: [],
      userTraits: [],
    ),
    PostModel(
      id: 'travel2',
      userId: 'user1',
      username: 'TravelBlogger',
      userProfileImage: 'https://example.com/avatar1.jpg',
      title: 'Mediterranean Coast',
      description: 'Scenic views of the Mediterranean coastline',
      steps: [
        PostStep(
          id: 'step1',
          type: StepType.image,
          title: 'Coastal Landscape',
          imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1473&q=80',
        )
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      updatedAt: DateTime.now().subtract(const Duration(days: 8)),
      likes: [],
      comments: [],
      status: PostStatus.published,
      ratings: [],
      userTraits: [],
    ),
  ];

  @override
  Future<List<ProjectModel>> getProjects() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    
    // For development: ensure Photography Collection appears first
    final projects = List<ProjectModel>.from(_projects);
    final photographyIndex = projects.indexWhere((p) => p.id == '1');
    if (photographyIndex > 0) {
      final photography = projects.removeAt(photographyIndex);
      projects.insert(0, photography);
    }
    return projects;
  }

  @override
  Future<ProjectModel> getProject(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _projects.firstWhere(
      (project) => project.id == id,
      orElse: () => throw Exception('Project not found'),
    );
  }

  @override
  Future<List<ProjectModel>> getProjectsByUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _projects.where((project) => project.creatorId == userId).toList();
  }

  @override
  Future<ProjectModel> createProject(ProjectModel project) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _projects.add(project);
    return project;
  }

  @override
  Future<void> updateProject(ProjectModel project) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index == -1) {
      throw Exception('Project not found');
    }
    _projects[index] = project;
  }

  @override
  Future<void> deleteProject(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _projects.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw Exception('Project not found');
    }
    _projects.removeAt(index);
  }

  @override
  Future<void> addPostToProject(String projectId, String postId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final project = await getProject(projectId);
    if (!project.postIds.contains(postId)) {
      final updatedProject = project.copyWith(
        postIds: [...project.postIds, postId],
        updatedAt: DateTime.now(),
      );
      await updateProject(updatedProject);
    }
  }

  @override
  Future<void> removePostFromProject(String projectId, String postId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final project = await getProject(projectId);
    if (project.postIds.contains(postId)) {
      final updatedProject = project.copyWith(
        postIds: project.postIds.where((id) => id != postId).toList(),
        updatedAt: DateTime.now(),
      );
      await updateProject(updatedProject);
    }
  }

  // New method to get posts for a project
  Future<List<PostModel>> getProjectPosts(String projectId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final project = await getProject(projectId);
    return _mockPosts.where((post) => project.postIds.contains(post.id)).toList();
  }
}
