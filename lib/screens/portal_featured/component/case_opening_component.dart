import 'package:flutter/material.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/screens/portal_featured/component/cs-event-model.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class CaseOpeningComponent extends StatelessWidget {
  final List<CSGOItem> items;
  final ScrollController scrollController;
  final bool isOpening;
  final dynamic winningItem;
  final Animation<double> animation;

  const CaseOpeningComponent({
    Key? key,
    required this.items,
    required this.scrollController,
    required this.isOpening,
    required this.winningItem,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return Stack(
      children: [
        // Scrolling items
        ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return _buildItemCard(
              item: items[index],
              isWinning: index == 80 && !isOpening && winningItem != null,
              theme: theme,
            );
          },
        ),

        // Center indicator arrow
        Center(
          child: Container(
            width: 4,
            height: 217,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
          ),
        ),

        // Top arrow indicator
        Positioned(
          top: -1,
          left: 0,
          right: 0,
          child: Center(
            child: Transform.rotate(
              angle: 3.14159, // 180 degrees
              child: CustomPaint(
                size: const Size(16, 16),
                painter: ArrowPainter(
                  color: theme.colorScheme.whiteColor,
                ),
              ),
            ),
          ),
        ),

        // Bottom arrow indicator
        Positioned(
          bottom: -1,
          left: 0,
          right: 0,
          child: Center(
            child: CustomPaint(
              size: const Size(16, 16),
              painter: ArrowPainter(
                color: theme.colorScheme.whiteColor,
              ),
            ),
          ),
        ),

        // Winner display - more compact
        // if (winningItem != null && !isOpening)
        //   AnimatedBuilder(
        //     animation: animation,
        //     builder: (context, child) {
        //       return Transform.scale(
        //         scale: 1.0 + (0.1 * animation.value),
        //         child: Container(
        //           margin: const EdgeInsets.symmetric(horizontal: 20),
        //           padding: const EdgeInsets.all(12),
        //           decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(12),
        //             gradient: LinearGradient(
        //               colors: [
        //                 winningItem.rarityColor.withOpacity(0.8),
        //                 winningItem.rarityColor.withOpacity(0.4),
        //               ],
        //               begin: Alignment.topLeft,
        //               end: Alignment.bottomRight,
        //             ),
        //             boxShadow: [
        //               BoxShadow(
        //                 color: winningItem.rarityColor.withOpacity(0.4),
        //                 spreadRadius: 1,
        //                 blurRadius: 8,
        //                 offset: const Offset(0, 2),
        //               ),
        //             ],
        //           ),
        //           child: Column(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               Text(
        //                 "Миний бэлэг",
        //                 style: TextStyles.textFt14Bold.textColor(Colors.white),
        //               ),
        //               const SizedBox(height: 4),
        //               Text(
        //                 winningItem.name,
        //                 style: TextStyles.textFt12Bold.textColor(Colors.white),
        //                 textAlign: TextAlign.center,
        //                 maxLines: 1,
        //                 overflow: TextOverflow.ellipsis,
        //               ),
        //             ],
        //           ),
        //         ),
        //       );
        //     },
        //   ),

        // Spacer to push button content
      ],
    );
  }

  Widget _buildItemCard({
    required CSGOItem item,
    required bool isWinning,
    required ThemeData theme,
  }) {
    bool isWinningItem = (winningItem == item && !isOpening) ? true : false;
    return isWinningItem
        ? Container(
            width: 132,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(2), // Border width
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF2AD0CA),
                    Color(0xFFE1F664),
                    Color(0xFFEFB0FE),
                    Color(0xFFABB3FC),
                    Color(0xFF5DF7A4),
                    Color(0xFF58C4F6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: 130,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.black, // Your content background
                  borderRadius: BorderRadius.circular(14), // Slightly smaller radius
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Item image placeholder (would be actual weapon image)
                    Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(image: NetworkImage(item.imageUrl!)),
                        )),
                    const SizedBox(height: 4),
                    Text(
                      item.name ?? '',
                      maxLines: 2, // Show first word of rarity
                      textAlign: TextAlign.center,
                      style: TextStyles.textFt16Reg.textColor(theme.colorScheme.whiteColor),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: item.rarityColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item.type ?? '',
                        maxLines: 1, // Show first word of rarity
                        style: TextStyles.textFt10Bold.textColor(item.rarityColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container(
            width: 132,
            decoration: BoxDecoration(color: const Color(0xFF181818), border: Border.all(color: Colors.grey, width: 0.1)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Item image placeholder (would be actual weapon image)
                Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(image: NetworkImage(item.imageUrl!)),
                    )),
                const SizedBox(height: 4),
                Text(
                  item.name ?? '',
                  maxLines: 1, // Show first word of rarity
                  style: TextStyles.textFt16Reg.textColor(theme.colorScheme.whiteColor),
                ),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: item.rarityColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item.type ?? '',
                    maxLines: 1, // Show first word of rarity
                    style: TextStyles.textFt10Bold.textColor(item.rarityColor),
                  ),
                ),
              ],
            ),
          );
  }
}

class ArrowPainter extends CustomPainter {
  final Color color;

  ArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
