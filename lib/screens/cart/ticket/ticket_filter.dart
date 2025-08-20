import 'package:flutter/material.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class TicketFilter extends StatelessWidget {
  final int selectedFilter;
  final Function(int) onFilterChanged;

  const TicketFilter({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _filterChip(
              context: context,
              index: 0,
              label: getTranslated(context, 'all'),
              theme: theme,
            ),
            _filterChip(
              context: context,
              index: 1,
              label: getTranslated(context, 'active'),
              theme: theme,
            ),
            _filterChip(
              context: context,
              index: 2,
              label: getTranslated(context, 'used'),
              theme: theme,
            ),
            _filterChip(
              context: context,
              index: 3,
              label: getTranslated(context, 'listed'),
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip({
    required BuildContext context,
    required int index,
    required String label,
    required ThemeData theme,
  }) {
    final bool isSelected = selectedFilter == index;

    return GestureDetector(
      onTap: () => onFilterChanged(index),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.whiteColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? theme.colorScheme.whiteColor : theme.colorScheme.fadedWhite,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyles.textFt14Med.textColor(
            isSelected ? theme.colorScheme.blackColor : theme.colorScheme.whiteColor,
          ),
        ),
      ),
    );
  }
}
