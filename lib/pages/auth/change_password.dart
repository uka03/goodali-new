import 'package:flutter/material.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/shared/components/auth_text_field.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/keyboard_hider.dart';
import 'package:goodali/shared/components/primary_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  static String path = "/change_password";

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late AuthProvider authProvider;
  final _formKey = GlobalKey<FormState>();

  final _oldPinCode = TextEditingController();
  final _newPinCode = TextEditingController();
  final _confirmPinCode = TextEditingController();

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardHider(
      child: GeneralScaffold(
        bottomBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: PrimaryButton(
              title: "Үргэлжлүүлэх",
              onPressed: () async {
                if (_formKey.currentState?.validate() == true) {
                  if (_confirmPinCode.text == _newPinCode.text) {
                    if (_confirmPinCode.text.length < 4 || _newPinCode.text.length < 4 || _oldPinCode.text.length < 4) {
                      Toast.error(context, description: "Пин код дутуу байна.");
                    } else {
                      // showLoader();
                      final response = await authProvider.changePassword(_oldPinCode.text, _confirmPinCode.text);
                      if (response.success == true) {
                        if (context.mounted) {
                          Toast.success(context, description: "Пин код амжилттай солигдлоо.");
                          Navigator.pop(context);
                        }
                      } else {
                        if (context.mounted) {
                          Toast.error(context, description: response.error ?? response.message);
                        }
                      }
                      // dismissLoader();
                    }
                  } else {
                    Toast.error(context, description: "Пин код тохирохгүй байна.");
                  }
                }
              },
            ),
          ),
        ),
        appBar: CustomAppBar(),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Пин код солих",
                style: GeneralTextStyle.titleText(
                  fontSize: 32,
                ),
              ),
              VSpacer(),
              AuthTextField(
                keyboardType: TextInputType.number,
                hintText: "Одоогийн пин код",
                maxLength: 4,
                controller: _oldPinCode,
              ),
              VSpacer(),
              AuthTextField(
                maxLength: 4,
                keyboardType: TextInputType.number,
                hintText: "Шинэ пин код",
                controller: _newPinCode,
              ),
              VSpacer(),
              AuthTextField(
                keyboardType: TextInputType.number,
                maxLength: 4,
                hintText: "Пин код давтах",
                controller: _confirmPinCode,
              ),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
