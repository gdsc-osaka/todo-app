import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:todo_app/components/check_text.dart';
import 'package:todo_app/components/text_divider.dart';
import 'package:todo_app/features/auth/email_login_page.dart';
import 'package:todo_app/features/home/home_page.dart';

import 'auth_providers.dart';
import 'email_signup_page.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  static const name = "/auth";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width * 0.6;
    final theme = Theme.of(context);
    final text = theme.textTheme;

    googleSignUp() async {
      final messenger = ScaffoldMessenger.of(context);
      context.loaderOverlay.show();

      try {
        final account = await GoogleSignIn(scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ]).signIn();

        if (account == null) {
          context.loaderOverlay.hide();
          messenger.showSnackBar(const SnackBar(content: Text("認証に失敗しました")));
          return;
        }

        final auth = await account.authentication;
        final credential = GoogleAuthProvider.credential(idToken: auth.idToken, accessToken: auth.accessToken);

        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final user = userCredential.user;

        if (user == null) {
          context.loaderOverlay.hide();
          messenger.showSnackBar(const SnackBar(content: Text("認証に失敗しました")));
          return;
        } else {
          context.loaderOverlay.hide();
          if (context.mounted) {
            context.go(HomePage.name);
          }
          return;
        }
      } catch (e) {
        context.loaderOverlay.hide();
      }
    }

    final signUpButtons = [
      SizedBox(width: double.infinity, child: FilledButton(onPressed: googleSignUp, child: const Text("Googleで登録"))),
      const SizedBox(height: 16),
      SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: () => context.push(EmailSignUpPage.name), child: const Text("メールアドレスで登録"))),
    ];

    final logInButtons = [
      SizedBox(width: double.infinity, child: FilledButton(onPressed: googleSignUp, child: const Text("Googleでログイン"))),
      const SizedBox(height: 16),
      SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: () => context.push(EmailLoginPage.name), child: const Text("メールアドレスでログイン"))),
      const SizedBox(height: 20),
      CheckText(
          mainAxisAlignment: MainAxisAlignment.center,
          value: ref.watch(isKeepAuthProvider),
          onChanged: (value) => ref.read(isKeepAuthProvider.notifier).state = value ?? true,
          child: const Text("ログインしたままにする"))
    ];

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("ユーザー登録", style: text.headlineSmall),
              const SizedBox(height: 60),
              ...signUpButtons,
              const SizedBox(height: 28),
              const TextDivider(child: Text("または")),
              const SizedBox(height: 28),
              ...logInButtons,
            ],
          ),
        ),
      ),
    );
  }
}
