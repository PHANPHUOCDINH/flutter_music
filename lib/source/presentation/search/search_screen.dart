import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../source.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      viewModel: SearchViewModel(),
      onViewModelReady: (vm) => _viewModel = vm..init(),
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              WidgetAppBar(
                isBack: false,
                title: "Tìm kiếm",
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
          WidgetTextFormField(
            hintText: "Tìm kiếm",
            hintStyle: AppStyles.DEFAULT_LARGE.copyWith(
              color: AppColors.grey,
            ),
            onSubmitted: _viewModel.controlSearching,
            controller: _viewModel.searchController,
            colorBorder: Colors.white,
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
                                _buildSearchType(
                                  name: "Chủ đề",
                                  index: 2,
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
                                        onTap: () async {
                                          await Data.audioPlayer.stop();
                                          await AppShared.setListenTrackNotification(false);

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
                                    : _viewModel.searchIndex == 1
                                        ? _buildArtist(data[index])
                                        : _buildChude(data[index]),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                            "Không có kết quả",
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

  Widget _buildArtist(TrackModel trackModel) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        Routers.album,
        arguments: trackModel.genreModel,
      ),
      child: Row(
        children: [
          WidgetImageNetwork(
            height: 75,
            width: 75,
            circular: 5,
            url: trackModel.genreModel.picture,
            fit: BoxFit.fill,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trackModel.genreModel.name,
                  style: AppStyles.DEFAULT_LARGE.copyWith(
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  trackModel.title,
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
    );
  }

  Widget _buildChude(TrackModel trackModel) {
    return Row(
      children: [
        WidgetImageNetwork(
          height: 75,
          width: 75,
          circular: 5,
          url: trackModel.albumModel.cover,
          fit: BoxFit.fill,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trackModel.type,
                style: AppStyles.DEFAULT_LARGE.copyWith(
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5),
              Text(
                trackModel.albumModel.title,
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
