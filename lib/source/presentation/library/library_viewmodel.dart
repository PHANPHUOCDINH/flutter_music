import '../../source.dart';

class LibraryViewModel extends BaseViewModel {
  List<String> headers = [
    "Tải về",
    "Bài hát yêu thích",
    "Nghệ sĩ yêu thích",
    "Chủ đề yêu thích",
  ];

  int headerIndex = 0;

  init() {}

  setHeaderSelected(int index) {
    headerIndex = index;
    notifyListeners();
  }
}
