import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/model/album_response.dart';

class AlbumProvider extends ChangeNotifier {
  final _dioClient = DioClient();

  AlbumDetailResponseData? albumDetail;

  Future<AlbumResponse> getAlbums({required String page, required String limit}) async {
    final response = await _dioClient.getAlbums(page: page, limit: limit);
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
