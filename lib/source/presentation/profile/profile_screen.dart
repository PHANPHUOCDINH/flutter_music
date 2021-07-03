import 'package:flutter/material.dart';

import '../../source.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      viewModel: ProfileViewModel(),
      onViewModelReady: (vm) => _viewModel = vm..init(),
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              WidgetAppBar(
                title: "Thông tin cá nhân",
                alignmentTitle: Alignment.centerLeft,
                colorAppBar: Colors.transparent,
                padding: EdgeInsets.only(left: 15),
                isBack: false,
              ),
              SizedBox(height: 15),
              Expanded(child: _buildBody()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return Data.userModel != null
        ? _buildUserResult(Data.userModel)
        : StreamBuilder(
            stream: AppShared.watchUser(),
            builder: (context, snapshot) {
              bool enabled = !snapshot.hasData;
              UserModel data = snapshot.data;

              return !enabled
                  ? _buildUserResult(data)
                  : GestureDetector(
                      onTap: !enabled
                          ? () {}
                          : () => _viewModel.loginGoogleFirebase(),
                      child: Center(
                        child: Image.asset(
                          "assets/icons/google.png",
                          width: AppSize.screenWidth / 1.5,
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
            },
          );
  }

  Widget _buildUserResult(UserModel userModel) {
    return Container(
      width: AppSize.screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WidgetImageNetwork(
            url: userModel.user_avatar,
            circular: 99,
            width: 100,
            height: 100,
            fit: BoxFit.fill,
          ),
          SizedBox(height: 15),
          Text(
            userModel?.name ?? "Tên của bạn",
            style: AppStyles.DEFAULT_LARGE.copyWith(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Text(
            userModel?.email ?? "Email của bạn",
            style: AppStyles.DEFAULT_REGULAR.copyWith(
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildContent(
                title: "Bài hát",
                amount: userModel?.like_tracks?.length,
              ),
              Container(
                height: 25,
                width: 1,
                color: Colors.white,
              ),
              _buildContent(
                title: "Nghệ sĩ",
                amount: userModel?.like_genres?.length,
              ),
              Container(
                height: 25,
                width: 1,
                color: Colors.white,
              ),
              _buildContent(
                title: "Chủ đề",
                amount: userModel?.like_genres?.length,
              ),
            ],
          ),
          SizedBox(height: 15),
          _buildButton(
            title: "Chỉnh sửa thông tin",
            iconData: Icons.edit,
            onTap: () => Navigator.pushNamed(context, Routers.profile_update),
            isShowNext: true,
          ),
          SizedBox(height: 15),
          _buildButton(
            title: "Đăng xuất",
            iconData: Icons.logout,
            onTap: _viewModel.logout,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    String title,
    Function onTap,
    IconData iconData,
    bool isShowNext = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSize.screenWidth,
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(25),
        ),
        padding: EdgeInsets.fromLTRB(25, 12.5, 15, 12.5),
        child: Row(
          children: [
            Icon(
              iconData,
              size: 25,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: AppStyles.DEFAULT_LARGE.copyWith(
                color: Colors.white,
              ),
            ),
            Spacer(),
            if (isShowNext)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 25,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent({
    String title,
    int amount,
  }) {
    return RichText(
      textAlign: TextAlign.center,
      maxLines: 2,
      text: TextSpan(
        text: "$title\n",
        style: AppStyles.DEFAULT_LARGE.copyWith(
          color: Colors.grey,
        ),
        children: [
          TextSpan(
            text: "${amount ?? 0}",
            style: AppStyles.DEFAULT_LARGE.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
