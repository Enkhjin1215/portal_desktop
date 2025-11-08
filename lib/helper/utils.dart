import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/models/event_detail_model.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class Utils {
  static final LocalAuthentication auth = LocalAuthentication();

  static Future<List<BiometricType>> getAvailableBiometricType() async {
    var bioType = await auth.getAvailableBiometrics();
    return bioType;
  }

  static String simpleObfuscate(String str) {
    const String key = 'PRTL_!@#\$%^&*()_+';
    // Convert to UTF-8 bytes
    final List<int> buffer = utf8.encode(str);
    final List<int> keyBuffer = utf8.encode(key);
    // XOR each byte with key bytes (cyclically)
    final Uint8List result = Uint8List(buffer.length);
    for (int i = 0; i < buffer.length; i++) {
      result[i] = buffer[i] ^ keyBuffer[i % keyBuffer.length];
    }
    return base64Encode(result);
  }

  static String simpleDeobfuscate(String str) {
    const String key = 'PRTL_!@#\$%^&*()_+';
    // Decode from base64
    final List<int> buffer = base64Decode(str);
    final List<int> keyBuffer = utf8.encode(key);
    // XOR each byte with key bytes (cyclically)
    final Uint8List result = Uint8List(buffer.length);
    for (int i = 0; i < buffer.length; i++) {
      result[i] = buffer[i] ^ keyBuffer[i % keyBuffer.length];
    }
    return utf8.decode(result);
  }

  static void hideKeyboard(BuildContext context) {
    // if (context == null) return;
    FocusScope.of(context).requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide'); // hide keyboard
  }

  static bool isEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    return emailRegex.hasMatch(email);
  }

  static bool passwordValidation(String password) {
    int least = 0;

    RegExp regexUpperCase = RegExp('(?:[A-Z]){$least}');
    RegExp regexSpecialSymbol = RegExp(r'[\^$*.\[\]{}()?\-"!@#%&/\,><:;_~`+='
        "'"
        ']');
    RegExp regexNumber = RegExp('(?:[0-9]){$least}');
    RegExp regexLowerCase = RegExp('(?:[a-z]){$least}');
    if (!regexUpperCase.hasMatch(password)) {
      return false;
    } else if (!regexNumber.hasMatch(password)) {
      return false;
    } else if (!regexLowerCase.hasMatch(password)) {
      return false;
    } else if (!regexSpecialSymbol.hasMatch(password)) {
      return false;
    } else {
      return true;
    }
  }

  static num rollPrice(int count) {
    if (count < 5) {
      return 2000 * count;
    } else if (count >= 5 && count < 10) {
      return 2000 * count * 0.9;
    } else {
      return 2000 * count * 0.85;
    }
  }

  static String rollPriceDiscountPercentage(int count) {
    if (count < 5) {
      return '0%';
    } else if (count >= 5 && count < 10) {
      return '10%';
    } else {
      return '15%';
    }
  }

  static num rollPriceDiscountAmt(int count) {
    if (count < 5) {
      return 0;
    } else if (count >= 5 && count < 10) {
      return 2000 * count - (2000 * count * 0.9);
    } else {
      return 2000 * count - (2000 * count * 0.85);
    }
  }

  static Ticket getTicketTemplateBySeat(List<Ticket> list, String seatId) {
    List<Ticket> seatList = list.where((e) => e.isSeat == true).toList();
    for (int i = 0; i < seatList.length; i++) {
      if (seatList[i].seats.isNotEmpty) {
        List<String> stringList = seatList[i].seats.map((item) => item.toString()).toList();
        if (stringList.contains(seatId)) {
          print('found:${seatList[i].id}');
          return seatList[i];
        }
      }
    }
    Ticket bigTicket = seatList.where((e) => e.seats.isEmpty == true).first;
    print('found 2:${bigTicket.id}');

    return bigTicket;
  }

  static String bufferArrayToString(List<dynamic> array) {
    return array.map((byte) => (byte as int).toRadixString(16).padLeft(2, '0')).join('');
  }

  static String formatSeatCode(String seatCode, String type) {
    RegExp regExp = RegExp(r'(?:F(\d+)-S([A-Z0-9]+)-)?R(\d+)-s(\d+)');
    Match? match = regExp.firstMatch(seatCode);
    if (match != null) {
      String floor = match.group(1) ?? '';
      String sector = match.group(2) ?? '';
      String row = match.group(3) ?? '';
      String seat = match.group(4) ?? '';

      switch (type) {
        case 'floor':
          return floor;
        case 'sector':
          return sector;
        case 'seat':
          return seat;
        case 'row':
          return row;
        default:
          return '*';
      }
      // return 'Floor: $floor, Sector: $sector, Seat: $seat';
    } else {
      return '';
    }
  }

  static Color hexToColor(String hexString) {
    hexString = hexString.replaceAll("#", ""); // Remove the '#' character if it exists
    return Color(int.parse("FF$hexString", radix: 16)); // Add 'FF' for full opacity and parse as a color
  }

  static Color? parseNamedColor(String colorName) {
    // Map of common color names to Flutter's Colors
    final Map<String, Color> namedColors = {
      "black": Colors.black,
      "white": Colors.white,
      "red": Colors.red,
      "green": Colors.green,
      "blue": Colors.blue,
      "yellow": Colors.yellow,
      "pink": Colors.pink,
      "purple": Colors.purple,
      "orange": Colors.orange,
      "brown": Colors.brown,
      "grey": Colors.grey,
      "cyan": Colors.cyan,
      "lime": Colors.lime,
      "teal": Colors.teal,
      "indigo": Colors.indigo,
      "amber": Colors.amber,
    };

    return namedColors[colorName.toLowerCase()];
  }

  // static Map<String, dynamic> reBuildBody(Map<String, dynamic>? data, Promo? promo, List<Ticket>? tickets) {
  //   Map<String, dynamic> finalData = {};
  //   for (int i = 0; i < data!['templates'].length!; i++) {
  //     var seats = data['templates'][i]['seats'];
  //     String templateID = data['templates'][i]['templateId'];
  //     if (seats.runtimeType == List<String>) {
  //       Ticket ticket = Utils.getTicketTemplateBySeat(tickets!, seats[0]);
  //     } else {
  //       for (int i = 0; i < tickets!.length; i++) {
  //         if (templateID == tickets[i].id) {

  //         }
  //       }
  //     }
  //   }

  //   return finalData;
  // }

  static String weekDay(int week, bool isEnglish) {
    if (week == 1) {
      return isEnglish ? 'Monday' : 'Даваа';
    } else if (week == 2) {
      return isEnglish ? 'Tuesday' : 'Мягмар';
    } else if (week == 3) {
      return isEnglish ? 'Wednesday' : 'Лхагва';
    } else if (week == 4) {
      return isEnglish ? 'Thursday' : 'Пүрэв';
    } else if (week == 5) {
      return isEnglish ? 'Friday' : 'Баасан';
    } else if (week == 6) {
      return isEnglish ? 'Saturday' : 'Бямба';
    } else {
      return isEnglish ? 'Sunday' : 'Ням';
    }
  }

  static String monthDate(int month, int day, bool isEnglish) {
    if (!isEnglish) {
      return '$month-р сар $day ';
    } else {
      DateTime date = DateTime(0, month);

      return "${DateFormat.MMMM().format(date)} $day ";
    }
  }

  static requiredText(String text, TextStyle style) {
    return RichText(
      text: TextSpan(text: text, style: style, children: <TextSpan>[
        TextSpan(
          text: ' *',
          style: TextStyles.textFt14Med.textColor(Colors.red),
        ),
      ]),
    );
  }
}

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
