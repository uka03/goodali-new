import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:goodali/utils/types.dart';

final bottomItems = [
  BottomItemData(iconPath: "assets/icons/ic_heart.png", index: 0, title: "Сэтгэл"),
  BottomItemData(iconPath: "assets/icons/ic_chat.png", index: 1, title: "Түүдэг гал"),
  BottomItemData(iconPath: "assets/icons/ic_profile.png", index: 2, title: "Би")
];
const String placeholder = "https://online-accounting.net/wp-content/uploads/2021/07/placeholder-image.jpg";
const String userPlaceholder = "https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_1280.png";

const String hostUrl = "https://app.goodali.mn/api/v1";

final List<TypeItem> homeTypes = [
  TypeItem("Сонсох", 0),
  TypeItem("Унших", 1),
  TypeItem("Мүүд", 2),
  TypeItem("Сургалт", 3),
];
final List<TypeItem> fireTypes = [
  TypeItem("Хүний байгаль", 0),
  TypeItem("Нууц бүлгэм", 1),
  TypeItem("Миний нандин", 2),
];
final List<TypeItem> podcastType = [
  TypeItem("Бүгд", 0),
  TypeItem("Сонсоогүй", 1),
  TypeItem("Сонссон", 2),
];
final List<TypeItem> profileTypes = [
  TypeItem("Авсан", 0),
  TypeItem("Татсан", 1),
];

class TypeItem {
  final String title;
  final int index;
  TypeItem(
    this.title,
    this.index,
  );
}

showLoader() {
  EasyLoading.show();
}

dismissLoader() {
  EasyLoading.dismiss();
}
