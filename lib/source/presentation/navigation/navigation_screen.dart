import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../source.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  NavigationViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    return BaseWidget(
      viewModel: NavigationViewModel(),
      onViewModelReady: (vm) => _viewModel = vm..init(),
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Expanded(child: _buildBody()),
              _buildBottomBar(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    switch (_viewModel.currentPage) {
      case 0:
        return HomeScreen();

      case 1:
        return LibraryScreen();

      case 2:
        return SearchScreen();

      case 3:
      default:
        return ProfileScreen();
    }
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: Column(
        children: [
          Stack(
            children: [
              StreamBuilder(
                stream: AppShared.watchListenTrackNotification(),
                builder: (context, snapshot) {
                  var data = snapshot.data;
                  bool enabled = data ?? false;

                  if (data != null && data && Data.tracks.length > 0) {
                    _viewModel.listenEventComplete();
                  }

                  return !enabled && data == null
                      ? WidgetShimmer(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 15),
                            child: _buildMusicHelp(null),
                          ),
                        )
                      : data && Data.tracks.length > 0
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 15),
                              child: _buildMusicHelp(Data.getCurrentTrack()),
                            )
                          : Container();
                },
              ),
              StreamBuilder(
                stream: _viewModel.isLoadingSubject,
                builder: (context, snapshot) {
                  var enabled = snapshot.data ?? false;
                  return enabled
                      ? Container(
                          width: AppSize.screenWidth,
                          height: 50,
                          color: Colors.black54,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Đang xử lý ",
                                style: AppStyles.DEFAULT_LARGE.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              WidgetLoading(),
                            ],
                          ),
                        )
                      : Container();
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildButton(
                icon: Feather.home,
                index: 0,
              ),
              _buildButton(
                icon: Feather.book,
                index: 1,
              ),
              _buildButton(
                icon: Feather.search,
                index: 2,
              ),
              _buildButton(
                icon: Feather.user,
                index: 3,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMusicHelp(TrackModel trackModel) {
    return Row(
      children: [
        trackModel != null
            ? WidgetImageNetwork(
                circular: 99,
                height: 50,
                width: 50,
                url: trackModel.albumModel.cover,
                fit: BoxFit.fill,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: Container(
                  height: 50,
                  width: 50,
                  color: AppColors.grey,
                ),
              ),
        SizedBox(width: 5),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              if (trackModel == null) return;
              await Data.audioPlayer.stop();
              await AppShared.setListenTrackNotification(false);

              Navigator.pushNamed(
                context,
                Routers.music,
                arguments: Data.getCurrentTrack(),
              );
            },
            onDoubleTap: () async {
              if (trackModel == null) return;
              await Data.audioPlayer.stop();
              await AppShared.setListenTrackNotification(false);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trackModel?.title ?? "Title",
                  style: AppStyles.DEFAULT_LARGE.copyWith(
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  trackModel?.genreModel?.name ?? "Name",
                  style: AppStyles.DEFAULT_MEDIUM.copyWith(
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        Spacer(),
        IconButton(
          onPressed:
              trackModel != null ? () => _viewModel.getNewTrack(0) : () {},
          icon: Icon(
            Icons.skip_previous_rounded,
            size: 30,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: trackModel != null ? _viewModel.onFavorite : () {},
          icon: Icon(
            (_viewModel?.isLove ?? false)
                ? Icons.favorite
                : Icons.favorite_border,
            size: 30,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            if (trackModel == null) return;
            _viewModel.playingMusic();
          },
          icon: Icon(
            _viewModel.isMusicPlaying ? Icons.pause : Icons.play_arrow_sharp,
            size: 30,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed:
              trackModel != null ? () => _viewModel.getNewTrack(0) : () {},
          icon: Icon(
            Icons.skip_next_rounded,
            size: 30,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildButton({IconData icon, int index}) {
    return GestureDetector(
      onTap: () => _viewModel.setCurrentPage(index),
      child: Icon(
        icon,
        size: 35,
        color: _viewModel.currentPage == index
            ? AppColors.primary
            : AppColors.grey,
      ),
    );
  }
}
