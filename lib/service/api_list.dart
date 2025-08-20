class APILIST {
  // development
  // static const baseUrl = 'http://192.168.1.15:3030/v1';
  // static const authService = 'http://192.168.1.15:3030/v1';

  static const baseUrl = 'https://client.portal.mn/v1';

  static const authService = 'https://client.portal.mn/v1';

  // static const authService = 'https://st-client.portal.mn/v1';

  // static const baseUrl = 'https://st-client.portal.mn/v1';

  static const webUrl = 'https://www.portal.mn/';

  static const refreshToken = '$authService/auth/loginWithRefreshToken';

  static const authcheckMail = '$authService/auth/check';

  static const authLogin = '$authService/auth/login';

  static const authCheckUsername = '$baseUrl/user/check-username';

  static const forgotPass = '$authService/auth/password/reset/';

  static const forgotPassConfirm = '$authService/auth/password/confirm';

  static const loginTwoFA = '$authService/auth/loginMFA';

  static const authRegister = '$authService/auth/register';

  static const authOtpResend = '$authService/auth/challengeResend';

  static const authOtpCheck = '$authService/auth/confirm';

  static const deleteAcc = '$authService/user/delete-account';

  static const eventList = '$baseUrl/event/group';

  static const eventDetail = '$baseUrl/event/';

  static const createInvoice = '$baseUrl/payment/invoice';

  static const changeInvoice = '$baseUrl/payment/invoice/change-method/';

  static const eventChildren = '$baseUrl/event/';

  static const ticketList = '$baseUrl/user/me/tickets';

  static const orderList = '$baseUrl/user/me/bar-items';

  static const myMerchList = '$baseUrl/user/me/merches';

  static const eventBar = '$baseUrl/ticket-bar/event/';

  static const eventMerch = '$baseUrl/merch-template/event/';

  static const wallet = '$baseUrl/user/me/wallet';

  static const walletHistory = '$baseUrl/wallet-log/me';

  static const userbankAccount = '$baseUrl/user-bank';

  static const checkVersion = 'https://client.portal.mn/checkVersion/';

  static const userbankVerifyAccnt = '$baseUrl/user-bank/verify-bank-account';

  static const userbankWithdraw = '$baseUrl/user-bank/withdraw';

  static const eventChooseSeat = 'https://portal.mn/seat-picker/';

  static const deleteInvoice = '$baseUrl/payment/discard/';

  static const pendingInvoice = '$baseUrl/payment/pending';

  static const checkInvoice = '$baseUrl/payment/check-invoice/';

  static const checkAppleInvoice = '$baseUrl/applepay/process/';

  static const deleteCheckAccount = '$baseUrl/user/delete-account/condition/user';

  static const featuredImage = '$baseUrl/event/query?type=FEATURED&type=PUBLIC&isEnded=false&page=1&limit=10&sortBy=createdAt';

  static const nftList = '$baseUrl/mongolnft/tickets/nft-templates';

  static const appleWallet = '$baseUrl/ticket/';

  static const ebarimtCheck = 'https://ebarimt.portal.mn/v1/ebarimt/info/';

  static const promoCheck = '$baseUrl/promo/validate';

  static const ticketDivide = '$baseUrl/ticket/divide/';

  static const bankCheck = '$baseUrl/check-feature/bank';

  static const quizNight = 'https://www.quiznight.mn/api/send_name';

  static const fcmToken = '$baseUrl/push-notification/fcm-token';

  static const notifList = '$baseUrl/push-notification/notifications';

  static const notifRead = '$baseUrl/push-notification/read';

  static const merchList = '$baseUrl/merch-template';

  static const csox = '$baseUrl/csox';

  static const csoxClaimDaily = '$baseUrl/csox/daily/';

  static const steamCheckAccount = '$baseUrl/steam/check-account/';

  static const steamExchangeRate = '$baseUrl/steam/exchange-rate';

  static const steamTradeUrl = '$baseUrl/csox/connect-trade-url';

  static const merchCertSend = '$baseUrl/merch/send-certificate';
}
