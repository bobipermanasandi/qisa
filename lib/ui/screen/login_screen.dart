import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qisa/common/enum/input_type.dart';
import 'package:qisa/common/enum/result_state.dart';
import 'package:qisa/common/string_ext.dart';
import 'package:qisa/data/api/api_service.dart';
import 'package:qisa/data/local/preference_helper.dart';
import 'package:qisa/data/models/request/request_login_model.dart';
import 'package:qisa/provider/login_provider.dart';
import 'package:qisa/ui/widgets/button_widget.dart';
import 'package:qisa/ui/widgets/input_widget.dart';
import 'package:qisa/utils/helper.dart';
import 'package:qisa/utils/info_util.dart';

class LoginScreen extends StatefulWidget {
  final Function() onLogin;
  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;

  bool showPassword = false;

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (context) => LoginProvider(
            apiService: ApiService(),
            pref: PreferencesHelper(),
          ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Image.asset('assets/image_login.webp'),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Ready to begin your journey?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Please fill in your identity first',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: InputWidget(
                          labelText: 'Email',
                          controller: emailController,
                          type: InputType.email,
                          hintText: 'ex:account@gmail.com',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email harus di isi';
                            }
                            if (!value.isValidEmail()) {
                              return 'Masukkan format email yang benar';
                            }
                            return null;
                          },
                        ),
                      ),
                      InputWidget(
                        controller: passwordController,
                        labelText: 'Password',
                        hintText: 'Masukkan password',
                        isPassword: true,
                        showPassword: showPassword,
                        onPressedPassword: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password harus di isi';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Consumer<LoginProvider>(
                        builder: (context, provider, _) {
                          _handleState(provider);
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: ButtonWidget(
                              text: 'Login',
                              isLoading:
                                  (provider.state == ResultState.loading),
                              onPressed: () {
                                if (formKey.currentState?.validate() == true &&
                                    provider.state != ResultState.loading) {
                                  provider.login(
                                    RequestLoginModel(
                                      email: emailController.text.trim(),
                                      password: passwordController.text,
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }

  _handleState(LoginProvider provider) {
    switch (provider.state) {
      case ResultState.hasData:
        HelperNav.afterBuildWidgetCallback(() => widget.onLogin());
        break;
      case ResultState.noData:
        InfoUtil.showToast(provider.message);
        break;
      case ResultState.error:
        InfoUtil.showToast(provider.message);
        break;
      default:
        break;
    }
  }
}
