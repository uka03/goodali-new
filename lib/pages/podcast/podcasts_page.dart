import 'package:flutter/material.dart';
import 'package:goodali/connection/model/podcast_response.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/pages/podcast/components/podcast_item.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class PodcastsPage extends StatefulWidget {
  const PodcastsPage({super.key});

  static const String path = "/podcasts-page";

  @override
  State<PodcastsPage> createState() => _PodcastsPageState();
}

class _PodcastsPageState extends State<PodcastsPage> {
  late final HomeProvider provider;
  final PagingController<int, PodcastResponseData> _pagingController = PagingController(firstPageKey: 1);

  final int limit = 10;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<HomeProvider>(context, listen: false);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final List<PodcastResponseData> newItems = await provider.getPodcasts(
        page: pageKey,
        limit: limit,
      );
      final isLastPage = (newItems.length) < limit;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      appBar: CustomAppBar(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Подкаст",
            style: GeneralTextStyle.titleText(fontSize: 32),
          ),
          VSpacer(),
          Expanded(
            child: PagedListView(
              padding: EdgeInsets.zero,
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<PodcastResponseData>(
                itemBuilder: (BuildContext context, item, int index) {
                  return PodcastItem(podcast: item);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
