import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:goodali/connection/model/user_response.dart';
import 'package:goodali/pages/auth/auth_page.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/feed/feed_page.dart';
import 'package:goodali/pages/home/home_page.dart';
import 'package:goodali/pages/profile/profile_page.dart';
import 'package:goodali/shared/components/custom_bottom_bar.dart';
import 'package:goodali/shared/components/primary_button.dart';
import 'package:goodali/shared/provider/navigator_provider.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/dailogs.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  static const String path = "/";

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late final AuthProvider _authProvider;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  List<ConnectivityResult>? _connectionStatus;
  bool _alert = false;
  bool _forceupdate = false;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);

    initConnectivity();

    checkForceUpdate();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _authProvider.getMe();
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    });
  }

  checkForceUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    final response = await _authProvider.getAppVersion();
    if (version.compareTo(response.data?.appVersion ?? "") < 0) {
      setState(() {
        _forceupdate = true;
      });
    }
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    if (_alert) {
      if (Navigator.canPop(context)) {
        _alert = false;
        Navigator.pop(context);
      }
    }
    setState(() {
      _connectionStatus = result;
    });
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigatorProvider>(builder: (context, provider, _) {
      if (_forceupdate) {
        return Scaffold(
          backgroundColor: GeneralColors.primaryColor,
          body: SafeArea(
            child: Column(
              children: [
                VSpacer(size: 100),
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/img_logo.png",
                        width: 250,
                        color: Colors.white,
                      ),
                      VSpacer(),
                      Text(
                        "Сэтгэлзүйн платформ",
                        style: GeneralTextStyle.titleText(
                          fontSize: 20,
                          textColor: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                VSpacer(size: 100),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    "Таны ашиглаж буй аппын хувилбар одоо шинэчлэлт хийх шаардлагатай байна. Та илүү хурдан, найдвартай, шинэлэг үйлчилгээг ашиглахын тулд сайжруулалт хийгээрэй.",
                    style: GeneralTextStyle.titleText(
                      fontSize: 16,
                      textColor: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                VSpacer(size: 100),
                Expanded(child: SizedBox()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: PrimaryButton(
                    backgroundColor: Colors.white,
                    title: "Шинэчлэх",
                    textColor: Colors.black,
                    onPressed: () {
                      if (Platform.isIOS) {
                        launchUrlString("https://apps.apple.com/us/app/id1661415299");
                      } else if (Platform.isAndroid) {
                        launchUrlString("https://play.google.com/store/apps/details?id=com.goodali.mn");
                      }
                    },
                  ),
                ),
                VSpacer(),
              ],
            ),
          ),
        );
      }
      if (_connectionStatus?.contains(ConnectivityResult.none) == true && !_alert) {
        dismissLoader();
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _alert = true;
          showAlertDialog(
            context,
            dismissible: false,
            title: Text(
              "Анхааруулга",
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 80,
                  color: GeneralColors.primaryColor,
                ),
                VSpacer(),
                Text(
                  "Холболт салсан байна.\n Та интернетээ шалгаад дахин оролдоно уу",
                  style: GeneralTextStyle.titleText(fontSize: 14),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            actions: [
              Column(children: [
                PrimaryButton(
                  title: "Дахин оролдох",
                  onPressed: () {
                    initConnectivity();
                    // Navigator.pop(context);
                  },
                ),
              ])
            ],
            onSuccess: () {},
            onDismiss: () {},
          );
        });
      }
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
