import 'package:flutter/material.dart';

const baseURl = 'http://192.168.42.119:8000/api';
const loginURL = '$baseURl/login';
const registerURL = '$baseURl/register';
const logoutURL = '$baseURl/logout';
const userURL = '$baseURl/user';
const postURL = '$baseURl/posts';
const commentsURL = '$baseURl/comments';

const serverError = 'Server Error';
const unAuthorized = 'Unauthorized';
const somethingWentWrong = 'Something went Wrong, try again';

// Input decoration
InputDecoration kInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    contentPadding: const EdgeInsets.all(10.0),
    border: const OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.black)),
  );
}
