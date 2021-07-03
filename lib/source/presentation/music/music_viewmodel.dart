import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';

import '../../source.dart';

class MusicViewModel extends BaseViewModel {
  Dio dio = Dio();

  RandomAccessFile raf;
  TrackModel trackModel;

  String percentDownload = "0%";

  bool isMusicPlaying = true;
  bool isLooping = false;
  bool isShuffle = false;
  bool isMusicCompleted = false;
  bool isDownloading = false;
  bool isDownloaded = false;
  bool isLove = false;

  init(TrackModel trackModel) async {
    setLoading(true);
    this.trackModel = trackModel;
    isLove = Data.checkIsLoveTrack(trackModel);
    checkIsDownloaded();

    Data.audioListenEventOnCompleteMusic(
      onComplete: () {
        isMusicPlaying = false;
        isMusicCompleted = true;

        if (isShuffle) {
          getNewTrack(2);
        } else {
          notifyListeners();
        }
      },
    );

    await Data.audioPlayer.setUrl(trackModel.preview);
    await Future.delayed(Duration(milliseconds: 750));

    Data.audioPlayer.play();
    setLoading(false);
  }

  comeBack() async {
    Data.setCurrentTrack(Data.getCurrentIndexTrack());
    await Data.audioPlayer.stop();
    await AppShared.setListenTrackNotification(true);

    var track = Data.getCurrentTrack();
    await Data.audioPlayer.setUrl(track.preview);

    Data.audioPlayer.play();
    Navigator.pop(context);
  }

  checkIsDownloaded() {
    if (Data.trackDownloads == null) return;
    for (var x in Data.trackDownloads) {
      if (x.title == trackModel.title) {
        isDownloaded = true;
        break;
      }
    }
  }

  playingMusic() {
    if (isMusicCompleted) return;
    isMusicPlaying = !isMusicPlaying;

    if (isMusicPlaying) {
      Data.audioPlayer.play();
    } else {
      Data.audioPlayer.pause();
    }

    notifyListeners();
  }

  looping() async {
    if (isMusicCompleted) return;
    isLooping = !isLooping;

    await Data.audioPlayer.setLoopMode(isLooping ? LoopMode.one : LoopMode.off);
    notifyListeners();
  }

  seek(double position) async {
    if (Data.audioPlayer.duration == null) return;
    var total =
        (Data.audioPlayer.duration.inMinutes * 60 + Data.audioPlayer.duration.inSeconds) * position;
    var minute = total ~/ 60;
    await Data.audioPlayer.seek(
      Duration(
        minutes: minute,
        seconds: total.toInt() - minute * 60,
      ),
    );

    isMusicPlaying = true;
    isMusicCompleted = false;
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

      case 2:
        trackModel = Data.shuffleTrack();
        isShuffle = !isShuffle;

        Toast.show(
          "Bạn đã ${isShuffle ? "bật" : "tắt"} ngẫu nhiên bài hát",
          context,
          duration: 2,
          backgroundColor: Colors.white70,
          textColor: Colors.black,
        );
        break;
    }

    await Data.audioPlayer.stop();
    await Data.audioPlayer.setUrl(trackModel.preview);
    Data.audioPlayer.play();

    isMusicPlaying = true;
    isDownloaded = false;
    isMusicCompleted = false;

    isLove = Data.checkIsLoveTrack(trackModel);
    checkIsDownloaded();
    notifyListeners();
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
        Data.userModel.like_tracks.add(trackModel);
        await AppFirebase.userCollection
            .doc("userID-${Data.userModel.id}")
            .update(Data.userModel.toJson());

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

  void onDownloadMusic() async {
    downloadMusic(url: trackModel.preview);
  }

  Future downloadMusic({String url}) async {
    try {
      setLoading(true);
      isDownloading = true;

      var dir = await getApplicationDocumentsDirectory();
      await dio.download(
        url,
        "${dir.path}/demo.mp4",
        onReceiveProgress: (rec, total) {
          percentDownload = "${((rec / total) * 100).toStringAsFixed(0)}%";
          notifyListeners();
        },
      );

      Data.trackDownloads.add(trackModel);
      await AppShared.setTracks(jsonEncode(Data.trackDownloads));
      setLoading(false);

      isDownloading = false;
      isDownloaded = true;

      Toast.show(
        "Download complete",
        context,
        duration: 2,
        backgroundColor: Colors.white70,
        textColor: Colors.black,
      );
      notifyListeners();
    } catch (e) {
      Toast.show(
        "Lỗi download",
        context,
        duration: 2,
        backgroundColor: Colors.white70,
        textColor: Colors.black,
      );
      isDownloading = false;
      setLoading(false);
    }
  }

  Future<void> stopDownloadMusic() async {
    dio.close(force: true);
    await raf.close();
  }

  void showDownloadProgress(received, total) {
    if (total != -1) percentDownload = received / total * 100;
  }
}
