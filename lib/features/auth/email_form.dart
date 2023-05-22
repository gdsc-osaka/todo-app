import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/check_text.dart';
import 'auth_providers.dart';

class EmailForm extends ConsumerStatefulWidget {
  const EmailForm(
      {super.key,
      required this.email,
      required this.password,
      required this.onChangeEmail,
      required this.onChangePassword});

  final String email;
  final String password;
  final ValueChanged<String> onChangeEmail;
  final ValueChanged<String> onChangePassword;

  @override
  ConsumerState<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends ConsumerState<EmailForm> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: "メールアドレス",
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
          autovalidateMode: AutovalidateMode.disabled,
          validator: (input) {
            if (input == null || !EmailValidator.validate(input)) {
              return "有効なメールアドレスを入力してください";
            } else {
              return null;
            }
          },
          initialValue: widget.email,
          onChanged: widget.onChangeEmail,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
              labelText: "パスワード",
              prefixIcon: const Icon(Icons.key),
              suffixIcon: IconButton(
                onPressed: () => setState(() {
                  _obscurePassword = !_obscurePassword;
                }),
                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
              )),
          obscureText: _obscurePassword,
          keyboardType: TextInputType.visiblePassword,
          autovalidateMode: AutovalidateMode.disabled,
          validator: (input) {
            if (input == null || input.length < 8) {
              return "8文字以上のパスワードを入力してください";
            } else {
              return null;
            }
          },
          initialValue: widget.password,
          onChanged: widget.onChangePassword,
        ),
        const SizedBox(height: 16),
        CheckText(
            mainAxisAlignment: MainAxisAlignment.center,
            value: ref.watch(isKeepAuthProvider),
            onChanged: (value) => ref.read(isKeepAuthProvider.notifier).state = value ?? true,
            child: const Text("ログインしたままにする"))
      ],
    );
  }
}
