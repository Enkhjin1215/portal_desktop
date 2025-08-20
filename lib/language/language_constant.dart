import 'package:flutter/material.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/language/app_localization.dart';

const String LANGUAGE_CODE = 'languageCode';

//languages code
const String ENGLISH = 'en';
const String MONGOLIA = 'mn';

Future<Locale> setLocale(String languageCode) async {
  await application.setLocale(languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  String languageCode = await application.getLocale() ?? "mn";
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, 'US');
    case MONGOLIA:
      return const Locale(MONGOLIA, "MN");
    default:
      return const Locale(MONGOLIA, "MN");
  }
}

String getTranslated(BuildContext context, String key) {
  return AppLocalization.of(context).translate(key);
}
