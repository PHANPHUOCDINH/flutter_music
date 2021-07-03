import 'package:flutter/material.dart';

import '../../source.dart';

class HomeViewModel extends BaseViewModel {
  List<LocalGenre> song_type_1 = [
    LocalGenre(
      name: "Pop",
      id: 132,
    ),
    LocalGenre(
      name: "Rap/Hip hop",
      id: 116,
    ),
    LocalGenre(
      name: "Rock",
      id: 152,
    ),
    LocalGenre(
      name: "Dance",
      id: 113,
    ),
    LocalGenre(
      name: "R&B",
      id: 165,
    ),
    LocalGenre(
      name: "Alternative",
      id: 85,
    ),
    LocalGenre(
      name: "Electro",
      id: 106,
    ),
    LocalGenre(
      name: "Folk",
      id: 466,
    ),
    LocalGenre(
      name: "Reggae",
      id: 144,
    ),
    LocalGenre(
      name: "Jazz",
      id: 129,
    ),
    LocalGenre(
      name: "Classical",
      id: 89,
    ),
    LocalGenre(
      name: "Films/Games",
      id: 173,
    ),
    LocalGenre(
      name: "Metal",
      id: 464,
    ),
    LocalGenre(
      name: "Soul & Funk",
      id: 169,
    ),
  ];

  List<LocalGenre> song_type_2 = [
    LocalGenre(
      name: "African Music",
      id: 2,
    ),
    LocalGenre(
      name: "Asian Music",
      id: 16,
    ),
    LocalGenre(
      name: "Blues",
      id: 153,
    ),
    LocalGenre(
      name: "Brazilian Music",
      id: 75,
    ),
    LocalGenre(
      name: "Indian Music",
      id: 81,
    ),
    LocalGenre(
      name: "Kids",
      id: 95,
    ),
    LocalGenre(
      name: "Latin Music",
      id: 197,
    ),
  ];

  List<LocalChude> chudes = [
    LocalChude(
      img:
          "https://photo-zmp3.zadn.vn/cover/5/7/d/b/57dbc9145318876d3d79e26a99ec8a83.jpg",
      name: "Tình yêu",
    ),
    LocalChude(
      img:
          "https://photo-zmp3.zadn.vn/cover/9/4/5/2/94525d3e4dfd9b64b3cddb0365b00dcc.jpg",
      name: "Ngủ ngon",
    ),
    LocalChude(
      img:
          "https://photo-zmp3.zadn.vn/cover/7/1/a/b/71ab8a69d1ad4cad8c6289a346773073.jpg",
      name: "Workout",
    ),
    LocalChude(
      img:
          "https://photo-zmp3.zadn.vn/cover/1/3/d/a/13da957b7350667f92a0c6ae620c97ec.jpg",
      name: "Spa - Yoga",
    ),
    LocalChude(
      img:
          "https://photo-zmp3.zadn.vn/cover/d/f/b/2/dfb2357709d81574da689144f0348c78.jpg",
      name: "Tập trung",
    ),
    LocalChude(
      img:
          "https://photo-zmp3.zadn.vn/cover/7/4/5/7/7457c5c2972c13603b22885baf25b47d.jpg",
      name: "Motivation",
    ),
  ];

  int header1 = 0;
  int header2 = 0;
  int header3 = 0;

  init() {
    if (Data.weatherVi != null && Data.weatherEn != null && !Data.isSentNotification) {
      NotificationHelper.initNotificationManager(
        onSelectNotification: (payload) => Navigator.pushNamed(
          context,
          Routers.notification,
          arguments: Data.weatherEn.weather[0].description,
        ),
      );

      NotificationHelper.showNotification(
        dt: DateTime.now(),
        title:
            "Thời tiết hôm nay là: ${Data.weatherVi.weather[0].description}",
        body: "Bạn nên nghe những bài nhạc sau đây ...",
      );

      Data.isSentNotification = true;
    }
  }

  setHeader1Selected(int index) {
    header1 = index;
    notifyListeners();
  }

  setHeader2Selected(int index) {
    header2 = index;
    notifyListeners();
  }

  setHeader3Selected(int index) {
    header3 = index;
    notifyListeners();
  }
}
