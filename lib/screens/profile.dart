import 'package:flutter/cupertino.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _PostScreenState();
}

class _PostScreenState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text('Profile'),
      ),
    );
  }
}
