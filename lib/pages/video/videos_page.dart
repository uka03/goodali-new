import 'package:flutter/material.dart';
import 'package:goodali/connection/model/tag_response.dart';
import 'package:goodali/connection/model/video_response.dart';
import 'package:goodali/pages/feed/components/filter_page.dart';
import 'package:goodali/pages/video/components/video_item.dart';
import 'package:goodali/pages/video/provider/video_provider.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/dailogs.dart';
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
  List<TagResponseData?> selectedTags = [];

  @override
  void initState() {
    super.initState();
    provider = Provider.of<VideoProvider>(context, listen: false);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getTags();
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final tagIds = selectedTags.map((e) => e?.id).toList().join(",");
      final VideoResponse newItems = await provider.getVideos(
        page: pageKey.toString(),
        limit: limit.toString(),
        tagIds: tagIds,
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
    return Selector<VideoProvider, List<TagResponseData>>(
        selector: (p0, p1) => p1.tags,
        builder: (context, tags, _) {
          return Stack(
            children: [
              GeneralScaffold(
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
                    VSpacer.sm(),
                    if (selectedTags.isNotEmpty)
                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final tag = selectedTags[index];
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: GeneralColors.borderColor,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Text(
                                    tag?.name ?? "",
                                    style: GeneralTextStyle.titleText(
                                      fontSize: 14,
                                    ),
                                  ),
                                  HSpacer.xs(),
                                  CustomButton(
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedTags.remove(tag);
                                      });
                                      _pagingController.refresh();
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => HSpacer(),
                          itemCount: selectedTags.length,
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
              ),
              Positioned(
                bottom: 0,
                right: 10,
                child: CustomButton(
                  onTap: () {
                    showModalSheet(
                      context,
                      isScrollControlled: true,
                      height: MediaQuery.of(context).size.height * 0.88,
                      withExpanded: true,
                      child: FilterPage(
                        tags: tags,
                        selectedTags: selectedTags,
                        onFinished: (filteredTags) {
                          setState(() {
                            selectedTags = filteredTags;
                          });
                          _pagingController.refresh();
                        },
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: GeneralColors.primaryColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Image.asset(
                      "assets/icons/ic_filter.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }
}
