import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppWindowWrapper extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onClose;
  final Color themeColor;

  const AppWindowWrapper({
    super.key,
    required this.title,
    required this.child,
    required this.onClose,
    this.themeColor = const Color(0xFF6C22D6),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF070714).withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: themeColor.withOpacity(0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          // Glassmorphic App Header / Title Bar
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(19),
                topRight: Radius.circular(19),
              ),
              border: Border(
                bottom: BorderSide(
                  color: themeColor.withOpacity(0.2),
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Window Buttons (Simulated Mac/OS style)
                Row(
                  children: [
                    GestureDetector(
                      onTap: onClose,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF5F56),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.close,
                            size: 8,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFBD2E),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Color(0xFF27C93F),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),

                // App Title
                Text(
                  title.toUpperCase(),
                  style: GoogleFonts.shareTechMono(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),

                // Active App Icon indicator
                Icon(
                  Icons.lens,
                  size: 8,
                  color: themeColor,
                ),
              ],
            ),
          ),

          // Main Screen Area inside the App Window
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(19),
                bottomRight: Radius.circular(19),
              ),
              child: Theme(
                data: ThemeData.dark().copyWith(
                  scaffoldBackgroundColor: Colors.transparent,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: themeColor,
                    brightness: Brightness.dark,
                  ),
                ),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
