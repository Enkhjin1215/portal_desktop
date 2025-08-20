import 'package:flutter/material.dart';

class AppText {
  static AppText? of(BuildContext context) {
    return Localizations.of<AppText>(
      context,
      AppText,
    );
  }

  // ignore: constant_identifier_names
  static const String PLACE_HOLDER = '[PLACE_HOLDER]';
  // ignore: constant_identifier_names
  static const String OBSCURE_TEXT = '***';

  static const String login = 'Нэвтрэх';

  static const String register = 'Бүртгүүлэх';

  static const String insertEmail = 'Та өөрийн мэйл хаягийг оруулна уу.';

  static const String emailInput = 'Мэйл хаяг оруулах';

  static const String pwdInput = 'Нууц үг оруулах';

  static const String continueTxt = 'Үргэлжлүүлэх';

  static const String wrongMailFormat = 'Буруу мэйл формат.';

  static const String useMongolNFTpassword = 'MongolNFT аккаунтын нууц үгийг\nоруулан нэвтэрнэ үү.';

  static const String insertNewUserName = 'Шинэ хэрэглэгчийн нэр оруулна уу.';

  static const String inserUserName = 'Хэрэглэгчийн нэр оруулах';

  static const String forgotPassword = 'Нууц үг мартсан?';

  static const String wrongPasswordFormat = 'Буруу нууц үг.';

  static const String pleaseInsertNewPassword = 'Шинэ нууц үг оруулна уу.';

  static const String insertNewPassword = 'Шинэ нууц үг оруулах';

  static const String repeatNewPassword = 'Шинэ нууц үг давтан оруулах';

  static const String emptyWarning = 'Хоосон байна.';

  static const String uppercase = 'Том үсэг';

  static const String lowercase = 'Жижиг үсэг';

  static const String specialCharacter = 'Тусгай тэмдэгт';

  static const String lengthis8 = '8 тэмдэгтээс их';

  static const String digit = 'Цифр';

  static const String mustSamePassword = 'Нууц үг ижилхэн байх';

  static const String cantPass = 'Шалгуур хангахгүй байна';

  static const String usernameNotUnique = 'Давхцаж байна';

  static const String mailConfirm = 'Мэйл баталгаажуулах';

  static const String pleaseCompleteField = 'Кодоо бүтэн оруулна уу';
}
