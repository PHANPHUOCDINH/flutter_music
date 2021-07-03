import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../source.dart';

class MusicScreen extends StatefulWidget {
  final TrackModel trackModel;

  MusicScreen({this.trackModel});

  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  MusicViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      viewModel: MusicViewModel(),
      onViewModelReady: (vm) => _viewModel = vm..init(widget.trackModel),
      builder: (context, vm, child) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Column(
                  children: [
                    WidgetAppBar(
                      title: "",
                      colorButton: Colors.white,
                      colorAppBar: Colors.transparent,
                      actionBack: () async => await _viewModel.comeBack(),
                    ),
                    Expanded(child: _buildBody()),
                  ],
                ),
                StreamBuilder(
                  stream: _viewModel.isLoadingSubject,
                  builder: (context, snapshot) {
                    bool enabled = snapshot.data ?? false;
                    return enabled
                        ? Container(
                            width: AppSize.screenWidth,
                            height: AppSize.screenHeight,
                            color: Colors.black45,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _viewModel.isDownloading
                                      ? "Downloading ${_viewModel.percentDownload} "
                                      : "Loading ",
                                  style: AppStyles.DEFAULT_LARGE.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                WidgetLoading(size: 5),
                              ],
                            ),
                          )
                        : Container();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PhysicalModel(
            borderRadius: BorderRadius.circular(15),
            elevation: 25,
            shadowColor: Colors.yellowAccent,
            color: Colors.yellowAccent,
            child: WidgetImageNetwork(
              circular: 15,
              width: AppSize.screenWidth / 1.25,
              height: AppSize.screenWidth / 1.25,
              url: _viewModel.trackModel.albumModel.cover,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(height: 25),
          Container(
            width: AppSize.screenWidth,
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _viewModel.onFavorite(),
                  icon: Icon(
                    !(_viewModel?.isLove ?? false) ? Icons.favorite_border : Icons.favorite,
                  ),
                  iconSize: 35,
                  color: Colors.white,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async => await _viewModel.comeBack(),
                    child: Column(
                      children: [
                        Expanded(
                          child: Text(
                            _viewModel.trackModel.title,
                            style: AppStyles.DEFAULT_2XLARGE_BOLD.copyWith(
                              color: AppColors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 5),
                        Expanded(
                          child: Text(
                            _viewModel.trackModel.genreModel.name,
                            style: AppStyles.DEFAULT_LARGE.copyWith(
                              color: AppColors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_viewModel.isDownloaded) return;
                    _viewModel.onDownloadMusic();
                  },
                  icon: Icon(
                    !_viewModel.isDownloaded
                        ? Icons.cloud_download_outlined
                        : Icons.cloud_done_outlined,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: Data.audioPlayer.positionStream,
            builder: (context, snapshot) {
              var duration = snapshot.data;
              bool enabled = duration == null;

              return Column(
                children: [
                  Slider(
                    value: enabled ? 0 : AppHelper.convertDurationToNumber(duration),
                    onChanged: (value) => _viewModel.seek(value),
                    activeColor: AppColors.primary,
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          enabled ? "00:00" : "${duration.inMinutes}:${duration.inSeconds}",
                          style: AppStyles.DEFAULT_LARGE.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                        Text(
                          !_viewModel.isLooping ? "Không lặp lại" : "Lặp lại",
                          style: AppStyles.DEFAULT_LARGE.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          Data.audioPlayer.duration == null
                              ? "00:00"
                              : AppHelper.convertDurationToTime2(Data.audioPlayer.duration),
                          style: AppStyles.DEFAULT_LARGE.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMusicButton(
                iconData: Icons.repeat,
                onPressed: () => _viewModel.getNewTrack(2),
              ),
              _buildMusicButton(
                iconData: Icons.skip_previous,
                onPressed: () => _viewModel.getNewTrack(1),
              ),
              GestureDetector(
                onTap: () => _viewModel.playingMusic(),
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    _viewModel.isMusicPlaying ? Icons.pause : Icons.play_arrow_sharp,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              _buildMusicButton(
                iconData: Icons.skip_next,
                onPressed: () => _viewModel.getNewTrack(0),
              ),
              _buildMusicButton(
                iconData: Icons.loop,
                onPressed: () => _viewModel.looping(),
              ),
            ],
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.live_tv,
                size: 25,
                color: AppColors.primary,
              ),
              Text(
                "  Chromecast is ready",
                style: AppStyles.DEFAULT_LARGE.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMusicButton({
    IconData iconData,
    Function onPressed,
  }) {
    return IconButton(
      icon: Icon(iconData),
      onPressed: onPressed,
      iconSize: 30,
      color: Colors.white,
    );
  }
}
