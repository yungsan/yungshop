import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nguyen_manh_dung/models/user.dart';
import 'package:nguyen_manh_dung/screens/chat.dart';
import 'package:nguyen_manh_dung/services/auth.services.dart';
import 'package:nguyen_manh_dung/services/user.service.dart';
import 'package:nguyen_manh_dung/skeletons/product_detail.dart';
import 'package:nguyen_manh_dung/widgets/text.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late Future<QuerySnapshot<Map<String, dynamic>>> _data;
  final _userService = UserService();
  final _authService = AuthService();

  @override
  void initState() {
    _data = _userService.getAllUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyText(text: 'Message', fs: 20),
        centerTitle: true,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: searchBar()),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 15, bottom: 50, right: 15, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MyText(text: 'Recent chat', fs: 18, bottom: 15),
            FutureBuilder(
              future: _data,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: MyText(text: 'No data...'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ProductDetailSkeleton();
                }
                return chatContainer(snapshot.data?.docs);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget chatContainer(data) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: data.length,
        itemBuilder: (context, index) {
          UserModel user = UserModel(
              fullName: data[index]['full_name'],
              avatar: data[index]['avatar']);
          return chatItem(user, data[index].id);
        },
      ),
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: TextFormField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(color: Colors.grey.shade300)),
          hintText: 'Search',
          hintStyle: const TextStyle(
              color: Colors.grey, fontWeight: FontWeight.normal),
          prefixIcon: const Icon(Iconsax.search_normal),
          prefixIconColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget chatItem(
    UserModel user,
    String receiverId, {
    bool isUnread = false,
  }) {
    return Visibility(
      visible: receiverId != _authService.getCurrentUserId(),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                user: user,
                receiverId: receiverId,
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              user.avatar == 'default_avatar.jpg'
                  ? CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      backgroundImage:
                          const AssetImage('assets/images/default_avatar.jpg'),
                    )
                  : CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      backgroundImage: NetworkImage(user.avatar),
                    ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(text: user.fullName, fw: FontWeight.w600, fs: 16),
                    const MyText(
                      text: 'An idiot sandwichhhhhhh',
                      fw: FontWeight.normal,
                      color: Colors.black38,
                      fs: 16,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const MyText(
                    text: '15:09',
                    color: Colors.black38,
                    fw: FontWeight.normal,
                  ),
                  isUnread
                      ? Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: const MyText(
                            text: '1',
                            color: Colors.white,
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
