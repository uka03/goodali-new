import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/model/base_response.dart';
import 'package:goodali/connection/model/feed_response.dart';
import 'package:goodali/connection/model/tag_response.dart';

class FeedProvider extends ChangeNotifier {
  final _dioClient = DioClient();
  final List<TagResponseData> tags = List.empty(growable: true);
  bool isLoading = true;
  List<TagResponseData?> selectedTags = [];

  void fetchTags({bool refresh = true}) async {
    if (refresh || isLoading) {
      final response = await _dioClient.getTags();
      if (response.data.isNotEmpty) {
        tags.clear();
        tags.addAll(response.data);

        notifyListeners();
        isLoading = false;
      }
    }
  }

  void setTags(List<TagResponseData?> tags) {
    selectedTags = tags;
    notifyListeners();
  }

  void removeTag(TagResponseData? tag) {
    selectedTags.remove(tag);
    notifyListeners();
  }

  Future<BaseResponse> createPost({
    required String title,
    required String body,
    required int? postType,
    required List<int?> tags,
  }) async {
    final response = await _dioClient.createPost(
      title: title,
      body: body,
      postType: postType,
      tags: tags,
    );
    return response;
  }

  Future<BaseResponse> updatePost({
    required String title,
    required String body,
    required int? id,
    required List<int?> tags,
  }) async {
    final response = await _dioClient.updatePost(
      id: id,
      title: title,
      body: body,
      tags: tags,
    );
    return response;
  }

  Future<FeedResponse> getFeedPost(int? id, {int? page, int? limit}) async {
    final tagIds = selectedTags.map((e) => e?.id).toList().join(",");

    final response = await _dioClient.getFeedPosts(
      id,
      page: page,
      limit: limit,
      tagIds: tagIds,
    );
    return response;
  }

  Future<bool> postLike(int? id) async {
    final response = await _dioClient.postLike(id);
    return response.success ?? false;
  }

  Future<bool> postDislike(int? id) async {
    final response = await _dioClient.postDislike(id);
    return response.success ?? false;
  }

  Future<ReplyResponseData?> postReply(int? postId, String? comment) async {
    final response = await _dioClient.postReply(postId, comment);
    return response.data;
  }

  Future<bool> deleteReply(int? id, int? postId) async {
    final response = await _dioClient.deleteReply(id, postId);
    return response.success ?? false;
  }

  Future<bool> deletePost(int? id) async {
    final response = await _dioClient.deletePost(id);
    return response.success ?? false;
  }
}
