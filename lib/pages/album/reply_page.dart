import 'package:flutter/material.dart';
import 'package:goodali/connection/model/feedback_response.dart';
import 'package:goodali/pages/album/album_detail.dart';
import 'package:goodali/pages/album/provider/album_provider.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class ReplyPage extends StatefulWidget {
  const ReplyPage({super.key});

  static const String path = "/reply-page";

  @override
  State<ReplyPage> createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage> {
  late final AlbumProvider _provider;

  final PagingController<int, FeedbackResponseData> _pagingController = PagingController(firstPageKey: 1);
  int limit = 10;
  @override
  void initState() {
    _provider = Provider.of<AlbumProvider>(context, listen: false);
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final arg = ModalRoute.of(context)?.settings.arguments as ReplyArg?;

      FeedbackResponse? newItems = await _provider.getReplies(
        arg?.id,
        arg?.type ?? "",
        page: pageKey,
        limit: limit,
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
      appBar: CustomAppBar(
        title: Text("Сэтгэгдэл"),
      ),
      child: PagedListView.separated(
        pagingController: _pagingController,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        builderDelegate: PagedChildBuilderDelegate<FeedbackResponseData>(
          itemBuilder: (BuildContext context, item, int index) {
            return ReplyItem(
              reply: item,
            );
          },
        ),
      ),
    );
  }
}

class ReplyArg {
  final int? id;
  final String? type;

  ReplyArg({
    required this.id,
    required this.type,
  });
}
