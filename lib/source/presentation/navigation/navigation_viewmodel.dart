import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:toast/toast.dart';

import '../../source.dart';

class NavigationViewModel extends BaseViewModel {
  TrackModel trackModel;
  int currentPage = 0;
  bool isMusicPlaying = true;
  bool isLove = false;

  init() {}

  setCurrentPage(int index) {
    currentPage = index;
    notifyListeners();
  }

  listenEventComplete() async {
    setLoading(true);
    if (trackModel != null) {
      setLoading(false);
      return;
    }

    trackModel = Data.getCurrentTrack();
    isLove = Data.checkIsLoveTrack(trackModel);

    try {
      await Data.audioPlayer.setUrl(trackModel.preview);
      setLoading(false);
      Data.audioPlayer.play();
    } on PlayerException catch (e) {
      print("Error code: ${e.code}");
      print("Error message: ${e.message}");
    } on PlayerInterruptedException catch (e) {
      print("Connection aborted: ${e.message}");
    } catch (e) {
      print(e);
    }

    Data.audioListenEventOnCompleteMusic(
      onComplete: () async {
        try {
          setLoading(true);
          trackModel = Data.shuffleTrack();
          await Data.audioPlayer.setUrl(trackModel.preview);

          isMusicPlaying = true;
          isLove = Data.checkIsLoveTrack(trackModel);

          setLoading(false);
          Data.audioPlayer.play();
          notifyListeners();
        } on PlayerException catch (e) {
          print("Error code: ${e.code}");
          print("Error message: ${e.message}");
        } on PlayerInterruptedException catch (e) {
          print("Connection aborted: ${e.message}");
        } catch (e) {
          print(e);
        }
      },
    );
  }

  playingMusic() async {
    isMusicPlaying = !isMusicPlaying;
    if (isMusicPlaying) {
      Data.audioPlayer.play();
    } else {
      Data.audioPlayer.pause();
    }

    notifyListeners();
  }

  getNewTrack(int type) async {
    switch (type) {
      case 0:
        trackModel = Data.skipToNext();
        break;

      case 1:
        trackModel = Data.skipToPrev();
        break;
    }

    try {
      setLoading(true);
      await Data.audioPlayer.stop();
      await Data.audioPlayer.setUrl(trackModel.preview);

      setLoading(false);
      Data.audioPlayer.play();

      isMusicPlaying = true;
      isLove = Data.checkIsLoveTrack(trackModel);
      notifyListeners();
    } on PlayerException catch (e) {
      print("Error code: ${e.code}");
      print("Error message: ${e.message}");
    } on PlayerInterruptedException catch (e) {
      print("Connection aborted: ${e.message}");
    } catch (e) {
      print(e);
    }
  }

  onFavorite() async {
    if (Data.userModel != null) {
      if (isLove ?? false) {
        Toast.show(
          "Bài này đã có trong library",
          context,
          duration: 2,
          backgroundColor: Colors.white70,
          textColor: Colors.black,
        );
      } else {
        setLoading(true);
        Data.userModel.like_tracks.add(trackModel);
        await AppFirebase.userCollection
            .doc("userID-${Data.userModel.id}")
            .update(Data.userModel.toJson());

        setLoading(false);
        isLove = true;
        Toast.show(
          "Bài đã thêm bài hát ${trackModel.title} vào library",
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

  checkErrorMusic({
    Function onAction,
  }) {
    try {
      onAction?.call();
    } on PlayerException catch (e) {
      print("Error code: ${e.code}");
      print("Error message: ${e.message}");
    } on PlayerInterruptedException catch (e) {
      print("Connection aborted: ${e.message}");
    } catch (e) {
      print(e);
    }
  }
}
