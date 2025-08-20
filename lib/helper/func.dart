import 'package:intl/intl.dart';
import 'package:portal/helper/app_text.dart';

class Func {
  static bool isEmpty(Object o) => o == '';

  static bool isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  static int toInt(String money) {
    return double.parse(money).toInt();
  }

  static double toDouble(String money) {
    return double.parse(money);
  }

  static String fixedString(int mthdDay, String interst) {
    String interstDay = (double.parse(interst) / mthdDay).toStringAsFixed(2);
    return interstDay;
  }

  static String toStr(Object obj) {
    String res = '';
    try {
      if (obj is DateTime) {
        // res = DateFormat('yyyy-MM-dd HH:mm:ss').format(obj);
        res = DateFormat('yyyy-MM-dd').format(obj);
      } else if (obj is int) {
        res = obj.toString();
      } else if (obj is double) {
        res = obj.toString();
      } else if (obj is String) {
        res = obj;
      }
    } catch (e) {
      ////debugPrint(e);
    }
    return res;
  }

  static String toMoneyComma(
    Object value, {
    bool obscureText = false, //Secure mode ашиглах эсэх
    NumberFormat? numberFormat,
  }) {
    // ////debugPrint('testL:$value');

    /// Format number with "Decimal Point" digit grouping.
    /// 10000 -> 10,000.00
    if (obscureText) return AppText.OBSCURE_TEXT;

    //Хоосон утгатай эсэх
    if (Func.toStr(value) == '') {
      return '0';
    }

    //Зөвхөн тоо агуулсан эсэх
    String tmpStr = Func.toStr(value).replaceAll(',', '').replaceAll('.', '');
    if (!isNumeric(tmpStr)) {
      return '0.00';
    }

    //Хэрэв ',' тэмдэгт агуулсан бол устгана
    double tmpDouble = double.parse(Func.toStr(value).replaceAll(',', ''));

    String formattedStr = '';
    String result = '';
    try {
      //Format number
      NumberFormat formatter = numberFormat ?? NumberFormat('#,###.##');
      result = formatter.format(tmpDouble);
      formattedStr = result;
    } catch (e) {
      ////debugPrint(e);
      result = '0.00';
    }
    if (!formattedStr.contains('.')) {
      formattedStr = '$formattedStr₮';
    }

    return formattedStr;
  }

  static String toIntStr(String intRate) {
    return '${num.parse(intRate)}%';
  }

  static String toMoneyStr(
    Object value, {
    bool obscureText = false, //Secure mode ашиглах эсэх
    NumberFormat? numberFormat,
  }) {
    // ////debugPrint('testL:$value');

    /// Format number with "Decimal Point" digit grouping.
    /// 10000 -> 10,000.00
    if (obscureText) return AppText.OBSCURE_TEXT;

    //Хоосон утгатай эсэх
    if (Func.toStr(value) == '') {
      return '0.00';
    }

    //Зөвхөн тоо агуулсан эсэх
    String tmpStr = Func.toStr(value).replaceAll(',', '').replaceAll('.', '');
    if (!isNumeric(tmpStr)) {
      return '0.00';
    }

    //Хэрэв ',' тэмдэгт агуулсан бол устгана
    double tmpDouble = double.parse(Func.toStr(value).replaceAll(',', ''));

    String formattedStr = '';
    String result = '';
    try {
      //Format number
      NumberFormat formatter = numberFormat ?? NumberFormat('#,###.##');
      result = formatter.format(tmpDouble);
      formattedStr = '${result.replaceAll(',', '\'')} MNT';
    } catch (e) {
      ////debugPrint(e);
      result = '0.00';
    }
    // formattedStr = '$formattedStr₮';
    return formattedStr;
  }

  static String toDateStr(String str) {
    // Datetime string-ийг форматлаад буцаана '2019.01.01T15:13:00.000' to '2019.01.01'
    if (isEmpty(str)) return '';

    DateTime dateTime = DateTime.parse(str);
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    return formattedDate; //trim(str.split(" ")[0]);
  }

  static String toDateTimeStr(String str) {
    // Datetime string-ийг форматлаад буцаана '2019.01.01T15:13:00.000' to '2019.01.01 15:13:00'
    if (isEmpty(str)) return '';

    DateTime dateTime = DateTime.parse(str).toLocal();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

    return formattedDate; //trim(str.split(" ")[0]);
  }

  /// Can return null value
  // static DateTime toDate(String str) {
  //   DateTime res;

  //   try {
  //     res = DateTime.parse(str);
  //   } catch (e) {
  //     ////debugPrint(e);
  //   }

  //   return res;
  // }

  static bool checkPhoneNo(String phoneNo) {
    String firstNumber = phoneNo.trimLeft().substring(0, 2);
    //debugPrint("first:$firstNumber");
    switch (firstNumber) {
      case '94':
        return true;
      case '95':
        return true;
      case '99':
        return true;
      case '84':
        return true;
      case '89':
        return true;
      case '80':
        return true;
      case '86':
        return true;
      case '88':
        return true;
      case '90':
        return true;
      case '91':
        return true;
      case '96':
        return true;
      case '83':
        return true;
      case '93':
        return true;
      case '97':
        return true;
      case '98':
        return true;
      case '60':
        return true;
      case '66':
        return true;
      default:
        return false;
    }
  }
}
