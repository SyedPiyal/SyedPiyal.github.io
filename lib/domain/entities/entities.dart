class ProjectEntity {
  final String id;
  final String title;
  final String description;
  final List<String> tags;
  final String url;
  final String imageUrl;

  const ProjectEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
    required this.url,
    required this.imageUrl,
  });
}

class SkillEntity {
  final String name;
  final String category; // 'Frontend', 'Backend', 'Tools', etc.
  final double level; // Value between 0.0 and 1.0 representing proficiency
  final String colorHex; // e.g. '#6C22D6'

  const SkillEntity({
    required this.name,
    required this.category,
    required this.level,
    required this.colorHex,
  });
}

class ExperienceEntity {
  final String id;
  final String role;
  final String company;
  final String duration;
  // final List<String> descriptionPoints;
  final String jobDescription;
  final List<String> keyContributions;
  final List<String> technologiesUsed;
  final String iconName; // e.g. 'work', 'school'
  final String colorHex;

  const ExperienceEntity({
    required this.id,
    required this.role,
    required this.company,
    required this.duration,
    // required this.descriptionPoints,
    required this.jobDescription,
    required this.keyContributions,
    required this.technologiesUsed,
    required this.iconName,
    required this.colorHex,
  });
}

class ToolEntity {
  final String name;
  final String category; // e.g. 'IDE', 'Design', 'VCS'
  final String iconAsset; // Flutter Icon name or SVG path / Image asset
  final String colorHex;

  const ToolEntity({
    required this.name,
    required this.category,
    required this.iconAsset,
    required this.colorHex,
  });
}
