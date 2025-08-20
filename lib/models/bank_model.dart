class BankModel {
  String? name;
  String? desc;
  String? logo;
  String? link;
  String? type;
  BankModel({this.name, this.desc, this.logo, this.link, this.type});
  BankModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    desc = json['description'];
    logo = json['logo'];
    link = json['link'];
    type = json['type'] ?? '';
  }
}

class QpayBanks {
  List getAll() => deeplinks;
  List<BankModel> getBanks() => deeplinks.map((map) => BankModel.fromJson(map)).map((item) => item).toList();
  List<BankModel> getBankList() => justBanks.map((map) => BankModel.fromJson(map)).map((item) => item).toList();

  List deeplinks = [
    {
      'name': 'qPay wallet',
      'description': 'qPay хэтэвч',
      'logo': 'https://s3.qpay.mn/p/e9bbdc69-3544-4c2f-aff0-4c292bc094f6/launcher-icon-ios.jpg',
      'link': 'qpaywallet://q?qPay_QRcode=',
    },
    {
      'name': 'Khan bank',
      'description': 'Хаан банк',
      'logo': 'https://qpay.mn/q/logo/khanbank.png',
      'link': 'khanbank://q?qPay_QRcode=',
    },
    {
      'name': 'State bank 3.0',
      'description': 'Төрийн банк 3.0',
      'logo': 'https://qpay.mn/q/logo/state_3.png',
      'link': 'statebankmongolia://q?qPay_QRcode=',
    },
    {
      'name': 'Xac bank',
      'description': 'Хас банк',
      'logo': 'https://qpay.mn/q/logo/xacbank.png',
      'link': 'xacbank://q?qPay_QRcode=',
    },
    {
      'name': 'TDB',
      'description': 'TDB online',
      'logo': 'https://qpay.mn/q/logo/tdbbank.png',
      'link': 'tdbbank://q?qPay_QRcode=',
    },
    {
      'name': 'SocialPay',
      'description': 'Голомт SocialPay',
      'logo': 'https://qpay.mn/q/logo/socialpay.png',
      'link': 'socialpay-payment://q?qPay_QRcode=',
    },
    {
      'name': 'Most money',
      'description': 'МОСТ мони',
      'logo': 'https://qpay.mn/q/logo/most.png',
      'link': 'most://q?qPay_QRcode=',
    },
    {
      'name': 'National investment bank',
      'description': 'Үндэсний хөрөнгө оруулалтын банк',
      'logo': 'https://qpay.mn/q/logo/nibank.jpeg',
      'link': 'nibank://q?qPay_QRcode=',
    },
    {
      'name': 'Chinggis khaan bank',
      'description': 'Чингис Хаан банк',
      'logo': 'https://qpay.mn/q/logo/ckbank.png',
      'link': 'ckbank://q?qPay_QRcode=',
    },
    {
      'name': 'Capitron bank',
      'description': 'Капитрон банк',
      'logo': 'https://qpay.mn/q/logo/capitronbank.png',
      'link': 'capitronbank://q?qPay_QRcode=',
    },
    {
      'name': 'Bogd bank',
      'description': 'Богд банк',
      'logo': 'https://qpay.mn/q/logo/bogdbank.png',
      'link': 'bogdbank://q?qPay_QRcode=',
    },
    {
      'name': 'Trans bank',
      'description': 'Тээвэр хөгжлийн банк',
      'logo': 'https://qpay.mn/q/logo/transbank.png',
      'link': 'transbank://q?qPay_QRcode=',
    },
    {
      'name': 'M bank',
      'description': 'М банк',
      'logo': 'https://qpay.mn/q/logo/mbank.png',
      'link': 'mbank://q?qPay_QRcode=',
    },
    {
      'name': 'Ard App',
      'description': 'Ард Апп',
      'logo': 'https://qpay.mn/q/logo/ardapp.png',
      'link': 'ard://q?qPay_QRcode=',
    },
    {
      'name': 'Arig bank',
      'description': 'Ариг банк',
      'logo': 'https://qpay.mn/q/logo/arig.png',
      'link': 'arig://q?qPay_QRcode=',
    },
    {
      'name': 'Monpay',
      'description': 'Мон Пэй',
      'logo': 'https://qpay.mn/q/logo/monpay.png',
      'link': 'Monpay://q?qPay_QRcode=',
    },
  ];

  List justBanks = [
    {
      'name': 'Khan bank',
      'description': 'Хаан банк',
      'logo': 'https://qpay.mn/q/logo/khanbank.png',
      'link': 'khanbank://q?qPay_QRcode=',
      'type': 'KHAN'
    },
    {
      'name': 'Golomt bank',
      'description': 'Голомт',
      'link': 'socialpay-payment://q?qPay_QRcode=',
      'type': 'GOLOMT',
      'logo': 'https://play-lh.googleusercontent.com/9tUBesUsI4UIkpgO1MPIMLFvhDa_4vZE75TrVAUHFA7a0bJ7IIgeyh2r1QXs9VlmXmkX'
    },
    {
      'name': 'State bank 3.0',
      'description': 'Төрийн банк 3.0',
      'logo': 'https://qpay.mn/q/logo/state_3.png',
      'link': 'statebankmongoli://q?qPay_QRcode=',
      'type': 'TOR'
    },
    {'name': 'Xac bank', 'description': 'Хас банк', 'logo': 'https://qpay.mn/q/logo/xacbank.png', 'link': 'xacbank://q?qPay_QRcode=', 'type': 'KHAS'},
    {
      'name': 'Trade and Development bank',
      'description': 'TDB online',
      'logo': 'https://qpay.mn/q/logo/tdbbank.png',
      'link': 'tdbbank://q?qPay_QRcode=',
      'type': 'TDB'
    },

    {
      'name': 'Chinggis khaan bank',
      'description': 'Чингис Хаан банк',
      'logo': 'https://qpay.mn/q/logo/ckbank.png',
      'link': 'ckbank://q?qPay_QRcode=',
      'type': 'CHINGIS'
    },
    {
      'name': 'Capitron bank',
      'description': 'Капитрон банк',
      'logo': 'https://qpay.mn/q/logo/capitronbank.png',
      'link': 'capitronbank://q?qPay_QRcode=',
      'type': 'CAPITRON'
    },
    {
      'name': 'Bogd bank',
      'description': 'Богд банк',
      'logo': 'https://qpay.mn/q/logo/bogdbank.png',
      'link': 'bogdbank://q?qPay_QRcode=',
      'type': 'BOGD'
    },
    {
      'name': 'Trans bank',
      'description': 'Тээвэр хөгжлийн банк',
      'logo': 'https://qpay.mn/q/logo/transbank.png',
      'link': 'transbank://q?qPay_QRcode=',
      'type': 'TEEVER_HOGJIL'
    },
    // {
    //   'name': 'M bank',
    //   'description': 'М банк',
    //   'logo': 'https://qpay.mn/q/logo/mbank.png',
    //   'link': 'mbank://q?qPay_QRcode=',
    // },
    {'name': 'Arig bank', 'description': 'Ариг банк', 'logo': 'https://qpay.mn/q/logo/arig.png', 'link': 'arig://q?qPay_QRcode=', 'type': 'ARIG'},
  ];
}
