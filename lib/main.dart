import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const DrRingApp());
}

class DrRingApp extends StatelessWidget {
  const DrRingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DrRing',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF77A2)),
        useMaterial3: true,
        fontFamily: 'sans-serif',
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    // Trigger fade-in after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              const SizedBox(height: 48),
              // Brand Title
              const Text(
                'DrRing',
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFFF77A2), // --brand: #ff77a2
                  letterSpacing: 0,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'for Family',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827), // --text-dark: #111827
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 24),
              // Message/Tagline
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Keeping families and caregivers informed\nabout safety, wellbeing, and reassurance.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF4B5563), // --text-soft: #4B5563
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 42),
              // Tile Carousels
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Top carousel: scrolls right to left (7s)
                    InfiniteCarousel(
                      cards: topRowCards,
                      scrollDirection: ScrollDirection.rightToLeft,
                      duration: 7,
                    ),
                    const SizedBox(height: 18),
                    // Bottom carousel: scrolls left to right (11s)
                    InfiniteCarousel(
                      cards: bottomRowCards,
                      scrollDirection: ScrollDirection.leftToRight,
                      duration: 11,
                    ),
                  ],
                ),
              ),
              // Skip button
              GestureDetector(
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF77A2), // --brand
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Version
              const Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280), // #6B7280
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

// Card data model
class CardData {
  final String text;
  final Color color;
  final Color? textColor;

  const CardData(this.text, this.color, [this.textColor]);
}

// Top row cards - matching CSS colors exactly
const topRowCards = [
  CardData('Low Phone\nBattery', Color(0xFF107C10)), // .green: #107C10
  CardData('Low\nDevice\nBattery', Color(0xFF00B7C3)), // .teal: #00B7C3
  CardData('GeoFence\nStatus', Color(0xFF5C2D91)), // .purple: #5C2D91
  CardData('SOS Alerts', Color(0xFFFFB900),
      Color(0xFF1F2937)), // .yellow: #FFB900, text: #1F2937
];

// Bottom row cards - matching CSS colors exactly
const bottomRowCards = [
  CardData('Inactivity\nAlert', Color(0xFF5C2D91)), // .purple: #5C2D91
  CardData('Device\nConnected', Color(0xFF0078D4)), // .blue: #0078D4
  CardData('Device\nWorn', Color(0xFF107C10)), // .green: #107C10
  CardData('Activity\nDetected', Color(0xFFFFB900),
      Color(0xFF1F2937)), // .yellow: #FFB900, text: #1F2937
];

enum ScrollDirection { leftToRight, rightToLeft }

class InfiniteCarousel extends StatefulWidget {
  final List<CardData> cards;
  final ScrollDirection scrollDirection;
  final int duration; // Duration in seconds

  const InfiniteCarousel({
    super.key,
    required this.cards,
    required this.scrollDirection,
    required this.duration,
  });

  @override
  State<InfiniteCarousel> createState() => _InfiniteCarouselState();
}

class _InfiniteCarouselState extends State<InfiniteCarousel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static const double cardSize = 140.0;
  static const double cardSpacing = 16.0;
  static const double cardTotalWidth = cardSize + cardSpacing;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Triple the cards to ensure seamless looping
    final extendedCards = [...widget.cards, ...widget.cards, ...widget.cards];
    final totalWidth = widget.cards.length * cardTotalWidth;

    return SizedBox(
      height: cardSize,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Calculate how much the cards have moved based on animation progress
          double animationValue = _controller.value * totalWidth;
          double offset;

          // Logic adjustment:
          // We need to ensure that no matter which direction we scroll, we are never
          // exposing the "empty void" at the start or end of the Row.
          if (widget.scrollDirection == ScrollDirection.rightToLeft) {
            // Standard scroll: Move backwards from -1 * width to -2 * width
            // This loops Set 2 -> Set 3
            offset = -animationValue - totalWidth;
          } else {
            // Reverse scroll: Move forwards from -2 * width to -1 * width
            // This loops Set 3 -> Set 2.
            // By starting at -2*width, we ensure there is content to the left (Set 1 and 2)
            offset = animationValue - (2 * totalWidth);
          }

          // Calculate center alignment
          // We add half screen width and subtract half card width to center the current item
          final centerAdjustment = (screenWidth - cardSize) / 2;
          final finalOffset = offset + centerAdjustment;

          return ClipRect(
            child: OverflowBox(
              maxWidth: double.infinity,
              alignment: Alignment.centerLeft,
              child: Transform.translate(
                offset: Offset(finalOffset, 0),
                child: Row(
                  children: extendedCards.map((card) {
                    return Padding(
                      padding: const EdgeInsets.only(right: cardSpacing),
                      child: CarouselCard(data: card, size: cardSize),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CarouselCard extends StatelessWidget {
  final CardData data;
  final double size;

  const CarouselCard({
    super.key,
    required this.data,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: data.color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            data.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: data.textColor ?? Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}