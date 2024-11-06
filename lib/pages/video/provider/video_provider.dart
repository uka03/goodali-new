import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/model/video_response.dart';

class VideoProvider extends ChangeNotifier {
  final _dioClient = DioClient();

  List<VideoResponseData> similarVideos = List.empty(growable: true);

  Future<void> getSimilarVideos(int? videoId) async {
    similarVideos = [];
    notifyListeners();
    final response = await _dioClient.getSimilarVideos(videoId);
    similarVideos = response.data ?? [];
    notifyListeners();
  }

  Future<VideoResponse> getVideos({String? page, String? limit}) async {
    final response = _dioClient.getVideos(page: page, limit: limit);
    return response;
  }
}
