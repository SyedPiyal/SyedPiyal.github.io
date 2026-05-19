import 'package:flutter/material.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/portfolio_repository.dart';

class PortfolioNotifier extends ChangeNotifier {
  final PortfolioRepository repository;

  PortfolioNotifier({required this.repository});

  // State Variables
  bool _isMobileFrame = true; // Default view is the beautiful simulated OS frame!
  String _activeDeviceType = 'iOS'; // 'iOS' or 'Android'
  String? _activeSimulatedApp; // App name that is currently opened inside the phone (null = Home Screen)
  bool _isLoading = true;
  bool _isHoveringInteractive = false;

  List<ProjectEntity> _projects = [];
  List<SkillEntity> _skills = [];
  List<ExperienceEntity> _experiences = [];
  List<ToolEntity> _tools = [];

  // Getters
  bool get isMobileFrame => _isMobileFrame;
  String get activeDeviceType => _activeDeviceType;
  String? get activeSimulatedApp => _activeSimulatedApp;
  bool get isLoading => _isLoading;
  bool get isHoveringInteractive => _isHoveringInteractive;

  List<ProjectEntity> get projects => _projects;
  List<SkillEntity> get skills => _skills;
  List<ExperienceEntity> get experiences => _experiences;
  List<ToolEntity> get tools => _tools;

  // Actions
  Future<void> loadPortfolioData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Parallel loading of clean domain repository parameters
      final results = await Future.wait([
        repository.getProjects(),
        repository.getSkills(),
        repository.getExperiences(),
        repository.getTools(),
      ]);

      _projects = results[0] as List<ProjectEntity>;
      _skills = results[1] as List<SkillEntity>;
      _experiences = results[2] as List<ExperienceEntity>;
      _tools = results[3] as List<ToolEntity>;
    } catch (e) {
      debugPrint("Error loading portfolio: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleLayoutMode() {
    _isMobileFrame = !_isMobileFrame;
    notifyListeners();
  }

  void setMobileFrameMode(bool isMobile) {
    _isMobileFrame = isMobile;
    notifyListeners();
  }

  void changeDeviceType(String type) {
    if (type == 'iOS' || type == 'Android') {
      _activeDeviceType = type;
      notifyListeners();
    }
  }

  void openApp(String appName) {
    _activeSimulatedApp = appName;
    notifyListeners();
  }

  void closeApp() {
    _activeSimulatedApp = null;
    notifyListeners();
  }

  void setHoveringInteractive(bool hovering) {
    if (_isHoveringInteractive != hovering) {
      _isHoveringInteractive = hovering;
      notifyListeners();
    }
  }
}
