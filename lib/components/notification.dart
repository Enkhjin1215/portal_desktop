import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class NotificationToast extends StatelessWidget {
  final String message;
  final String desc;
  final dynamic route;

  const NotificationToast({
    Key? key,
    this.message = '',
    this.desc = '',
    this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
      child: GestureDetector(
          onTap: () async {
            String jwtToken = await application.getAccessToken();
            ////debugPrint("jwt token:${jwtToken}");
            ////debugPrint("route:${route}");

            if (route.isNotEmpty && jwtToken.isNotEmpty) {
              // if (route['lnDetail'] != null) {
              //   NavKey.navKey.currentState?.pushNamed(loanDetailRoute, arguments: {
              //     'acntNo': route['lnDetail'],
              //     'isFromNotif': true,
              //   });
              // } else if (route['lnClosed'] != null) {
              //   NavKey.navKey.currentState?.pushNamed(loanHistoryDetail, arguments: {
              //     'isFromNotif': true,
              //     'acntNo': route['lnClosed'],
              //   });
              // } else if (route['cntr'] == 'success') {
              //   NavKey.navKey.currentState?.pushNamed(loanGetRoute, arguments: {'isFromNotif': true, 'changed': false});
              // }
            }
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey.withOpacity(0.3),
            child: Column(children: [
              SizedBox(
                height: ResponsiveFlutter.of(context).hp(8),
              ),
              Container(
                width: 327,
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                    color: theme.colorScheme.whiteColor, borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).fontSize(2))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.logo,
                      height: 32,
                      width: 32,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message,
                            maxLines: 1,
                            style: TextStyles.textFt14Reg.textColor(theme.colorScheme.blackColor),
                          ),
                          Text(
                            desc,
                            maxLines: 1,
                            style: TextStyles.textFt14Reg.textColor(theme.colorScheme.greyText),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ]),
          )),
    );
  }
}
