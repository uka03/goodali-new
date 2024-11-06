class BottomItemData {
  final String title;
  final String iconPath;
  final int index;

  BottomItemData({required this.iconPath, required this.index, required this.title});
}

class AuthInfo {
  String? email;
  String? pass;
  String? otpCode;
  String? nickName;
  AuthType authType;

  AuthInfo({
    required this.authType,
    this.email,
    this.pass,
    this.nickName,
    this.otpCode,
  });

  Object toJson() {
    final data = {};
    if (email?.isNotEmpty == true) {
      data["email"] = email;
    }
    if (pass?.isNotEmpty == true) {
      data["password"] = pass;
    }
    if (nickName?.isNotEmpty == true) {
      data["nickname"] = nickName;
    }
    if (otpCode?.isNotEmpty == true) {
      data["otpCode"] = otpCode;
    }
    return data;
  }
}

enum AuthType {
  login,
  register,
  registerConfirm,
  forgot,
  forgotConfirm,
}
