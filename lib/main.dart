import 'package:flutter/material.dart';
import 'package:goodali/pages/album/provider/album_provider.dart';
import 'package:goodali/pages/article/provider/article_provider.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/book/provider/book_provider.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/pages/feed/provider/feed_provider.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/pages/mood/provider/mood_provider.dart';
import 'package:goodali/pages/podcast/components/player_provider.dart';
import 'package:goodali/pages/profile/provider/profile_provider.dart';
import 'package:goodali/pages/search/provider/search_provider.dart';
import 'package:goodali/pages/training/provider/training_provider.dart';
import 'package:goodali/pages/video/provider/video_provider.dart';
import 'package:goodali/routes/routes.dart';
import 'package:goodali/shared/components/custom_animation.dart';
import 'package:goodali/shared/provider/navigator_provider.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  configLoading();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigatorProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => AlbumProvider()),
        ChangeNotifierProvider(create: (context) => VideoProvider()),
        ChangeNotifierProvider(create: (context) => ArticleProvider()),
        ChangeNotifierProvider(create: (context) => MoodProvider()),
        ChangeNotifierProvider(create: (context) => TrainingProvider()),
        ChangeNotifierProvider(create: (context) => FeedProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => PlayerProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => BookProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: routes,
        builder: EasyLoading.init(),
      ),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..maskType = EasyLoadingMaskType.custom
    ..displayDuration = const Duration(milliseconds: 1000)
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 60
    ..textColor = Colors.white
    ..backgroundColor = Colors.transparent
    ..indicatorColor = Colors.white
    ..maskColor = Colors.transparent
    ..userInteractions = false
    ..dismissOnTap = false
    ..animationStyle = EasyLoadingAnimationStyle.custom
    ..customAnimation = CustomAnimation();
}
