import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'email_form.dart';

class EmailLoginPage extends ConsumerStatefulWidget {
  const EmailLoginPage({Key? key}) : super(key: key);

  static const name = '/login';

  @override
  EmailLoginPageState createState() => EmailLoginPageState();
}

class EmailLoginPageState extends ConsumerState<EmailLoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.6;
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("メールアドレスでログイン", style: text.headlineSmall),
              const SizedBox(height: 60),
              EmailForm(
                  key: _formKey,
                  email: _email,
                  password: _password,
                  onChangeEmail: (value) => setState(() {
                        _email = value;
                      }),
                  onChangePassword: (value) => setState(() {
                        _password = value;
                      })),
              const SizedBox(height: 28),
              FilledButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // 入力データが正常な場合
                    }
                  },
                  child: const Text("ログイン"))
            ],
          ),
        ),
      ),
    );
  }
}
