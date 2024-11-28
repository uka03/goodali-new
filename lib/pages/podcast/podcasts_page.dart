import 'package:flutter/material.dart';
import 'package:goodali/connection/model/podcast_response.dart';
import 'package:goodali/pages/home/components/type_bar.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/pages/podcast/components/podcast_item.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/shared/provider/navigator_provider.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/empty_state.dart';
import 'package:goodali/utils/globals.dart';
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
  final PagingController<int, PodcastResponseData> _pagingNotListenController = PagingController(firstPageKey: 1);
  final PagingController<int, PodcastResponseData> _pagingListenController = PagingController(firstPageKey: 1);

  final int limit = 10;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<HomeProvider>(context, listen: false);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, _pagingController, null);
    });
    _pagingNotListenController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, _pagingNotListenController, "notlisten");
    });
    _pagingListenController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, _pagingListenController, "listen");
    });
  }

  Future<void> _fetchPage(int pageKey, PagingController<int, PodcastResponseData> pagingController, String? type) async {
    try {
      final List<PodcastResponseData> newItems = await provider.getPodcasts(
        type: type,
        page: pageKey,
        limit: limit,
      );
      final isLastPage = (newItems.length) < limit;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigatorProvider>(
      builder: (context, provider, _) {
        return DefaultTabController(
          length: 3,
          initialIndex: provider.fireSelectedPage,
          child: GeneralScaffold(
            horizontalPadding: 0,
            appBar: CustomAppBar(
              title: Text("Подкаст"),
              titleCenter: true,
            ),
            child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyHeaderDelegate(
                        child: TypeBar(
                      onChanged: (index) {
                        provider.setFire(index);
                      },
                      selectedType: provider.fireSelectedPage,
                      typeItems: podcastType,
                    )),
                  ),
                ];
              },
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  pagedView(_pagingController),
                  pagedView(_pagingNotListenController),
                  pagedView(_pagingListenController),
                ],
              ),

              //          Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Expanded(
              //       child: PagedListView.separated(
              //         padding: EdgeInsets.symmetric(horizontal: 16),
              //         pagingController: _pagingController,
              //         builderDelegate: PagedChildBuilderDelegate<PodcastResponseData>(
              //           itemBuilder: (BuildContext context, item, int index) {
              //
              //           },
              //         ),
              //         separatorBuilder: (context, index) => Divider(
              //           color: GeneralColors.borderColor,
              //         ),
              //       ),
              //     )
              //   ],
              // ),
            ),
          ),
        );
      },
    );
  }

  Widget pagedView(
    PagingController<int, PodcastResponseData> pagingController,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        pagingController.refresh();
      },
      color: GeneralColors.primaryColor,
      child: PagedListView.separated(
        padding: EdgeInsets.all(16),
        pagingController: pagingController,
        separatorBuilder: (context, index) => Divider(),
        builderDelegate: PagedChildBuilderDelegate<PodcastResponseData>(
          noItemsFoundIndicatorBuilder: (context) {
            return Center(
              child: EmptyState(
                title: "Одоогоор энэхүү хэсэг хоосон байна.",
              ),
            );
          },
          itemBuilder: (BuildContext context, item, int index) {
            return PodcastItem(podcast: item);
          },
        ),
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Colors.white,
      elevation: shrinkOffset > 0 ? 4 : 0,
      child: child,
    );
  }

  @override
  double get maxExtent => 48.0;

  @override
  double get minExtent => 48.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
