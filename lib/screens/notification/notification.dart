import 'package:flutter/material.dart';
import 'package:portal/components/bottom_navigation.dart';
import 'package:portal/components/container_transparent.dart';
import 'package:portal/components/custom_app_bar.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/func.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/provider_xo.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  List<dynamic> list = [];
  @override
  void initState() {
    getNotifList();
    super.initState();
  }

  getNotifList() async {
    await Webservice().loadGet(Response.getNotifList, context, parameter: '').then((response) {
      print('response: $response');
      Provider.of<ProviderXO>(context, listen: false).setNotifList(response['data'] ?? []);
    });
  }

  setNotifRead(String id) async {
    Map<String, dynamic> data = {};
    data['notifId'] = id;
    data['type'] = 'ONE';
    await Webservice().loadPost(Response.setNotifRead, context, data, parameter: '').then((response) {
      getNotifList();
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    list = Provider.of<ProviderXO>(context, listen: true).getNotif();

    return CustomScaffold(
      padding: EdgeInsets.zero,
      // appBar: tittledAppBar(context: context, tittle: 'notification', backShow: true),
      resizeToAvoidBottomInset: false,
      body: Container(
          width: ResponsiveFlutter.of(context).wp(100),
          height: ResponsiveFlutter.of(context).hp(100),
          color: theme.colorScheme.blackColor,
          child: list.isEmpty
              ? Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            NavKey.navKey.currentState!.pop();
                          },
                          child: const ContainerTransparent(
                              margin: EdgeInsets.only(left: 12, top: 12),
                              padding: EdgeInsets.fromLTRB(10, 12, 10, 12),
                              width: 48,
                              bRadius: 60,
                              child: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: Colors.white,
                              ))),
                      const Expanded(
                        child: SizedBox(),
                      ),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       getTranslated(context, 'notification'),
                  //       style: TextStyles.textFt15Bold.textColor(theme.colorScheme.whiteColor),
                  //     )
                  //   ],
                  // ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Center(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveFlutter.of(context).wp(30), vertical: 52),
                    child: Image.asset(Assets.notif),
                  )),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    getTranslated(context, 'noNotif'),
                    style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor),
                    textAlign: TextAlign.center,
                  ),
                  const Expanded(
                    flex: 2,
                    child: SizedBox(),
                  ),
                ])
              : SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    InkWell(
                        onTap: () {
                          NavKey.navKey.currentState!.pop();
                        },
                        child: const ContainerTransparent(
                            margin: EdgeInsets.only(left: 12, top: 12),
                            padding: EdgeInsets.fromLTRB(10, 12, 10, 12),
                            width: 48,
                            bRadius: 60,
                            child: Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: Colors.white,
                            ))),
                  ]),
                  const SizedBox(
                    height: 16,
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              if (!list[index]['isRead']) {
                                setNotifRead(list[index]['_id']);
                              }
                            },
                            child: Container(
                                margin: const EdgeInsets.only(top: 12),
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 0.5),
                                    color: Colors.white.withValues(alpha: 0.15)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${list[index]['data']['title']}',
                                            style: TextStyles.textFt16Bold.textColor(Colors.white),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        if (!list[index]['isRead'])
                                          Container(
                                            width: 4,
                                            height: 4,
                                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                          )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      '${list[index]['data']['body']}',
                                      style: TextStyles.textFt14Bold.textColor(Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        Func.toDateTimeStr(list[index]['sendAt']),
                                        style: TextStyles.textFt12MoneyReg.textColor(Colors.grey),
                                      ),
                                    )
                                  ],
                                )));
                      }),
                  const SizedBox(
                    height: 30,
                  )
                ]))),
    );
  }
}
