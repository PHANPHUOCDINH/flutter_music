import 'package:flutter/material.dart';
import 'package:spotify_clone/source/presentation/home/widget_track.dart';

import '../../source.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      viewModel: HomeViewModel(),
      onViewModelReady: (vm) => _viewModel = vm..init(),
      builder: (context, vm, child) {
        var temp = Data.weatherVi?.main;
        var weather = Data.weatherVi?.weather?.length ?? 0;

        return Scaffold(
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                WidgetAppBar(
                  title: "Khám phá",
                  alignmentTitle: Alignment.centerLeft,
                  colorAppBar: Colors.transparent,
                  isBack: false,
                  actions: [
                    GestureDetector(
                      onTap: () {
                        if (Data.weatherVi != null && Data.weatherEn != null) {
                          Navigator.pushNamed(
                            context,
                            Routers.notification,
                            arguments: Data.weatherEn.weather[0].description,
                          );
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${Data.city ?? "Error"}",
                            style: AppStyles.DEFAULT_REGULAR_BOLD.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "${weather > 0 ? Data.weatherVi.weather[0].description : "Error"}, ${temp != null ? (temp.temp - 273.15).toInt() : 0}\u2070C",
                            style: AppStyles.DEFAULT_REGULAR_BOLD.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _buildBody(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        WidgetTrack(
          onTap: _viewModel.setHeader1Selected,
          headers: _viewModel.song_type_1,
          originIndex: _viewModel.header1,
        ),
        SizedBox(height: 15),
        WidgetTrack(
          onTap: _viewModel.setHeader2Selected,
          headers: _viewModel.song_type_2,
          originIndex: _viewModel.header2,
        ),
        SizedBox(height: 15),
        Text(
          "CHỦ ĐỀ",
          style: AppStyles.DEFAULT_5XLARGE_BOLD.copyWith(
            color: Colors.white,
          ),
        ),
        SizedBox(height: 15),
        Wrap(
          runSpacing: 15,
          children: List.generate(
            _viewModel.chudes.length,
            (index) => Column(
              children: [
                PhysicalModel(
                  elevation: 5,
                  shadowColor: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.yellowAccent,
                  child: WidgetImageNetwork(
                    height: 200,
                    circular: 15,
                    width: AppSize.screenWidth,
                    url: _viewModel.chudes[index].img,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  _viewModel.chudes[index].name,
                  style: AppStyles.DEFAULT_REGULAR.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                if (index < _viewModel.chudes.length - 1)
                  Container(
                    height: 1,
                    width: AppSize.screenWidth,
                    color: Colors.white,
                  ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
