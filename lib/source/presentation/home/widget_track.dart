import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../source.dart';

class WidgetTrack extends StatefulWidget {
  final List<LocalGenre> headers;
  final Function(int index) onTap;

  final int originIndex;

  WidgetTrack({
    this.headers,
    this.onTap,
    this.originIndex,
  });

  @override
  _WidgetTrackState createState() => _WidgetTrackState();
}

class _WidgetTrackState extends State<WidgetTrack> {
  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository();
  final isLoadingSubject = BehaviorSubject<bool>();
  List<GenreModel> genres = [];

  bool get isLoading => isLoadingSubject.value;

  void setLoading(bool loading) {
    if (loading != isLoading) isLoadingSubject.add(loading);
  }

  @override
  void initState() {
    super.initState();
    initItem();
  }

  initItem() async {
    setLoading(true);
    genres = null;
    genres = await getGenres(id: widget.headers[0].id);
    setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 25,
          width: AppSize.screenWidth,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  widget.onTap(index);
                  setLoading(true);

                  genres = null;
                  genres = await getGenres(id: widget.headers[index].id);
                  setLoading(false);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.headers[index].name,
                      style: AppStyles.DEFAULT_LARGE_BOLD.copyWith(
                        color: widget.originIndex == index
                            ? AppColors.primary
                            : AppColors.grey,
                      ),
                    ),
                    Container(
                      width: 15,
                      height: 3,
                      decoration: BoxDecoration(
                        color: widget.originIndex == index
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => Container(width: 25),
            itemCount: widget.headers?.length ?? 0,
          ),
        ),
        SizedBox(height: 15),
        Container(
          height: 210,
          width: AppSize.screenWidth,
          child: StreamBuilder(
            stream: isLoadingSubject,
            builder: (context, snapshot) {
              var data = genres;
              bool enabled = data == null;

              return enabled
                  ? WidgetShimmer(
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) =>
                            Container(width: 15),
                        itemBuilder: (context, index) =>
                            _buildSearchResult(null),
                        itemCount: 2,
                      ),
                    )
                  : data.length > 0
                      ? ListView.separated(
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) =>
                              Container(width: 15),
                          itemCount: data.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () async {
                              Navigator.pushNamed(
                                context,
                                Routers.album,
                                arguments: data[index],
                              );
                            },
                            child: _buildSearchResult(data[index]),
                          ),
                        )
                      : Center(
                          child: Text(
                            "Không có kết quả",
                            style: AppStyles.DEFAULT_LARGE,
                            textAlign: TextAlign.center,
                          ),
                        );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResult(GenreModel genreModel) {
    return Container(
      width: 175,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          genreModel != null
              ? WidgetImageNetwork(
                  height: 175,
                  circular: 15,
                  url: genreModel.picture,
                  fit: BoxFit.fill,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: 175,
                    height: 175,
                    color: AppColors.grey,
                  ),
                ),
          SizedBox(height: 10),
          Text(
            genreModel?.name ?? "Name",
            style: AppStyles.DEFAULT_REGULAR_BOLD.copyWith(
              color: AppColors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Future<List<GenreModel>> getGenres({int id}) async {
    try {
      Response response =
          await AppClients().get("${AppEndPoint.GET_GENRE}/$id/artists");
      return GenreModel.listFromJson(response.data["data"]);
    } catch (e) {
      return [];
    }
  }
}
