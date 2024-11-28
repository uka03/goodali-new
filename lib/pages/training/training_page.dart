import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/album/album_detail.dart';
import 'package:goodali/pages/album/reply_page.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/home/components/home_title.dart';
import 'package:goodali/pages/training/packages_page.dart';
import 'package:goodali/pages/training/provider/training_provider.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/primary_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/empty_state.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';
import 'package:provider/provider.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  static const path = "/training-detail";

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  late final TrainingProvider _trainingProvider;
  late final AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _trainingProvider = Provider.of<TrainingProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final id = ModalRoute.of(context)?.settings.arguments as int?;
      showLoader();
      await _trainingProvider.getTraining(id);
      await _authProvider.getMe();
      await _trainingProvider.getReplies(id, "training");
      dismissLoader();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _trainingProvider.trainingInfo = null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrainingProvider>(builder: (context, provider, _) {
      final detail = provider.trainingInfo;
      return GeneralScaffold(
        horizontalPadding: 0,
        verticalPadding: 0,
        appBar: CustomAppBar(),
        bottomBar: Container(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 32),
          color: Colors.transparent,
          child: PrimaryButton(
            isEnable: _authProvider.user != null && (detail?.canPurchase ?? false),
            onPressed: () {
              Navigator.pushNamed(
                context,
                PackagesPage.path,
                arguments: provider.trainingInfo,
              );
            },
            title: "Худалдаж авах",
          ),
        ),
        child: ListView(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedImage(
                imageUrl: detail?.banner.toUrl() ?? "",
              ),
            ),
            VSpacer(),
            Center(
              child: Column(
                children: [
                  Text(
                    detail?.name ?? "",
                    style: GeneralTextStyle.titleText(fontSize: 24),
                  ),
                  Text(
                    "Цахим сургалт",
                    style: GeneralTextStyle.bodyText(textColor: GeneralColors.primaryColor),
                  ),
                ],
              ),
            ),
            VSpacer(),
            if (detail?.opennedDate?.isNotEmpty == true)
              InfoItem(
                title: 'Эхлэх огноо',
                value: detail?.opennedDate ?? "",
              ),
            if (detail?.expireAt?.isNotEmpty == true)
              InfoItem(
                title: 'Дуусах огноо',
                value: detail?.expireAt ?? "",
              ),
            if (detail?.price != null)
              InfoItem(
                title: 'Сургалтын үнэ',
                value: formatCurrency(detail?.price ?? 0),
              ),
            VSpacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: HtmlWidget(
                detail?.body ?? "",
              ),
            ),
            VSpacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: HomeTitle(
                title: "Сэтгэгдэл",
                onPressed: provider.replies.length >= 3
                    ? () {
                        Navigator.pushNamed(context, ReplyPage.path, arguments: ReplyArg(id: detail?.id, type: "lecture"));
                      }
                    : null,
              ),
            ),
            VSpacer(size: 24),
            provider.replies.isNotEmpty == true
                ? ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: provider.replies.length,
                    separatorBuilder: (context, index) => Divider(color: GeneralColors.borderColor),
                    itemBuilder: (context, index) {
                      final reply = provider.replies[index];
                      return ReplyItem(reply: reply);
                    },
                  )
                : EmptyState(
                    title: "Одоогоор сэтгэгдэл байхгүй байна",
                  ),
          ],
        ),
      );
    });
  }
}

class InfoItem extends StatelessWidget {
  const InfoItem({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GeneralTextStyle.bodyText(textColor: GeneralColors.textGrayColor),
          ),
          Text(
            value,
            style: GeneralTextStyle.titleText(),
          ),
          Divider(),
        ],
      ),
    );
  }
}
