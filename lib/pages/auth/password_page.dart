import 'package:flutter/material.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/auth/forgot_page.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:goodali/utils/types.dart';
import 'package:provider/provider.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  static const String path = "/password";

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  late final AuthProvider _authProvider;
  String pinValue = "";

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  onTap(String? value) async {
    if (value?.toLowerCase() == "undo") {
      if (pinValue.isNotEmpty == true) {
        setState(() {
          pinValue = pinValue.substring(0, pinValue.length - 1);
        });
      }
      return;
    }
    if (pinValue.length < 4) {
      setState(() {
        pinValue += value.orEmpty();
      });
    }
    if (pinValue.length == 4) {
      final info = ModalRoute.of(context)?.settings.arguments as AuthInfo;

      switch (info.authType) {
        case AuthType.login:
          info.pass = pinValue;
          showLoader();
          final response = await _authProvider.login(info);
          if (response.data?.token?.isNotEmpty == true) {
            if (mounted) {
              final home = context.read<HomeProvider>();
              home.getHomeData(refresh: true);
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          } else if (mounted) {
            Toast.error(context, description: response.error);
          }
          dismissLoader();
          break;
        case AuthType.register:
          info.pass = pinValue;
          info.authType = AuthType.registerConfirm;
          await Navigator.pushNamed(context, PasswordPage.path, arguments: info);
          pinValue = "";
          info.authType = AuthType.register;
          break;
        case AuthType.registerConfirm:
          if (info.pass == pinValue) {
            showLoader();
            final response = await _authProvider.register(info);
            if (response.success == true) {
              if (mounted) {
                Navigator.popUntil(context, (route) => route.isFirst);
                Toast.success(context, description: "Бүртгэл амжилттай үүслээ.");
              }
            } else if (mounted) {
              Toast.error(context, description: response.error);
            }
            dismissLoader();
          } else {
            Toast.error(context, description: "Пин код адилхан байх ёстой");
          }
          break;
        case AuthType.forgot:
          info.pass = pinValue;
          info.authType = AuthType.forgotConfirm;
          await Navigator.pushNamed(context, PasswordPage.path, arguments: info);
          pinValue = "";
          info.authType = AuthType.forgot;
          break;
        case AuthType.forgotConfirm:
          if (info.pass == pinValue) {
            showLoader();
            final response = await _authProvider.forgetPassword(info);
            if (response.success == true) {
              if (mounted) {
                Navigator.popUntil(context, (route) => route.isFirst);
                Toast.success(context, description: response.message ?? "Нууц үг амжилттай солигдолоо.");
              }
            } else if (mounted) {
              Toast.error(context, description: response.error);
            }
            dismissLoader();
          } else {
            Toast.error(context, description: "Пин код адилхан байх ёстой");
          }
          break;
        default:
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = "";
    final info = ModalRoute.of(context)?.settings.arguments as AuthInfo;
    switch (info.authType) {
      case AuthType.login:
        title = "Пин код оруулна уу";
        break;
      case AuthType.register:
        title = "Пин код үүсгэнэ үү";
        break;
      case AuthType.registerConfirm:
        title = "Пин код давтана уу";
        break;
      case AuthType.forgot:
        title = "Шинэ пин код оруулна уу";
        break;
      case AuthType.forgotConfirm:
        title = "Шинэ пин код давтана уу";
        break;
      default:
    }
    return GeneralScaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              VSpacer(size: 100),
              Text(
                title,
                style: GeneralTextStyle.titleText(fontSize: 24),
              ),
              VSpacer(size: 40),
              RatingBar.builder(
                itemCount: 4,
                itemSize: 12,
                ignoreGestures: true,
                initialRating: pinValue.length.toDouble(),
                itemPadding: EdgeInsets.all(15),
                onRatingUpdate: (value) {},
                itemBuilder: (context, index) {
                  return Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: GeneralColors.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                },
              ),
            ],
          ),
          Column(
            children: [
              NumbericKeyboard(
                onTap: onTap,
              ),
              VSpacer(),
              if (info.authType == AuthType.login)
                CustomButton(
                  onTap: () {
                    Navigator.pushNamed(context, ForgotPage.path);
                  },
                  child: Text(
                    "Пин код мартсан?",
                    style: GeneralTextStyle.titleText(
                      fontSize: 14,
                      textColor: GeneralColors.primaryColor,
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}

class NumbericKeyboard extends StatelessWidget {
  const NumbericKeyboard({
    super.key,
    required this.onTap,
  });
  final Function(String? value) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OverflowBar(
          alignment: MainAxisAlignment.spaceAround,
          children: [
            NumberButton(
              text: "1",
              onTap: onTap,
            ),
            NumberButton(
              text: "2",
              onTap: onTap,
            ),
            NumberButton(
              text: "3",
              onTap: onTap,
            ),
          ],
        ),
        VSpacer(),
        OverflowBar(
          alignment: MainAxisAlignment.spaceAround,
          children: [
            NumberButton(
              text: "4",
              onTap: onTap,
            ),
            NumberButton(
              text: "5",
              onTap: onTap,
            ),
            NumberButton(
              text: "6",
              onTap: onTap,
            ),
          ],
        ),
        VSpacer(),
        OverflowBar(
          alignment: MainAxisAlignment.spaceAround,
          children: [
            NumberButton(
              text: "7",
              onTap: onTap,
            ),
            NumberButton(
              text: "8",
              onTap: onTap,
            ),
            NumberButton(
              text: "9",
              onTap: onTap,
            ),
          ],
        ),
        OverflowBar(
          alignment: MainAxisAlignment.spaceAround,
          children: [
            HSpacer(
              size: 64,
            ),
            NumberButton(
              text: "0",
              onTap: onTap,
            ),
            NumberButton(
              text: "Undo",
              content: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 24,
              ),
              onTap: onTap,
            ),
          ],
        ),
      ],
    );
  }
}

class NumberButton extends StatelessWidget {
  const NumberButton({
    super.key,
    required this.text,
    required this.onTap,
    this.content,
  });
  final String text;
  final Widget? content;
  final Function(String? value) onTap;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      highlightColor: GeneralColors.grayColor.withOpacity(0.2),
      splashColor: GeneralColors.grayColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        onTap(text);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        width: 64,
        height: 64,
        child: content ??
            Text(
              text,
              style: GeneralTextStyle.titleText(fontSize: 26),
            ),
      ),
    );
  }
}
