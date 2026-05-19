import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/cosmic_theme.dart';
import 'data/datasources/static_datasource.dart';
import 'data/repositories/portfolio_repository_impl.dart';
import 'presentation/pages/mobile_launcher_page.dart';
import 'presentation/pages/web_landing_page.dart';
import 'presentation/state/portfolio_notifier.dart';
import 'presentation/widgets/cosmic_background.dart';
import 'presentation/widgets/cosmic_cursor.dart';
import 'presentation/widgets/device_frame.dart';
import 'presentation/widgets/orbit_loader.dart';

void main() {
  // Bootstrapping clean dependencies
  final staticDataSource = StaticPortfolioDataSource();
  final repository = PortfolioRepositoryImpl(dataSource: staticDataSource);
  final portfolioNotifier = PortfolioNotifier(repository: repository);

  runApp(MyApp(notifier: portfolioNotifier));
}

class MyApp extends StatelessWidget {
  final PortfolioNotifier notifier;

  const MyApp({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syed - Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: CosmicTheme.spaceBlack,
        colorScheme: ColorScheme.fromSeed(
          seedColor: CosmicTheme.primaryPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: MainPortfolioView(notifier: notifier),
    );
  }
}

class MainPortfolioView extends StatefulWidget {
  final PortfolioNotifier notifier;

  const MainPortfolioView({super.key, required this.notifier});

  @override
  State<MainPortfolioView> createState() => _MainPortfolioViewState();
}

class _MainPortfolioViewState extends State<MainPortfolioView> {
  bool _showLoader = true;

  @override
  void initState() {
    super.initState();
    // Load portfolio entities immediately
    widget.notifier.loadPortfolioData();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Planetary Orbit Loading Sequence
    if (_showLoader) {
      return OrbitLoader(
        onLoaded: () {
          setState(() {
            _showLoader = false;
          });
        },
      );
    }

    // 2. Main Portfolio with Cosmic Starfield & Theme layout
    return ListenableBuilder(
      listenable: widget.notifier,
      builder: (context, child) {
        if (widget.notifier.isLoading) {
          return const Scaffold(
            backgroundColor: CosmicTheme.spaceBlack,
            body: Center(
              child: CircularProgressIndicator(color: CosmicTheme.neonCyan),
            ),
          );
        }

        return CosmicCursor(
          notifier: widget.notifier,
          child: CosmicBackground(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: widget.notifier.isMobileFrame
                    ? _buildSimulatedOSLayout()
                    : WebLandingPage(notifier: widget.notifier),
              ),
            ),
          ),
        );
      },
    );
  }

  // Beautiful layout centered around the vector phone frame
  Widget _buildSimulatedOSLayout() {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWide = screenWidth > 900;

    return Center(
      key: const ValueKey('mobile_os_layout'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Flex(
          direction: isWide ? Axis.horizontal : Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // LEFT PANEL: Brief introduction with expand toggle (For wide desktops)
            if (isWide) ...[
              SizedBox(
                width: 320,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Tagline
                    Text(
                      'MOBILE OS EMULATOR',
                      style: GoogleFonts.shareTechMono(
                        color: CosmicTheme.neonCyan,
                        fontSize: 13,
                        letterSpacing: 4.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Header Name
                    Text(
                      'SYED\'S WORKSPACE',
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Introduction text
                    Text(
                      'Interact directly with the simulated iOS/Android phone! Launch built-in apps, play retro arcade games, or browse resume milestones. Click the settings icon in the phone to switch active vector shells.',
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.45),
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Expand to Web Mode Button
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) =>
                          widget.notifier.setHoveringInteractive(true),
                      onExit: (_) =>
                          widget.notifier.setHoveringInteractive(false),
                      child: GestureDetector(
                        onTap: () => widget.notifier.toggleLayoutMode(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.02),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: CosmicTheme.primaryPurple.withOpacity(0.3),
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.fullscreen,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'VIEW FULL WEB PAGE',
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
              ),
              const SizedBox(width: 60),
            ],

            // CENTER PANEL: The vector mock phone shell itself
            DeviceFrame(
              deviceType: widget.notifier.activeDeviceType,
              themeColor: widget.notifier.activeSimulatedApp == 'SNAKE GAME'
                  ? const Color(0xFFC70039)
                  : CosmicTheme.primaryPurple,
              child: MobileLauncherPage(notifier: widget.notifier),
            ),

            // RIGHT PANEL: Toggle for small screens
            if (!isWide) ...[
              const SizedBox(height: 40),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => widget.notifier.setHoveringInteractive(true),
                onExit: (_) => widget.notifier.setHoveringInteractive(false),
                child: GestureDetector(
                  onTap: () => widget.notifier.toggleLayoutMode(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: CosmicTheme.primaryPurple.withOpacity(0.3),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.fullscreen,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'VIEW FULL WEB PAGE',
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
          ],
        ),
      ),
    );
  }
}
