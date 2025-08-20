import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal/components/bottom_navigation.dart';
import 'package:portal/components/custom_app_bar.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/components/event_slider.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/screens/dashboard/widget_event.dart';
import 'package:portal/service/core_requests.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = -1;
  int selectedFilter = 0;

  RefreshController refreshController = RefreshController(initialRefresh: false);
  CoreRequests coreRequests = CoreRequests();

  @override
  void initState() {
    coreRequests.getEventList(context);
    super.initState();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) setState(() {});

    refreshController.loadComplete();
  }

  void _onRefresh() async {
    coreRequests.getEventList(context);
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    return CustomScaffold(
      padding: EdgeInsets.zero,
      appBar: homeAppBar(context: context),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        // width: ResponsiveFlutter.of(context).wp(100),
        height: ResponsiveFlutter.of(context).hp(100),
        color: theme.colorScheme.blackColor,
        child: SmartRefresher(
            footer: const SizedBox(),
            physics: const BouncingScrollPhysics(),
            enablePullDown: true,
            // enablePullUp: true,
            header: CustomHeader(
              builder: (context, mode) {
                Widget body;
                if (mode == RefreshStatus.idle) {
                  body = const Text('pull down refresh');
                } else if (mode == RefreshStatus.refreshing) {
                  body = const CupertinoActivityIndicator();
                } else if (mode == RefreshStatus.canRefresh) {
                  body = const Text('release to refresh');
                } else if (mode == RefreshStatus.completed) {
                  body = const Text('refreshCompleted!');
                }
                return Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).hp(5)),
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: theme.colorScheme.primaryColor,
                    ),
                  ),
                );
              },
            ),
            controller: refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // SizedBox(
              //     height: 400 + ResponsiveFlutter.of(context).hp(3),
              //     child: const Center(
              //       child: EventSlider(),
              //     )),
              Text(
                getTranslated(context, 'events'),
                style: TextStyles.textFt20Bold.textColor(theme.colorScheme.whiteColor),
              ),
              const SizedBox(
                height: 16,
              ),
              // InkWell(
              //     onTap: () {
              //       NavKey.navKey.currentState!.pushNamed(eventRoute, arguments: {'id': '681c7849d15a55664bd40f04', 'from': 0});
              //     },
              //     child: Container(
              //       width: double.maxFinite,
              //       height: 120,
              //       decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(16)),
              //       child: Center(
              //         child: Text(
              //           'PROD-MAIN-TEST',
              //           style: TextStyles.textFt22Bold.textColor(theme.colorScheme.whiteColor),
              //         ),
              //       ),
              //     )),
              const Event(),
              const SizedBox(
                height: 80,
              )
            ]))),
      ),
      bottomNavigationBar: const BottomNavigation(
        currentMenu: 0,
      ),
    );
  }

  Widget filter(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text(
            'Нээгдсэн',
            style: TextStyle(color: Colors.white),
          ),
          leading: Radio<int>(
            activeColor: Colors.white,
            value: 0,
            groupValue: selectedFilter,
            onChanged: (int? value) {
              setState(() {
                selectedFilter = value!;
                NavKey.navKey.currentState!.pop();
              });
            },
          ),
        ),
        ListTile(
          title: const Text(
            'Дууссан',
            style: TextStyle(color: Colors.white),
          ),
          leading: Radio<int>(
            value: 1,
            groupValue: selectedFilter,
            onChanged: (int? value) {
              setState(() {
                selectedFilter = value!;
                NavKey.navKey.currentState!.pop();
              });
            },
          ),
        )
      ],
    );
  }
}
