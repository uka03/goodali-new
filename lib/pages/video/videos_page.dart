import 'package:flutter/material.dart';
import 'package:goodali/connection/model/video_response.dart';
import 'package:goodali/pages/video/components/video_item.dart';
import 'package:goodali/pages/video/provider/video_provider.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  static const String path = "/videos";

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  late final VideoProvider provider;
  final PagingController<int, VideoResponseData> _pagingController = PagingController(firstPageKey: 1);

  final int limit = 10;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<VideoProvider>(context, listen: false);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final VideoResponse newItems = await provider.getVideos(
        page: pageKey.toString(),
        limit: limit.toString(),
      );
      final isLastPage = (newItems.data?.length ?? 0) < limit;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.data ?? []);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems.data ?? [], nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      appBar: CustomAppBar(),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Видео",
              style: GeneralTextStyle.titleText(fontSize: 32),
            ),
          ),
          VSpacer(),
          Expanded(
            child: PagedListView(
              padding: EdgeInsets.zero,
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<VideoResponseData>(
                itemBuilder: (BuildContext context, item, int index) {
                  return VideoItem(
                    video: item,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
