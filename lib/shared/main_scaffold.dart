import 'package:flutter/material.dart';
import 'package:goodali/connection/model/user_response.dart';
import 'package:goodali/pages/auth/auth_page.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/feed/feed_page.dart';
import 'package:goodali/pages/home/home_page.dart';
import 'package:goodali/pages/profile/profile_page.dart';
import 'package:goodali/shared/components/custom_bottom_bar.dart';
import 'package:goodali/shared/provider/navigator_provider.dart';
import 'package:goodali/utils/colors.dart';
import 'package:provider/provider.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  static const String path = "/";

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late final AuthProvider _authProvider;
  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authProvider.getMe();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigatorProvider>(builder: (context, provider, _) {
      return Scaffold(
        backgroundColor: GeneralColors.primaryBGColor,
        bottomNavigationBar: SafeArea(
          child: CustomBottomBar(
            selectedIndex: provider.selectedIndex,
            onChanged: provider.setIndex,
          ),
        ),
        body: Selector<AuthProvider, UserResponseData?>(
            selector: (p0, p1) => p1.user,
            builder: (context, user, _) {
              final pages = [
                HomePage(),
                FeedPage(),
                user == null ? AuthPage() : ProfilePage()
              ];
              return pages[provider.selectedIndex];
            }),
      );
    });
  }
}
