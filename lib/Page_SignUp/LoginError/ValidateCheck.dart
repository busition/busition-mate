import 'package:flutter/material.dart';

class CheckValidate {

  static List<bool> inputStatus = [
    false,false,false,false
  ];

  String? validateEmail(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      inputStatus[0] = false;
      return '이메일을 입력하세요.';

    } else {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus(); //포커스를 해당 textformfield에 맞춘다.
        inputStatus[0] = false;

        return '잘못된 이메일 형식입니다.';
      } else {
        focusNode.unfocus(); //포커스를 해당 textformfield에 맞춘다.
        inputStatus[0] = true;

        return "올바른 이메일입니다.";
      }
    }
  }

  String? validatePassword(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      inputStatus[1] = false;
      return '비밀번호를 입력하세요.';
    } else {
      String pattern =
          r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        inputStatus[1] = false;
        return '특수문자, 대소문자, 숫자 포함 8자 이상 15자 이내로 입력하세요.';
      } else {
        inputStatus[1] = true;
        return "올바른 비밀번호 입니다.";
      }
    }
  }

  String? validateNumber(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      inputStatus[2] = false;
      return '번호를 입력하세요.';
    } else {
      String pattern = r'^010-?([0-9]{4})-?([0-9]{4})$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        inputStatus[2] = false;
        return '올바른 형식으로 번호를 입력하세요.';
      } else {
        inputStatus[2] = true;
        return "올바른 번호 형식입니다.";
      }
    }
  }

  String? validateName(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      inputStatus[3] = false;

      return '이름을 입력하세요.';
    } else {
      inputStatus[3] = true;

      return "";
    }
  }
}
