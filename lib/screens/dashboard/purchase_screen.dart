import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:portal/components/custom_app_bar.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/screens/cart/ticket/ticketShape/gradient_text.dart';
import 'package:portal/screens/dashboard/purchase_model.dart';
import 'package:portal/service/core_requests.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final PagingController<int, TicketItem2> _pagingController = PagingController(firstPageKey: 1);
  static const _pageSize = 20;
  CoreRequests coreRequests = CoreRequests();

  @override
  void initState() {
    init();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await coreRequests.getPurchaseHistory(context, pageKey, _pageSize);
      print('newItems:$newItems');
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  String formatDateTime(String? dateStr) {
    if (dateStr == null) return "";

    try {
      final dateTime = DateTime.parse(dateStr).toLocal(); // convert to local time
      final formatter = DateFormat('yyyy/MM/dd HH:mm:ss');
      return formatter.format(dateTime);
    } catch (e) {
      return dateStr; // fallback if parsing fails
    }
  }

  init() async {
    await Webservice().loadGet(Response.purchaseList, context, parameter: '?page=1&limit=20').then((response) {});
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    return CustomScaffold(
        padding: EdgeInsets.zero,
        appBar: tittledAppBar(context: context, tittle: 'purchaseCount', backShow: true),
        resizeToAvoidBottomInset: false,
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: ResponsiveFlutter.of(context).hp(100),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: ResponsiveFlutter.of(context).hp(4),
              ),
              Expanded(
                  child: PagedListView<int, TicketItem2>(
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<TicketItem2>(noItemsFoundIndicatorBuilder: (context) {
                        return Center(
                          child: Text(
                            'Гүйлгээний түүх хоосон байна!',
                            style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor),
                          ),
                        );
                      }, itemBuilder: (context, item, index) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.all(4),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${index + 1}.',
                                style: TextStyles.textFt18Bold.textColor(Colors.white),
                              ),
                              const SizedBox(
                                width: 32,
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  width: ResponsiveFlutter.of(context).wp(100),
                                  height: 300,
                                  decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(item.eventId.coverImage), fit: BoxFit.fill)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GradientText(
                                        item.eventId.name,
                                        style: TextStyles.textFt24Bold,
                                      ),
                                      const Expanded(
                                        child: SizedBox(),
                                      ),
                                      GradientText(
                                        formatDateTime(item.updatedAt.toString()),
                                        style: TextStyles.textFt24Bold,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      })))
            ])));
  }
}
