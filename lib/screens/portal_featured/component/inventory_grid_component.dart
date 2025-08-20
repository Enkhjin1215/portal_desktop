import 'package:flutter/material.dart';
import 'package:portal/components/bottom_sheet.dart';
import 'package:portal/components/custom_button.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/screens/cart/ticket/ticketShape/gradient_text.dart';
import 'package:portal/screens/portal_featured/component/cs-event-model.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class InventoryGridComponent extends StatelessWidget {
  final List<CSGOItem> items;
  final bool isAllGifts;
  final String tradeUrl;

  const InventoryGridComponent({
    Key? key,
    required this.items,
    required this.isAllGifts,
    required this.tradeUrl,
  }) : super(key: key);

  Future<bool> tradeUrlConnect(BuildContext context, String value) async {
    Map<String, dynamic> data = {};
    // 'https://steamcommunity.com/tradeoffer/new/?partner=140396168&token=DwKjyoNe'
    data['tradeUrl'] = value;
    try {
      await Webservice().loadPost(Response.steamTradeUrl, context, data, parameter: '').then((response) {
        print('case 1');

        return true;
      });
    } catch (e) {
      print('case 2');

      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return Container(
        decoration: BoxDecoration(
            color: theme.colorScheme.backgroundColor,
            border: Border.all(color: Colors.white, width: 0.2),
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.6,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildInventoryItem(item, theme);
              },
            ),
            items.isEmpty
                ? SizedBox(
                    height: 300,
                    child: Center(
                      child: GradientText('Одоогоор хоосон байна', style: TextStyles.textFt16Med),
                    ),
                  )
                : const SizedBox(
                    height: 1,
                  ),
            if (!isAllGifts && items.isNotEmpty)
              CustomButton(
                width: 186,
                height: 40,
                text: 'Татах',
                margin: const EdgeInsets.only(bottom: 16),
                onTap: () {
                  ModalAlert().claimItem(context, theme, (val) => tradeUrlConnect(context, val), tradeUrl != '', TextEditingController());

                  // print('trade url :${tradeUrl}'); // tradeUrlConnect(context);
                  // application.showToast('Тэмцээн дууссаны дараа та татах боломжтой');
                },
              )
          ],
        ));
  }

  Widget _buildInventoryItem(CSGOItem item, ThemeData theme) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Item image placeholder
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(item.imageUrl ?? ''),
            ),
          ),

          const SizedBox(height: 2),

          // Item name
          Expanded(
            child: Center(
              // padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                item.name ?? 'null',
                style: TextStyles.textFt12Bold.textColor(theme.colorScheme.whiteColor),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 2),

          // Rarity badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: item.rarityColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item.type ?? 'Unknown',
              style: TextStyles.textFt10Bold.textColor(item.rarityColor),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 2),
        ],
      ),
    );
  }
}
