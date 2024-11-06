import 'package:flutter/material.dart';
import 'package:goodali/pages/auth/login_page.dart';
import 'package:goodali/pages/auth/register_page.dart';
import 'package:goodali/shared/components/primary_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      child: Column(
        children: [
          VSpacer(
            size: 100,
          ),
          Expanded(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/img_logo.png",
                  height: 50,
                ),
                VSpacer(),
                Text(
                  "Сайн байна уу? Та дээрх үйлдлийг\n хийхийн тулд нэвтрэх хэрэгтэй.",
                  style: GeneralTextStyle.titleText(
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          Hero(
            tag: "loginButton",
            child: PrimaryButton(
              onPressed: () {
                Navigator.pushNamed(context, LoginPage.path);
              },
              title: "Нэтрэх",
            ),
          ),
          VSpacer(),
          Hero(
            tag: "registerbutton",
            child: PrimaryButton(
              backgroundColor: GeneralColors.grayBGColor,
              textColor: GeneralColors.textColor,
              onPressed: () {
                Navigator.pushNamed(context, RegisterPage.path);
              },
              title: "Бүртгүүлэх",
            ),
          ),
        ],
      ),
    );
  }
}
