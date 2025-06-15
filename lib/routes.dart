import 'package:get/get.dart';
import 'package:tbc_application/app/modules/authentication/bindings/login_binding.dart';
import 'package:tbc_application/app/modules/authentication/views/login_view.dart';
import 'package:tbc_application/util/constants/text_strings.dart';

class AppRoute {

  AppRoute._();

  static final _routes = [


    // GetPage(
    //   name: RoutingUrl.onBoarding,
    //   page: () => const OnBoardingScreen(),
    // ),

    GetPage(
      name: RoutingUrl.login,
      binding: LoginBinding(),
      page: () => LoginView(),
      // middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: RoutingUrl.forgetPassword,
      binding: LoginBinding(),
      page: () => LoginView(),
      // middlewares: [AuthMiddleware()],
    ),

    // GetPage(
    //   name: RoutingUrl.forgetPassword,
    //   binding: RestorePasswordBinding(),
    //   page: () => const RestorePassword(),
    //   middlewares: [AuthMiddleware()],
    // ),

    // GetPage(
    //   name: RoutingUrl.home,
    //   page: () => const HomeScreen(),
    //   middlewares: [UnauthMiddleware()],
    //   binding: HomeBinding(),
    // ),

  ];

  static const INITIAL = RoutingUrl.login;

  static get route => _routes;
}
