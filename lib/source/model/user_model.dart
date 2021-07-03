import '../source.dart';

class UserModel {
  String name;
  String email;
  String user_avatar;
  String id;
  String sdt;
  String genre;
  String chude;

  List<TrackModel> like_tracks = [];
  List<GenreModel> like_genres = [];

  UserModel({
    this.name,
    this.id,
    this.email,
    this.sdt,
    this.genre,
    this.chude,
    this.user_avatar,
    this.like_tracks,
    this.like_genres,
  });

  setAvatar(String url) {
    user_avatar = url;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        sdt: json["sdt"],
        genre: json["genre"],
        chude: json["chude"],
        user_avatar: json["user_avatar"],
        like_tracks: TrackModel.listFromJson(json["like_tracks"]),
        like_genres: GenreModel.listFromJson(json["like_genres"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "genre": genre,
        "sdt": sdt,
        "chude": chude,
        "user_avatar": user_avatar,
        "like_tracks": List<dynamic>.from(
          like_tracks.map((x) => x.toJson()),
        ),
        "like_genres": List<dynamic>.from(
          like_genres.map((x) => x.toJson()),
        ),
      };
}
