import 'package:flutter/material.dart';
import 'package:portal/helper/application.dart';

class ThemeNotifier with ChangeNotifier {
  bool _themeType;

  ThemeNotifier(this._themeType);

  static final List<ThemeData> themeData = [
    ThemeData(
        textTheme: const TextTheme(titleMedium: TextStyle(color: Colors.black, fontSize: 12)),
        brightness: Brightness.light,
        primaryColor: const Color(0xff24ABF8),
        shadowColor: Colors.black,
        hintColor: const Color(0xFFF4F6F8),
        colorScheme: const ColorScheme.light(background: Colors.white, onPrimaryContainer: Colors.white, primaryContainer: Colors.white)
            .copyWith(background: Colors.white)),
    ThemeData(
        textTheme: const TextTheme(titleMedium: TextStyle(color: Colors.blue, fontSize: 12)),
        brightness: Brightness.dark,
        primaryColor: Colors.pink,
        shadowColor: Colors.black,
        hintColor: const Color(0xFFF4F6F8),
        colorScheme: const ColorScheme.dark(background: Colors.black, onPrimaryContainer: Colors.black, primaryContainer: Colors.black)
            .copyWith(background: Colors.black))
  ];

  setTheme() async {
    application.setThemeType();
    _themeType = await application.getThemeType();
    notifyListeners();
  }

  getTheme() {
    // ignore: unnecessary_null_comparison
    if (_themeType == null || _themeType == false) {
      return themeData[0];
    }
    return themeData[1];
  }

  getThemeType() {
    if (_themeType == false) {
      return false;
    }
    return true;
  }
}

extension CustomColorScheme on ColorScheme {
  Color get whiteColor => const Color(0xFFFAFAFA);
  Color get blackColor => Colors.black;
  Color get backColor => const Color(0x66A1A1AA);
  Color get profileBackground => const Color(0xFF141414);
  Color get profileAppBar => const Color(0xFF202020);
  Color get backgroundColor => const Color(0xFF1E1E1E);
  Color get inputBackground => const Color(0xFF171717);
  Color get iconBackground => const Color(0xFF1b1b1b);
  Color get toastWarningColor => const Color(0xFFE0AC00);
  Color get toastGreenColor => Colors.green;
  Color get bottomNavigationColor => const Color(0xFF0e0e0e);
  Color get colorGrey => const Color(0xFFbdbdbf);
  Color get softBlack => const Color(0xFF262626);
  Color get fadedWhite => const Color(0xFF8c8d8d);
  Color get hintColor => const Color(0xFF737373);
  Color get hintGrey => const Color(0xFFD4D4D4);
  Color get darkGrey => const Color(0xFF363636);
  Color get weekDayColor => const Color(0xFFA3A3A3);
  Color get ticketItemColor => const Color(0xFFa6aaac);
  Color get ticketDescColor => const Color(0xFFF9FAFB);
  Color get mattBlack => const Color(0xFF181818);
  Color get darkGreen => const Color(0xFF1f302a);
  Color get neonGreen => const Color(0xFF48c97e);
  Color get greyText => const Color(0xFF71717A);
  Color get hipay => const Color(0xFFf54753);
  Color get loadingIcon => const Color(0xFFD1D5DB);
  Color get primaryColor => const Color(0xFFeeeeee);
  Color get primaryColor1 => const Color(0xFFaee4ed);
  Color get primaryColor2 => const Color(0xFF5fb7cf);
  Color get primaryColor3 => const Color(0xFF5a79c8);
  Color get bgDark => const Color(0xFF242424);
  Color get neutral200 => const Color(0xFFE5E5E5);
  Color get backgroundBlack => const Color(0xFF000000);
  Color get discountColor => const Color(0xFF5DF7A4);
}
