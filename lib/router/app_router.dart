import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/screens/cart/payment_cart.dart';
import 'package:portal/screens/dashboard/home_screen.dart';
import 'package:portal/screens/dashboard/notif_permission.dart';
import 'package:portal/screens/dashboard/purchase_screen.dart';
import 'package:portal/screens/events/event_route.dart';
import 'package:portal/screens/events/event_webview_screen.dart';
import 'package:portal/screens/events/merch_detail_screen.dart';
import 'package:portal/screens/market/market_screen.dart';
import 'package:portal/screens/merch/merch_screen.dart';
import 'package:portal/screens/notification/notification.dart';
import 'package:portal/screens/onboard/onboard_logo_screen.dart';
import 'package:portal/screens/onboard/onboard_screen.dart';
import 'package:portal/screens/payment_section/payment_screen.dart';
import 'package:portal/screens/payment_section/payment_success_route.dart';
import 'package:portal/screens/portal_featured/cs_go_loot_screen.dart';
import 'package:portal/screens/portal_featured/item_details.dart';
import 'package:portal/screens/portal_featured/portal_featured_screen.dart';
import 'package:portal/screens/portal_featured/portal_main_screen.dart';
import 'package:portal/screens/portal_featured/steam/steam_main_screen.dart';
import 'package:portal/screens/portal_featured/x_o_screen.dart';
import 'package:portal/screens/profile/my_nft_screen.dart';
import 'package:portal/screens/profile/profile_delete_screen.dart';
import 'package:portal/screens/profile/profile_edit_screen.dart';
import 'package:portal/screens/profile/profile_screen.dart';
import 'package:portal/screens/profile/support/support_screen.dart';
import 'package:portal/screens/profile/wallet/wallet_add_screen.dart';
import 'package:portal/screens/profile/wallet/wallet_screen.dart';
import 'package:portal/screens/profile/wallet/wallet_verify_screen.dart';
import 'package:portal/screens/profile/wallet/wallet_withdraw_screen.dart';
import 'package:portal/screens/ticket/event_choose_seat_screen.dart';
import 'package:portal/screens/ticket/event_ticket_screen.dart';
import 'package:portal/screens/user/2fa_verify_screen.dart';
import 'package:portal/screens/user/biometric_verify_screen.dart';
import 'package:portal/screens/user/login_register_step_one.dart';
import 'package:portal/screens/user/login_step_one.dart';
import 'package:portal/screens/user/need_update_screen.dart';
import 'package:portal/screens/user/register_step_one.dart';
import 'package:portal/screens/user/register_step_three.dart';
import 'package:portal/screens/user/register_step_two.dart';
import 'package:portal/screens/user/splash_screen.dart';

import '../screens/cart/CartTab.dart';

class AppRouter {
  static Route<dynamic> generatedRoute(settings) {
    switch (settings.name) {
      case onboardLogoRoute:
        return PageTransition(
          child: const OnboardLogoScreen(),
          type: PageTransitionType.fade,
          duration: const Duration(microseconds: 1),
        );
      case onboardRoute:
        return PageTransition(
          child: const OnboardScreen(),
          type: PageTransitionType.fade,
          duration: const Duration(microseconds: 1),
        );
      case splashRoute:
        return PageTransition(
          child: const SplashScreen(),
          type: PageTransitionType.fade,
          duration: const Duration(microseconds: 1),
        );
      case homeRoute:
        return PageTransition(
          child: const HomeScreen(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 200),
          settings: settings,
          reverseDuration: const Duration(milliseconds: 200),
        );
      case onboardLogJoinedRoute:
        return PageTransition(
          child: const LogRegStepOne(),
          type: PageTransitionType.bottomToTopJoined,
          childCurrent: const OnboardScreen(),
          duration: const Duration(milliseconds: 300),
          settings: settings,
          reverseDuration: const Duration(milliseconds: 300),
        );

      case onboardHomeJoinedRoute:
        return PageTransition(
          child: const HomeScreen(),
          type: PageTransitionType.bottomToTopJoined,
          childCurrent: const OnboardScreen(),
          duration: const Duration(milliseconds: 300),
          settings: settings,
          reverseDuration: const Duration(milliseconds: 300),
        );
      case logRegStepOneRoute:
        return PageTransition(
            child: const LogRegStepOne(), type: PageTransitionType.fade, duration: const Duration(microseconds: 1), settings: settings);

      case twoFaRoute:
        return PageTransition(
            child: const TwoFAVerifyScreen(), type: PageTransitionType.fade, duration: const Duration(microseconds: 1), settings: settings);

      // case forgotPassRoute:
      //   return PageTransition(
      //     child: const ForgotPass(),
      //     type: PageTransitionType.fade,
      //     duration: const Duration(microseconds: 1),
      //   );
      case biometricVerifyRoute:
        return PageTransition(
          child: const BiometricVerifyScreen(),
          type: PageTransitionType.fade,
          duration: const Duration(microseconds: 1),
        );
      case loginStepOneRoute:
        return PageTransition(
            child: const LoginStepOne(), type: PageTransitionType.fade, duration: const Duration(microseconds: 1), settings: settings);
      case registerStepOneRoute:
        return PageTransition(
            child: const RegisterStepOne(), type: PageTransitionType.fade, duration: const Duration(microseconds: 1), settings: settings);
      case registerStepTwoRoute:
        return PageTransition(
            child: const RegisterStepTwo(), type: PageTransitionType.fade, duration: const Duration(microseconds: 1), settings: settings);
      case registerStepThreeRoute:
        return PageTransition(
          child: const RegisterStepThree(),
          type: PageTransitionType.fade,
          settings: settings,
          duration: const Duration(microseconds: 1),
        );
      // case notifPermissionRoute:
      //   return PageTransition(child: const NotifPermission(), type: PageTransitionType.fade, duration: const Duration(microseconds: 1));
      case eventRoute:
        return PageTransition(
            child: const EventRoute(),
            type: PageTransitionType.bottomToTop,
            settings: settings,
            duration: const Duration(milliseconds: 300),
            reverseDuration: const Duration(milliseconds: 400));
      case paymentRoute:
        return PageTransition(
            child: const PaymentScreen(),
            type: PageTransitionType.bottomToTop,
            settings: settings,
            reverseDuration: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 300));
      case paymentCartRoute:
        return PageTransition(
            child: const PaymentCart(),
            type: PageTransitionType.bottomToTop,
            settings: settings,
            reverseDuration: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 300));
      // case pendingPaymentRoute:
      //   return PageTransition(
      //       child: const PendingPayment(),
      //       type: PageTransitionType.fade,
      //       settings: settings,
      //       reverseDuration: const Duration(milliseconds: 300),
      //       duration: const Duration(milliseconds: 300));
      case merchDetailRoute:
        return PageTransition(
            child: const MerchDetail(),
            type: PageTransitionType.bottomToTop,
            settings: settings,
            reverseDuration: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 300));
      // case walletRoute:
      //   return SwipeablePageRoute(
      //     builder: (_) => const WalletScreen(),
      //     settings: settings,
      //     canOnlySwipeFromEdge: false,
      //     transitionDuration: const Duration(milliseconds: 300),
      //   );

      // case supportRoute:
      //   return SwipeablePageRoute(
      //     builder: (_) => const SupportScreen(),
      //     settings: settings,
      //     canOnlySwipeFromEdge: false,
      //     transitionDuration: const Duration(milliseconds: 300),
      //   );

      // case walletAddRoute:
      //   return SwipeablePageRoute(
      //     builder: (_) => const WalletAddScreen(),
      //     settings: settings,
      //     canOnlySwipeFromEdge: false,
      //     transitionDuration: const Duration(milliseconds: 300),
      //   );

      // case walletVerifyRoute:
      //   return SwipeablePageRoute(
      //     builder: (_) => const WalletVerify(),
      //     settings: settings,
      //     canOnlySwipeFromEdge: false,
      //     transitionDuration: const Duration(milliseconds: 300),
      //   );

      case eventTabtRoute:
        return PageTransition(
          child: const CartTab(),
          type: PageTransitionType.fade,
          duration: const Duration(microseconds: 1),
        );
      case merchMainRoute:
        return PageTransition(
          child: const MerchScreen(),
          type: PageTransitionType.fade,
          duration: const Duration(microseconds: 1),
        );
      case marketRoute:
        return PageTransition(
          child: const MarketScreen(),
          type: PageTransitionType.fade,
          duration: const Duration(microseconds: 1),
        );
      case walletWithdrawRoute:
        return PageTransition(
          child: const WalletWithdraw(),
          type: PageTransitionType.bottomToTop,
          childCurrent: const WalletScreen(),
          duration: const Duration(milliseconds: 300),
          settings: settings,
          reverseDuration: const Duration(milliseconds: 300),
        );
      case eventWebViewRoute:
        return PageTransition(
            child: const EventWebviewScreen(), type: PageTransitionType.fade, duration: const Duration(microseconds: 1), settings: settings);

      case eventTicketRoute:
        return PageTransition(
            childCurrent: const EventRoute(),
            child: const EventTicketScreen(),
            type: PageTransitionType.bottomToTop,
            settings: settings,
            reverseDuration: const Duration(milliseconds: 400),
            duration: const Duration(milliseconds: 300));

      case eventChooseSeatRoute:
        return PageTransition(
            child: const EventChooseSeatScreen(),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 300),
            settings: settings);
      case portalRoute:
        return PageTransition(
            child: const PortalFeaturedScreen(), type: PageTransitionType.fade, duration: const Duration(milliseconds: 0), settings: settings);

      case portalFeaturedDetail:
        return PageTransition(
            child: const ItemDetails(), type: PageTransitionType.fade, duration: const Duration(milliseconds: 0), settings: settings);
      case csgoRoute:
        return PageTransition(
            child: const CSGOLootScreen(), type: PageTransitionType.fade, duration: const Duration(milliseconds: 0), settings: settings);

      case steamMainRoute:
        return PageTransition(
            child: const SteamMainScreen(), type: PageTransitionType.fade, duration: const Duration(milliseconds: 0), settings: settings);

      case profileRoute:
        return PageTransition(
            child: const ProfileScreen(), type: PageTransitionType.fade, duration: const Duration(milliseconds: 0), settings: settings);
      case purchaseRoute:
        return PageTransition(
            child: const PurchaseScreen(), type: PageTransitionType.fade, duration: const Duration(milliseconds: 0), settings: settings);

      // case profileEditRoute:
      //   return SwipeablePageRoute(
      //     builder: (_) => const ProfileEditScreen(),
      //     settings: settings,
      //     canOnlySwipeFromEdge: false,
      //     transitionDuration: const Duration(milliseconds: 300),
      //   );

      // case myNFTRoute:
      //   return SwipeablePageRoute(
      //     builder: (_) => const MyNftScreen(),
      //     settings: settings,
      //     canOnlySwipeFromEdge: false,
      //     transitionDuration: const Duration(milliseconds: 300),
      //   );

      // case profileDeleteRoute:
      //   return SwipeablePageRoute(
      //     builder: (_) => const ProfileDelete(),
      //     settings: settings,
      //     canOnlySwipeFromEdge: false,
      //     transitionDuration: const Duration(milliseconds: 300),
      //   );
      case portalMainRoute:
        return PageTransition(
            child: const PortalMainScreen(), type: PageTransitionType.fade, duration: const Duration(milliseconds: 0), settings: settings);

      case notifRoute:
        return PageTransition(
            child: const NotificationList(), type: PageTransitionType.bottomToTop, duration: const Duration(milliseconds: 300), settings: settings);

      case paymentSuccessRoute:
        return PageTransition(
            child: const SuccessRoute(), type: PageTransitionType.fade, duration: const Duration(milliseconds: 0), settings: settings);
      case needUpdateRoute:
        return PageTransition(
            child: const NeedUpdateScreen(),
            settings: settings,
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 200),
            // childCurrent: LoginScreen(),
            reverseDuration: const Duration(milliseconds: 200));
      default:
        return PageTransition(
            child: const LogRegStepOne(), type: PageTransitionType.fade, duration: const Duration(microseconds: 1), settings: settings);
    }
  }
}
