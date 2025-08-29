import 'package:flutter/material.dart';
import 'package:portal/components/container_transparent.dart';
import 'package:portal/components/custom_app_bar.dart';
import 'package:portal/components/custom_button.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/components/custom_text.dart';
import 'package:portal/components/custom_text_input.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/func.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/steam_user_model.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class SteamMainScreen extends StatefulWidget {
  const SteamMainScreen({super.key});

  @override
  State<SteamMainScreen> createState() => _SteamMainScreenState();
}

class _SteamMainScreenState extends State<SteamMainScreen> {
  final TextEditingController _accountIdController = TextEditingController(text: '');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _accountIdFocus = FocusNode();
  num ratio = 3600;
  SteamUser? steamUser;
  bool isError = false;
  @override
  void dispose() {
    _accountIdController.dispose();
    _nameController.dispose();
    _amountController.dispose();
    _accountIdFocus.dispose();
    super.dispose();
  }

  void _onSteamIdTap(String steamId) {
    _amountController.text = steamId;
  }

  @override
  void initState() {
    super.initState();
    steamExchangeRate();
  }

  void _onLoginTap() async {
    Map<String, dynamic> data = {};

    if (steamUser == null) {
      application.showToastAlert('Steam хаягаа зөв оруулна уу');
    } else if (_amountController.text == '' || double.parse(_amountController.text.trim()) <= 0) {
      application.showToastAlert('Үнийн дүнгээ зөв оруулна уу');
    } else {
      // String idToken = await application.getIdToken();
      data['accountId'] = _accountIdController.text.trim();
      data['amount'] = double.parse(_amountController.text.trim());
      // data['idToken'] = idToken;

      print('----------->$data');

      NavKey.navKey.currentState!.pushNamed(paymentRoute, arguments: {'data': data, 'promo': '', 'ebarimt': '', 'steam': true});
    }
  }

  steamCheckAccount() async {
    try {
      await Webservice().loadGet(SteamUser.steamCheckAcc, context, parameter: _accountIdController.text.trim()).then((response) {
        setState(() {
          steamUser = response;
          _nameController.text = steamUser?.personaName ?? '';
          isError = false;
        });
      });
    } catch (e) {
      setState(() {
        isError = true;
        _nameController.clear();
      });
    }
  }

  steamExchangeRate() async {
    try {
      await Webservice().loadGet(Response.steamExchangeRate, context, parameter: '').then((response) {
        setState(() {
          ratio = response['currency'];
        });
      });
    } catch (e) {
      setState(() {
        ratio = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return CustomScaffold(
      padding: EdgeInsets.zero,
      backgroundColor: theme.colorScheme.blackColor,
      appBar: tittledAppBar(context: context, tittle: 'steamCharge', backShow: true),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            getTranslated(context, 'steamDesc'),
            style: TextStyles.textFt16Reg.textColor(theme.colorScheme.whiteColor),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF114d7d), // blue-900
                  Color(0xFF185f90), // blue-800
                  Color(0xFF0F766E), // teal-700
                ],
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                        color: Colors.white.withValues(alpha: 0.6),
                        blurRadius: 1,
                        spreadRadius: 0,
                        offset: const Offset(0, 1),
                        blurStyle: BlurStyle.outer),
                  ]),
                  child: steamUser?.avatar != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(
                            steamUser!.avatarMedium,
                            fit: BoxFit.fill,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 32,
                        ),
                ),
                const SizedBox(height: 24),

                // Account ID Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Account ID',
                      style: CustomTextStyle.Normal,
                      color: Colors.white70,
                      alignment: Alignment.centerLeft,
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      focusNode: _accountIdFocus,
                      controller: _accountIdController,
                      hintText: 'Account ID оруулна уу',
                      inputType: TextInputType.number,
                      fillColor: Colors.white.withOpacity(0.1),
                      borderColor: Colors.white.withOpacity(0.3),
                      textColor: Colors.white,
                      onFocusChanged: (p0) {
                        if (!p0) {
                          steamCheckAccount();
                        }
                      },
                      onDone: () {
                        steamCheckAccount();
                      },
                    ),
                    if (isError)
                      CustomText(
                        'Account олдсонгүй',
                        style: CustomTextStyle.Normal,
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                      )
                  ],
                ),
                const SizedBox(height: 16),

                // Name Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Name',
                      style: CustomTextStyle.Normal,
                      color: Colors.white70,
                      alignment: Alignment.centerLeft,
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      enable: false,
                      controller: _nameController,
                      hintText: '-',
                      inputType: TextInputType.text,
                      fillColor: Colors.white.withOpacity(0.1),
                      borderColor: Colors.white.withOpacity(0.3),
                      textColor: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Password Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Цэнэглэх дүн',
                      style: CustomTextStyle.Normal,
                      color: Colors.white70,
                      alignment: Alignment.centerLeft,
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _amountController,
                      hintText: '0₮',
                      inputType: TextInputType.numberWithOptions(decimal: true),
                      obscureText: false,
                      fillColor: Colors.white.withOpacity(0.1),
                      borderColor: Colors.white.withOpacity(0.3),
                      textColor: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Steam ID Options Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5,
                  children: [
                    _buildSteamIdButton(2.5),
                    _buildSteamIdButton(5),
                    _buildSteamIdButton(10),
                    _buildSteamIdButton(15),
                  ],
                ),
                const SizedBox(height: 24),

                // Login Button
                CustomButton(
                  margin: EdgeInsets.zero,
                  width: double.infinity,
                  height: 56,
                  text: 'Цэнэглэх',
                  backgroundColor: Colors.white,
                  textColor: const Color(0xFF1E3A8A),
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  bRadius: BorderRadius.circular(12),
                  onTap: _onLoginTap,
                ),
              ],
            ),
          ),
          SizedBox(height: ResponsiveFlutter.of(context).hp(8)),
        ]),
      )),
    );
  }

  Widget _buildSteamIdButton(num amt) {
    return GestureDetector(
      onTap: () => _onSteamIdTap("${amt * ratio}"),
      child: ContainerTransparent(
        opacity: 0.2,
        bRadius: 8,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: CustomText(
          '$amt\$ ~ ${Func.toMoneyComma(amt * ratio)}',
          style: CustomTextStyle.Normal,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
