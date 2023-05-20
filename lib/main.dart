import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/features/auth/email_signup_page.dart';

import 'features/auth/auth_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final _router = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => const RootPage()),
  GoRoute(path: AuthPage.name, builder: (context, state) => const AuthPage()),
  GoRoute(path: EmailSignUpPage.name, builder: (context, state) => const EmailSignUpPage()),
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class RootPage extends ConsumerWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    context.go(AuthPage.name);

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
