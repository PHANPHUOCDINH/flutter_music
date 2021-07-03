import 'package:flutter/cupertino.dart';

import '../../source.dart';

class ProfileViewModel extends BaseViewModel {
  TextEditingController nameController = TextEditingController();
  bool isReadOnly = false;

  init() {
    if (Data.userModel != null) {
      nameController.text = Data.userModel.name;
      isReadOnly = true;
    }
  }

  setCanEdit() {
    isReadOnly = false;
    notifyListeners();
  }
}
