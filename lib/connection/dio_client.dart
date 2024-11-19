import 'dart:io';

import 'package:dio/dio.dart';
import 'package:goodali/connection/model/album_response.dart';
import 'package:goodali/connection/model/banner_response.dart';
import 'package:goodali/connection/model/base_response.dart';
import 'package:goodali/connection/model/cart_response.dart';
import 'package:goodali/connection/model/faq_response.dart';
import 'package:goodali/connection/model/feed_response.dart';
import 'package:goodali/connection/model/lesson_response.dart';
import 'package:goodali/connection/model/login_response.dart';
import 'package:goodali/connection/model/mood_response.dart';
import 'package:goodali/connection/model/order_response.dart';
import 'package:goodali/connection/model/podcast_response.dart';
import 'package:goodali/connection/model/post_response.dart';
import 'package:goodali/connection/model/purchase_response.dart';
import 'package:goodali/connection/model/search_response.dart';
import 'package:goodali/connection/model/tag_response.dart';
import 'package:goodali/connection/model/training_response.dart';
import 'package:goodali/connection/model/upload_response.dart';
import 'package:goodali/connection/model/user_response.dart';
import 'package:goodali/connection/model/video_response.dart';
import 'package:goodali/connection/network_interceptor.dart';
import 'package:goodali/utils/types.dart';
import 'package:http_parser/http_parser.dart';

class DioClient {
  final _dioClient = Dio()..interceptors.add(NetworkInterceptor());

  // final baseUrl = "http://localhost:8000/api/v1";
  // final baseUrl = "http://172.20.10.5:8000/api/v1";
  final baseUrl = "https://app.goodali.mn/api/v1";

  final userUrl = "/users";
  final infoUrl = "/info";
  final loginUrl = "/login";
  final registerUrl = "/register";
  final checkUrl = "/check";
  final forgotUrl = "/forget-password";
  final verifyUrl = "/verify-otp";
  final sendOTPUrl = "/sent-otp";
  final bannerUrl = "/banners";
  final albumUrl = "/album";
  final podcastUrl = "/podcast";
  final videoUrl = "/video";
  final postUrl = "/post";
  final moodUrl = "/mood";
  final trainingUrl = "/training";
  final listUrl = "/list";
  final similarUrl = "/similar";

// Auth rest api
  Future<BaseResponse> userCheck(String? email) async {
    try {
      final response = await _dioClient.post(
        "$baseUrl$userUrl$checkUrl",
        data: {
          "email": email
        },
      );
      final model = BaseResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = BaseResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<UserResponse> getMe() async {
    try {
      final response = await _dioClient.get(
        "$baseUrl$userUrl$infoUrl",
      );
      final model = UserResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;

      final error = UserResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<UserResponse> updateMe(String? nickName) async {
    try {
      final response = await _dioClient.patch(
        "$baseUrl/users/update",
        data: {
          "nickname": nickName,
        },
      );
      final model = UserResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;

      final error = UserResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<BaseResponse> uploadAvatar(String? imagePath) async {
    try {
      final response = await _dioClient.post(
        "$baseUrl/users/upload-avatar",
        data: {
          "image": imagePath,
        },
      );
      final model = BaseResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;

      final error = BaseResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<UploadResponse> uploadImage(
    File? image,
  ) async {
    if (image == null) {
      return UploadResponse(success: false, error: "Та хийнэ үү.", data: null);
    }

    try {
      String imagePath = DateTime.now().microsecondsSinceEpoch.toString();

      String mimeType = "image/${imagePath.split('.').last}";

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          image.path,
          filename: imagePath,
          contentType: MediaType("image", mimeType.split('/').last),
        ),
        "prefix": "avatar",
      });

      print(image.path);
      final response = await _dioClient.post(
        "$baseUrl/uploads/image",
        data: formData,
      );

      final model = UploadResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = UploadResponse.fromJson(dioFailure?.response?.data);

      return error;
    }
  }

  Future<PurchaseResponse> getUserdata() async {
    try {
      final response = await _dioClient.get(
        "$baseUrl$userUrl/me",
      );
      final model = PurchaseResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;

      final error = PurchaseResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<LoginResponse> login(AuthInfo info) async {
    print(info.toJson());
    try {
      final response = await _dioClient.post(
        "$baseUrl$userUrl$loginUrl",
        data: info.toJson(),
      );

      final model = LoginResponse.fromJson(response.data);
      return model;
    } catch (e) {
      print(e);
      final dioFailure = e as DioException?;

      final error = LoginResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<LoginResponse> register(AuthInfo info) async {
    try {
      final response = await _dioClient.post(
        "$baseUrl$userUrl$registerUrl",
        data: info.toJson(),
      );
      final model = LoginResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;

      final error = LoginResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<LoginResponse> forgot(AuthInfo info) async {
    try {
      final response = await _dioClient.post(
        "$baseUrl$userUrl$forgotUrl",
        data: info.toJson(),
      );
      final model = LoginResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;

      final error = LoginResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<BaseResponse> sendOTP(String email) async {
    try {
      final response = await _dioClient.post("$baseUrl$userUrl$sendOTPUrl", data: {
        "email": email
      });
      final model = BaseResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;

      final error = BaseResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<BaseResponse> verify(AuthInfo info) async {
    try {
      final response = await _dioClient.post(
        "$baseUrl$userUrl$verifyUrl",
        data: info.toJson(),
      );
      final model = BaseResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;

      final error = BaseResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<BaseResponse> changePassword(String? current, String? password) async {
    try {
      final data = {
        "currentPassword": current,
        "newPassword": password,
      };
      final response = await _dioClient.post("$baseUrl$userUrl/change-password", data: data);
      final model = BaseResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;

      final error = BaseResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<FaqResponse> getFaq({String? page, String? limit}) async {
    try {
      final response = await _dioClient.get("$baseUrl/faq?page=$page&limit=$limit");
      final model = FaqResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;

      final error = FaqResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  /// Cart Api
  ///
  Future<CartResponse> getItemFromCart() async {
    try {
      final response = await _dioClient.get("$baseUrl/cart");
      final model = CartResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;

      final error = CartResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<BaseResponse> checkPayment(String? id, int type) async {
    try {
      final response = await _dioClient.get("$baseUrl/payment/callback/${type == 1 ? "qpay" : "golomt"}/$id");
      final model = BaseResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;

      final error = BaseResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<BaseResponse> addToCart(int? id) async {
    try {
      final data = {
        "productId": id,
        "quantity": 1
      };
      final response = await _dioClient.post("$baseUrl/cart/items", data: data);
      final model = BaseResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;

      final error = BaseResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<BaseResponse> deleteFromCart(int? id) async {
    try {
      final data = {
        "productId": id,
        "quantity": 0
      };
      final response = await _dioClient.patch("$baseUrl/cart/items", data: data);
      final model = BaseResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;

      final error = BaseResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  /// Home Page datas
  Future<BannerResponse> getBanners() async {
    try {
      final response = await _dioClient.get("$baseUrl$bannerUrl");
      final model = BannerResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;

      final error = BannerResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<AlbumResponse> getAlbums({String? page, String? limit}) async {
    try {
      final response = await _dioClient.get("$baseUrl$albumUrl?page=$page&limit=$limit");
      final model = AlbumResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = AlbumResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<AlbumDetailResponse> getAlbum(int? id) async {
    try {
      final response = await _dioClient.get("$baseUrl$albumUrl/$id");
      final model = AlbumDetailResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = AlbumDetailResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<PodcastResponse> getPodcasts({int? limit, int page = 1}) async {
    try {
      final response = await _dioClient.get("$baseUrl$podcastUrl?limit=$limit&page=$page");
      final model = PodcastResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = PodcastResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<PodcastResponseData> getPodcast(int? id) async {
    try {
      final response = await _dioClient.get("$baseUrl$podcastUrl/$id");
      final model = PodcastResponseData.fromJson(response.data["data"]);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = PodcastResponseData.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<BaseResponse> podcastPausedTime(int? id, int pausedTime) async {
    try {
      final response = await _dioClient.post(
        "$baseUrl$podcastUrl/$id/pause",
        data: {
          "audioType": "podcast",
          "pausedTime": pausedTime
        },
      );
      final model = BaseResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = BaseResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<VideoResponse> getVideos({String? page, String? limit, String? tagIds}) async {
    try {
      String url = "$baseUrl$videoUrl?page=$page&limit=$limit";
      if (tagIds != null) {
        url = "$baseUrl$videoUrl?page=$page&limit=$limit&tagIds=$tagIds";
      }
      final response = await _dioClient.get(url);
      final model = VideoResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = VideoResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<VideoResponse> getSimilarVideos(int? id) async {
    try {
      final response = await _dioClient.get("$baseUrl$videoUrl$similarUrl?videoId=$id");
      final model = VideoResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = VideoResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<PostResponse> getPost({String? page, String? limit, String? tagIds}) async {
    try {
      String url = "$baseUrl$postUrl?page=$page&limit=$limit";
      if (tagIds != null) {
        url = "$baseUrl$postUrl?page=$page&limit=$limit&tagIds=$tagIds";
      }
      final response = await _dioClient.get(url);
      final model = PostResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = PostResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<PostResponse> getSimilarPost(int? id) async {
    try {
      final response = await _dioClient.get("$baseUrl$postUrl/similar?postId=$id");
      final model = PostResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = PostResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<PostResponseData> getPostById(int? id) async {
    try {
      final response = await _dioClient.get("$baseUrl$postUrl/$id");
      final model = PostResponseData.fromJson(response.data["data"]);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = PostResponseData.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<MoodResponse> getMoods() async {
    try {
      final response = await _dioClient.get("$baseUrl$moodUrl$listUrl?mainId=1&limit=300");
      final model = MoodResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = MoodResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<MoodItemResponse> getMoodItems(int? id) async {
    try {
      final response = await _dioClient.get("$baseUrl$moodUrl$listUrl/$id?limit=300");
      final model = MoodItemResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = MoodItemResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<PodcastResponse> getMoodMain() async {
    try {
      final response = await _dioClient.get("$baseUrl$moodUrl");
      final model = PodcastResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = PodcastResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<TrainingResponse> getTrainings() async {
    try {
      final response = await _dioClient.get("$baseUrl$trainingUrl");
      final model = TrainingResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = TrainingResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<TrainingDetailResponse> getTraining(int? id) async {
    try {
      final response = await _dioClient.get("$baseUrl$trainingUrl/$id");
      final model = TrainingDetailResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = TrainingDetailResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<LessonResponse> getTrainingItem(int? id) async {
    try {
      final response = await _dioClient.get("$baseUrl/item?trainingId=$id");
      final model = LessonResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = LessonResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<LessonResponse> getTrainingLesson(int? id) async {
    try {
      final response = await _dioClient.get("$baseUrl/lesson?itemId=$id");
      final model = LessonResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = LessonResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<TaskResponse> getTrainingTask(int? id) async {
    try {
      final response = await _dioClient.get("$baseUrl/task/?userLessonId=$id");
      final model = TaskResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = TaskResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<BaseResponse> setAnswer(int? id, String? text) async {
    try {
      final data = {
        "text": text ?? "",
        "task_id": id.toString(),
      };

      final response = await _dioClient.post("$baseUrl/setanswer", data: data);
      final model = BaseResponse.fromJson(response.data);

      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = BaseResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<PackageResponse> getPackages(int? id) async {
    try {
      final response = await _dioClient.get("$baseUrl/package?trainingId=$id");
      final model = PackageResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = PackageResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<OrderResponse> createOrder(List<int?> productIds, int type) async {
    try {
      final data = {
        "productIds": productIds,
        "invoiceType": type.toString(),
      };
      final response = await _dioClient.post("$baseUrl/order", data: data);
      final model = OrderResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = OrderResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<FeedResponse> getFeedPosts(
    int? id, {
    int? page,
    int? limit,
    required String tagIds,
  }) async {
    try {
      final response = await _dioClient.get("$baseUrl/community/?postType=$id&page=$page&limit=$limit&tagIds=$tagIds");
      final model = FeedResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = FeedResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<BaseResponse> postLike(int? id) async {
    try {
      final response = await _dioClient.post("$baseUrl/community/$id/like");
      final model = BaseResponse.fromJson(response.data);
      print(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = BaseResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<BaseResponse> postDislike(int? id) async {
    try {
      final response = await _dioClient.post("$baseUrl/community/$id/dislike");

      final model = BaseResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = BaseResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<BaseResponse> deleteReply(int? id, int? postId) async {
    try {
      final response = await _dioClient.delete("$baseUrl/community/$postId/reply/$id");

      final model = BaseResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = BaseResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<ReplyResponse> postReply(int? postId, String? content) async {
    try {
      final response = await _dioClient.post("$baseUrl/community/$postId/reply", data: {
        'body': content,
      });

      final model = ReplyResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = ReplyResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<BaseResponse> createPost({
    required String title,
    required String body,
    required int? postType,
    required List<int?> tags,
  }) async {
    try {
      final data = {
        "title": title,
        "body": body,
        "post_type": postType,
        "tags": tags
      };
      final response = await _dioClient.post("$baseUrl/community", data: data);
      final model = BaseResponse.fromJson(response.data);

      return model;
    } catch (e) {
      final dioFailure = e as DioException?;

      final error = BaseResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<BaseResponse> updatePost({
    required int? id,
    required String title,
    required String body,
    required List<int?> tags,
  }) async {
    try {
      final data = {
        "title": title,
        "body": body,
        "tags": tags
      };
      final response = await _dioClient.patch("$baseUrl/community/$id", data: data);
      final model = BaseResponse.fromJson(response.data);

      return model;
    } catch (e) {
      final dioFailure = e as DioException?;

      final error = BaseResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<BaseResponse> deletePost(int? postId) async {
    try {
      final response = await _dioClient.delete("$baseUrl/community/$postId");
      final model = BaseResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = BaseResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<TagResponse> getTags() async {
    try {
      final response = await _dioClient.get("$baseUrl/tag");
      final model = TagResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = TagResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<SearchResponse> getSearch(String? text) async {
    try {
      final response = await _dioClient.post(
        "$baseUrl/search",
        data: {
          "text": text,
        },
      );
      final model = SearchResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = SearchResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<PodcastResponse> getBooks() async {
    try {
      final response = await _dioClient.get("$baseUrl/book");
      final model = PodcastResponse.fromJson(response.data);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = PodcastResponse.fromJson(dioFailure?.response?.data);
      return error;
    }
  }

  Future<PodcastResponseData> getBookById(int? id) async {
    try {
      final response = await _dioClient.get("$baseUrl/book/$id");
      final model = PodcastResponseData.fromJson(response.data["data"]);
      return model;
    } catch (e) {
      final dioFailure = e as DioException?;
      final error = PodcastResponseData.fromJson(dioFailure?.response?.data);
      return error;
    }
  }
}
