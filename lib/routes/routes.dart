import 'package:flutter/material.dart';
import 'package:goodali/pages/album/album_detail.dart';
import 'package:goodali/pages/album/albums_page.dart';
import 'package:goodali/pages/article/article_detail.dart';
import 'package:goodali/pages/article/articles_page.dart';
import 'package:goodali/pages/auth/change_password.dart';
import 'package:goodali/pages/auth/email_confirm.dart';
import 'package:goodali/pages/auth/forgot_page.dart';
import 'package:goodali/pages/auth/login_page.dart';
import 'package:goodali/pages/auth/password_page.dart';
import 'package:goodali/pages/auth/register_page.dart';
import 'package:goodali/pages/cart/card_page.dart';
import 'package:goodali/pages/cart/cart_page.dart';
import 'package:goodali/pages/cart/payment_page.dart';
import 'package:goodali/pages/cart/qpay_page.dart';
import 'package:goodali/pages/feed/create_post.dart';
import 'package:goodali/pages/lesson/item_page.dart';
import 'package:goodali/pages/lesson/lesson_page.dart';
import 'package:goodali/pages/lesson/task_detail.dart';
import 'package:goodali/pages/lesson/task_page.dart';
import 'package:goodali/pages/menu/faq_page.dart';
import 'package:goodali/pages/menu/menu_page.dart';
import 'package:goodali/pages/menu/term_page.dart';
import 'package:goodali/pages/mood/mood_detail.dart';
import 'package:goodali/pages/podcast/podcast_player.dart';
import 'package:goodali/pages/training/packages_page.dart';
import 'package:goodali/pages/training/training_page.dart';
import 'package:goodali/pages/video/video_detail.dart';
import 'package:goodali/pages/video/videos_page.dart';
import 'package:goodali/shared/main_scaffold.dart';

final Map<String, WidgetBuilder> routes = {
  MainScaffold.path: (context) => MainScaffold(),
  LoginPage.path: (context) => LoginPage(),
  RegisterPage.path: (context) => RegisterPage(),
  PasswordPage.path: (context) => PasswordPage(),
  ForgotPage.path: (context) => ForgotPage(),
  EmailConfirm.path: (context) => EmailConfirm(),
  AlbumsPage.path: (context) => AlbumsPage(),
  AlbumDetail.path: (context) => AlbumDetail(),
  VideosPage.path: (context) => VideosPage(),
  VideoDetail.path: (context) => VideoDetail(),
  ArticlesPage.path: (context) => ArticlesPage(),
  ArticleDetail.path: (context) => ArticleDetail(),
  MoodDetail.path: (context) => MoodDetail(),
  TrainingPage.path: (context) => TrainingPage(),
  PackagesPage.path: (context) => PackagesPage(),
  CreatePost.path: (context) => CreatePost(),
  MenuPage.path: (context) => MenuPage(),
  FaqPage.path: (context) => FaqPage(),
  ChangePassword.path: (context) => ChangePassword(),
  TermPage.path: (context) => TermPage(),
  PodcastPlayer.path: (context) => PodcastPlayer(),
  CartPage.path: (context) => CartPage(),
  PaymentPage.path: (context) => PaymentPage(),
  QpayPage.path: (context) => QpayPage(),
  CardPage.path: (context) => CardPage(),
  ItemPage.path: (context) => ItemPage(),
  LessonPage.path: (context) => LessonPage(),
  TaskPage.path: (context) => TaskPage(),
  TaskDetail.path: (context) => TaskDetail(),
};
