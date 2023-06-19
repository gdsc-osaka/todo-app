import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:todo_app/features/auth/email_form.dart';
import 'package:todo_app/api/firestore_api.dart';

import '../home/home_page.dart';

class EmailSignUpPage extends ConsumerStatefulWidget {
  const EmailSignUpPage({super.key});

  static const name = "/signup";

  @override
  ConsumerState<EmailSignUpPage> createState() => _EmailSignUpPageState();
}

class _EmailSignUpPageState extends ConsumerState<EmailSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.8;
    final theme = Theme.of(context);
    final text = theme.textTheme;

    signUp() async {
      if (_formKey.currentState?.validate() ?? false) {
        // 入力データが正常な場合
      }
    }

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
              Form(
                key: _formKey,
                child: EmailForm(
                    email: _email,
                    password: _password,
                    onChangeEmail: (value) => setState(() {
                          _email = value;
                        }),
                    onChangePassword: (value) => setState(() {
                          _password = value;
                        })),
              ),
              const SizedBox(height: 28),
              FilledButton(onPressed: signUp, child: const Text("登録"))
            ],
          ),
        ),
      ),
    );
  }
}
