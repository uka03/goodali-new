import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/model/mood_response.dart';

class MoodProvider extends ChangeNotifier {
  final _dioClient = DioClient();

  List<MoodItemResponseData> moodDetails = List.empty(growable: true);

  Future<void> getMoodItems(int? id) async {
    final response = await _dioClient.getMoodItems(id);

    moodDetails = response.data;
    notifyListeners();
  }
}
