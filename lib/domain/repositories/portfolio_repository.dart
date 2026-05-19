import '../entities/entities.dart';

abstract class PortfolioRepository {
  Future<List<ProjectEntity>> getProjects();
  Future<List<SkillEntity>> getSkills();
  Future<List<ExperienceEntity>> getExperiences();
  Future<List<ToolEntity>> getTools();
}
