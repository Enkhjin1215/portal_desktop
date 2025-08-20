import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:portal/components/bottom_navigation.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/screens/cart/ticket/ticketShape/gradient_text.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int userType = 0;
  String email = '';
  String username = 'null';
  String token = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    print('userType:$userType');
    userType = await application.getUserType();
    email = await application.getEmail();
    token = await application.getAccessToken() ?? '';
    Map<String, dynamic> data = JwtDecoder.decode(token);
    username = data['username'] ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    bool isEnglish = Provider.of<ProviderCoreModel>(context, listen: true).isEnglish;
    return CustomScaffold(
      padding: EdgeInsets.zero,
      // appBar: tittledAppBar(context: context, tittle: ''),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: ResponsiveFlutter.of(context).wp(100),
        height: ResponsiveFlutter.of(context).hp(100),
        color: theme.colorScheme.blackColor,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF2AD0CA),
                          Color(0xFFE1F664),
                          Color(0xFFEFB0FE),
                          Color(0xFFABB3FC),
                          Color(0xFF5DF7A4),
                          Color(0xFF58C4F6),
                          Color(0xFF5DF7A4),
                        ],
                        stops: [0, 0.1, 0.5, 0.7, 0.9, 0.95, 1],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    )),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: TextStyles.textFt18Bold.textColor(theme.colorScheme.whiteColor),
                    ),
                    Text(
                      email,
                      style: TextStyles.textFt14Reg.textColor(theme.colorScheme.hintColor),
                    )
                  ],
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                InkWell(
                  onTap: () async {
                    await Provider.of<ProviderCoreModel>(context, listen: false).clearUser();
                    NavKey.navKey.currentState!.pushNamedAndRemoveUntil(logRegStepOneRoute, (route) => false);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 7),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), shape: BoxShape.circle),
                    child: SvgPicture.asset(
                      Assets.logout,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              decoration: BoxDecoration(
                  color: theme.colorScheme.profileBackground,
                  border: Border.all(color: theme.colorScheme.fadedWhite.withValues(alpha: 0.7), width: 0.5),
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      NavKey.navKey.currentState!.pushNamed(eventTabtRoute);
                    },
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 2,
                        ),
                        SvgPicture.asset(
                          Assets.miniTicket,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        GradientText(
                          getTranslated(context, 'myPurchase'),
                          style: TextStyles.textFt15Bold,
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        const Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () {
                      NavKey.navKey.currentState!.pushNamed(walletRoute);
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          Assets.wallet,
                          color: Colors.white,
                          width: 25,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          getTranslated(context, 'wallet'),
                          style: TextStyles.textFt15Bold.textColor(theme.colorScheme.whiteColor),
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        const Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () {
                      NavKey.navKey.currentState!.pushNamed(profileEditRoute);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.account_circle_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          getTranslated(context, 'myInfo'),
                          style: TextStyles.textFt15Bold.textColor(theme.colorScheme.whiteColor),
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        const Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () {
                      application.showToast(getTranslated(context, 'soon'));
                      // NavKey.navKey.currentState!.pushNamed(myNFTRoute);
                    },
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 2,
                        ),
                        SvgPicture.asset(
                          Assets.nft,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          getTranslated(context, 'myNFTs'),
                          style: TextStyles.textFt15Bold.textColor(theme.colorScheme.whiteColor),
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        const Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () {
                      NavKey.navKey.currentState!.pushNamed(supportRoute);
                    },
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 2,
                        ),
                        SvgPicture.asset(
                          Assets.support,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          getTranslated(context, 'support'),
                          style: TextStyles.textFt15Bold.textColor(theme.colorScheme.whiteColor),
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        const Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.language_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        getTranslated(context, 'language'),
                        style: TextStyles.textFt15Bold.textColor(theme.colorScheme.whiteColor),
                      ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      Text(getTranslated(context, 'en'),
                          style: TextStyles.textFt15Bold.textColor(isEnglish ? theme.colorScheme.whiteColor : theme.colorScheme.fadedWhite)),
                      const SizedBox(
                        width: 8,
                      ),
                      Switch(
                        value: !isEnglish,
                        activeColor: theme.colorScheme.fadedWhite,
                        onChanged: (bool value) {
                          if (value) {
                            Provider.of<ProviderCoreModel>(context, listen: false).changeLanguage(Language(2, "mn", "Mongolia", "mn"), context);
                          } else {
                            Provider.of<ProviderCoreModel>(context, listen: false).changeLanguage(Language(1, "us", "English", "en"), context);
                          }
                        },
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(getTranslated(context, 'mn'),
                          style: TextStyles.textFt15Bold.textColor(!isEnglish ? theme.colorScheme.whiteColor : theme.colorScheme.fadedWhite))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(
        currentMenu: 3,
      ),
    );
  }
}
