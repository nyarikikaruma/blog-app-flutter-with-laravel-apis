import 'dart:convert';

import 'package:blogapp/constants.dart';
import 'package:blogapp/models/api_response.dart';
import 'package:blogapp/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Login
// late final http.Client httpClient;
Future<APIResponse> login(
  String email,
  String password,
) async {
  APIResponse apiResponse = APIResponse();
  try {
    final response = await http.post(Uri.parse(loginURL), headers: {
      'Accept': 'application/json'
    }, body: {
      'email': email,
      'password': password,
    });
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        {
          apiResponse.data = User.fromJson(jsonDecode(response.body));
          print('error 200');
        }
        break;
      case 422:
        {
          final errors = jsonDecode(response.body)['errors'];
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
          print('error 422');
        }
        break;
      case 403:
        {
          apiResponse.error = jsonDecode(response.body)['message'];
          print('error 403');
        }
        break;
      default:
        {
          apiResponse.error = somethingWentWrong;
          print('default error');
        }
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
    print('default error');
  }
  return apiResponse;
}

///Register
Future<APIResponse> register(
  String name,
  String email,
  String password,
) async {
  APIResponse apiResponse = APIResponse();
  // try {
  final response = await http.post(Uri.parse(registerURL), headers: {
    'Accept': 'application/json'
  }, body: {
    'name': name,
    'email': email,
    'password': password,
    'password_confirmation': password,
  });
  if (response.statusCode == 200) {
    apiResponse.data = User.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 422) {
    final errors = jsonDecode(response.body)['errors'];
    apiResponse.error = errors[errors.keys.elementAt(0)][0];
  } else if (response.statusCode == 403) {
    apiResponse.error = jsonDecode(response.body)['message'];
  } else {
    throw apiResponse.error = serverError;
  }
  return apiResponse;
  //   print(response.statusCode);
  //   switch (response.statusCode) {
  //     case 200:
  //       print('error 201');
  //       {
  //         print(response.body);
  //         apiResponse.data = User.fromJson(jsonDecode(response.body));
  //         print('error 200');
  //       }
  //       break;
  //     case 422:
  //       {
  //         final errors = jsonDecode(response.body)['errors'];
  //         apiResponse.error = errors[errors.keys.elementAt(0)][0];
  //         print('Error 422');
  //       }
  //       break;
  //     case 403:
  //       {
  //         apiResponse.error = jsonDecode(response.body)['message'];
  //         print('Error 403');
  //       }
  //       break;
  //     default:
  //       {
  //         apiResponse.error = somethingWentWrong;
  //         print('Default error');
  //       }
  //       break;
  //   }
  // } catch (e) {
  //   apiResponse.error = serverError;
  // }
  // print(apiResponse);
  // return apiResponse;
}

///Get user details
Future<APIResponse> getUserDetails() async {
  APIResponse apiResponse = APIResponse();
  // try {
  String token = await getToken();
  final response = await http.post(Uri.parse(userURL), headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });
  if (response.statusCode == 200) {
    apiResponse.data = User.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 422) {
    final errors = jsonDecode(response.body)['errors'];
    apiResponse.error = errors[errors.keys.elementAt(0)][0];
  } else if (response.statusCode == 403) {
    apiResponse.error = jsonDecode(response.body)['message'];
  } else {
    throw apiResponse.error = serverError;
  }
  return apiResponse;
  //   switch (response.statusCode) {
  //     case 200:
  //       apiResponse.data = User.fromJson(jsonDecode(response.body));
  //       break;
  //     case 422:
  //       final errors = jsonDecode(response.body)['errors'];
  //       apiResponse.error = errors[errors.keys.elementAt(0)][0];
  //       break;
  //     case 403:
  //       apiResponse.error = jsonDecode(response.body)['message'];
  //       break;
  //     default:
  //       apiResponse.error = somethingWentWrong;
  //       break;
  //   }
  // } catch (e) {
  //   apiResponse.error = serverError;
  // }
  // return apiResponse;
}

// Get user token
Future<String> getToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('token') ?? '';
}

// Get user id
Future<String> getUserId() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('userId') ?? '';
}

// Logout user
Future<bool> logout() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return await preferences.remove('token');
}
