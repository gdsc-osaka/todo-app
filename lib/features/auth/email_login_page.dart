import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:todo_app/features/home/home_page.dart';

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

    logIn() async {
      if (_formKey.currentState?.validate() ?? false) {
        // 入力データが正常な場合
        context.loaderOverlay.show();
        final messenger = ScaffoldMessenger.of(context);

        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email,
            password: _password,
          );
          context.loaderOverlay.hide();
          if (mounted) context.go(HomePage.name);
        } on FirebaseAuthException catch (e) {
          context.loaderOverlay.hide();

          if (e.code == 'user-not-found' || e.code == 'wrong-password') {
            messenger.showSnackBar(const SnackBar(content: Text('ユーザー名またはパスワードが不明です')));
          }
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
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
              Text("メールアドレスでログイン", style: text.headlineSmall),
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
              FilledButton(onPressed: logIn, child: const Text("ログイン"))
            ],
          ),
        ),
      ),
    );
  }
}
