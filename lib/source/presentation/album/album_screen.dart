import 'package:flutter/material.dart';

import '../../source.dart';

class AlbumScreen extends StatefulWidget {
  final GenreModel genreModel;

  AlbumScreen({this.genreModel});

  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  AlbumViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      viewModel: AlbumViewModel(),
      onViewModelReady: (vm) => _viewModel = vm..init(widget.genreModel),
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: _viewModel.getTrackList(
          apiTrackList: widget.genreModel.tracklist,
        ),
        builder: (context, snapshot) {
          var data = snapshot.data;
          bool enabled = data != null;
          return Column(
            children: [
              Stack(
                children: [
                  WidgetImageNetwork(
                    height: AppSize.screenWidth / 1.5,
                    width: AppSize.screenWidth,
                    url: widget.genreModel.picture,
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    top: 5,
                    left: 5,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 20),
                child: Column(
                  children: [
                    Container(
                      width: AppSize.screenWidth,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.genreModel.name,
                            style: AppStyles.DEFAULT_LARGE_BOLD.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                _viewModel.addNewGenre(widget.genreModel),
                            icon: Icon(
                              !_viewModel.isLove
                                  ? Icons.favorite_border
                                  : Icons.favorite,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    !enabled
                        ? WidgetShimmer(
                            child: _buildBodyResult(null),
                          )
                        : _buildBodyResult(data),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBodyResult(List<TrackModel> trackModels) {
    if (trackModels != null) {
      Data.addNewTracks(trackModels);
    }

    return Column(
      children: [
        Container(
          width: AppSize.screenWidth,
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                width: 175,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    trackModels != null
                        ? WidgetImageNetwork(
                            height: 175,
                            circular: 15,
                            url: trackModels[index].albumModel.cover,
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
                    Expanded(
                      child: Text(
                        trackModels != null
                            ? trackModels[index].albumModel.title
                            : "Title",
                        style: AppStyles.DEFAULT_REGULAR_BOLD.copyWith(
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => Container(width: 15),
            itemCount: trackModels?.length ?? 5,
          ),
        ),
        SizedBox(height: 25),
        Wrap(
          runSpacing: 20,
          children: List.generate(
            trackModels?.length ?? 5,
            (index) => GestureDetector(
              onTap: () async {
                if (trackModels == null) return;
                await Data.audioPlayer.stop();
                await AppShared.setListenTrackNotification(false);

                Data.setCurrentTrack(index);
                Navigator.pushNamed(
                  context,
                  Routers.music,
                  arguments: trackModels[index],
                );
              },
              child: Container(
                width: AppSize.screenWidth,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${index + 1}  ${trackModels != null ? trackModels[index].title : "Title"}",
                        style: AppStyles.DEFAULT_LARGE_BOLD.copyWith(
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Spacer(),
                    Text(
                      trackModels != null
                          ? AppHelper.convertDurationToTime(
                              trackModels[index].duration)
                          : "00:00",
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
            ),
          ),
        ),
      ],
    );
  }
}
