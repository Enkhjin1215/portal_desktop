import 'package:flutter/material.dart';
import 'package:portal/helper/responsive_flutter.dart';

class ToggleSelector extends StatefulWidget {
  final Function(int) onChanged;
  final int initialSelection;

  const ToggleSelector({
    Key? key,
    required this.onChanged,
    this.initialSelection = 0,
  }) : super(key: key);

  @override
  State<ToggleSelector> createState() => _ToggleSelectorState();
}

class _ToggleSelectorState extends State<ToggleSelector> with SingleTickerProviderStateMixin {
  late int selectedIndex;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<ToggleOption> options = [
    ToggleOption(
      title: 'Roll',
      subtitle: 'Бэлэг нээх',
    ),
    ToggleOption(
      title: 'Poll',
      subtitle: 'Санал өгөх',
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialSelection;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectOption(int index) {
    if (selectedIndex != index) {
      setState(() {
        selectedIndex = index;
      });
      _animationController.forward().then((_) {
        _animationController.reset();
      });
      widget.onChanged(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveFlutter.of(context).wp(15)),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Animated background selector
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: selectedIndex == 0 ? 4 : null,
            right: selectedIndex == 1 ? 4 : null,
            top: 4,
            bottom: 4,
            width: MediaQuery.of(context).size.width * 0.33,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6BE3D7),
                    Color(0xFFEEA2F5),
                    Color(0xFFF6CAB3),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE91E63).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),

          // Toggle options
          Row(
            children: options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = selectedIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () => _selectOption(index),
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          option.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.black : Colors.white.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          option.subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.black.withOpacity(0.9) : Colors.white.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
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

class ToggleOption {
  final String title;
  final String subtitle;

  ToggleOption({
    required this.title,
    required this.subtitle,
  });
}

// Example usage widget
class ToggleSelectorDemo extends StatefulWidget {
  const ToggleSelectorDemo({Key? key}) : super(key: key);

  @override
  State<ToggleSelectorDemo> createState() => _ToggleSelectorDemoState();
}

class _ToggleSelectorDemoState extends State<ToggleSelectorDemo> {
  int currentSelection = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Toggle Selector',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ToggleSelector(
                initialSelection: currentSelection,
                onChanged: (index) {
                  setState(() {
                    currentSelection = index;
                  });
                  print('Selected: ${index == 0 ? 'Roll' : 'Poll'}');
                },
              ),
              const SizedBox(height: 40),
              Text(
                'Selected: ${currentSelection == 0 ? 'Roll' : 'Poll'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
