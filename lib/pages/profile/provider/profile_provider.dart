import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/model/podcast_response.dart';
import 'package:goodali/connection/model/purchase_response.dart';

class ProfileProvider extends ChangeNotifier {
  final _dioClient = DioClient();
  PurchaseResponseData? data;
  List<BoughtData> dataList = [];

  getUserData() async {
    dataList.clear();
    notifyListeners();
    final response = await _dioClient.getUserdata();
    data = response.data;
    for (var i = 0; i < (response.data?.training?.length ?? 0); i++) {
      if (i == 0) {
        dataList.add(
          BoughtData(
            items: BoughtItems(
              training: response.data?.training?[i],
              podcast: null,
            ),
            title: 'Онлайн сургалт',
            withTitle: true,
          ),
        );
      } else {
        dataList.add(
          BoughtData(
            items: BoughtItems(
              training: response.data?.training?[i],
              podcast: null,
            ),
            title: 'Онлайн сургалт',
            withTitle: false,
          ),
        );
      }
    }
    for (var i = 0; i < (response.data?.book?.length ?? 0); i++) {
      if (i == 0) {
        dataList.add(
          BoughtData(
            items: BoughtItems(
              book: response.data?.book?[i],
              podcast: null,
            ),
            title: 'Онлайн ном',
            withTitle: true,
          ),
        );
      } else {
        dataList.add(
          BoughtData(
            items: BoughtItems(
              book: response.data?.book?[i],
              podcast: null,
            ),
            title: 'Онлайн ном',
            withTitle: false,
          ),
        );
      }
    }
    for (int i = 0; i < (response.data?.albums?.length ?? 0); i++) {
      for (var l = 0; l < (response.data?.albums?[i].lectures?.length ?? 0); l++) {
        if (l == 0) {
          dataList.add(
            BoughtData(
              items: BoughtItems(
                training: null,
                podcast: response.data?.albums?[i].lectures?[l],
              ),
              title: response.data?.albums?[i].albumTitle,
              withTitle: true,
            ),
          );
        } else {
          dataList.add(
            BoughtData(
              items: BoughtItems(
                training: null,
                podcast: response.data?.albums?[i].lectures?[l],
              ),
              title: response.data?.albums?[i].albumTitle,
              withTitle: false,
            ),
          );
        }
      }
    }

    notifyListeners();
  }
}

class BoughtData {
  final BoughtItems items;
  final String? title;
  final bool withTitle;
  BoughtData({
    required this.items,
    this.title,
    this.withTitle = false,
  });
}

class BoughtItems {
  final PurchaseTrainingData? training;
  final PodcastResponseData? podcast;
  final PodcastResponseData? book;

  BoughtItems({
    this.training,
    this.podcast,
    this.book,
  });
}
