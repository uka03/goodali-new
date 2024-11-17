import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/model/post_response.dart';
import 'package:goodali/connection/model/tag_response.dart';

class ArticleProvider extends ChangeNotifier {
  final _dioClient = DioClient();

  List<PostResponseData> similarArticles = List.empty(growable: true);
  List<TagResponseData> tags = List.empty(growable: true);

  Future<PostResponse> getArticles({
    String? page,
    String? limit,
    String? tagIds,
  }) async {
    final response = await _dioClient.getPost(
      page: page,
      limit: limit,
      tagIds: tagIds,
    );

    return response;
  }

  Future<PostResponseData> getPostById(int? id) async {
    final response = await _dioClient.getPostById(id);

    return response;
  }

  Future<void> getTags() async {
    final response = await _dioClient.getTags();

    tags = response.data;
    notifyListeners();
  }

  Future<void> getSimilarArticles(int? id) async {
    similarArticles = [];
    notifyListeners();
    final response = await _dioClient.getSimilarPost(id);
    similarArticles = response.data ?? [];
    notifyListeners();
  }
}
