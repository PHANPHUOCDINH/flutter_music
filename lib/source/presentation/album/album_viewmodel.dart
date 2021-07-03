import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../../source.dart';

class AlbumViewModel extends BaseViewModel {
  AlbumModel albumModel;
  bool isLove = false;

  init(GenreModel genreModel) {
    if (Data.userModel != null) {
      for (var x in Data.userModel.like_genres) {
        if (x.name == genreModel.name) {
          isLove = true;
          break;
        }
      }
    }
  }

  addNewGenre(GenreModel genreModel) async {
    if (Data.userModel != null) {
      if (isLove) {
        Toast.show(
          "Thể loại này đã có trong library",
          context,
          duration: 2,
          backgroundColor: Colors.white70,
          textColor: Colors.black,
        );
      } else {
        Data.userModel.like_genres.add(genreModel);
        await AppFirebase.userCollection
            .doc("userID-${Data.userModel.id}")
            .update(Data.userModel.toJson());

        isLove = true;
        Toast.show(
          "Bài đã thêm thể loại ${genreModel.type} vào library",
          context,
          duration: 2,
          backgroundColor: Colors.white70,
          textColor: Colors.black,
        );
      }
    } else {
      Toast.show(
        "Hãy đăng nhập để sử dụng chức năng này",
        context,
        duration: 2,
        backgroundColor: Colors.white70,
        textColor: Colors.black,
      );
    }

    notifyListeners();
  }

  Future<List<TrackModel>> getTrackList({String apiTrackList}) async {
    Response response = await AppClients().get(apiTrackList);
    return TrackModel.listFromJson(response.data["data"]);
  }
}
