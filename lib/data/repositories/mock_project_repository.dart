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
      postIds: ['post_0', 'post_1', 'post_2'],  // Updated to match TestDataService IDs
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now(),
    ),
    ProjectModel(
      id: '2',
      name: 'Travel Adventures',
      description: 'Documenting my travels across Europe',
      creatorId: 'user1',
      postIds: ['post_3', 'post_4'],  // Updated to match TestDataService IDs
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
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
}
