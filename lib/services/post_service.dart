import 'dart:convert';
import 'package:blogapp/models/post.dart';
import 'package:blogapp/services/user_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:blogapp/constants.dart';
import 'package:blogapp/models/api_response.dart';

// Get all posts
Future<APIResponse> getPosts() async {
  APIResponse apiResponse = APIResponse();
  String token = await getToken();
  final response = await http.get(Uri.parse(postURL), headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });
  print('StatusCode:${response.statusCode}');
  if (response.statusCode == 200) {
    print('StatusCode:${response.body}');
    apiResponse.data = jsonDecode(response.body.toString())['posts']
        .map((p) => Post.fromJson(p))
        .toList();
    apiResponse.data as List<dynamic>;
  } else if (response.statusCode == 401) {
    apiResponse.error = unAuthorized;
  } else if (response.statusCode == 500) {
    apiResponse.error = serverError;
  } else {
    apiResponse.error = somethingWentWrong;
  }
  return apiResponse;
}

// Create post
Future<APIResponse> createPost(String mainbody, PlatformFile? image) async {
  print("Image:${image?.bytes?.length}");
  APIResponse apiResponse = APIResponse();
  String token = await getToken();
  List<int> mData = [];
  image?.bytes?.forEach((element) {
    mData.add(element);
  });
  var myImagePart =
      http.MultipartFile.fromBytes('image', mData, filename: image?.name);
  var request = http.MultipartRequest(
    'POST',
    Uri.parse(postURL),
  );
  request.files.add(myImagePart);
  request.headers.addAll({
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });
  request.fields.addAll({'body': mainbody});
  final response = await request.send();
  print('StatusCode:${response.statusCode}');

  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);

  print('Stream-ss:${responseString}');

  if (response.statusCode == 200) {
    print('Success');
    apiResponse.data = jsonDecode(responseString);
    //apiResponse.data as List<dynamic>;
  } else if (response.statusCode == 422) {
    print(apiResponse.error);
    final errors = jsonDecode(responseString)['errors'];
    print(errors);
    apiResponse.error = errors[errors.keys.elementAt(0)[0]];
  } else if (response.statusCode == 401) {
    apiResponse.error = unAuthorized;
  } else if (response.statusCode == 500) {
    apiResponse.error = serverError;
  } else {
    apiResponse.error = somethingWentWrong;
  }
  print(apiResponse.error);
  return apiResponse;
}

Future<APIResponse> editPost(String? body, int? postId) async {
  APIResponse apiResponse = APIResponse();
  try {
    String token = await getToken();
    final response = await http.put(
      Uri.parse('$postURL/$postId'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {'body': body},
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unAuthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<APIResponse> deletePost(int postId) async {
  APIResponse apiResponse = APIResponse();
  try {
    String token = await getToken();
    final response = await http.delete(
      Uri.parse('$postURL/$postId'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unAuthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
