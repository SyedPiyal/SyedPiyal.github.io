import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/cosmic_theme.dart';
import '../../domain/entities/entities.dart';
import '../state/portfolio_notifier.dart';
import '../widgets/device_frame.dart';
import 'mobile_launcher_page.dart';

class WebLandingPage extends StatefulWidget {
  final PortfolioNotifier notifier;

  const WebLandingPage({super.key, required this.notifier});

  @override
  State<WebLandingPage> createState() => _WebLandingPageState();
}

class _WebLandingPageState extends State<WebLandingPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  
  // Section keys for precise scrolling
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  late AnimationController _typeController;
  int _typeIndex = 0;
  String _typedText = '';
  final List<String> _titles = [
    'A CREATIVE FLUTTER ARCHITECT.',
    'AN EXPERT CROSS-PLATFORM DEVELOPER.',
    'A BUILDER OF IMMERSIVE EXPERIENCES.',
  ];

  @override
  void initState() {
    super.initState();
    _typeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _animateTypewriter();
  }

  void _animateTypewriter() async {
    while (mounted) {
      String fullText = _titles[_typeIndex];
      // Type in
      for (int i = 0; i <= fullText.length; i++) {
        if (!mounted) return;
        setState(() {
          _typedText = fullText.substring(0, i);
        });
        await Future.delayed(const Duration(milliseconds: 60));
      }
      await Future.delayed(const Duration(milliseconds: 1500));

      // Type out
      for (int i = fullText.length; i >= 0; i--) {
        if (!mounted) return;
        setState(() {
          _typedText = fullText.substring(0, i);
        });
        await Future.delayed(const Duration(milliseconds: 30));
      }
      await Future.delayed(const Duration(milliseconds: 500));

      _typeIndex = (_typeIndex + 1) % _titles.length;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 850),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWide = screenWidth > 900;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Scrollable layout contents
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: 100), // Spacing for Navbar
                // HERO SECTION
                _buildHeroSection(screenWidth),

                // WHAT I OFFER SECTION
                _buildServicesSection(screenWidth),

                // PROJECTS WALL SECTION
                _buildProjectsSection(screenWidth),

                // EXPERIENCE TIMELINE
                _buildExperienceSection(screenWidth),

                // SKILLS & TECH SECTION
                _buildSkillsSection(screenWidth),

                // FOOTER & CONTACT
                _buildFooterSection(screenWidth),
              ],
            ),
          ),

          // STICKY NAVBAR
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildNavbar(isWide, screenWidth),
          ),
        ],
      ),
    );
  }

  // 1. Sticky Navbar
  Widget _buildNavbar(bool isWide, double screenWidth) {
    // Choose logo text based on screen width
    String logoText = 'SYED ANAMUL HAQUE PIYAL';
    double logoFontSize = 22;
    double logoLetterSpacing = 4.0;

    if (screenWidth < 600) {
      logoText = 'SYED';
      logoFontSize = 18;
      logoLetterSpacing = 2.0;
    } else if (screenWidth < 1100) {
      logoText = 'SYED PIYAL';
      logoFontSize = 18;
      logoLetterSpacing = 3.0;
    }

    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: screenWidth < 1200 ? 24 : 48),
      decoration: BoxDecoration(
        color: CosmicTheme.spaceBlack.withOpacity(0.85),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.04), width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo Syed
          Row(
            children: [
              Text(
                logoText,
                style: GoogleFonts.orbitron(
                  fontSize: logoFontSize,
                  fontWeight: FontWeight.bold,
                  letterSpacing: logoLetterSpacing,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: CosmicTheme.neonCyan,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),

          // Navigation Actions
          if (isWide && screenWidth > 1200)
            Row(
              children: [
                _buildNavLink('SERVICES', () => _scrollToSection(_servicesKey)),
                const SizedBox(width: 32),
                _buildNavLink('PROJECTS', () => _scrollToSection(_projectsKey)),
                const SizedBox(width: 32),
                _buildNavLink('EXPERIENCE', () => _scrollToSection(_experienceKey)),
                const SizedBox(width: 32),
                _buildNavLink('SKILLS', () => _scrollToSection(_skillsKey)),
              ],
            ),

          // Layout Mode Selector Button (Pill toggle to simulate OS)
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => widget.notifier.setHoveringInteractive(true),
            onExit: (_) => widget.notifier.setHoveringInteractive(false),
            child: GestureDetector(
              onTap: () => widget.notifier.toggleLayoutMode(),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth < 600 ? 10 : 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [CosmicTheme.primaryPurple, CosmicTheme.cyberPink],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: CosmicTheme.neonGlow(
                    color: CosmicTheme.primaryPurple,
                    blur: 10,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.phone_android,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      screenWidth < 600 ? 'SIMULATE' : 'SIMULATE OS FRAME',
                      style: GoogleFonts.shareTechMono(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavLink(String title, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => widget.notifier.setHoveringInteractive(true),
      onExit: (_) => widget.notifier.setHoveringInteractive(false),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          title,
          style: GoogleFonts.shareTechMono(
            color: Colors.white.withOpacity(0.7),
            fontSize: 13,
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 2. Hero Section
  Widget _buildHeroSection(double width) {
    bool isWide = width > 950;

    Widget leftColumn = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hello Prefix
        Text(
          'HELLO WORLD, I\'M',
          style: GoogleFonts.shareTechMono(
            color: CosmicTheme.neonCyan,
            fontSize: 16,
            letterSpacing: 6.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Name Header
        Text(
          'PIYAL',
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontSize: width > 800 ? 55 : 45,
            fontWeight: FontWeight.w900,
            letterSpacing: 4.0,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 16),

        // Typewriter title
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _typedText,
              style: GoogleFonts.orbitron(
                color: Colors.white.withOpacity(0.85),
                fontSize: width > 800 ? 24 : 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            // Blinking cursor
            AnimatedOpacity(
              opacity: _typedText.length % 2 == 0 ? 1.0 : 0.0,
              duration: Duration.zero,
              child: Text(
                '|',
                style: GoogleFonts.orbitron(
                  color: CosmicTheme.neonCyan,
                  fontSize: width > 800 ? 24 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 36),

        // Creative bio statement
        SizedBox(
          width: isWide ? 500 : width * 0.8,
          child: Text(
            'A self-taught software craftsperson building beautifully interactive, responsive, and performance-tuned applications using Flutter frameworks. Specialized in writing clean architecture models, pixel-perfect design systems, and custom physics renderers.',
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.55),
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 48),

        // CTAs
        Wrap(
          spacing: 24,
          runSpacing: 16,
          children: [
            ElevatedButton(
              onPressed: () => _scrollToSection(_projectsKey),
              style: ElevatedButton.styleFrom(
                backgroundColor: CosmicTheme.primaryPurple,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'BROWSE PROJECTS',
                style: GoogleFonts.shareTechMono(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () => _scrollToSection(_contactKey),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withOpacity(0.2)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'CONTACT ME',
                style: GoogleFonts.shareTechMono(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ],
    );

    if (!isWide) {
      return Container(
        width: width,
        height: 600,
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: leftColumn,
      );
    }

    // Wide Layout: Left text details, Right beautiful mobile emulator launcher screen!
    return Container(
      width: width,
      height: 650, // Slightly taller to fit the phone screen comfortably
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 3, child: leftColumn),
          const SizedBox(width: 48),
          Expanded(
            flex: 2,
            child: DeviceFrame(
              height: 580,
              deviceType: widget.notifier.activeDeviceType,
              themeColor: widget.notifier.activeSimulatedApp == 'SNAKE GAME'
                  ? const Color(0xFFC70039)
                  : CosmicTheme.primaryPurple,
              child: MobileLauncherPage(notifier: widget.notifier),
            ),
          ),
        ],
      ),
    );
  }

  // 3. Services / "What I Offer" Section
  Widget _buildServicesSection(double width) {
    bool isWide = width > 900;
    return Container(
      key: _servicesKey,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('01 / WHAT I OFFER'),
          const SizedBox(height: 50),

          // Layout Content
          if (isWide)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildServiceCard(
                      icon: Icons.phone_android,
                      title: 'Cross-Platform Apps',
                      description:
                          'Crafting pixel-perfect, highly responsive, native apps across Android, iOS, and Web using a single Flutter codebase.',
                      accentColor: CosmicTheme.primaryPurple,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildServiceCard(
                      icon: Icons.brush,
                      title: 'Interactive Canvas UI',
                      description:
                          'Building custom vector paint components, fluid physics loops, custom charting packages, and gorgeous page transition dynamics.',
                      accentColor: CosmicTheme.neonCyan,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildServiceCard(
                      icon: Icons.layers,
                      title: 'Clean Architecture Design',
                      description:
                          'Applying strict Domain-Driven clean structures, decoupled state notifications, automated mock pipelines, and modular testing parameters.',
                      accentColor: CosmicTheme.cyberPink,
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: [
                _buildServiceCard(
                  icon: Icons.phone_android,
                  title: 'Cross-Platform Apps',
                  description:
                      'Crafting pixel-perfect, highly responsive, native apps across Android, iOS, and Web using a single Flutter codebase.',
                  accentColor: CosmicTheme.primaryPurple,
                ),
                const SizedBox(height: 24),
                _buildServiceCard(
                  icon: Icons.brush,
                  title: 'Interactive Canvas UI',
                  description:
                      'Building custom vector paint components, fluid physics loops, custom charting packages, and gorgeous page transition dynamics.',
                  accentColor: CosmicTheme.neonCyan,
                ),
                const SizedBox(height: 24),
                _buildServiceCard(
                  icon: Icons.layers,
                  title: 'Clean Architecture Design',
                  description:
                      'Applying strict Domain-Driven clean structures, decoupled state notifications, automated mock pipelines, and modular testing parameters.',
                  accentColor: CosmicTheme.cyberPink,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required String description,
    required Color accentColor,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallCard = screenWidth < 1200;

    return Container(
      padding: EdgeInsets.all(isSmallCard ? 20 : 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: CosmicTheme.cardRadius,
        border: CosmicTheme.glassBorder(
          accentColor: accentColor,
          opacity: 0.15,
        ),
      ),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: accentColor, size: isSmallCard ? 28 : 36),
            SizedBox(height: isSmallCard ? 16 : 24),
            Text(
              title.toUpperCase(),
              style: GoogleFonts.orbitron(
                color: Colors.white,
                fontSize: isSmallCard ? 15 : 18,
                fontWeight: FontWeight.bold,
                letterSpacing: isSmallCard ? 0.5 : 1.0,
              ),
            ),
            SizedBox(height: isSmallCard ? 12 : 16),
            Text(
              description,
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.5),
                fontSize: isSmallCard ? 13 : 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    ));
  }

  // 4. Projects Showcase Section
  Widget _buildProjectsSection(double width) {
    bool isWide = width > 900;
    return Container(
      key: _projectsKey,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('02 / FEATURED PROJECTS'),
          const SizedBox(height: 50),

          // Project Masonry
          if (isWide)
            Column(
              children: [
                for (int i = 0; i < widget.notifier.projects.length; i += 2)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 32),
                              child: _buildProjectCard(
                                widget.notifier.projects[i],
                                i,
                                isWide,
                              ),
                            ),
                          ),
                          if (i + 1 < widget.notifier.projects.length)
                            Expanded(
                              child: _buildProjectCard(
                                widget.notifier.projects[i + 1],
                                i + 1,
                                isWide,
                              ),
                            )
                          else
                            Expanded(child: Container()),
                        ],
                      ),
                    ),
                  ),
              ],
            )
          else
            Column(
              children: [
                for (int i = 0; i < widget.notifier.projects.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: _buildProjectCard(
                      widget.notifier.projects[i],
                      i,
                      isWide,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(ProjectEntity project, int index, bool isWide) {
    return _HoverProjectCard(
      project: project,
      index: index,
      isWide: isWide,
      notifier: widget.notifier,
      onTap: () async {
        final uri = Uri.parse(project.url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
    );
  }

  Widget _buildExperienceSection(double width) {
    return Container(
      key: _experienceKey,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('02 / EXPERIENCE TIMELINE'),
          const SizedBox(height: 50),

          // Timeline Listing
          ListView.builder(
            itemCount: widget.notifier.experiences.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final exp = widget.notifier.experiences[index];
              return _buildExperienceItem(exp, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceItem(ExperienceEntity exp, int index) {
    Color itemColor = Color(int.parse(exp.colorHex.replaceFirst('#', '0xFF')));

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: itemColor.withOpacity(0.3), width: 2.0),
        ),
      ),
      padding: const EdgeInsets.only(left: 32, bottom: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Duration pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: itemColor.withOpacity(0.06),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: itemColor.withOpacity(0.2), width: 0.8),
            ),
            child: Text(
              exp.duration,
              style: GoogleFonts.shareTechMono(
                color: itemColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Role & Company
          Text(
            exp.role.toUpperCase(),
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            exp.company,
            style: GoogleFonts.shareTechMono(
              color: Colors.white.withOpacity(0.55),
              fontSize: 14,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),

          // Job Description
          if (exp.jobDescription.isNotEmpty) ...[
            Text(
              exp.jobDescription,
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.65),
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Key Contributions
          if (exp.keyContributions.isNotEmpty) ...[
            Text(
              'KEY CONTRIBUTIONS',
              style: GoogleFonts.shareTechMono(
                color: itemColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: exp.keyContributions.map((point) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: itemColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          point,
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.45),
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Technologies Used
          if (exp.technologiesUsed.isNotEmpty) ...[
            Text(
              'TECHNOLOGIES USED',
              style: GoogleFonts.shareTechMono(
                color: itemColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: exp.technologiesUsed.map((tech) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: itemColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: itemColor.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    tech,
                    style: GoogleFonts.shareTechMono(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 11,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // 6. Skills Section
  Widget _buildSkillsSection(double width) {
    bool isWide = width > 900;
    return Container(
      key: _skillsKey,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('04 / SKILLS GRID'),
          const SizedBox(height: 50),

          // Skill cards layout
          if (isWide)
            Column(
              children: [
                for (int i = 0; i < widget.notifier.skills.length; i += 3)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 24),
                              child: _buildSkillCard(widget.notifier.skills[i]),
                            ),
                          ),
                          if (i + 1 < widget.notifier.skills.length)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 24),
                                child: _buildSkillCard(
                                  widget.notifier.skills[i + 1],
                                ),
                              ),
                            )
                          else
                            Expanded(child: Container()),
                          if (i + 2 < widget.notifier.skills.length)
                            Expanded(
                              child: _buildSkillCard(
                                widget.notifier.skills[i + 2],
                              ),
                            )
                          else
                            Expanded(child: Container()),
                        ],
                      ),
                    ),
                  ),
              ],
            )
          else
            Column(
              children: [
                for (int i = 0; i < widget.notifier.skills.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _buildSkillCard(widget.notifier.skills[i]),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(SkillEntity skill) {
    Color skillColor = Color(
      int.parse(skill.colorHex.replaceFirst('#', '0xFF')),
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.015),
        borderRadius: CosmicTheme.cardRadius,
        border: CosmicTheme.glassBorder(
          accentColor: skillColor,
          opacity: 0.12,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  skill.name,
                  style: GoogleFonts.shareTechMono(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(skill.level * 100).toInt()}%',
                style: GoogleFonts.shareTechMono(
                  color: skillColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Simple levels bar
          Container(
            height: 4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: skill.level,
              child: Container(
                decoration: BoxDecoration(
                  color: skillColor,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: CosmicTheme.neonGlow(
                    color: skillColor,
                    blur: 5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 7. Footer Section
  Widget _buildFooterSection(double width) {
    return Container(
      key: _contactKey,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 100),
      decoration: BoxDecoration(
        color: CosmicTheme.spaceBlack.withOpacity(0.5),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.03), width: 1.0),
        ),
      ),
      child: Column(
        children: [
          // Glowing Call to Action
          Text(
            'GET IN TOUCH',
            style: GoogleFonts.shareTechMono(
              color: CosmicTheme.neonCyan,
              fontSize: 14,
              letterSpacing: 4.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'syedanamul67@gmail.com',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: width > 600 ? 32 : 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 48),

          // Social icons wrapper
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(Icons.code, 'https://github.com/SyedPiyal'),
              const SizedBox(width: 24),
              _buildSocialIcon(
                Icons.business_center,
                'https://www.linkedin.com/in/syed-anamul-haque-piyal-74b676241/',
              ),
              const SizedBox(width: 24),
              _buildSocialIcon(Icons.mail, 'mailto:syedanamul67@gmail.com'),
            ],
          ),
          const SizedBox(height: 48),

          // copyright
          Text(
            '© 2026 SYED. ALL RIGHTS RESERVED. DESIGN INSPIRED',
            textAlign: TextAlign.center,
            style: GoogleFonts.shareTechMono(
              color: Colors.white.withOpacity(0.3),
              fontSize: 10,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String url) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => widget.notifier.setHoveringInteractive(true),
      onExit: (_) => widget.notifier.setHoveringInteractive(false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1.0,
            ),
          ),
          child: Icon(icon, color: Colors.white70, size: 20),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.shareTechMono(
            color: CosmicTheme.neonCyan,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 4.0,
          ),
        ),
        const SizedBox(height: 8),
        Container(width: 60, height: 1.5, color: CosmicTheme.primaryPurple),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Hover-animated Project Card
// ─────────────────────────────────────────────
class _HoverProjectCard extends StatefulWidget {
  final ProjectEntity project;
  final int index;
  final bool isWide;
  final VoidCallback onTap;
  final PortfolioNotifier notifier;

  const _HoverProjectCard({
    required this.project,
    required this.index,
    required this.isWide,
    required this.onTap,
    required this.notifier,
  });

  @override
  State<_HoverProjectCard> createState() => _HoverProjectCardState();
}

class _HoverProjectCardState extends State<_HoverProjectCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _glowAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter() {
    setState(() => _hovered = true);
    _controller.forward();
    widget.notifier.setHoveringInteractive(true);
  }

  void _onExit() {
    setState(() => _hovered = false);
    _controller.reverse();
    widget.notifier.setHoveringInteractive(false);
  }

  @override
  Widget build(BuildContext context) {
    final Color borderAccent = widget.index % 2 == 0
        ? CosmicTheme.primaryPurple
        : CosmicTheme.neonCyan;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _onEnter(),
      onExit: (_) => _onExit(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, _) {
            return AnimatedSlide(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              offset: _hovered ? const Offset(0, -0.015) : Offset.zero,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: _hovered
                      ? Colors.white.withOpacity(0.035)
                      : Colors.white.withOpacity(0.015),
                  borderRadius: CosmicTheme.cardRadius,
                  border: Border.all(
                    color: borderAccent.withOpacity(
                      _hovered ? 0.55 : 0.15,
                    ),
                    width: _hovered ? 1.2 : 0.8,
                  ),
                  boxShadow: _hovered
                      ? [
                          BoxShadow(
                            color: borderAccent.withOpacity(0.12),
                            blurRadius: 24,
                            spreadRadius: 0,
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project Counter Tag
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PROJECT 0${widget.index + 1}',
                          style: GoogleFonts.shareTechMono(
                            color: borderAccent,
                            fontSize: 12,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          decoration: BoxDecoration(
                            color: _hovered
                                ? borderAccent.withOpacity(0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.arrow_outward,
                            color: _hovered ? borderAccent : Colors.white24,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Project Title
                    Text(
                      widget.project.title.toUpperCase(),
                      style: GoogleFonts.orbitron(
                        color: _hovered ? Colors.white : Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Project Description
                    if (widget.isWide)
                      Expanded(
                        child: Text(
                          widget.project.description,
                          style: GoogleFonts.inter(
                            color: _hovered
                                ? Colors.white.withOpacity(0.65)
                                : Colors.white.withOpacity(0.45),
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                      )
                    else
                      Text(
                        widget.project.description,
                        style: GoogleFonts.inter(
                          color: _hovered
                              ? Colors.white.withOpacity(0.65)
                              : Colors.white.withOpacity(0.45),
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    const SizedBox(height: 24),

                    // Project Tags Pills
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.project.tags.map((tag) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: borderAccent.withOpacity(
                              _hovered ? 0.1 : 0.05,
                            ),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: borderAccent.withOpacity(
                                _hovered ? 0.4 : 0.2,
                              ),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            tag.toUpperCase(),
                            style: GoogleFonts.shareTechMono(
                              color: borderAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
