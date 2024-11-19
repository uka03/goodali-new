import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/model/podcast_response.dart';

class BookProvider extends ChangeNotifier {
  final _dioClient = DioClient();

  Future<PodcastResponseData> getBookById(int? id) async {
    final response = _dioClient.getBookById(id);
    return response;
  }
}
