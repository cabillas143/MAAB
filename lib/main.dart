import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:redcross_mp/landing_page.dart';
import 'package:redcross_mp/user/dashboard.dart';
import 'package:redcross_mp/user/login_page.dart';
import 'package:redcross_mp/user/registration_page.dart';
import 'package:redcross_mp/user/signup_page.dart';
import 'package:redcross_mp/user/membership_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBZlQwXbyTabokS3D-ETuqmJM1Xaf2-yAw",
      appId: "1:950526525980:android:d46eafcf10eee5f45115d9",
      messagingSenderId: "950526525980",
      projectId: "redcrossmp-42cfa",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Default route
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const LandingPage());
          case '/login':
            return MaterialPageRoute(builder: (context) => const LoginPage());
          case '/signup':
            return MaterialPageRoute(builder: (context) => const SignupPage());
          case '/register':
            return MaterialPageRoute(
                builder: (context) => const RegistrationPage(
                      email: '',
                    ));
          case '/dashboard':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => DashboardPage(
                email: args?['email'] ?? '',
              ),
            );
          case '/membershipcards':
            return MaterialPageRoute(
              builder: (context) =>
                  const MembershipCardsPage(membershipTiers: []),
            );
          default:
            return MaterialPageRoute(builder: (context) => const LandingPage());
        }
      },
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
