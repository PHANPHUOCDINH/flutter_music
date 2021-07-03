import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';

import '../../source.dart';

abstract class BaseViewModel extends ChangeNotifier {
  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository();

  final isLoadingSubject = BehaviorSubject<bool>();
  final isErrorSubject = BehaviorSubject<String>();

  BuildContext _context;

  BuildContext get context => _context;

  setContext(BuildContext value) => _context = value;

  void setLoading(bool loading) {
    if (loading != isLoading) isLoadingSubject.add(loading);
  }

  bool get isLoading => isLoadingSubject.value;

  void setError(String message) => isErrorSubject.add(message);

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  @override
  void dispose() async {
    await isLoadingSubject.drain();
    isLoadingSubject.close();

    await isErrorSubject.drain();
    isErrorSubject.close();

    super.dispose();
  }

  void unFocus() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    FocusScope.of(context).unfocus();
  }

  /*void loginFacebookFirebase() async {
    setLoading(true);
    final facebookLogin = FacebookLogin();
    if (await facebookLogin.isLoggedIn) await facebookLogin.logOut();

    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final credential = FacebookAuthProvider.credential(result.accessToken.token);
        final user = (await AppFirebase.firebaseAuth.signInWithCredential(credential)).user;

        handleLogin(
          id: result.accessToken.userId,
          type: LoginType.facebook,
          accessToken: result.accessToken.token,
          avatar: user.photoURL,
          email: user.email,
          fullName: user.displayName,
          phone: user.phoneNumber,
        );
        break;
      case FacebookLoginStatus.cancelledByUser:
        await handleFailure(msg: result.errorMessage);
        setLoading(false);
        break;
      case FacebookLoginStatus.error:
        print(result.errorMessage);
        await handleFailure(msg: result.errorMessage);
        setLoading(false);
        break;
    }
  }*/

  void loginGoogleFirebase() async {
    try {
      setLoading(true);
      GoogleSignInAccount account =
          await GoogleSignIn(scopes: ['email']).signIn();
      GoogleSignInAuthentication authentication = await account.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken,
      );

      UserCredential authResult =
          await AppFirebase.firebaseAuth.signInWithCredential(credential);
      User user = authResult.user;

      if (user != null) {
        final User currentUser = AppFirebase.firebaseAuth.currentUser;
        handleLogin(
          user_avatar: currentUser.photoURL,
          email: currentUser.email,
          loginType: LoginType.google,
          id: currentUser.uid,
          accessToken: authentication.accessToken,
          fullName: currentUser.displayName,
          phone: currentUser.phoneNumber,
          isNewUser: authResult.additionalUserInfo.isNewUser,
        );
      }
    } catch (e) {
      print(e.toString());
      await showError(title: "Đăng nhập google thất bại");
      setLoading(false);
    }
  }

  void loginWithEmailAndPassword({
    String emailOrPhone,
    String password,
  }) async {
    try {
      UserCredential authResult =
          await AppFirebase.firebaseAuth.signInWithEmailAndPassword(
        email: emailOrPhone,
        password: password,
      );

      User user = authResult.user;
      if (user != null) {
        final User currentUser = AppFirebase.firebaseAuth.currentUser;
        handleLogin(
          user_avatar: currentUser.photoURL,
          email: currentUser.email,
          loginType: LoginType.normal,
          id: currentUser.uid,
          fullName: currentUser.displayName,
          phone: currentUser.phoneNumber,
        );
      }

      setLoading(false);
    } catch (e) {
      print(e.toString());
      await showError(title: "Đăng nhập thất bại");
      setLoading(false);
    }
  }

  void registerWithEmailAndPassword({
    String emailOrPhone,
    String password,
  }) async {
    try {
      isLoadingSubject.add(true);
      UserCredential authResult =
          await AppFirebase.firebaseAuth.createUserWithEmailAndPassword(
        email: emailOrPhone,
        password: password,
      );

      User user = authResult.user;
      if (user != null) await showConfirm(content: "Đăng ký thành công");
      isLoadingSubject.add(false);
    } catch (e) {
      print(e.toString());
      await showError(title: "Đăng ký thất bại");
      setLoading(false);
    }
  }

  void handleLogin({
    String accessToken,
    LoginType loginType,
    String user_avatar,
    String email,
    String fullName,
    String password,
    String id,
    String phone,
    bool isNewUser = false,
  }) async {
    try {
      setLoading(true);
      UserModel userModel = new UserModel(
        name: fullName,
        user_avatar: user_avatar,
        email: email,
        sdt: "",
        chude: "",
        genre: "",
        id: id,
        like_tracks: [],
        like_genres: [],
      );

      switch (loginType) {
        case LoginType.facebook:
        case LoginType.google:
          if (isNewUser) {
            AppFirebase.uploadUser(userModel);
            Data.userModel = userModel;
            await AppShared.setUser(userModel);
          } else {
            var doc =
                await AppFirebase.userCollection.doc("userID-${id}").get();
            var data = doc.data();
            var um = UserModel.fromJson(data);

            Data.userModel = um;
            await AppShared.setUser(um);
          }

          break;

        case LoginType.apple:
          await showError(title: "Chức năng chưa hỗ trợ");
          break;

        case LoginType.phone:
          await showError(title: "Chức năng chưa hỗ trợ");
          break;

        case LoginType.normal:
          break;
      }

      setLoading(false);
      Toast.show(
        "Đăng nhập thành công",
        context,
        backgroundColor: Colors.white70,
        textColor: Colors.black,
      );
    } catch (e) {
      await showError(title: "Đăng nhập thất bại");
      setLoading(false);
    }
  }

  Future<dynamic> baseRequest({@required Function authenticationCall}) async {
    NetworkState state = await authenticationCall();
    if (state.data != null && state.isSuccess) return state.data;
    return null;
  }

  Future<bool> showError({
    String title,
    Function onAction,
  }) async {
    return await showDialog(
      context: context,
      builder: (c) => WidgetDialogError(
        title: title ?? "Lỗi không xác định",
        onAction: onAction,
      ),
    );
  }

  Future<bool> showConfirm({
    String title,
    @required String content,
    Function actionCancel,
    Function actionConfirm,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) => WidgetDialogConfirm(
        title: title ?? "Thông báo",
        content: content ?? "Nothing",
        actionConfirm: actionConfirm,
        actionCancel: actionCancel,
      ),
    );
  }

  Future handlePickImage() async {
    setLoading(true);
    File file = await _showPickImage();
    if (file != null) {
      print("Avatar URL: ${file.path}");
      UploadTask task = await AppFirebase.uploadImageFile(file);
      task.whenComplete(() async {
        await AppFirebase.downloadLink(task.snapshot.ref).then(
          (value) async {
            Data.userModel.setAvatar(value);
            AppFirebase.userCollection
                .doc("userID-${Data.userModel.id}")
                .update(Data.userModel.toJson());
            await AppShared.setUser(Data.userModel);
          },
        );
      });
    }

    setLoading(false);
  }

  Future<File> _showPickImage() async {
    return await showDialog(
      context: context,
      builder: (c) => WidgetDialogPickImage(),
    );
  }

  Future<void> logout() async {
    await AppFirebase.firebaseAuth.signOut();
    await AppShared.setUser(null);

    Data.userModel = null;
    Toast.show(
      "Đăng xuất thành công",
      context,
      duration: 2,
      backgroundColor: Colors.white70,
      textColor: Colors.black,
    );

    notifyListeners();
  }
}
