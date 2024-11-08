import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/model/base_response.dart';
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

  getTraining(int? id) async {
    final response = await _dioClient.getTraining(id);

    trainingInfo = response.data;
    notifyListeners();
  }

  Future<PackageResponse> getPackages(int? id) async {
    return await _dioClient.getPackages(id);
  }

  Future<void> getTraingingItem(PurchaseTrainingData? data) async {
    items.clear();
    final response = await _dioClient.getTrainingItem(data?.id);

    items.addAll(response.data ?? []);
    trainingData = data;
    notifyListeners();
  }

  Future<void> getTraingingLesson(LessonResponseData? data) async {
    lessons.clear();
    final response = await _dioClient.getTrainingLesson(data?.id);

    lessons.addAll(response.data ?? []);
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

  void clearItems() {
    items.clear(); // Clear the items list
    notifyListeners(); // Notify listeners to update the UI
  }

  void clearTasks() {
    tasks.clear(); // Clear the items list
    notifyListeners(); // Notify listeners to update the UI
  }

  void clearlessons() {
    lessons.clear(); // Clear the items list
    notifyListeners(); // Notify listeners to update the UI
  }
}
