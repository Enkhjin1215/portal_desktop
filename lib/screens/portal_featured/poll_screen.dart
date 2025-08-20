import 'package:flutter/material.dart';
import 'package:portal/components/bottom_navigation.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/components/custom_button.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/screens/cart/ticket/ticketShape/gradient_text.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class PollScreen extends StatefulWidget {
  const PollScreen({super.key});

  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int? _selectedOption;
  bool _showResults = false;

  // Sample poll data
  final String _pollQuestion = "Which event would you like to see next on Portal?";
  final List<String> _pollOptions = ["Music Festival", "Theater Performance", "Art Exhibition", "Tech Conference"];

  // Mock results (percentage)
  final List<double> _mockResults = [45.0, 25.0, 15.0, 15.0];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _vote() {
    if (_selectedOption != null) {
      setState(() {
        _showResults = true;
      });
      _animationController.forward();
    }
  }

  void _reset() {
    setState(() {
      _selectedOption = null;
      _showResults = false;
    });
    _animationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return CustomScaffold(
      padding: EdgeInsets.zero,
      body: Container(
        width: ResponsiveFlutter.of(context).wp(100),
        height: ResponsiveFlutter.of(context).hp(100),
        color: theme.colorScheme.backgroundBlack,
        child: SingleChildScrollView(
          child: Container(
            color: theme.colorScheme.backgroundBlack,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 48),

                // Poll title
                Center(
                  child: GradientText(
                    'PORTAL POLL',
                    style: TextStyles.textFt22Bold,
                  ),
                ),

                const SizedBox(height: 32),

                // Poll question
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.whiteColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.whiteColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _pollQuestion,
                    textAlign: TextAlign.center,
                    style: TextStyles.textFt18Bold.textColor(theme.colorScheme.whiteColor),
                  ),
                ),

                const SizedBox(height: 24),

                // Poll options
                ...List.generate(_pollOptions.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _showResults ? _buildResultItem(index, theme) : _buildOptionItem(index, theme),
                  );
                }),

                const SizedBox(height: 24),

                // Vote or Reset button
                CustomButton(
                  width: 280,
                  height: 56,
                  text: _showResults ? "Vote Again" : "Vote",
                  backgroundColor:
                      _selectedOption != null || _showResults ? theme.colorScheme.whiteColor : theme.colorScheme.whiteColor.withOpacity(0.3),
                  textColor: theme.colorScheme.blackColor,
                  onTap: _showResults ? _reset : _vote,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: const BottomNavigation(currentMenu: 1),
    );
  }

  Widget _buildOptionItem(int index, ThemeData theme) {
    final bool isSelected = _selectedOption == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = index;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.whiteColor.withOpacity(0.1) : theme.colorScheme.blackColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.colorScheme.whiteColor : theme.colorScheme.whiteColor.withOpacity(0.05),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.whiteColor,
                  width: 2,
                ),
                color: isSelected ? theme.colorScheme.whiteColor : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: theme.colorScheme.blackColor,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _pollOptions[index],
                style: TextStyles.textFt16Med.textColor(theme.colorScheme.whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(int index, ThemeData theme) {
    final bool isWinner = _mockResults.indexOf(_mockResults.reduce((a, b) => a > b ? a : b)) == index;
    final bool isSelected = _selectedOption == index;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.backgroundBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? theme.colorScheme.whiteColor : theme.colorScheme.whiteColor.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _pollOptions[index],
                  style: (isWinner ? TextStyles.textFt16Bold : TextStyles.textFt16Med).textColor(theme.colorScheme.whiteColor),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.blackColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${_mockResults[index].toInt()}%",
                  style: TextStyles.textFt14Bold.textColor(theme.colorScheme.whiteColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 12,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.blackColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  Container(
                    width: ResponsiveFlutter.of(context).wp(100) * (_mockResults[index] / 100) * _animationController.value,
                    height: 12,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isWinner
                            ? const [
                                Color(0xFF2AD0CA),
                                Color(0xFFE1F664),
                                Color(0xFFEFB0FE),
                                Color(0xFFABB3FC),
                                Color(0xFF5DF7A4),
                              ]
                            : [
                                theme.colorScheme.whiteColor.withOpacity(0.7),
                                theme.colorScheme.whiteColor,
                              ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              );
            },
          ),
          if (isSelected)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: theme.colorScheme.whiteColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Your vote",
                    style: TextStyles.textFt12Med.textColor(theme.colorScheme.whiteColor),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
