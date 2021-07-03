import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/source/source.dart';
import 'package:toast/toast.dart';

class ProfileUpdateViewModel extends BaseViewModel {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController sdtController = TextEditingController();

  List<String> genres = [
    "Thư giãn",
    "Nhạc buồn",
    "Giáng Sinh",
    "Nhạc vui",
    "Nhạc trẻ",
    "Nhạc sôi động",
  ];

  List<String> chudes = [
    "Artist",
    "Pop",
    "Hiphop",
    "American",
    "Asia",
    "Trung quốc",
    "Hàn quốc",
  ];

  int genreIndex = 0;
  int chudeIndex = 0;
  String genre = "", chude = "";

  init() {}

  setGenreIndex(int index) {
    Navigator.pop(context);
    genreIndex = index;
    genre = genres[index];
    notifyListeners();
  }

  setChudeIndex(int index) async {
    Navigator.pop(context);
    chudeIndex = index;
    chude = chudes[index];
    notifyListeners();
  }

  initText() {
    nameController.text = Data.userModel?.name ?? "Error";
    emailController.text = Data.userModel?.email ?? "Error";
    sdtController.text = Data.userModel?.sdt ?? "Error";

    if (genre != "") return;
    genre = Data.userModel.genre.isEmpty ? "Thể loại quan tâm" : Data.userModel.genre;

    if (chude != "") return;
    chude = Data.userModel.chude.isEmpty ? "Chủ đề quan tâm" : Data.userModel.chude;
  }

  uploadInformation() async {
    setLoading(true);
    try {
      UserModel _user = new UserModel(
        id: Data.userModel.id,
        user_avatar: Data.userModel.user_avatar,
        like_genres: Data.userModel.like_genres,
        like_tracks: Data.userModel.like_tracks,
        name: nameController.text.trim(),
        sdt: sdtController.text.trim(),
        email: emailController.text.trim(),
        genre: genre,
        chude: chude,
      );

      await AppShared.setUser(_user);
      await AppFirebase.userCollection.doc("userID-${Data.userModel.id}").update(_user.toJson());

      Data.userModel = _user;
      setLoading(false);

      Toast.show(
        "Update thông tin thành công",
        context,
        duration: 2,
        backgroundColor: Colors.white70,
        textColor: Colors.black,
      );
      Navigator.pop(context);
    } catch (e) {
      await showConfirm(content: e.toString());
      setLoading(false);
    }
  }
}
