import 'package:flutter/material.dart';
import 'package:goodali/pages/auth/password_page.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/keyboard_hider.dart';
import 'package:goodali/shared/components/primary_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:goodali/utils/types.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class EmailConfirm extends StatefulWidget {
  const EmailConfirm({super.key});

  static const String path = "/emailConfirm";

  @override
  State<EmailConfirm> createState() => _EmailConfirmState();
}

class _EmailConfirmState extends State<EmailConfirm> {
  late final AuthProvider _authProvider;
  final _formKey = GlobalKey<FormState>();
  String pinCode = "";

  bool isAgree = false;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  onSubmit() async {
    final email = ModalRoute.of(context)?.settings.arguments as String?;
    if (_formKey.currentState?.validate() == true) {
      FocusScope.of(context).unfocus();
      final data = AuthInfo(
        authType: AuthType.forgot,
        email: email,
        otpCode: pinCode,
      );
      if (pinCode.length >= 4) {
        showLoader();
        final response = await _authProvider.verify(data);
        if (response.success == true && mounted) {
          Navigator.pushNamed(context, PasswordPage.path, arguments: data);
        } else {
          if (mounted) {
            Toast.error(context, description: response.error);
          }
        }
        dismissLoader();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String?;
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Баталгаажуулах",
                    style: GeneralTextStyle.titleText(
                      fontSize: 24,
                    ),
                  ),
                  VSpacer(),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: "Таны "),
                        TextSpan(text: email ?? "", style: GeneralTextStyle.titleText()),
                        TextSpan(text: " хаягт илгээсэн 4 оронтой кодыг оруулна уу."),
                      ],
                      style: GeneralTextStyle.bodyText(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  VSpacer(size: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: PinCodeTextField(
                      appContext: context,
                      length: 4,
                      autoFocus: true,
                      autoUnfocus: true,
                      keyboardType: TextInputType.number,
                      enableActiveFill: true,
                      onCompleted: (value) {
                        onSubmit();
                      },
                      onChanged: (value) {
                        pinCode = value;
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.circle,
                        fieldHeight: 50,
                        fieldWidth: 50,
                        activeColor: GeneralColors.grayBGColor,
                        selectedColor: GeneralColors.primaryColor,
                        inactiveColor: GeneralColors.grayBGColor,
                        inactiveFillColor: GeneralColors.grayBGColor,
                        selectedFillColor: GeneralColors.primaryColor,
                        activeFillColor: GeneralColors.grayBGColor,
                      ),
                    ),
                  ),
                  VSpacer(),
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        showLoader();
                        final response = await _authProvider.sendOTP(
                          email ?? "",
                        );
                        if (response.success != true && context.mounted) {
                          Toast.error(
                            context,
                            description: response.error ?? response.message,
                          );
                        } else {
                          if (!context.mounted) return;

                          Toast.success(
                            context,
                            description: response.error ?? response.message,
                          );
                        }
                        dismissLoader();
                      },
                      child: Text(
                        "Дахин авах",
                        style: GeneralTextStyle.titleText(
                          textColor: GeneralColors.primaryColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Hero(
                    tag: "loginButton",
                    child: PrimaryButton(
                      onPressed: onSubmit,
                      title: "Үргэлжлүүлэх",
                    ),
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
