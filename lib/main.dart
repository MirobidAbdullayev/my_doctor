import 'package:my_doctor/main_layout.dart';
import 'package:my_doctor/models/auth_model.dart';
import 'package:my_doctor/screens/auth_page.dart';
import 'package:my_doctor/screens/booking_page.dart';
import 'package:my_doctor/screens/success_booked.dart';
import 'package:my_doctor/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //this is for push navigator
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    //define ThemeData here
    return ChangeNotifierProvider<AuthModel>(
      create: (context) => AuthModel(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Flutter Doctor App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          //pre-define input decoration
          inputDecorationTheme: const InputDecorationTheme(
            focusColor: Config.PrimaryColor,
            focusedBorder: Config.focusBorder,
            errorBorder: Config.errorBorder,
            floatingLabelStyle: TextStyle(color: Config.PrimaryColor),
            prefixIconColor: Colors.black38,
          ),
          scaffoldBackgroundColor: Colors.white,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Config.PrimaryColor,
            selectedItemColor: Colors.white,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            unselectedItemColor: Colors.grey.shade700,
            elevation: 10,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthPage(),
          'main': (context) => const MainLayout(),
          'booking_page': (context) => BookingPage(),
          'success_booking': (context) => const AppointmentBooked(),
        },
      ),
    );
  }
}