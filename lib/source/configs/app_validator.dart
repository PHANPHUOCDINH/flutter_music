import 'package:flutter/material.dart';

enum AccountType { Email, Phone }

class AppValidator {
  AppValidator._();

  static Pattern patternEmail =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static Pattern patternPhone = r'^(?:[+0]9)?[0-9]{10}$';
  static Pattern patternPassword = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~])\$";

  static RegExp regexPassword = new RegExp(patternPassword);
  static RegExp regexEmail = new RegExp(patternEmail);
  static RegExp regexPhone = new RegExp(patternPhone);

  static validateFullName(BuildContext context) {
    return (value) {
      if (value == null || value.length == 0) return "Tên không được để trống";
      return null;
    };
  }

  static validateNumber(BuildContext context) {
    return (value) {
      if (value == null || value.length == 0) {
        return "Trường này không được để trống";
      } else if (!(value is int)) {
        return "Trường này chỉ có thể là số";
      }

      return null;
    };
  }

  static validateEmail(BuildContext context) {
    return (value) {
      if (value == null || value.length == 0) {
        return "Email không được để trống";
      } else {
        if (!regexEmail.hasMatch(value)) return "Email không đúng định dạng";
        return null;
      }
    };
  }

  static validateEmailOrPhoneNumber(BuildContext context) {
    return (value) {
      if (value == null || value.length == 0) {
        return "Email hoặc số điện thoại không được để trống";
      } else {
        if (!regexEmail.hasMatch(value)) {
          return "Email không đúng đinh dạng";
        } else {
          if (value.length > 10) {
            return "Số điện thoại quá dài";
          } else if (value.length < 10) {
            return "Số điện thoại quá ngắn";
          } else if (!regexPhone.hasMatch(value)) {
            return "Số điện thoại không đúng định dạng";
          }
        }

        return null;
      }
    };
  }

  static validatePassword(BuildContext context, {int length = 8}) {
    return (value) {
      if (value == null || value.length == 0) {
        return "Mật khẩu không được để trống";
      } else if (value.length < length) {
        return "Mật khẩu phải chứa ít nhất 8 ký tự";
      } else {
        if (!regexPassword.hasMatch(value))
          return "Mật khẩu phải có 1 chữ hoa, thường, số và ký tự đặc biệt";
        return null;
      }
    };
  }

  static validateConfirmPassword(
    BuildContext context, {
    @required TextEditingController password,
    int length = 8,
  }) {
    return (value) {
      if (value == null || value.length == 0) {
        return "Mật khẩu không được để trống";
      } else if (value < length) {
        return "Mật khẩu phải chứa ít nhất 8 ký tự";
      } else {
        if (!regexPassword.hasMatch(value))
          return "Mật khẩu phải có 1 chữ hoa, thường, số và ký tự đặc biệt";
        if (password.text.compareTo(value) == 0) return null;
        return "Mật khẩu nhập lại không giống nhau";
      }
    };
  }

  static validatePhoneNumber(BuildContext context) {
    return (value) {
      if (value == null || value.length == 0) {
        return "Số điện thoại không để trống";
      } else if (value.length > 10) {
        return "Số điện thoại quá dài";
      } else if (value.length < 10) {
        return "Số điện thoại quá ngắn";
      } else if (!regexPhone.hasMatch(value)) {
        return "Số điện thoại không đúng định dạng";
      }

      return null;
    };
  }
}
