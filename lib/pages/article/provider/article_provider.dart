import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/model/post_response.dart';

class ArticleProvider extends ChangeNotifier {
  final _dioClient = DioClient();

  List<PostResponseData> similarArticles = List.empty(growable: true);

  Future<PostResponse> getArticles({String? page, String? limit}) async {
    final response = await _dioClient.getPost(page: page, limit: limit);

    return response;
  }

  Future<PostResponseData> getPostById(int? id) async {
    final response = await _dioClient.getPostById(id);

    return response;
  }

  Future<void> getSimilarArticles(int? id) async {
    similarArticles = [];
    notifyListeners();
    final response = await _dioClient.getSimilarPost(id);
    similarArticles = response.data ?? [];
    notifyListeners();
  }
}
