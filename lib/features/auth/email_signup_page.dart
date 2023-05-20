import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth_providers.dart';
import 'check_text.dart';

class EmailSignUpPage extends ConsumerStatefulWidget {
  const EmailSignUpPage({super.key});

  @override
  ConsumerState<EmailSignUpPage> createState() => _EmailSignUpPageState();
}

class _EmailSignUpPageState extends ConsumerState<EmailSignUpPage> {
  String _email = "";
  String _password = "";
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.6;
    final theme = Theme.of(context);
    final text = theme.textTheme;

    final form = [
      TextFormField(
        decoration: const InputDecoration(labelText: "メールアドレス"),
        autovalidateMode: AutovalidateMode.disabled,
        validator: (input) {
          if (input == null || !EmailValidator.validate(input)) {
            return "有効なメールアドレスを入力してください";
          } else {
            return null;
          }
        },
        initialValue: _email,
        onChanged: (input) => _email = input,
      ),
      const SizedBox(height: 16),
      TextFormField(
        decoration: InputDecoration(
            labelText: "パスワード",
            suffixIcon: IconButton(
              onPressed: () => setState(() {
                _obscurePassword = !_obscurePassword;
              }),
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
            )),
        obscureText: _obscurePassword,
        autovalidateMode: AutovalidateMode.disabled,
        validator: (input) {
          if (input == null || input.length < 8) {
            return "8文字以上のパスワードを入力してください";
          } else {
            return null;
          }
        },
        initialValue: _password,
        onChanged: (input) => _password = input,
      ),
      const SizedBox(height: 16),
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
              Text("メールアドレスで登録", style: text.headlineSmall),
              const SizedBox(height: 60),
              ...form,
              const SizedBox(height: 28),
              FilledButton(onPressed: () {}, child: const Text("登録"))
            ],
          ),
        ),
      ),
    );
  }
}
