import 'package:flutter/material.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/auth/password_page.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/auth_text_field.dart';
import 'package:goodali/shared/components/keyboard_hider.dart';
import 'package:goodali/shared/components/primary_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:goodali/utils/types.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const String path = "/register";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final AuthProvider _authProvider;

  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _name = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
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
                    "Бүртгүүлэх",
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
                  AuthTextField(
                    controller: _name,
                    hintText: "Нууц нэр",
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return "Бөглөх хэрэгтэй";
                      }
                      return null;
                    },
                  ),
                  VSpacer.sm(),
                  Text(
                    "Та өөртөө хүссэн нэрээ өгөөрэй",
                    style: GeneralTextStyle.bodyText(),
                  )
                ],
              ),
              Column(
                children: [
                  Hero(
                    tag: "registerbutton",
                    child: PrimaryButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() == true) {
                          showLoader();
                          final response = await _authProvider.checkUser(_controller.text);
                          dismissLoader();
                          if (response.success == false && context.mounted) {
                            Navigator.pushNamed(
                              context,
                              PasswordPage.path,
                              arguments: AuthInfo(
                                authType: AuthType.register,
                                email: _controller.text,
                                nickName: _name.text,
                              ),
                            );
                          } else if (context.mounted) {
                            Toast.error(context, description: response.message);
                          }
                        }
                      },
                      title: "Бүртгүүлэх",
                    ),
                  ),
                  VSpacer(),
                  CustomButton(
                    onTap: () {},
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Хаяг байгаа ?",
                            style: GeneralTextStyle.bodyText(fontSize: 14),
                          ),
                          TextSpan(
                            text: " Нэвтрэх",
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
