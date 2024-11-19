import 'dart:async';

import 'package:flutter/material.dart';
import 'package:goodali/connection/model/search_response.dart';
import 'package:goodali/pages/album/album_detail.dart';
import 'package:goodali/pages/article/article_detail.dart';
import 'package:goodali/pages/book/book_page.dart';
import 'package:goodali/pages/mood/mood_detail.dart';
import 'package:goodali/pages/podcast/podcast_player.dart';
import 'package:goodali/pages/search/provider/search_provider.dart';
import 'package:goodali/pages/training/training_page.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/custom_text_field.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/empty_state.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  static const String path = "/search-page";

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  late final SearchProvider _provider;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<SearchProvider>(context, listen: false);
    getSearchHistory();
  }

  searchItem(String value) async {
    timer?.cancel();
    timer = Timer(Duration(milliseconds: 500), () async {
      if (value.isNotEmpty) {
        saveSearchHistory(value);
        await _provider.getSearch(value);
      }
    });
    setState(() {});
  }

  List<String> searchHistory = [];

  saveSearchHistory(String value) async {
    final prefs = await SharedPreferences.getInstance();

    final values = prefs.getStringList('search_history') ?? [];
    if (!values.contains(value)) {
      values.add(value);
      prefs.setStringList('search_history', values);
    } else {
      values.remove(value);
      values.add(value);
      prefs.setStringList('search_history', values);
    }

    setState(() {
      searchHistory = values.reversed.toList();
    });
  }

  getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final values = prefs.getStringList('search_history') ?? [];

    setState(() {
      searchHistory = values;
    });
  }

  removeSearchHistory(String value) async {
    final prefs = await SharedPreferences.getInstance();

    final values = prefs.getStringList('search_history') ?? [];
    if (values.contains(value)) {
      values.remove(value);
      prefs.setStringList('search_history', values);
    }

    setState(() {
      searchHistory = values.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<SearchProvider, List<SearchResponseData>>(
      selector: (p0, p1) => p1.items,
      builder: (context, items, _) {
        return GeneralScaffold(
          appBar: CustomAppBar(),
          child: Column(
            children: [
              CustomTextField(
                controller: _controller,
                onChange: (value) {
                  searchItem(value ?? "");
                  if (value?.isEmpty == true) {
                    _provider.items = [];
                  }
                  return;
                },
              ),
              _controller.text.isEmpty == true
                  ? searchHistory.isEmpty == true
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            VSpacer(
                              size: 120,
                            ),
                            EmptyState(
                              title: "Хайлтын түүх байхгүй байна.",
                              fontSize: 16,
                            ),
                          ],
                        )
                      : Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VSpacer(),
                              Text(
                                "Сүүлд хайсан",
                                style: GeneralTextStyle.titleText(
                                  fontSize: 20,
                                ),
                              ),
                              Expanded(
                                child: ListView.separated(
                                  itemCount: searchHistory.length,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  separatorBuilder: (context, index) => VSpacer(),
                                  itemBuilder: (context, index) {
                                    final search = searchHistory[index];
                                    return Row(
                                      children: [
                                        Icon(
                                          Icons.history,
                                          size: 28,
                                        ),
                                        HSpacer(),
                                        Expanded(
                                          child: Text(search),
                                        ),
                                        HSpacer(),
                                        CustomButton(
                                          onTap: () {
                                            removeSearchHistory(search);
                                          },
                                          child: Icon(
                                            Icons.close,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                  : items.isNotEmpty == true
                      ? Expanded(
                          child: ListView.separated(
                            itemCount: items.length,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            separatorBuilder: (context, index) => VSpacer(size: 0),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return CustomButton(
                                onTap: () {
                                  switch (item.module) {
                                    case "post":
                                      Navigator.pushNamed(
                                        context,
                                        ArticleDetail.path,
                                        arguments: item.id,
                                      );
                                      break;
                                    case "book":
                                      Navigator.pushNamed(
                                        context,
                                        BookPage.path,
                                        arguments: item.id,
                                      );
                                      break;
                                    case "training":
                                      Navigator.pushNamed(
                                        context,
                                        TrainingPage.path,
                                        arguments: item.id,
                                      );
                                      break;
                                    case "album":
                                      Navigator.pushNamed(
                                        context,
                                        AlbumDetail.path,
                                        arguments: item.id,
                                      );
                                      break;
                                    case "lecture":
                                      Navigator.pushNamed(
                                        context,
                                        AlbumDetail.path,
                                        arguments: item.album,
                                      );
                                      break;
                                    case "mood":
                                      Navigator.pushNamed(
                                        context,
                                        MoodDetail.path,
                                        arguments: item.id,
                                      );
                                      break;
                                    case "podcast":
                                      Navigator.pushNamed(
                                        context,
                                        PodcastPlayer.path,
                                        arguments: item.id,
                                      );
                                      break;
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.title ?? "",
                                              style: GeneralTextStyle.titleText(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            VSpacer.sm(),
                                            Text(
                                              item.module ?? "",
                                              style: GeneralTextStyle.bodyText(
                                                textColor: GeneralColors.grayColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      HSpacer(),
                                      Icon(
                                        Icons.keyboard_arrow_right_rounded,
                                        color: GeneralColors.grayColor,
                                        size: 26,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : EmptyState(
                          title: "Уучлаарай, өөр үгээр хайна уу?",
                        )
            ],
          ),
        );
      },
    );
  }
}
