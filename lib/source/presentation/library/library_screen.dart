import 'package:flutter/material.dart';

import '../../source.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  LibraryViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      viewModel: LibraryViewModel(),
      onViewModelReady: (vm) => _viewModel = vm..init(),
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              WidgetAppBar(
                title: "Thư viện của tôi",
                isBack: false,
                padding: EdgeInsets.only(left: 15),
                alignmentTitle: Alignment.centerLeft,
                colorAppBar: Colors.transparent,
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
      padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(height: 15),
          _viewModel.headerIndex == 0
              ? _buildDownloadedTrack()
              : Data.userModel != null
                  ? _viewModel.headerIndex == 1
                      ? _buildLikeTrack()
                      : _viewModel.headerIndex == 2
                          ? _buildLikeArtist()
                          : _buildLikeGenre()
                  : Text(
                      "Bạn chưa đăng nhập để sử dụng chức năng này",
                      style: AppStyles.DEFAULT_LARGE.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
        ],
      ),
    );
  }

  Widget _buildLikeTrack() {
    return Data.userModel.like_tracks.length > 0
        ? Wrap(
            runSpacing: 15,
            children: List.generate(
              Data.userModel.like_tracks.length,
              (index) {
                var track = Data.userModel.like_tracks[index];
                return GestureDetector(
                  onTap: () async {
                    await Data.audioPlayer.stop();
                    await AppShared.setListenTrackNotification(false);

                    Data.addNewTracks(Data.userModel.like_tracks);
                    Data.setCurrentTrack(index);

                    Navigator.pushNamed(
                      context,
                      Routers.music,
                      arguments: track,
                    );
                  },
                  child: Container(
                    width: AppSize.screenWidth,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${index + 1}  ${track.title}",
                            style: AppStyles.DEFAULT_LARGE_BOLD.copyWith(
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Spacer(),
                        Text(
                          AppHelper.convertDurationToTime(track.duration),
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
                  ),
                );
              },
            ),
          )
        : Text(
            "Bạn chưa có thích bài hát nào",
            style: AppStyles.DEFAULT_LARGE.copyWith(
              color: Colors.white,
            ),
          );
  }

  Widget _buildDownloadedTrack() {
    return Data.trackDownloads.length > 0
        ? Wrap(
            runSpacing: 15,
            children: List.generate(
              Data.trackDownloads.length,
              (index) {
                var track = Data.trackDownloads[index];
                return GestureDetector(
                  onTap: () async {
                    await Data.audioPlayer.stop();
                    await AppShared.setListenTrackNotification(false);

                    Data.addNewTracks(Data.trackDownloads);
                    Data.setCurrentTrack(index);

                    Navigator.pushNamed(
                      context,
                      Routers.music,
                      arguments: track,
                    );
                  },
                  child: Container(
                    width: AppSize.screenWidth,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${index + 1}  ${track.title}",
                            style: AppStyles.DEFAULT_LARGE_BOLD.copyWith(
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Spacer(),
                        Text(
                          AppHelper.convertDurationToTime(track.duration),
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
                  ),
                );
              },
            ),
          )
        : Text(
            "Bạn chưa có tải bài hát nào",
            style: AppStyles.DEFAULT_LARGE.copyWith(
              color: Colors.white,
            ),
          );
  }

  Widget _buildLikeArtist() {
    return Data.userModel.like_genres.length > 0
        ? Wrap(
            runSpacing: 15,
            children: List.generate(
              Data.userModel.like_genres.length,
              (index) {
                var genre = Data.userModel.like_genres[index];
                return GestureDetector(
                  onTap: () async {
                    await Data.audioPlayer.stop();
                    await AppShared.setListenTrackNotification(false);
                    Navigator.pushNamed(
                      context,
                      Routers.album,
                      arguments: genre,
                    );
                  },
                  child: Container(
                    width: AppSize.screenWidth,
                    child: Row(
                      children: [
                        WidgetImageNetwork(
                          url: genre.picture,
                          fit: BoxFit.fill,
                          circular: 10,
                          width: 100,
                          height: 100,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "${genre.name}",
                          style: AppStyles.DEFAULT_LARGE_BOLD.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : Text(
            "Bạn chưa có thích nghệ sĩ nào",
            style: AppStyles.DEFAULT_LARGE.copyWith(
              color: Colors.white,
            ),
          );
  }

  Widget _buildLikeGenre() {
    return Data.userModel.like_genres.length > 0
        ? Wrap(
            runSpacing: 15,
            children: List.generate(
              Data.userModel.like_genres.length,
              (index) {
                var genre = Data.userModel.like_genres[index];
                return Container(
                  width: AppSize.screenWidth,
                  child: Row(
                    children: [
                      WidgetImageNetwork(
                        url: genre.picture,
                        fit: BoxFit.fill,
                        circular: 10,
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(width: 10),
                      Text(
                        genre.type,
                        style: AppStyles.DEFAULT_LARGE.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        : Text(
            "Bạn chưa có thích chủ đề nào",
            style: AppStyles.DEFAULT_LARGE.copyWith(
              color: Colors.white,
            ),
          );
  }

  Widget _buildHeader() {
    return Container(
      height: 25,
      width: AppSize.screenWidth,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _viewModel.setHeaderSelected(index),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _viewModel.headers[index],
                  style: AppStyles.DEFAULT_LARGE_BOLD.copyWith(
                    color: _viewModel.headerIndex == index
                        ? AppColors.primary
                        : AppColors.grey,
                  ),
                ),
                Container(
                  width: 15,
                  height: 3,
                  decoration: BoxDecoration(
                    color: _viewModel.headerIndex == index
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
        itemCount: _viewModel.headers.length,
      ),
    );
  }
}
