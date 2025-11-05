import 'package:portal/helper/assets.dart';

class PaymentModel {
  String? name;
  bool? isSvg;
  String? image;
  String? type;
  bool? isQr;
  int? min;
  PaymentModel({this.name, this.isSvg, this.image, this.type, this.isQr, this.min});
  PaymentModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isSvg = json['isSvg'];
    image = json['image'];
    type = json['type'];
    isQr = json['isQr'];
    min = json['min'];
  }

  List<PaymentModel> getPaymentModel() {
    List<PaymentModel> payList = [
      PaymentModel(name: 'HiPay', isSvg: true, image: Assets.hipay, type: 'hipay', isQr: false, min: 0),
      PaymentModel(name: 'Monpay', isSvg: true, image: Assets.monpay, type: 'monpay', isQr: true, min: 0),
      PaymentModel(name: 'M Credit', isSvg: true, image: Assets.mcredit, type: 'mcredit', isQr: true, min: 0),
      PaymentModel(name: 'Simple', isSvg: false, image: Assets.simple, type: 'simple', isQr: false, min: 50000),
      // PaymentModel(name: 'Storepay', isSvg: false, image: Assets.storepay, type: 'storepay', isQr: false, min: 100000)

      // PaymentModel(name: 'Simple pay', isSvg: false, image: Assets.simple, type: 'simple', isQr: true)
    ];
    return payList;
  }

  List<PaymentModel> getPaymentMethods() {
    List<PaymentModel> payMethodList = [
      PaymentModel(name: 'QPay', isSvg: false, image: Assets.qpay, type: 'qpay', isQr: false, min: 0),
      // PaymentModel(name: 'SocialPay', isSvg: true, image: Assets.socialpay, type: 'socialpay', isQr: true, min: 0),
      // PaymentModel(name: 'Apple Pay', isSvg: false, image: Assets.applePay, type: 'applepay', isQr: false, min: 0),
      PaymentModel(name: 'POS', isSvg: true, image: Assets.pos, type: 'pos', isQr: false, min: 0),
      PaymentModel(name: 'CASH', isSvg: true, image: Assets.cash, type: 'wire', isQr: false, min: 0),

      // PaymentModel(name: 'QPos', isSvg: false, image: Assets.qpos, type: 'qpos', isQr: true),
      // PaymentModel(name: 'Digipay', isSvg: false, image: Assets.digipay, type: 'digipay_m', isQr: true, min: 0),
      // PaymentModel(name: 'Pocket', isSvg: false, image: Assets.pocket, type: 'pocket', isQr: false, min: 50000),
    ];
    return payMethodList;
  }
}
