import 'package:flutter/material.dart';
import 'package:goodali/pages/auth/password_page.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/auth/register_page.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/custom_check_box.dart';
import 'package:goodali/shared/components/auth_text_field.dart';
import 'package:goodali/shared/components/keyboard_hider.dart';
import 'package:goodali/shared/components/primary_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:goodali/utils/types.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String path = "/login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthProvider _authProvider;
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  bool isAgree = false;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final pref = await SharedPreferences.getInstance();
      final email = pref.getString("email");
      if (email?.isNotEmpty == true) {
        _controller.text = email.orEmpty();
        setState(() {
          isAgree = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardHider(
      child: GeneralScaffold(
        appBar: CustomAppBar(
          action: [
            CustomButton(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.close),
            ),
            HSpacer(
              size: 20,
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Нэвтрэх",
                    style: GeneralTextStyle.titleText(
                      fontSize: 32,
                    ),
                  ),
                  VSpacer(size: 50),
                  AuthTextField(
                    controller: _controller,
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return "Бөглөх хэрэгтэй";
                      }
                      if (!value!.isValidEmail()) {
                        return "И-мэйл буруу байна";
                      }
                      return null;
                    },
                  ),
                  VSpacer(),
                  CustomButton(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        isAgree = !isAgree;
                      });
                    },
                    child: Row(
                      children: [
                        CustomCheckBox(
                          value: isAgree,
                          onChanged: (bool? value) {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              isAgree = value ?? false;
                            });
                          },
                        ),
                        HSpacer(),
                        Text("Сануулах")
                      ],
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Hero(
                    tag: "loginButton",
                    child: PrimaryButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() == true) {
                          FocusScope.of(context).unfocus();
                          final response = await _authProvider.checkUser(
                            _controller.text,
                          );
                          if (response.success == true) {
                            if (isAgree) {
                              final pref = await SharedPreferences.getInstance();
                              pref.setString("email", _controller.text);
                            }
                            if (context.mounted) {
                              Navigator.pushNamed(
                                context,
                                PasswordPage.path,
                                arguments: AuthInfo(
                                  email: _controller.text,
                                  authType: AuthType.login,
                                ),
                              );
                            }
                          } else if (context.mounted) {
                            Toast.error(
                              context,
                              title: response.error,
                              description: response.message,
                            );
                          }
                        }
                      },
                      title: "Нэвтрэх",
                    ),
                  ),
                  VSpacer(),
                  CustomButton(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, RegisterPage.path);
                    },
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Хаяг байхгүй ?",
                            style: GeneralTextStyle.bodyText(fontSize: 14),
                          ),
                          TextSpan(
                            text: " Бүртгүүлэх",
                            style: GeneralTextStyle.titleText(
                              fontSize: 14,
                              textColor: GeneralColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
