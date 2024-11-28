import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/model/album_response.dart';
import 'package:goodali/connection/model/feedback_response.dart';

class AlbumProvider extends ChangeNotifier {
  final _dioClient = DioClient();

  AlbumDetailResponseData? albumDetail;
  List<FeedbackResponseData> replies = List.empty(growable: true);

  Future<AlbumResponse> getAlbums({required String page, required String limit}) async {
    final response = await _dioClient.getAlbums(page: page, limit: limit);
    return response;
  }

  Future<FeedbackResponse> getReplies(int? id, String type, {int? limit, int? page}) async {
    final response = await _dioClient.getFeedback(id, type, limit: limit, page: page);
    replies = response.data ?? [];
    notifyListeners();
    return response;
  }

  Future<void> getAlbum(int? id) async {
    albumDetail = null;
    notifyListeners();
    final response = await _dioClient.getAlbum(id);
    albumDetail = response.data;
    notifyListeners();
  }
}
