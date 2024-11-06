import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/connection/model/faq_response.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  static String path = "/faq-page";

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  late final AuthProvider authProvider;
  final PagingController<int, FaqResponseData> _pagingController = PagingController(firstPageKey: 1);

  final int limit = 10;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final FaqResponse newItems = await authProvider.getFaq(
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
      horizontalPadding: 0,
      appBar: CustomAppBar(title: Text("Нийтлэг асуулт хариулт")),
      child: PagedListView.separated(
        padding: EdgeInsets.all(16),
        pagingController: _pagingController,
        separatorBuilder: (context, index) => VSpacer(size: 0),
        builderDelegate: PagedChildBuilderDelegate<FaqResponseData>(
          itemBuilder: (context, item, index) {
            return DropDown(faq: item);
          },
        ),
      ),
    );
  }
}

class DropDown extends StatelessWidget {
  const DropDown({
    super.key,
    required this.faq,
  });

  final FaqResponseData? faq;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData().copyWith(
        dividerColor: Colors.transparent,
        unselectedWidgetColor: GeneralColors.primaryColor,
      ),
      child: ExpansionTile(
        iconColor: GeneralColors.primaryColor,
        collapsedIconColor: GeneralColors.primaryColor,
        textColor: Colors.black,
        expandedAlignment: Alignment.topLeft,
        collapsedTextColor: Colors.black,
        tilePadding: const EdgeInsets.symmetric(horizontal: 0),
        title: Text(
          faq?.question ?? "",
          style: GeneralTextStyle.titleText(
            fontSize: 16,
          ),
        ),
        children: [
          HtmlWidget(faq?.answer ?? "")
        ],
      ),
    );
  }
}
