import 'package:flutter/material.dart';
import 'package:goodali/pages/auth/change_password.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/menu/faq_page.dart';
import 'package:goodali/pages/menu/term_page.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  static const String path = "/menu";

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late final AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      verticalPadding: 0,
      appBar: CustomAppBar(),
      child: ListView(
        children: [
          Text(
            "Тохиргоо",
            style: GeneralTextStyle.titleText(
              fontSize: 32,
            ),
          ),
          VSpacer(),
          menuItem(
            iconPath: "assets/icons/ic_lock.png",
            title: 'Пин код солих',
            onPressed: () {
              Navigator.pushNamed(context, ChangePassword.path);
            },
          ),
          menuItem(
            iconPath: "assets/icons/ic_info_menu.png",
            title: 'Нийтлэг асуулт хариулт',
            onPressed: () {
              Navigator.pushNamed(context, FaqPage.path);
            },
          ),
          menuItem(
            iconPath: "assets/icons/ic_paper.png",
            title: 'Үйлчилгээний нөхцөл',
            onPressed: () {
              Navigator.pushNamed(context, TermPage.path);
            },
          ),
          menuItem(
            iconPath: "assets/icons/ic_logout.png",
            title: 'Гарах',
            isLogout: true,
            onPressed: () {
              _authProvider.logout();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget menuItem({
    required String iconPath,
    required String title,
    required VoidCallback onPressed,
    bool isLogout = false,
  }) {
    return CustomButton(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 30,
              height: 30,
              color: isLogout ? GeneralColors.errorColor : Colors.black,
            ),
            HSpacer(size: 20),
            Expanded(
              child: Text(
                title,
                style: GeneralTextStyle.titleText(
                  textColor: isLogout ? GeneralColors.errorColor : Colors.black,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              color: isLogout ? GeneralColors.errorColor : Colors.black,
              size: 26,
            )
          ],
        ),
      ),
    );
  }
}
