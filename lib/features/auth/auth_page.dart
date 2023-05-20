import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/components/check_text.dart';
import 'package:todo_app/components/text_divider.dart';
import 'package:todo_app/features/auth/email_signup_pagevider.dart';

import 'auth_providers.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  static const name = "/auth";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width * 0.6;
    final theme = Theme.of(context);
    final text = theme.textTheme;

    final signUpButtons = [
      SizedBox(width: double.infinity, child: FilledButton(onPressed: () {}, child: Text("Googleで登録"))),
      const SizedBox(height: 16),
      SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: () => context.push(EmailSignUpPage.name), child: const Text("メールアドレスで登録"))),
    ];

    final logInButtons = [
      SizedBox(width: double.infinity, child: FilledButton(onPressed: () {}, child: const Text("Googleでログイン"))),
      const SizedBox(height: 16),
      SizedBox(width: double.infinity, child: FilledButton(onPressed: () {}, child: const Text("メールアドレスでログイン"))),
      const SizedBox(height: 20),
      CheckText(
          mainAxisAlignment: MainAxisAlignment.center,
          value: ref.watch(isKeepAuthProvider),
          onChanged: (value) => ref.read(isKeepAuthProvider.notifier).setState(value ?? true),
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
