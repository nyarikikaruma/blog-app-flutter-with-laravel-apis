import 'dart:developer';
import 'dart:io';
import 'package:blogapp/constants.dart';
import 'package:blogapp/models/api_response.dart';
import 'package:blogapp/screens/login.dart';
import 'package:blogapp/services/post_service.dart';
import 'package:blogapp/services/user_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostForm extends StatefulWidget {
  const PostForm({Key? key}) : super(key: key);

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final GlobalKey<FormState> formkey = GlobalKey();
  final TextEditingController _textControllerBody = TextEditingController();
  bool _loading = false;
  File? _imageFile;
  final _picker = ImagePicker();
  PlatformFile? file;

  // Future getImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     _imageFile = File(pickedFile.path);
  //   }
  // }
  Future getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      _imageFile = File(result.files.single.path!);
      file = result.files.first;
    }
  }

  void _createPost() async {
    PlatformFile? image = file == null ? null : file!;
    log(image!.toString());
    APIResponse response = await createPost(_textControllerBody.text, image);
    if (response.error == null) {
      Navigator.of(context).pop();
    } else if (response.error == unAuthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
          )
        ],
        title: const Text('Posts'),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                    image: _imageFile == null
                        ? null
                        : DecorationImage(
                            image: FileImage(
                              _imageFile ?? File(''),
                            ),
                            fit: BoxFit.cover,
                          ),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      await getImage();
                    },
                  ),
                ),
                Form(
                  key: formkey,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _textControllerBody,
                      keyboardType: TextInputType.multiline,
                      maxLines: 9,
                      validator: (val) =>
                          val!.isEmpty ? 'Post body is required' : null,
                      decoration: const InputDecoration(
                        hintText: "Post body...",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    child: const Text('Post'),
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        setState(() {
                          _loading = !_loading;
                          _createPost();
                        });
                      }
                    },
                  ),
                )
              ],
            ),
    );
  }
}
