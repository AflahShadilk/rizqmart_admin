// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rizqmartadmin/features/auth/presentation/utils/page_navigation.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/welcome/text_features.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation1;
  late Animation<int> _animation2;
  late Animation<int> _animation3;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Color?> _colorAnimation;

  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  final String text1 = "Welcome to";
  final String text2 = "Rizq Mart";
  final String text3 = "Admin Dashboard";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _animation1 = StepTween(begin: 0, end: text1.length).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.3)),
    );
    _animation2 = StepTween(begin: 0, end: text2.length).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.65)),
    );
    _animation3 = StepTween(begin: 0, end: text3.length).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.65, 1.0)),
    );

    _controller.forward();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    _colorAnimation = ColorTween(
      begin: Colors.deepPurple,
      end: Colors.orange,
    ).animate(_fadeController);

    _fadeController.forward();

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);

    _backgroundAnimation = CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          double fontSmall = screenWidth < 600 ? 14 : 18;
          double fontMedium = screenWidth < 600 ? 18 : 24;
          double fontLarge = screenWidth < 600 ? 20 : 28;
          double paddingTop = screenWidth < 600 ? 60 : 100;
          double borderRadius = screenWidth < 600 ? 8 : 16;

          return Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              // ignore: sized_box_for_whitespace
              child: Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.85,
                child: Stack(
                  children: [
                    // Animated gradient background
                    AnimatedBuilder(
                      animation: _backgroundAnimation,
                      builder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.lerp(
                                  const Color(0xFF1A237E),
                                  const Color(0xFF0D47A1),
                                  _backgroundAnimation.value,
                                )!,
                                Color.lerp(
                                  const Color(0xFF283593),
                                  const Color(0xFF1565C0),
                                  _backgroundAnimation.value,
                                )!,
                                Color.lerp(
                                  const Color(0xFF00695C),
                                  const Color(0xFF00897B),
                                  _backgroundAnimation.value,
                                )!,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        );
                      },
                    ),
                    // Decorative circles
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -80,
                      left: -80,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    Positioned(
                      top: screenHeight * 0.3,
                      right: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green.withOpacity(0.15),
                        ),
                      ),
                    ),
                    // Admin icons decoration
                    Positioned(
                      top: 40,
                      left: 40,
                      child: _buildFloatingIcon(Icons.dashboard, 0),
                    ),
                    Positioned(
                      top: 120,
                      right: 60,
                      child: _buildFloatingIcon(Icons.analytics, 0.5),
                    ),
                    Positioned(
                      bottom: 100,
                      right: 40,
                      child: _buildFloatingIcon(Icons.inventory, 1.0),
                    ),
                    Positioned(
                      bottom: 160,
                      left: 50,
                      child: _buildFloatingIcon(Icons.people, 1.5),
                    ),
                    // Content overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    // Main content
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05, vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedBuilder(
                            animation: _animation1,
                            builder: (context, child) {
                              return textPadding(
                                text: text1.substring(0, _animation1.value),
                                padding: EdgeInsets.fromLTRB(8, paddingTop, 0, 5),
                                fontSize: fontMedium,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withOpacity(0.9),
                                align: TextAlign.left,
                              );
                            },
                          ),
                          AnimatedBuilder(
                            animation: _animation2,
                            builder: (context, child) {
                              return textPadding(
                                text: text2.substring(0, _animation2.value),
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 5),
                                fontSize: fontLarge,
                                fontWeight: FontWeight.bold,
                                color: Colors.greenAccent,
                                align: TextAlign.left,
                              );
                            },
                          ),
                          AnimatedBuilder(
                            animation: _animation3,
                            builder: (context, child) {
                              return textPadding(
                                text: text3.substring(0, _animation3.value),
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 5),
                                fontSize: fontMedium,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withOpacity(0.9),
                                align: TextAlign.left,
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: AnimatedBuilder(
                              animation: _colorAnimation,
                              builder: (context, child) {
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Text(
                                    "Together,\n let's turn opportunities \n into achievements.",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSmall,
                                      color: Colors.white.withOpacity(0.85),
                                      height: 1.5,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.greenAccent.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await GlobalNavigator.saveAndNavigate(
                                    context: context,
                                    key: "welcome",
                                    value: true,
                                    route: '/loginPage',
                                    replace: true,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent,
                                  foregroundColor: Colors.black87,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth < 600 ? 32 : 40,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Get Started',
                                      style: TextStyle(
                                        fontSize: fontSmall + 2,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingIcon(IconData icon, double delay) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 1000 + (delay * 500).toInt()),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value * 0.6,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                color: Colors.white.withOpacity(0.7),
                size: 24,
              ),
            ),
          ),
        );
      },
    );
  }
}