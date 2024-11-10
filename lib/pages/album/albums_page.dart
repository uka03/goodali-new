import 'package:flutter/material.dart';
import 'package:goodali/connection/model/album_response.dart';
import 'package:goodali/pages/album/components/album_item.dart';
import 'package:goodali/pages/album/provider/album_provider.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class AlbumsPage extends StatefulWidget {
  const AlbumsPage({super.key});

  static const String path = "/albums-page";

  @override
  State<AlbumsPage> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  late final AlbumProvider provider;
  final PagingController<int, AlbumResponseData> _pagingController = PagingController(firstPageKey: 1);

  final limit = 10;
  @override
  void initState() {
    super.initState();
    provider = Provider.of<AlbumProvider>(context, listen: false);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final AlbumResponse newItems = await provider.getAlbums(
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
      verticalPadding: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Цомог",
            style: GeneralTextStyle.titleText(fontSize: 32),
          ),
          VSpacer(),
          Expanded(
            child: PagedGridView(
              showNewPageProgressIndicatorAsGridChild: false,
              showNewPageErrorIndicatorAsGridChild: false,
              showNoMoreItemsIndicatorAsGridChild: false,
              pagingController: _pagingController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.7,
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              builderDelegate: PagedChildBuilderDelegate<AlbumResponseData>(
                itemBuilder: (BuildContext context, item, int index) {
                  return AlbumItem(album: item);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
