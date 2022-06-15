import 'package:blogapp/constants.dart';
import 'package:blogapp/models/api_response.dart';
import 'package:blogapp/models/post.dart';
import 'package:blogapp/screens/login.dart';
import 'package:blogapp/services/post_service.dart';
import 'package:blogapp/services/user_service.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool _loading = true;
  List<dynamic> _postList = [];
  int userId = 0;

  // Get all posts
  Future<void> _getPosts() async {
    userId = await getUserId();
    APIResponse response = await getPosts();
    if (response.error == null) {
      setState(() {
        _postList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unAuthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false),
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  @override
  void initState() {
    _getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            onRefresh: () {
              return _getPosts();
            },
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                Post post = _postList[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    image: post.user!.image != null
                                        ? DecorationImage(
                                            image: NetworkImage(
                                              '${post.user!.image}',
                                            ),
                                          )
                                        : null,
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${post.user!.name}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                )
                              ],
                            ),
                          ),
                          post.user!.id == userId
                              ? PopupMenuButton(
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Text('Edit'),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Delete'),
                                    ),
                                    PopupMenuItem(
                                      value: 'share',
                                      child: Text('Share'),
                                    ),
                                  ],
                                  onSelected: (val) {
                                    if (val == 'edit') {
                                      // Edit

                                    } else {
                                      // Delete
                                    }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.more_vert_sharp,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text('${post.body}'),
                      post.image != null
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: 180,
                              margin: const EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage('${post.image}'),
                                    fit: BoxFit.cover),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                );
              },
              itemCount: _postList.length,
            ),
          );
  }
}
