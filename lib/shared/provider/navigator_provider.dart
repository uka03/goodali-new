import 'package:flutter/material.dart';

class NavigatorProvider extends ChangeNotifier {
  int selectedIndex = 0;
  int homeSelectedPage = 0;
  int podcastSelectedPage = 0;
  int fireSelectedPage = 0;
  int profileSelectedPage = 0;

  setIndex(int index) {
    selectedIndex = index;

    notifyListeners();
  }

  setHomePage(int value) {
    homeSelectedPage = value;
    notifyListeners();
  }

  setProfile(int value) {
    profileSelectedPage = value;
    notifyListeners();
  }

  setFire(int value) {
    fireSelectedPage = value;
    notifyListeners();
  }

  setPodcast(int value) {
    podcastSelectedPage = value;
    notifyListeners();
  }
}
