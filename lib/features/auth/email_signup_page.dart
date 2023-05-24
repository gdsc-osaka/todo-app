import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:todo_app/features/auth/email_form.dart';
import 'package:todo_app/features/home/firestore_api.dart';

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
    final width = MediaQuery.of(context).size.width * 0.6;
    final theme = Theme.of(context);
    final text = theme.textTheme;

    signUp() async {
      if (_formKey.currentState?.validate() ?? false) {
        // 入力データが正常な場合
        context.loaderOverlay.show();
        final messenger = ScaffoldMessenger.of(context);

        try {
          final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email,
            password: _password,
          );

          final user = credential.user;

          if (user != null) {
            FirestoreAPI.instance.addUser(user);
          }

          if (mounted) {
            context.loaderOverlay.hide();
            context.go(HomePage.name);
          }
        } on FirebaseAuthException catch (e) {
          context.loaderOverlay.hide();

          if (e.code == 'weak-password') {
            messenger.showSnackBar(const SnackBar(content: Text('より複雑なパスワードを使用してください')));
          } else if (e.code == 'email-already-in-use') {
            messenger.showSnackBar(const SnackBar(content: Text('メールアドレスが既に使用されています')));
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
