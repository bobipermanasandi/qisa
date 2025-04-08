import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qisa/common/enum/input_type.dart';
import 'package:qisa/common/enum/result_state.dart';
import 'package:qisa/common/string_ext.dart';
import 'package:qisa/data/api/api_service.dart';
import 'package:qisa/data/models/request/request_register_model.dart';
import 'package:qisa/provider/register_provider.dart';
import 'package:qisa/ui/widgets/button_widget.dart';
import 'package:qisa/ui/widgets/input_widget.dart';
import 'package:qisa/utils/helper.dart';
import 'package:qisa/utils/info_util.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onRegister;
  const RegisterScreen({super.key, required this.onRegister});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  bool showPassword = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterProvider(apiService: ApiService()),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 70),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20,
                    left: 16,
                    right: 16,
                  ),
                  child: Image.asset('assets/image_signup.webp'),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Please fill in your identity first',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
                            labelText: 'Name',
                            controller: nameController,
                            hintText: 'What\'s your name?',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Nama harus di isi';
                              }
                              return null;
                            },
                          ),
                        ),
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
                          hintText: 'Password',
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
                        const SizedBox(height: 32),
                        Consumer<RegisterProvider>(
                          builder: (context, provider, _) {
                            _handleState(context, provider);
                            return ButtonWidget(
                              text: 'Register',
                              isLoading:
                                  (provider.state == ResultState.loading),
                              onPressed: () {
                                if (formKey.currentState?.validate() == true &&
                                    provider.state != ResultState.loading) {
                                  provider.register(
                                    RequestRegisterModel(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _handleState(BuildContext context, RegisterProvider provider) {
    switch (provider.state) {
      case ResultState.hasData:
        HelperNav.afterBuildWidgetCallback(() => widget.onRegister());
        InfoUtil.showToast(provider.message);
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
