import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/cosmic_theme.dart';
import '../../domain/entities/entities.dart';
import '../state/portfolio_notifier.dart';
import '../state/snake_game_controller.dart';
import '../state/tictactoe_controller.dart';
import 'package:portfolio/widgets/app_window_wrapper.dart';

class MobileLauncherPage extends StatefulWidget {
  final PortfolioNotifier notifier;

  const MobileLauncherPage({super.key, required this.notifier});

  @override
  State<MobileLauncherPage> createState() => _MobileLauncherPageState();
}

class _MobileLauncherPageState extends State<MobileLauncherPage> {
  // Game Controllers
  late SnakeGameController _snakeController;
  late TicTacToeController _tictacController;

  @override
  void initState() {
    super.initState();
    _snakeController = SnakeGameController();
    _tictacController = TicTacToeController();
  }

  @override
  void dispose() {
    _snakeController.dispose();
    _tictacController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? activeApp = widget.notifier.activeSimulatedApp;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 1. HOME SCREEN BACKGROUND WALLPAPER
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF04030F),
                    Color(0xFF0F0B2D),
                    Color(0xFF070414),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Subtle Wallpaper Abstract Nebula Glow
          Positioned(
            top: 100,
            left: 50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: CosmicTheme.primaryPurple.withOpacity(0.15),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          // 2. TOP STATUS BAR (Time, Wi-Fi, Battery)
          Positioned(
            top: widget.notifier.activeDeviceType == 'iOS' ? 14 : 10,
            left: 0,
            right: 0,
            child: _buildStatusBar(),
          ),

          // 3. MAIN LAUNCHER GRID (Icon apps)
          Positioned.fill(top: 60, bottom: 90, child: _buildAppGrid()),

          // 4. BOTTOM FLOATING DOCK BAR
          Positioned(bottom: 20, left: 20, right: 20, child: _buildDockBar()),

          // 5. SLIDING APP WINDOW (Rendered on top if activeApp != null)
          if (activeApp != null)
            Positioned.fill(
              top: widget.notifier.activeDeviceType == 'iOS' ? 44 : 36,
              bottom: widget.notifier.activeDeviceType == 'iOS' ? 20 : 10,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: AppWindowWrapper(
                  title: activeApp,
                  onClose: () {
                    widget.notifier.closeApp();
                    _snakeController.resetGame();
                    _tictacController.resetGame();
                  },
                  themeColor: _getAppThemeColor(activeApp),
                  child: _loadActiveAppView(activeApp),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // --- STATS & LAUNCHER WIDGETS ---
  Widget _buildStatusBar() {
    bool isIos = widget.notifier.activeDeviceType == 'iOS';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isIos ? 28 : 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Current Time
          Text(
            '16:30',
            style: GoogleFonts.shareTechMono(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Right: Status Icons
          Row(
            children: [
              const Icon(
                Icons.signal_cellular_alt,
                size: 12,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              const Icon(Icons.wifi, size: 12, color: Colors.white),
              const SizedBox(width: 6),
              Container(
                width: 20,
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: Colors.white, width: 1.0),
                ),
                padding: const EdgeInsets.all(1),
                child: Container(width: 14, height: 6, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppGrid() {
    final List<Map<String, dynamic>> apps = [
      {
        'name': 'ABOUT',
        'icon': Icons.person_outline,
        'color': CosmicTheme.primaryPurple,
      },
      {
        'name': 'SKILLS',
        'icon': Icons.extension_outlined,
        'color': CosmicTheme.neonCyan,
      },
      {
        'name': 'PROJECTS',
        'icon': Icons.folder_open_outlined,
        'color': CosmicTheme.cyberPink,
      },
      {
        'name': 'TOOLS',
        'icon': Icons.terminal_outlined,
        'color': CosmicTheme.neonGreen,
      },
      {
        'name': 'EXPERIENCE',
        'icon': Icons.history_edu_outlined,
        'color': CosmicTheme.electricBlue,
      },
      {
        'name': 'SETTINGS',
        'icon': Icons.settings_outlined,
        'color': Colors.grey,
      },
      // {'name': 'TIC-TAC-TOE', 'icon': Icons.grid_on_outlined, 'color': Colors.orange},
      // {'name': 'SNAKE GAME', 'icon': Icons.sports_esports_outlined, 'color': const Color(0xFFC70039)},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 24,
          crossAxisSpacing: 16,
          childAspectRatio: 0.52,
        ),
        itemCount: apps.length,
        itemBuilder: (context, index) {
          final app = apps[index];
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => widget.notifier.setHoveringInteractive(true),
            onExit: (_) => widget.notifier.setHoveringInteractive(false),
            child: GestureDetector(
              onTap: () => widget.notifier.openApp(app['name']),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Beautiful Rounded Glow Icon
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: app['color'].withOpacity(0.3),
                        width: 1.0,
                      ),
                    ),
                    child: Icon(app['icon'], color: app['color'], size: 26),
                  ),
                  const SizedBox(height: 8),

                  // App Name Label
                  Text(
                    app['name'],
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.shareTechMono(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDockBar() {
    // Dock shortcuts for social launcher
    final List<Map<String, dynamic>> shortcuts = [
      {'name': 'GitHub', 'icon': Icons.code, 'url': 'https://github.com/syed'},
      {
        'name': 'LinkedIn',
        'icon': Icons.business_center,
        'url': 'https://linkedin.com/in/syed',
      },
      {
        'name': 'Email',
        'icon': Icons.mail,
        'url': 'mailto:syed.flutter@gmail.com',
      },
    ];

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.06), width: 1.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: shortcuts.map((item) {
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => widget.notifier.setHoveringInteractive(true),
            onExit: (_) => widget.notifier.setHoveringInteractive(false),
            child: GestureDetector(
              onTap: () async {
                final uri = Uri.parse(item['url']);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1.0,
                  ),
                ),
                child: Icon(item['icon'], color: Colors.white, size: 20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getAppThemeColor(String appName) {
    switch (appName) {
      case 'ABOUT':
        return CosmicTheme.primaryPurple;
      case 'SKILLS':
        return CosmicTheme.neonCyan;
      case 'PROJECTS':
        return CosmicTheme.cyberPink;
      case 'TOOLS':
        return CosmicTheme.neonGreen;
      case 'EXPERIENCE':
        return CosmicTheme.electricBlue;
      case 'SETTINGS':
        return Colors.grey;
      default:
        return Colors.purple;
    }
  }

  // --- APP VIEWS DISPATCHER ---
  Widget _loadActiveAppView(String appName) {
    switch (appName) {
      case 'ABOUT':
        return _buildAboutApp();
      case 'SKILLS':
        return _buildSkillsApp();
      case 'PROJECTS':
        return _buildProjectsApp();
      case 'TOOLS':
        return _buildToolsApp();
      case 'EXPERIENCE':
        return _buildExperienceApp();
      case 'SETTINGS':
        return _buildSettingsApp();
      case 'TIC-TAC-TOE':
        return _buildTicTacToeApp();
      case 'SNAKE GAME':
        return _buildSnakeGameApp();
      default:
        return const Center(child: Text("App content placeholder"));
    }
  }

  // --- INDIVIDUAL APP IMPLEMENTATIONS ---

  // 1. ABOUT SLIDER APP
  Widget _buildAboutApp() {
    final List<Map<String, String>> slides = [
      {
        'header': 'CREATIVE MIND',
        'body':
            'I am Syed, a creative Flutter Architect. I love translating futuristic designs and gaming interfaces into fast, beautiful cross-platform code.',
      },
      {
        'header': 'CLEAN STANDARDS',
        'body':
            'Decoupled systems, test-driven pipelines, and strict Clean Architecture interfaces are my foundational guidelines for development.',
      },
      {
        'header': 'DOCK & SIMULATE',
        'body':
            'This entire website serves as an interactive proof-of-concept for high-performance interactive widgets built entirely inside Flutter Web canvas.',
      },
    ];

    return Container(
      color: const Color(0xFF060515),
      child: DefaultTabController(
        length: slides.length,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: slides.map((slide) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Slide Avatar Glow
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: CosmicTheme.primaryPurple,
                              width: 2.0,
                            ),
                            boxShadow: CosmicTheme.neonGlow(
                              color: CosmicTheme.primaryPurple,
                              blur: 15,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.face,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        Text(
                          slide['header']!,
                          style: GoogleFonts.orbitron(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Text(
                          slide['body']!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12,
                            height: 1.6,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const TabPageSelector(
                color: Colors.white10,
                selectedColor: CosmicTheme.primaryPurple,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 2. SKILLS PILLS APP
  Widget _buildSkillsApp() {
    return Container(
      color: const Color(0xFF040614),
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: widget.notifier.skills.length,
        itemBuilder: (context, index) {
          final skill = widget.notifier.skills[index];
          Color skillColor = Color(
            int.parse(skill.colorHex.replaceFirst('#', '0xFF')),
          );
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.015),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: skillColor.withOpacity(0.12),
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      skill.name,
                      style: GoogleFonts.shareTechMono(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${(skill.level * 100).toInt()}%',
                      style: GoogleFonts.shareTechMono(
                        color: skillColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: skill.level,
                    child: Container(color: skillColor),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 3. PROJECTS SHOWCASE APP
  Widget _buildProjectsApp() {
    return Container(
      color: const Color(0xFF06030F),
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: widget.notifier.projects.length,
        itemBuilder: (context, index) {
          final project = widget.notifier.projects[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.015),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: CosmicTheme.cyberPink.withOpacity(0.15),
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title.toUpperCase(),
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  project.description,
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.45),
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: project.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: CosmicTheme.cyberPink.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                          color: CosmicTheme.cyberPink.withOpacity(0.15),
                          width: 0.6,
                        ),
                      ),
                      child: Text(
                        tag.toUpperCase(),
                        style: GoogleFonts.shareTechMono(
                          color: CosmicTheme.cyberPink,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 4. TOOLS GRID APP
  Widget _buildToolsApp() {
    return Container(
      color: const Color(0xFF04060E),
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: widget.notifier.tools.length,
        itemBuilder: (context, index) {
          final tool = widget.notifier.tools[index];
          Color toolColor = Color(
            int.parse(tool.colorHex.replaceFirst('#', '0xFF')),
          );

          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.01),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: toolColor.withOpacity(0.15),
                width: 1.0,
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.terminal_outlined, color: toolColor, size: 24),
                const SizedBox(height: 12),
                Text(
                  tool.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.shareTechMono(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tool.category,
                  style: GoogleFonts.shareTechMono(
                    color: Colors.white30,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 5. EXPERIENCE APP (Timeline)
  Widget _buildExperienceApp() {
    return Container(
      color: const Color(0xFF030514),
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: widget.notifier.experiences.length,
        itemBuilder: (context, index) {
          final exp = widget.notifier.experiences[index];
          Color expColor = Color(
            int.parse(exp.colorHex.replaceFirst('#', '0xFF')),
          );
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: expColor, width: 2.0)),
              color: Colors.white.withOpacity(0.01),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exp.duration,
                  style: GoogleFonts.shareTechMono(
                    color: expColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  exp.role,
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  exp.company,
                  style: GoogleFonts.shareTechMono(
                    color: Colors.white60,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),

                // Job Description
                if (exp.jobDescription.isNotEmpty) ...[
                  Text(
                    exp.jobDescription,
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 10,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Key Contributions
                if (exp.keyContributions.isNotEmpty) ...[
                  Text(
                    'KEY CONTRIBUTIONS',
                    style: GoogleFonts.shareTechMono(
                      color: expColor,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Column(
                    children: exp.keyContributions.map((point) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                width: 3,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: expColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                point,
                                style: GoogleFonts.inter(
                                  color: Colors.white.withOpacity(0.35),
                                  fontSize: 10,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                ],

                // Technologies Used
                if (exp.technologiesUsed.isNotEmpty) ...[
                  Text(
                    'TECHNOLOGIES USED',
                    style: GoogleFonts.shareTechMono(
                      color: expColor,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: exp.technologiesUsed.map((tech) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: expColor.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                            color: expColor.withOpacity(0.12),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          tech,
                          style: GoogleFonts.shareTechMono(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 9,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // 6. SETTINGS APP (Toggle Device Frame)
  Widget _buildSettingsApp() {
    String currentType = widget.notifier.activeDeviceType;
    return Container(
      color: const Color(0xFF0F0F14),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DEVICE SETTINGS',
            style: GoogleFonts.shareTechMono(
              color: Colors.white30,
              fontSize: 11,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 24),

          _buildSettingsToggle(
            title: 'iOS Vector Frame',
            subtitle: 'iPhone shell, Dynamic Island',
            isActive: currentType == 'iOS',
            onTap: () => widget.notifier.changeDeviceType('iOS'),
          ),
          const SizedBox(height: 16),

          _buildSettingsToggle(
            title: 'Android Vector Frame',
            subtitle: 'Samsung micro-bezel shell',
            isActive: currentType == 'Android',
            onTap: () => widget.notifier.changeDeviceType('Android'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsToggle({
    required String title,
    required String subtitle,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => widget.notifier.setHoveringInteractive(true),
      onExit: (_) => widget.notifier.setHoveringInteractive(false),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white.withOpacity(0.04)
                : Colors.white.withOpacity(0.01),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? CosmicTheme.primaryPurple.withOpacity(0.3)
                  : Colors.white.withOpacity(0.05),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.shareTechMono(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: Colors.white30,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              Icon(
                isActive ? Icons.radio_button_checked : Icons.radio_button_off,
                color: isActive ? CosmicTheme.primaryPurple : Colors.white24,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 7. TIC-TAC-TOE MINI APP
  Widget _buildTicTacToeApp() {
    return AnimatedBuilder(
      animation: _tictacController,
      builder: (context, child) {
        return Container(
          color: const Color(0xFF0F0B06),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Score details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'YOU (X)',
                    style: GoogleFonts.shareTechMono(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _tictacController.winner == ''
                        ? 'PLAYER ${_tictacController.currentPlayer}\'S TURN'
                        : _tictacController.winner == 'Draw'
                        ? 'MATCH DRAW'
                        : 'WINNER: ${_tictacController.winner}',
                    style: GoogleFonts.shareTechMono(
                      color: Colors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    'AI (O)',
                    style: GoogleFonts.shareTechMono(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // TicTacToe Grid Board
              AspectRatio(
                aspectRatio: 1.0,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: 9,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final cell = _tictacController.board[index];
                    return MouseRegion(
                      cursor: cell == ''
                          ? SystemMouseCursors.click
                          : SystemMouseCursors.basic,
                      onEnter: (_) => cell == ''
                          ? widget.notifier.setHoveringInteractive(true)
                          : null,
                      onExit: (_) =>
                          widget.notifier.setHoveringInteractive(false),
                      child: GestureDetector(
                        onTap: () => _tictacController.makeMove(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.02),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: cell == 'X'
                                  ? CosmicTheme.neonCyan.withOpacity(0.4)
                                  : cell == 'O'
                                  ? Colors.orange.withOpacity(0.4)
                                  : Colors.white.withOpacity(0.04),
                              width: 1.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              cell,
                              style: GoogleFonts.orbitron(
                                color: cell == 'X'
                                    ? CosmicTheme.neonCyan
                                    : Colors.orange,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Reset Match Button
              ElevatedButton(
                onPressed: () => _tictacController.resetGame(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'RESET GAME',
                  style: GoogleFonts.shareTechMono(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 8. SNAKE RETRO APP
  Widget _buildSnakeGameApp() {
    return AnimatedBuilder(
      animation: _snakeController,
      builder: (context, child) {
        return Container(
          color: const Color(0xFF0F0606),
          child: Column(
            children: [
              // Score bar
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white.withOpacity(0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SCORE: ${_snakeController.score}',
                      style: GoogleFonts.shareTechMono(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'HIGH: ${_snakeController.highScore}',
                      style: GoogleFonts.shareTechMono(
                        color: const Color(0xFFC70039),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Arcade screen
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFC70039).withOpacity(0.2),
                          width: 1.0,
                        ),
                      ),
                      child:
                          _snakeController.gameState == SnakeGameState.gameOver
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'GAME OVER',
                                    style: GoogleFonts.orbitron(
                                      color: const Color(0xFFC70039),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () =>
                                        _snakeController.startGame(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFC70039),
                                    ),
                                    child: Text(
                                      'PLAY AGAIN',
                                      style: GoogleFonts.shareTechMono(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : _snakeController.gameState == SnakeGameState.idle
                          ? Center(
                              child: ElevatedButton(
                                onPressed: () => _snakeController.startGame(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC70039),
                                ),
                                child: Text(
                                  'START MATCH',
                                  style: GoogleFonts.shareTechMono(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : CustomPaint(
                              painter: SnakeGridPainter(
                                snake: _snakeController.snakeBody,
                                food: _snakeController.food,
                              ),
                            ),
                    ),
                  ),
                ),
              ),

              // D-PAD CONTROLLER OVERLAY (For in-device gameplay)
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // UP button
                      _buildDpadButton(
                        icon: Icons.keyboard_arrow_up,
                        onTap: () =>
                            _snakeController.changeDirection(SnakeDirection.up),
                      ),

                      // LEFT & RIGHT buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildDpadButton(
                            icon: Icons.keyboard_arrow_left,
                            onTap: () => _snakeController.changeDirection(
                              SnakeDirection.left,
                            ),
                          ),
                          const SizedBox(width: 48),
                          _buildDpadButton(
                            icon: Icons.keyboard_arrow_right,
                            onTap: () => _snakeController.changeDirection(
                              SnakeDirection.right,
                            ),
                          ),
                        ],
                      ),

                      // DOWN button
                      _buildDpadButton(
                        icon: Icons.keyboard_arrow_down,
                        onTap: () => _snakeController.changeDirection(
                          SnakeDirection.down,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDpadButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => widget.notifier.setHoveringInteractive(true),
      onExit: (_) => widget.notifier.setHoveringInteractive(false),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1.0,
            ),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}

class SnakeGridPainter extends CustomPainter {
  final List<Point<int>> snake;
  final Point<int> food;

  SnakeGridPainter({required this.snake, required this.food});

  @override
  void paint(Canvas canvas, Size size) {
    final double cellSize = size.width / SnakeGameController.gridSize;

    // Draw Food (glowing pink dot)
    final foodPaint = Paint()
      ..color = const Color(0xFFFE0E85)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(
        food.x * cellSize + cellSize / 2,
        food.y * cellSize + cellSize / 2,
      ),
      cellSize / 2.2,
      foodPaint,
    );

    // Draw Snake Body
    for (int i = 0; i < snake.length; i++) {
      final cell = snake[i];
      final paint = Paint()
        ..color = i == 0
            ? const Color(0xFF39FF14) // Neon green head
            : const Color(0xFF2EB80D) // Darker green body
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            cell.x * cellSize + 1,
            cell.y * cellSize + 1,
            cellSize - 2,
            cellSize - 2,
          ),
          const Radius.circular(3),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
