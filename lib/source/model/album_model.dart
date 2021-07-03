import '../source.dart';

class AlbumModel {
  AlbumModel({
    this.id,
    this.title,
    this.upc,
    this.link,
    this.share,
    this.cover,
    this.coverSmall,
    this.coverMedium,
    this.coverBig,
    this.coverXl,
    this.md5Image,
    this.genreId,
    this.genres,
    this.label,
    this.nbTracks,
    this.duration,
    this.fans,
    this.rating,
    this.releaseDate,
    this.recordType,
    this.available,
    this.tracklist,
    this.explicitLyrics,
    this.explicitContentLyrics,
    this.explicitContentCover,
    this.contributors,
    this.genreModel,
    this.type,
    this.trackModels,
  });

  int id;
  String title;
  String upc;
  String link;
  String share;
  String cover;
  String coverSmall;
  String coverMedium;
  String coverBig;
  String coverXl;
  Md5Image md5Image;
  int genreId;
  Genres genres;
  Label label;
  int nbTracks;
  int duration;
  int fans;
  int rating;
  DateTime releaseDate;
  String recordType;
  bool available;
  String tracklist;
  bool explicitLyrics;
  int explicitContentLyrics;
  int explicitContentCover;
  List<Contributor> contributors;
  GenreModel genreModel;
  String type;
  List<TrackModel> trackModels;

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      id: json["id"],
      title: json["title"],
      upc: json["upc"],
      link: json["link"],
      share: json["share"],
      cover: json["cover"],
      coverSmall: json["cover_small"],
      coverMedium: json["cover_medium"],
      coverBig: json["cover_big"],
      coverXl: json["cover_xl"],
      md5Image: md5ImageValues.map[json["md5_image"]],
      genreId: json["genre_id"],
      label: labelValues.map[json["label"]],
      nbTracks: json["nb_tracks"],
      duration: json["duration"],
      fans: json["fans"],
      rating: json["rating"],
      recordType: json["record_type"],
      available: json["available"],
      tracklist: json["tracklist"],
      explicitLyrics: json["explicit_lyrics"],
      explicitContentLyrics: json["explicit_content_lyrics"],
      explicitContentCover: json["explicit_content_cover"],
      genreModel: json["artist"] != null ? GenreModel.fromJson(json["artist"]) : null,
      type: json["type"],
      trackModels: json["tracks"] != null
          ? TrackModel.listFromJson(json["tracks"]["data"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "upc": upc,
        "link": link,
        "share": share,
        "cover": cover,
        "cover_small": coverSmall,
        "cover_medium": coverMedium,
        "cover_big": coverBig,
        "cover_xl": coverXl,
        "md5_image": md5ImageValues.reverse[md5Image],
        "genre_id": genreId,
        "genres": genres != null ? genres.toJson() : null,
        "label": labelValues.reverse[label],
        "nb_tracks": nbTracks,
        "duration": duration,
        "fans": fans,
        "rating": rating,
        "release_date": releaseDate != null
            ? "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}"
            : "",
        "record_type": recordType,
        "available": available,
        "tracklist": tracklist,
        "explicit_lyrics": explicitLyrics,
        "explicit_content_lyrics": explicitContentLyrics,
        "explicit_content_cover": explicitContentCover,
        "contributors": contributors != null
            ? List<dynamic>.from(contributors.map((x) => x.toJson()))
            : null,
        "artist": genreModel != null ? genreModel.toJson() : null,
        "type": type,
      };
}

enum Label { DANCE, THE_50_WEDDINGS }

final labelValues = EnumValues({
  "Dance": Label.DANCE,
  "50 Weddings": Label.THE_50_WEDDINGS,
});

enum ArtistType { GENRE, ARTIST }

final artistTypeValues = EnumValues({
  "artist": ArtistType.ARTIST,
  "genre": ArtistType.GENRE,
});

class Contributor {
  Contributor({
    this.id,
    this.name,
    this.link,
    this.share,
    this.picture,
    this.pictureSmall,
    this.pictureMedium,
    this.pictureBig,
    this.pictureXl,
    this.radio,
    this.tracklist,
    this.type,
    this.role,
  });

  int id;
  Label name;
  String link;
  String share;
  String picture;
  String pictureSmall;
  String pictureMedium;
  String pictureBig;
  String pictureXl;
  bool radio;
  String tracklist;
  ArtistType type;
  String role;

  factory Contributor.fromJson(Map<String, dynamic> json) => Contributor(
        id: json["id"],
        name: labelValues.map[json["name"]],
        link: json["link"],
        share: json["share"],
        picture: json["picture"],
        pictureSmall: json["picture_small"],
        pictureMedium: json["picture_medium"],
        pictureBig: json["picture_big"],
        pictureXl: json["picture_xl"],
        radio: json["radio"],
        tracklist: json["tracklist"],
        type: artistTypeValues.map[json["type"]],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": labelValues.reverse[name],
        "link": link,
        "share": share,
        "picture": picture,
        "picture_small": pictureSmall,
        "picture_medium": pictureMedium,
        "picture_big": pictureBig,
        "picture_xl": pictureXl,
        "radio": radio,
        "tracklist": tracklist,
        "type": artistTypeValues.reverse[type],
        "role": role,
      };
}

class Genres {
  Genres({
    this.data,
  });

  List<ArtistElement> data;

  factory Genres.fromJson(Map<String, dynamic> json) => Genres(
        data: List<ArtistElement>.from(
            json["data"].map((x) => ArtistElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ArtistElement {
  ArtistElement({
    this.id,
    this.name,
    this.picture,
    this.type,
    this.tracklist,
  });

  int id;
  Label name;
  String picture;
  ArtistType type;
  String tracklist;

  factory ArtistElement.fromJson(Map<String, dynamic> json) => ArtistElement(
        id: json["id"],
        name: labelValues.map[json["name"]],
        picture: json["picture"] == null ? null : json["picture"],
        type: artistTypeValues.map[json["type"]],
        tracklist: json["tracklist"] == null ? null : json["tracklist"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": labelValues.reverse[name],
        "picture": picture == null ? null : picture,
        "type": artistTypeValues.reverse[type],
        "tracklist": tracklist == null ? null : tracklist,
      };
}

enum Md5Image { DA7_FB853_CAFC5858_CB90_D446_B60_A0460 }

final md5ImageValues = EnumValues({
  "da7fb853cafc5858cb90d446b60a0460":
      Md5Image.DA7_FB853_CAFC5858_CB90_D446_B60_A0460
});

enum PurpleType { TRACK }

final purpleTypeValues = EnumValues({"track": PurpleType.TRACK});
