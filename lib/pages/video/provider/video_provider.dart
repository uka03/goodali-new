import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/model/tag_response.dart';
import 'package:goodali/connection/model/video_response.dart';

class VideoProvider extends ChangeNotifier {
  final _dioClient = DioClient();
  List<TagResponseData> tags = List.empty(growable: true);

  List<VideoResponseData> similarVideos = List.empty(growable: true);

  Future<void> getSimilarVideos(int? videoId) async {
    similarVideos = [];
    notifyListeners();
    final response = await _dioClient.getSimilarVideos(videoId);
    similarVideos = response.data ?? [];
    notifyListeners();
  }

  Future<VideoResponse> getVideos({
    String? page,
    String? limit,
    String? tagIds,
  }) async {
    final response = _dioClient.getVideos(
      page: page,
      limit: limit,
      tagIds: tagIds,
    );
    return response;
  }

  Future<void> getTags() async {
    final response = await _dioClient.getTags();

    tags = response.data;
    notifyListeners();
  }
}
