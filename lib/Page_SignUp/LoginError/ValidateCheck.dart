import 'package:flutter/material.dart';

class CheckValidate {
  String? validateEmail(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      return '이메일을 입력하세요.';
    } else {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus(); //포커스를 해당 textformfield에 맞춘다.
        return '잘못된 이메일 형식입니다.';
      } else {
        focusNode.unfocus(); //포커스를 해당 textformfield에 맞춘다.

        return "올바른 이메일입니다.";
      }
    }
  }

  String? validatePassword(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      return '비밀번호를 입력하세요.';
    } else {
      String pattern =
          r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '특수문자, 대소문자, 숫자 포함 8자 이상 15자 이내로 입력하세요.';
      } else {
        return "올바른 비밀번호 입니다.";
      }
    }
  }

  String? validateNumber(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      return '번호를 입력하세요.';
    } else {
      String pattern = r'^010-?([0-9]{4})-?([0-9]{4})$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '올바른 형식으로 번호를 입력하세요.';
      } else {
        return "올바른 번호 형식입니다.";
      }
    }
  }

  String? validateName(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      return '이름을 입력하세요.';
    } else {
      return "";
    }
  }
}
