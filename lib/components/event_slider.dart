import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/models/event_image.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class EventSlider extends StatefulWidget {
  const EventSlider({super.key});

  @override
  State<EventSlider> createState() => _EventSliderState();
}

class _EventSliderState extends State<EventSlider> with SingleTickerProviderStateMixin {
  List<EventImage> images = [];
  int _currentIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getImage();
    });
  }

  Future<void> getImage() async {
    try {
      await Webservice()
          .loadGet(
        EventImage.getImages,
        context,
      )
          .then((response) {
        if (mounted) {
          Provider.of<ProviderCoreModel>(context, listen: false).setImages(response);
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    images = Provider.of<ProviderCoreModel>(context, listen: true).getImages();

    return Container(
      margin: EdgeInsets.only(top: ResponsiveFlutter.of(context).hp(0), bottom: ResponsiveFlutter.of(context).hp(3)),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: _isLoading || images.isEmpty
                ? SkeletonLoader()
                : CarouselSlider.builder(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      // Smoother autoplay settings
                      autoPlay: true,
                      autoPlayInterval: const Duration(milliseconds: 2000),
                      autoPlayAnimationDuration: const Duration(milliseconds: 1500),
                      autoPlayCurve: Curves.easeInOutCubic, // Smoother curve

                      // Improved viewfraction for better performance
                      viewportFraction: 0.85,
                      aspectRatio: 1,

                      // Optimized enlarging
                      enlargeCenterPage: true,
                      enlargeFactor: 0.2,
                      enlargeStrategy: CenterPageEnlargeStrategy.height, // Changed from zoom to height

                      // Enable hardware acceleration
                      pauseAutoPlayOnTouch: true,
                      pauseAutoPlayOnManualNavigate: true,

                      onPageChanged: (index, reason) {
                        HapticFeedback.lightImpact(); // Optional: adds tactile feedback
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    itemCount: images.length,
                    itemBuilder: (context, index, realIndex) {
                      // Use RepaintBoundary to optimize rendering
                      return RepaintBoundary(
                        child: EventCard(
                          eventImage: images[index],
                          isActive: index == _currentIndex,
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),
          images.isEmpty
              ? const SizedBox()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: images.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _carouselController.animateToPage(entry.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 2000),
                        width: _currentIndex == entry.key ? 12 : 8, // Slightly larger for active dot
                        height: _currentIndex == entry.key ? 12 : 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == entry.key ? theme.colorScheme.whiteColor : theme.colorScheme.whiteColor.withOpacity(0.4),
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final EventImage eventImage;
  final bool isActive;

  const EventCard({
    required this.eventImage,
    this.isActive = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    // Use AnimatedScale instead of AnimatedContainer for smoother transitions
    return GestureDetector(
      onTap: () {
        NavKey.navKey.currentState!.pushNamed(eventRoute, arguments: {'id': eventImage.id, 'from': 0});
      },
      child: AnimatedScale(
        scale: isActive ? 1.0 : 0.9,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              if (isActive)
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              decoration: BoxDecoration(
                color: isActive ? Colors.transparent : theme.colorScheme.mattBlack,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image with fade-in effect
                  FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: eventImage.coverImage!,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 200),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        child: const Center(
                          child: Icon(Icons.error_outline, color: Colors.white, size: 40),
                        ),
                      );
                    },
                  ),

                  // Gradient overlay
                  if (!isActive)
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.8),
                          ],
                          stops: const [0.2, 0.5, 0.75, 1.0],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SkeletonLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Shimmer.fromColors(
          baseColor: Colors.transparent,
          highlightColor: Colors.grey.withValues(alpha: 0.01),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(24),
            ),
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Shimmer for title
                Container(
                  height: 32,
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 30, right: 80, bottom: 10),
                  color: Colors.white.withOpacity(0.1),
                ),

                // Shimmer for subtitle
                Container(
                  height: 16,
                  width: 200,
                  margin: const EdgeInsets.only(left: 30, bottom: 60),
                  color: Colors.white.withOpacity(0.1),
                ),

                // Shimmer for date
                Container(
                  height: 24,
                  width: 150,
                  margin: const EdgeInsets.only(left: 30, bottom: 10),
                  color: Colors.white.withOpacity(0.1),
                ),

                // Shimmer for location
                Container(
                  height: 16,
                  width: 100,
                  margin: const EdgeInsets.only(left: 30, bottom: 30),
                  color: Colors.white.withOpacity(0.1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Transparent placeholder image bytes
final Uint8List kTransparentImage = Uint8List.fromList([
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82
]);
