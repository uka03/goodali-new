import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/model/base_response.dart';
import 'package:goodali/connection/model/feedback_response.dart';
import 'package:goodali/connection/model/lesson_response.dart';
import 'package:goodali/connection/model/purchase_response.dart';
import 'package:goodali/connection/model/training_response.dart';

class TrainingProvider extends ChangeNotifier {
  final _dioClient = DioClient();
  TrainingInfoResponseData? trainingInfo;
  List<LessonResponseData> lessons = List.empty(growable: true);
  List<LessonResponseData> items = List.empty(growable: true);
  List<TaskResponseData> tasks = List.empty(growable: true);
  LessonResponseData? item;
  LessonResponseData? lesson;
  PurchaseTrainingData? trainingData;

  List<FeedbackResponseData> replies = List.empty(growable: true);

  Future<FeedbackResponse> getReplies(int? id, String type, {int? limit, int? page}) async {
    final response = await _dioClient.getFeedback(id, type, limit: limit, page: page);
    replies = response.data ?? [];
    notifyListeners();
    return response;
  }

  Future<BaseResponse> postTrainingFeedback({
    int? productId,
    int? trainingId,
    String? text,
  }) async {
    return await _dioClient.postTrainingFeedback(
      productId: productId,
      trainingId: trainingId,
      text: text,
    );
  }

  getTraining(int? id) async {
    final response = await _dioClient.getTraining(id);

    trainingInfo = response.data;
    notifyListeners();
  }

  Future<PackageResponse> getPackages(int? id) async {
    return await _dioClient.getPackages(id);
  }

  Future<void> getTraingingItem(PurchaseTrainingData? data) async {
    final response = await _dioClient.getTrainingItem(data?.id);

    items = (response.data ?? []);
    trainingData = data;
    notifyListeners();
  }

  Future<void> getTraingingLesson(LessonResponseData? data) async {
    final response = await _dioClient.getTrainingLesson(data?.id);

    lessons = (response.data ?? []);
    item = data;
    notifyListeners();
  }

  Future<void> getTraingingTask(LessonResponseData? data) async {
    tasks.clear();
    final response = await _dioClient.getTrainingTask(data?.id);

    tasks.addAll(response.data ?? []);
    lesson = data;
    notifyListeners();
  }

  Future<BaseResponse> setAnswer(int? id, String? text) async {
    return await _dioClient.setAnswer(id, text);
  }
}
