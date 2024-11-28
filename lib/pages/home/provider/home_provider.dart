import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/model/album_response.dart';
import 'package:goodali/connection/model/banner_response.dart';
import 'package:goodali/connection/model/mood_response.dart';
import 'package:goodali/connection/model/podcast_response.dart';
import 'package:goodali/connection/model/post_response.dart';
import 'package:goodali/connection/model/training_response.dart';
import 'package:goodali/connection/model/video_response.dart';
import 'package:goodali/pages/album/albums_page.dart';
import 'package:goodali/pages/article/articles_page.dart';
import 'package:goodali/pages/podcast/podcasts_page.dart';
import 'package:goodali/pages/video/videos_page.dart';

class HomeProvider extends ChangeNotifier {
  final _dioClient = DioClient();

  List<BannerResponseData> banners = List.empty(growable: true);
  HomeData homeData = HomeData(
    albums: List.empty(growable: true),
    podcasts: List.empty(growable: true),
    videos: List.empty(growable: true),
    posts: List.empty(growable: true),
    moods: List.empty(growable: true),
    moodMain: List.empty(growable: true),
    trainings: List.empty(growable: true),
  );

  List<HomeDataType> homeFeel = [];
  List<HomeDataType> homeRead = [];
  List<HomeDataType> homeTraining = [];

  bool isLoading = true;

  getHomeTrainingData() async {
    final traings = await getTrainings();
    for (var i = 0; i < traings.length; i++) {
      if (i == 0) {
        homeTraining.add(
          HomeDataType(
            title: "Онлайн сургалт",
            item: HomeFeelItems(
              training: traings[i],
            ),
          ),
        );
      } else {
        homeTraining.add(
          HomeDataType(
            item: HomeFeelItems(
              training: traings[i],
            ),
          ),
        );
      }
    }
    notifyListeners();
  }

  getHomeFeelData() async {
    final albums = await getAlbums();
    final podcasts = await getPodcasts();
    final videos = await getVideos();

    homeFeel.add(
      HomeDataType(
        title: "Цомог",
        path: AlbumsPage.path,
        item: HomeFeelItems(
          albums: albums,
        ),
      ),
    );

    for (var i = 0; i < podcasts.length; i++) {
      final podcast = podcasts[i];
      if (i == 0) {
        homeFeel.add(
          HomeDataType(
            title: "Подкаст",
            path: PodcastsPage.path,
            item: HomeFeelItems(
              podcast: podcast,
            ),
          ),
        );
      } else {
        homeFeel.add(
          HomeDataType(
            item: HomeFeelItems(
              podcast: podcast,
            ),
          ),
        );
      }
    }
    for (var i = 0; i < videos.length; i++) {
      final video = videos[i];
      if (i == 0) {
        homeFeel.add(
          HomeDataType(
            title: "Видео",
            path: VideosPage.path,
            item: HomeFeelItems(
              video: video,
            ),
          ),
        );
      } else {
        homeFeel.add(
          HomeDataType(
            item: HomeFeelItems(
              video: video,
            ),
          ),
        );
      }
    }
    notifyListeners();
  }

  void getHomeReadData() async {
    final posts = await getposts();
    final books = await getBooks();
    homeRead.add(
      HomeDataType(
        title: "Онлайн ном",
        item: HomeFeelItems(
          book: books,
        ),
      ),
    );
    for (var i = 0; i < posts.length; i++) {
      final post = posts[i];
      if (i == 0) {
        homeRead.add(
          HomeDataType(
            title: "Бичвэр",
            path: ArticlesPage.path,
            item: HomeFeelItems(
              post: post,
            ),
          ),
        );
      } else {
        homeRead.add(
          HomeDataType(
            item: HomeFeelItems(
              post: post,
            ),
          ),
        );
      }
    }

    notifyListeners();
  }

  Future<void> getHomeData({
    bool refresh = false,
  }) async {
    if (refresh || isLoading) {
      homeFeel = [];
      homeRead = [];
      homeTraining = [];
      getHomeReadData();
      getHomeFeelData();
      getHomeTrainingData();
      final moods = await getMoods();
      final moodMain = await getMoodMain();
      final banner = await getBanners();

      homeData = HomeData(
        albums: [],
        podcasts: [],
        videos: [],
        posts: [],
        moods: moods,
        moodMain: moodMain,
        trainings: [],
      );
      banners = banner;
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<BannerResponseData>> getBanners() async {
    final response = await _dioClient.getBanners();

    return response.data ?? [];
  }

  Future<List<AlbumResponseData>> getAlbums() async {
    final response = await _dioClient.getAlbums();
    return response.data ?? [];
  }

  Future<List<PodcastResponseData>> getPodcasts({int limit = 4, int page = 1, String? type}) async {
    final response = await _dioClient.getPodcasts(limit: limit, page: page, type: type);
    return response.data ?? [];
  }

  Future<List<PodcastResponseData>> getBooks({int limit = 4, int page = 1}) async {
    final response = await _dioClient.getBooks();
    return response.data ?? [];
  }

  Future<List<VideoResponseData>> getVideos() async {
    final response = await _dioClient.getVideos(limit: "4", page: "1");
    return response.data ?? [];
  }

  Future<List<PostResponseData>> getposts() async {
    final response = await _dioClient.getPost(limit: "6", page: "1");
    return response.data ?? [];
  }

  Future<List<MoodResponseData>> getMoods() async {
    final response = await _dioClient.getMoods();
    return response.data ?? [];
  }

  Future<List<PodcastResponseData>> getMoodMain() async {
    final response = await _dioClient.getMoodMain();
    return response.data ?? [];
  }

  Future<List<TrainingResponseData>> getTrainings() async {
    final response = await _dioClient.getTrainings();
    return response.data ?? [];
  }
}

class HomeDataType {
  final String? title;
  final String? path;
  final HomeFeelItems item;
  HomeDataType({
    required this.item,
    this.path,
    this.title,
  });
}

class HomeFeelItems {
  final List<AlbumResponseData>? albums;
  final PodcastResponseData? podcast;
  final List<PodcastResponseData>? book;
  final VideoResponseData? video;
  final PostResponseData? post;
  final TrainingResponseData? training;

  HomeFeelItems({
    this.albums,
    this.podcast,
    this.video,
    this.post,
    this.training,
    this.book,
  });
}

class HomeData {
  final List<AlbumResponseData> albums;
  final List<PodcastResponseData> podcasts;
  final List<PodcastResponseData> moodMain;
  final List<VideoResponseData> videos;
  final List<PostResponseData> posts;
  final List<MoodResponseData> moods;
  final List<TrainingResponseData> trainings;

  HomeData({
    required this.albums,
    required this.podcasts,
    required this.videos,
    required this.posts,
    required this.moods,
    required this.moodMain,
    required this.trainings,
  });
}
