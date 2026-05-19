import '../../domain/entities/entities.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.title,
    required super.description,
    required super.tags,
    required super.url,
    required super.imageUrl,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      tags: List<String>.from(json['tags'] as List),
      url: json['url'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'tags': tags,
      'url': url,
      'imageUrl': imageUrl,
    };
  }
}

class SkillModel extends SkillEntity {
  const SkillModel({
    required super.name,
    required super.category,
    required super.level,
    required super.colorHex,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      name: json['name'] as String,
      category: json['category'] as String,
      level: (json['level'] as num).toDouble(),
      colorHex: json['colorHex'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'level': level,
      'colorHex': colorHex,
    };
  }
}

class ExperienceModel extends ExperienceEntity {
  const ExperienceModel({
    required super.id,
    required super.role,
    required super.company,
    required super.duration,
    // required super.descriptionPoints,
    required super.jobDescription,
    required super.keyContributions,
    required super.technologiesUsed,
    required super.iconName,
    required super.colorHex,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      id: json['id'] as String,
      role: json['role'] as String,
      company: json['company'] as String,
      duration: json['duration'] as String,
      // descriptionPoints: List<String>.from(json['descriptionPoints'] as List? ?? []),
      jobDescription: json['jobDescription'] as String? ?? '',
      keyContributions: List<String>.from(json['keyContributions'] as List? ?? []),
      technologiesUsed: List<String>.from(json['technologiesUsed'] as List? ?? []),
      iconName: json['iconName'] as String,
      colorHex: json['colorHex'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'company': company,
      'duration': duration,
      // 'descriptionPoints': descriptionPoints,
      'jobDescription': jobDescription,
      'keyContributions': keyContributions,
      'technologiesUsed': technologiesUsed,
      'iconName': iconName,
      'colorHex': colorHex,
    };
  }
}

class ToolModel extends ToolEntity {
  const ToolModel({
    required super.name,
    required super.category,
    required super.iconAsset,
    required super.colorHex,
  });

  factory ToolModel.fromJson(Map<String, dynamic> json) {
    return ToolModel(
      name: json['name'] as String,
      category: json['category'] as String,
      iconAsset: json['iconAsset'] as String,
      colorHex: json['colorHex'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'iconAsset': iconAsset,
      'colorHex': colorHex,
    };
  }
}
