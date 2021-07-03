import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify_clone/source/source.dart';

class Data {
  static AudioPlayer audioPlayer = AudioPlayer();
  static List<TrackModel> tracks = [];
  static List<TrackModel> trackDownloads = [];

  static WeatherModel weatherVi;
  static WeatherModel weatherEn;

  static UserModel userModel;
  static Position location;

  static String city;
  static bool isSentNotification = false;
  static bool isLove = false;
  static int currentTrack = 0;

  static void addNewTracks(List<TrackModel> track) {
    tracks.clear();
    tracks.addAll(track);
    currentTrack = 0;
  }

  static TrackModel skipToNext() {
    if (currentTrack + 1 >= tracks.length) return tracks.last;
    currentTrack = currentTrack + 1;
    return tracks[currentTrack];
  }

  static TrackModel shuffleTrack() {
    currentTrack = Random.secure().nextInt(tracks.length - 1);
    return tracks[currentTrack];
  }

  static TrackModel skipToPrev() {
    if (currentTrack - 1 < 0) return tracks.first;
    currentTrack = currentTrack - 1;
    return tracks[currentTrack];
  }

  static void setCurrentTrack(int index) {
    currentTrack = index;
  }

  static TrackModel getCurrentTrack() {
    return tracks[currentTrack];
  }

  static int getCurrentIndexTrack() {
    return tracks.indexOf(Data.getCurrentTrack());
  }

  static void audioListenEventOnCompleteMusic({
    Function onComplete,
  }) {
    audioPlayer.playerStateStream.listen(
      (event) {
        if (event.processingState == ProcessingState.completed) {
          onComplete?.call();
        }
      },
    );
  }

  static bool checkIsLoveTrack(TrackModel trackModel) {
    if (userModel == null) return false;
    for (var x in userModel.like_tracks) {
      if (x.title == trackModel.title) return true;
    }
  }
}
