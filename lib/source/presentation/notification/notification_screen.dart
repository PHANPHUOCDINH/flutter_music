import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../source.dart';

class NotificationScreen extends StatefulWidget {
  final String keyword;

  NotificationScreen({this.keyword});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      viewModel: NotificationViewModel(),
      onViewModelReady: (vm) => _viewModel = vm..init(widget.keyword),
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              WidgetAppBar(
                colorButton: Colors.white,
                title: "Thông báo",
                colorAppBar: Colors.transparent,
                actions: [
                  IconButton(
                    onPressed: _viewModel.listenMusicRandom,
                    icon: Icon(
                      Icons.repeat,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Expanded(child: _buildBody()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            (Data.city ?? "Error").toUpperCase(),
            style: AppStyles.DEFAULT_5XLARGE.copyWith(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                color: Colors.white,
                size: 15,
              ),
              SizedBox(width: 5),
              Text(
                "${Data.location.latitude.toStringAsFixed(2) ?? "Error"}, ${Data.location.longitude.toStringAsFixed(2) ?? "Error"}",
                style: AppStyles.DEFAULT_LARGE.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${(Data.weatherVi.main.temp - 273.15).toInt()}\u2070C",
                style: AppStyles.DEFAULT_2XLARGE.copyWith(
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10),
              Image.asset(
                "assets/icons/mua.png",
                fit: BoxFit.fill,
                width: 35,
                height: 30,
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            Data.weatherVi.weather[0].description.toUpperCase(),
            style: AppStyles.DEFAULT_5XLARGE.copyWith(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15),
          StreamBuilder(
            stream: _viewModel.isLoadingSubject,
            builder: (context, snapshot) {
              var data = _viewModel.searchResult;
              bool enabled = data == null;
              return enabled
                  ? WidgetShimmer(
                      child: Wrap(
                        runSpacing: 15,
                        children: List.generate(
                          5,
                          (index) => _buildSearchResult(
                            trackModel: null,
                            index: index,
                          ),
                        ),
                      ),
                    )
                  : data.length > 0
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildSearchType(
                                  name: "Bài hát",
                                  index: 0,
                                ),
                                _buildSearchType(
                                  name: "Nghệ sĩ",
                                  index: 1,
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Wrap(
                              runSpacing: 15,
                              children: List.generate(
                                data.length,
                                (index) => _viewModel.searchIndex == 0
                                    ? GestureDetector(
                                        onTap: () {
                                          Data.addNewTracks(_viewModel.searchResult);
                                          Data.setCurrentTrack(index);

                                          Navigator.pushNamed(
                                            context,
                                            Routers.music,
                                            arguments: data[index],
                                          );
                                        },
                                        child: _buildSearchResult(
                                          trackModel: data[index],
                                          index: index,
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () => Navigator.pushNamed(
                                          context,
                                          Routers.album,
                                          arguments: data[index].genreModel,
                                        ),
                                        child: Row(
                                          children: [
                                            WidgetImageNetwork(
                                              height: 75,
                                              circular: 15,
                                              width: 75,
                                              url: data[index].genreModel.picture,
                                              fit: BoxFit.fill,
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data[index].genreModel.name,
                                                    style: AppStyles.DEFAULT_LARGE.copyWith(
                                                      color: Colors.white,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    data[index].title,
                                                    style: AppStyles.DEFAULT_LARGE.copyWith(
                                                      color: AppColors.grey,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                            "Không có dữ liệu",
                            style: AppStyles.DEFAULT_LARGE.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchType({
    String name,
    int index,
  }) {
    return GestureDetector(
      onTap: () => _viewModel.setSearchSelected(index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: AppStyles.DEFAULT_LARGE_BOLD.copyWith(
              color: _viewModel.searchIndex == index ? AppColors.primary : AppColors.grey,
            ),
          ),
          Container(
            width: 15,
            height: 3,
            decoration: BoxDecoration(
              color: _viewModel.searchIndex == index ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResult({
    TrackModel trackModel,
    int index,
  }) {
    return Container(
      width: AppSize.screenWidth,
      child: Row(
        children: [
          Expanded(
            child: Text(
              "${index + 1}  ${trackModel != null ? trackModel.title : "Title"}",
              style: AppStyles.DEFAULT_LARGE_BOLD.copyWith(
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Spacer(),
          Text(
            trackModel != null ? AppHelper.convertDurationToTime(trackModel.duration) : "00:00",
            style: AppStyles.DEFAULT_LARGE_BOLD.copyWith(
              color: AppColors.grey,
            ),
          ),
          SizedBox(width: 5),
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: AppColors.grey,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.play_arrow_sharp,
              size: 20,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
