import 'package:spotify_clone/source/model/album_model.dart';
import 'package:spotify_clone/source/source.dart';

class TrackModel {
  TrackModel({
    this.id,
    this.readable,
    this.title,
    this.titleShort,
    this.titleVersion,
    this.link,
    this.duration,
    this.rank,
    this.explicitLyrics,
    this.explicitContentLyrics,
    this.explicitContentCover,
    this.preview,
    this.md5Image,
    this.genreModel,
    this.albumModel,
    this.type,
  });

  int id;
  bool readable;
  String title;
  String titleShort;
  TitleVersion titleVersion;
  String link;
  int duration;
  int rank;
  bool explicitLyrics;
  int explicitContentLyrics;
  int explicitContentCover;
  String preview;
  String md5Image;
  GenreModel genreModel;
  AlbumModel albumModel;
  String type;

  factory TrackModel.fromJson(Map<String, dynamic> json) => TrackModel(
        id: json["id"],
        readable: json["readable"],
        title: json["title"],
        titleShort: json["title_short"],
        titleVersion: titleVersionValues.map[json["title_version"]],
        link: json["link"],
        duration: json["duration"],
        rank: json["rank"],
        explicitLyrics: json["explicit_lyrics"],
        explicitContentLyrics: json["explicit_content_lyrics"],
        explicitContentCover: json["explicit_content_cover"],
        preview: json["preview"],
        md5Image: json["md5_image"],
        genreModel: GenreModel.fromJson(json["artist"]),
        albumModel:
            json["album"] != null ? AlbumModel.fromJson(json["album"]) : null,
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "readable": readable,
        "title": title,
        "title_short": titleShort,
        "title_version": titleVersionValues.reverse[titleVersion],
        "link": link,
        "duration": duration,
        "rank": rank,
        "explicit_lyrics": explicitLyrics,
        "explicit_content_lyrics": explicitContentLyrics,
        "explicit_content_cover": explicitContentCover,
        "preview": preview,
        "md5_image": md5Image,
        "artist": genreModel.toJson(),
        "album": albumModel != null ? albumModel.toJson() : null,
        "type": type,
      };

  static List<TrackModel> listFromJson(dynamic json) => json != null
      ? List<TrackModel>.from(
          json.map((x) => TrackModel.fromJson(x)),
        )
      : [];
}

enum AlbumType { ALBUM }

final albumTypeValues = EnumValues({"album": AlbumType.ALBUM});

enum TitleVersion {
  EMPTY,
  FROM_8_MILE_SOUNDTRACK,
  MUSIC_FROM_THE_MOTION_PICTURE,
  SOUNDTRACK_VERSION
}

final titleVersionValues = EnumValues({
  "": TitleVersion.EMPTY,
  "(From \"8 Mile\" Soundtrack)": TitleVersion.FROM_8_MILE_SOUNDTRACK,
  "(Music From The Motion Picture)": TitleVersion.MUSIC_FROM_THE_MOTION_PICTURE,
  "(Soundtrack Version)": TitleVersion.SOUNDTRACK_VERSION
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
