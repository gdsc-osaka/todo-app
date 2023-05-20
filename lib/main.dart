import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/features/auth/email_login_page.dart';
import 'package:todo_app/features/auth/email_signup_page.dart';

import 'features/auth/auth_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

final _router = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => const RootPage()),
  GoRoute(path: AuthPage.name, builder: (context, state) => const AuthPage()),
  GoRoute(path: EmailSignUpPage.name, builder: (context, state) => const EmailSignUpPage()),
  GoRoute(path: EmailLoginPage.name, builder: (context, state) => const EmailLoginPage()),
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'To-Do',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  RootPageState createState() => RootPageState();
}

class RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user == null) {
        context.go(AuthPage.name);
      } else {
        // context.go(location)
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
