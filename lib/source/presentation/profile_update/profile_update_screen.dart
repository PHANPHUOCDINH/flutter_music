import 'package:flutter/material.dart';

import '../../source.dart';

class ProfileUpdateScreen extends StatefulWidget {
  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  ProfileUpdateViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      viewModel: ProfileUpdateViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel..init(),
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Column(
              children: [
                WidgetAppBar(
                  title: "Thông tin cá nhân",
                  colorButton: Colors.white,
                  colorAppBar: Colors.transparent,
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: AppShared.watchUser(),
                    builder: (context, snapshot) {
                      bool enabled = !snapshot.hasData;
                      var data = snapshot.data;

                      if (!enabled) _viewModel.initText();
                      return enabled
                          ? WidgetShimmer(child: _buildBody(null, true))
                          : _buildBody(data, false);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(UserModel user, bool loading) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAvatar(user),
          const SizedBox(height: 20),
          WidgetTextFormField(
            controller: _viewModel.nameController,
            hintText: "Tên của bạn",
            hintStyle: AppStyles.DEFAULT_REGULAR,
            readOnly: loading,
            colorBorder: Colors.transparent,
          ),
          const SizedBox(height: 8),
          WidgetTextFormField(
            controller: _viewModel.emailController,
            hintText: "Email",
            hintStyle: AppStyles.DEFAULT_REGULAR,
            readOnly: loading,
            colorBorder: Colors.transparent,
          ),
          const SizedBox(height: 8),
          WidgetTextFormField(
            controller: _viewModel.sdtController,
            hintText: "Số điện thoại",
            hintStyle: AppStyles.DEFAULT_REGULAR,
            readOnly: loading,
            colorBorder: Colors.transparent,
          ),
          const SizedBox(height: 8),
          _buildChoose(
            title: _viewModel.genre,
            nonTitle: "Thể loại quan tâm",
            onTap: () async {
              await showDialog(
                context: context,
                builder: (c) => WidgetDialog(
                  choose: _viewModel.genres,
                  onTap: _viewModel.setGenreIndex,
                  originIndex: _viewModel.genreIndex,
                  header: "Thể loại",
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildChoose(
            title: _viewModel.chude,
            nonTitle: "Chủ đề quan tâm",
            onTap: () async {
              await showDialog(
                context: context,
                builder: (c) => WidgetDialog(
                  choose: _viewModel.chudes,
                  onTap: _viewModel.setChudeIndex,
                  originIndex: _viewModel.chudeIndex,
                  header: "Chủ đề",
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          WidgetButtonGradientAnimation(
            width: AppSize.screenWidth,
            title: "Cập nhật",
            isLoading: loading,
            colorStart: Colors.white,
            colorEnd: Colors.white,
            action: _viewModel.uploadInformation,
            textStyle: AppStyles.DEFAULT_LARGE,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildChoose({
    String title,
    String nonTitle,
    Function onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: AppSize.screenWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 25),
        child: Text(
          title ?? nonTitle,
          style: AppStyles.DEFAULT_REGULAR.copyWith(
            color: AppColors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(UserModel user) {
    return Column(
      children: [
        PhysicalModel(
          borderRadius: BorderRadius.all(Radius.circular(130)),
          color: Colors.transparent,
          elevation: 3,
          child: Stack(
            children: [
              WidgetImageNetwork(
                width: 130,
                circular: 130,
                height: 130,
                url: user?.user_avatar ??
                    "https://cdn.pixabay.com/photo/2021/02/12/09/36/sunflowers-6007847__340.jpg",
                fit: BoxFit.fill,
              ),
              Positioned(
                bottom: 1,
                right: 5,
                child: GestureDetector(
                  onTap: () async => await _viewModel.handlePickImage(),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WidgetDialog extends StatefulWidget {
  String header;
  int originIndex;
  List<String> choose;
  Function(int index) onTap;

  WidgetDialog({
    this.choose,
    this.header,
    this.originIndex,
    this.onTap,
  });

  @override
  _WidgetDialogState createState() => _WidgetDialogState();
}

class _WidgetDialogState extends State<WidgetDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 3,
      insetPadding: EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.header,
            style: AppStyles.DEFAULT_LARGE,
          ),
          SizedBox(height: 10),
          Wrap(
            runSpacing: 5,
            children: List.generate(
              widget.choose.length,
              (index) => RadioListTile(
                value: index,
                groupValue: widget.originIndex,
                onChanged: widget.onTap,
                title: Text(
                  widget.choose[index],
                  style: AppStyles.DEFAULT_REGULAR,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
