import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nguyen_manh_dung/services/auth.services.dart';
import 'package:nguyen_manh_dung/services/user.service.dart';
import 'package:nguyen_manh_dung/skeletons/product_detail.dart';
import 'package:nguyen_manh_dung/widgets/button.dart';
import 'package:nguyen_manh_dung/widgets/text.dart';

enum SelectionType { picker, camera }

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _fs = FirebaseFirestore.instance;
  final userService = UserService();
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;
  late String _userAvatar;
  late String _userFullName;
  late Future _data;
  XFile? image;
  late ImagePicker _picker;
  final _storage = FirebaseStorage.instance.ref();

  final List<Widget> _icons = const [
    Icon(Icons.person_outline, size: 30, color: Color(0xFF944A01)),
    Icon(Iconsax.card, size: 30, color: Color(0xFF944A01)),
    Icon(Iconsax.clipboard_text, size: 30, color: Color(0xFF944A01)),
    Icon(Iconsax.setting_2, size: 30, color: Color(0xFF944A01)),
    Icon(Iconsax.info_circle, size: 30, color: Color(0xFF944A01)),
    Icon(Iconsax.lock, size: 30, color: Color(0xFF944A01)),
    Icon(Iconsax.user_add, size: 30, color: Color(0xFF944A01)),
    Icon(Iconsax.logout_1, size: 30, color: Color(0xFF944A01)),
  ];

  final List<String> strings = [
    'Your Profile',
    'Payment Methods',
    'My Orders',
    'Settings',
    'Help Center',
    'Private Policy',
    'Invites Friends',
    'Log Out',
  ];

  void _handleImagePicker(SelectionType type) async {
    print(type);
    try {
      _picker = ImagePicker();

      XFile? img;

      if (type == SelectionType.picker) {
        img = await _picker.pickImage(source: ImageSource.gallery);
      } else {
        img = await _picker.pickImage(source: ImageSource.camera);
      }

      _uploadImage(img);

      setState(() {
        image = img;
      });
    } catch (e) {
      print('upload avatar failed $e');
    }
  }

  void _uploadImage(img) async {
    final avatarRef = _storage.child(img!.name);

    avatarRef.putFile(File(img.path)).snapshotEvents.listen((event) async {
      switch (event.state) {
        case TaskState.success:
          print('upload successfully');
          final downloadURL = await avatarRef.getDownloadURL();
          _fs.collection('users').doc(_userId).update({'avatar': downloadURL});
          setState(() {
            _userAvatar = downloadURL;
          });
          _closeDialog();
          break;
        case TaskState.running:
          print('Uploading...');
          break;
        case TaskState.canceled:
          print('Upload canceled');
          break;
        case TaskState.paused:
          print('Upload paused');
          break;
        case TaskState.error:
          print('Upload error. Try again.');
          break;
      }
    });
  }

  void _closeDialog() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    _data = userService.getUser(_userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
        body: FutureBuilder(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ProductDetailSkeleton();
            }
            _userAvatar = snapshot.data['avatar'];
            _userFullName = snapshot.data['full_name'];
            return SizedBox(width: double.infinity, child: mainContent());
          },
        ));
  }

  Column mainContent() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Builder(
              builder: (context) {
                if (image != null) {
                  return CircleAvatar(
                      radius: 60,
                      backgroundImage: FileImage(File(image!.path)));
                }
                if (_userAvatar != 'default_avatar.jpg') {
                  return CircleAvatar(
                      radius: 60, backgroundImage: NetworkImage(_userAvatar));
                }
                return CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/images/$_userAvatar'));
              },
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 2, color: Colors.white),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            surfaceTintColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const MyText(
                                    text: 'Select options',
                                    fs: 20,
                                    bottom: 10,
                                  ),
                                  MyButton(
                                    text: const MyText(
                                      text: 'Choose Image',
                                      color: Colors.white,
                                      fs: 18,
                                    ),
                                    background:
                                        Theme.of(context).colorScheme.primary,
                                    onPressed: () => _handleImagePicker(
                                        SelectionType.picker),
                                  ),
                                  MyButton(
                                    text: const MyText(
                                      text: 'Take Photo',
                                      color: Colors.white,
                                      fs: 18,
                                    ),
                                    background:
                                        Theme.of(context).colorScheme.primary,
                                    onPressed: () => _handleImagePicker(
                                        SelectionType.camera),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  icon: const Icon(Iconsax.edit_24),
                  iconSize: 20,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        MyText(text: _userFullName, fs: 20, top: 10, bottom: 20),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            itemCount: _icons.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (index == 7) {
                    AuthService().signOut(context, index);
                  } else {
                    print(index);
                  }
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color:
                              index == 7 ? Colors.transparent : Colors.black12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _icons[index],
                        MyText(
                          text: strings[index],
                          fs: 18,
                          fw: FontWeight.normal,
                          left: 10,
                        ),
                        const Spacer(),
                        Icon(
                          Iconsax.arrow_right_34,
                          color: Theme.of(context).colorScheme.primary,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Center(child: MyText(text: 'Profile', fs: 20)),
      automaticallyImplyLeading: false,
    );
  }
}
