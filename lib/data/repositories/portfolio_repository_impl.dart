import '../../domain/entities/entities.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../datasources/static_datasource.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final StaticPortfolioDataSource dataSource;

  const PortfolioRepositoryImpl({required this.dataSource});

  @override
  Future<List<ProjectEntity>> getProjects() async {
    // Artificial latency to simulate active background fetch / loader testing
    await Future.delayed(const Duration(milliseconds: 500));
    return dataSource.getProjects();
  }

  @override
  Future<List<SkillEntity>> getSkills() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return dataSource.getSkills();
  }

  @override
  Future<List<ExperienceEntity>> getExperiences() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return dataSource.getExperiences();
  }

  @override
  Future<List<ToolEntity>> getTools() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return dataSource.getTools();
  }
}
