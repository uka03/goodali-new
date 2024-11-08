import 'package:flutter/material.dart';
import 'package:goodali/pages/auth/email_confirm.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/auth_text_field.dart';
import 'package:goodali/shared/components/keyboard_hider.dart';
import 'package:goodali/shared/components/primary_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:provider/provider.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  static const String path = "/forgot";

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  late final AuthProvider _authProvider;
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

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
          leading: CustomButton(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              size: 30,
            ),
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Пин код мартсан",
                    style: GeneralTextStyle.titleText(
                      fontSize: 24,
                    ),
                  ),
                  VSpacer(),
                  Text(
                    "Та и-мэйл хаягаа оруулна уу",
                    style: GeneralTextStyle.bodyText(
                      fontSize: 14,
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
                ],
              ),
              Column(
                children: [
                  PrimaryButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() == true) {
                        FocusScope.of(context).unfocus();
                        showLoader();
                        final response = await _authProvider.sendOTP(
                          _controller.text,
                        );
                        if (response.success == true) {
                          if (context.mounted) {
                            Navigator.pushNamed(
                              context,
                              EmailConfirm.path,
                              arguments: _controller.text,
                            );
                          }
                        } else if (context.mounted) {
                          Toast.error(
                            context,
                            description: response.error ?? response.message,
                          );
                        }
                        dismissLoader();
                      }
                    },
                    title: "Үргэлжлүүлэх",
                  ),
                  VSpacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
