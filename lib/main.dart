import 'dart:convert';

import 'package:etaseta_user/providers/cart_provider.dart';
import 'package:etaseta_user/providers/order_provider.dart';
import 'package:etaseta_user/providers/product_provider.dart';
import 'package:etaseta_user/providers/user_provider.dart';
import 'package:etaseta_user/ui/pages/cart_page.dart';
import 'package:etaseta_user/ui/pages/checkout_page.dart';
import 'package:etaseta_user/ui/pages/launcher_page.dart';
import 'package:etaseta_user/ui/pages/login_page.dart';
import 'package:etaseta_user/ui/pages/my_orders_page.dart';
import 'package:etaseta_user/ui/pages/order_details_page.dart';
import 'package:etaseta_user/ui/pages/product_details_page.dart';
import 'package:etaseta_user/ui/pages/product_page.dart';
import 'package:etaseta_user/ui/pages/profile_page.dart';
import 'package:etaseta_user/ui/pages/user_address_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:json_theme/json_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final themeStr =
      await rootBundle.loadString('assets/theme/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ProductProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => OrderProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => UserProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => CartProvider(),
      ),
    ],
    child: MyApp(theme: theme),
  ));
}

class MyApp extends StatelessWidget {
  final ThemeData theme;

  const MyApp({Key? key, required this.theme}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.wave
      ..toastPosition = EasyLoadingToastPosition.bottom;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      builder: EasyLoading.init(),
      initialRoute: LauncherPage.routeName,
      routes: {
        LauncherPage.routeName: (context) => LauncherPage(),
        LoginPage.routeName: (context) => LoginPage(),
        ProductPage.routeName: (context) => ProductPage(),
        ProductDetailsPage.routeName: (context) => ProductDetailsPage(),
        ProfilePage.routeName: (context) => ProfilePage(),
        CartPage.routeName: (context) => CartPage(),
        CheckoutPage.routeName: (context) => CheckoutPage(),
        UserAddressPage.routeName: (context) => UserAddressPage(),
        MyOrdersPage.routeName: (context) => MyOrdersPage(),
        OrderDetailsPage.routeName: (context) => OrderDetailsPage(),
      },
    );
  }
}
