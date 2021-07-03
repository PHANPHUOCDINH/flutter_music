import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify_clone/source/source.dart';
import 'package:toast/toast.dart';

class NotificationViewModel extends BaseViewModel {
  TextEditingController searchController = TextEditingController();
  List<TrackModel> searchResult = [];
  int searchIndex = 0;

  init(String keyword) {
    if (keyword?.isNotEmpty ?? false) {
      searchController.text = keyword;
      controlSearching(keyword);
    }
  }

  controlSearching(String keyword) async {
    setLoading(true);
    searchResult = null;
    searchResult = await getSearch(keyword: keyword);
    setLoading(false);
  }

  setSearchSelected(int index) {
    searchIndex = index;
    notifyListeners();
  }

  listenMusicRandom() async {
    if (searchResult == null) return;
    if (searchResult.length < 1) {
      Toast.show(
        "Không có bài nhạc nào để phát",
        context,
        duration: 2,
        textColor: Colors.black,
        backgroundColor: Colors.white,
      );
    }

    int index = Random.secure().nextInt(searchResult.length - 1);
    Data.addNewTracks(searchResult);
    Data.setCurrentTrack(index);

    await AppShared.setListenTrackNotification(true);
    Navigator.pop(context);
  }

  Future<List<TrackModel>> getSearch({String keyword}) async {
    var state = await authenticationRepository.getSearch(keyword: keyword);
    if (state.data != null && state.isSuccess) return state.data;
    return null;
  }
}
