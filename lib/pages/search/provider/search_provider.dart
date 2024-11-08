import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/model/search_response.dart';

class SearchProvider extends ChangeNotifier {
  final _dioClient = DioClient();

  List<SearchResponseData> items = List.empty(growable: true);

  getSearch(String? text) async {
    final response = await _dioClient.getSearch(text);
    items = response.data ?? [];
    notifyListeners();
  }
}
