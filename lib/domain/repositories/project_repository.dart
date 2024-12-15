import '../../data/models/project_model.dart';

abstract class ProjectRepository {
  Future<List<ProjectModel>> getProjects();
  Future<ProjectModel> getProject(String id);
  Future<List<ProjectModel>> getProjectsByUser(String userId);
  Future<ProjectModel> createProject(ProjectModel project);
  Future<void> updateProject(ProjectModel project);
  Future<void> deleteProject(String id);
  Future<void> addPostToProject(String projectId, String postId);
  Future<void> removePostFromProject(String projectId, String postId);
}
