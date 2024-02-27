import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nguyen_manh_dung/models/message.dart';
import 'package:nguyen_manh_dung/models/user.dart';
import 'package:nguyen_manh_dung/services/auth.services.dart';
import 'package:nguyen_manh_dung/services/chat.service.dart';
import 'package:nguyen_manh_dung/services/notification.service.dart';
import 'package:nguyen_manh_dung/skeletons/product_detail.dart';
import 'package:nguyen_manh_dung/widgets/text.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.user, required this.receiverId});

  final UserModel user;
  final String receiverId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // controllers
  final _chatInputController = TextEditingController();

  // variables
  late List<String> _messageList;
  late String _senderId;
  late String _receiverId;

  // models
  late UserModel _user;

  // services
  final _authService = AuthService();
  final _chatService = ChatService();
  final _notificationService = NotificationService();

  @override
  void initState() {
    _user = widget.user;
    _senderId = _authService.getCurrentUserId();
    _receiverId = widget.receiverId;
    _messageList = [];
    super.initState();
  }

  @override
  void dispose() {
    _chatInputController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    print(_notificationService.getToken());
    String content = _chatInputController.text;
    if (content.isEmpty) return;
    _messageList.add(content);
    _chatInputController.clear();

    try {
      _chatService.sendMessage(content, _senderId, _receiverId);
    } catch (e) {
      print('send failed $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: appBar(context),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          height: double.infinity,
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40))),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('messages')
                      .where(Filter.and(
                        Filter('sender_id', whereIn: [_senderId, _receiverId]),
                        Filter('receiver_id',
                            whereIn: [_senderId, _receiverId]),
                      ))
                      .orderBy('created_at')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: Text('No data...'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const ProductDetailSkeleton();
                    }
                    final data = snapshot.data?.docs;
                    return SingleChildScrollView(
                      reverse: true,
                      child: ListView.builder(
                          addAutomaticKeepAlives: true,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data?.length,
                          itemBuilder: (context, index) {
                            _messageList.add(data?[index]['content']);
                            String content = data?[index]['content'];
                            String senderId = data?[index]['sender_id'];
                            String receiverId = data?[index]['receiver_id'];
                            return chatBox(
                                MessageModel(content, senderId, receiverId));
                          }),
                    );
                  },
                ),
                // child: FutureBuilder(
                //   future: _messagesData,
                //   builder: (context, snapshot) {
                //     if (!snapshot.hasData) {
                //       return const Center(child: Text('No data...'));
                //     }
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const ProductDetailSkeleton();
                //     }
                //     final data = snapshot.data?.docs;
                //     return SingleChildScrollView(
                //       reverse: true,
                //       child: ListView.builder(
                //           addAutomaticKeepAlives: true,
                //           shrinkWrap: true,
                //           physics: const NeverScrollableScrollPhysics(),
                //           itemCount: data?.length,
                //           itemBuilder: (context, index) {
                //             _messageList.add(data?[index]['content']);
                //             String content = data?[index]['content'];
                //             String senderId = data?[index]['sender_id'];
                //             String receiverId = data?[index]['receiver_id'];
                //             return chatBox(
                //                 MessageModel(content, senderId, receiverId));
                //           }),
                //     );
                //   },
                // ),
              ),
              chatInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget chatBox(MessageModel message) {
    bool isFromMe = message.senderId == _senderId;
    return Row(
      mainAxisAlignment:
          isFromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            bottom: 15,
            top: 15,
          ),
          margin: const EdgeInsets.only(bottom: 20),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            minWidth: 50,
            minHeight: 50,
          ),
          decoration: BoxDecoration(
            color:
                isFromMe ? Theme.of(context).colorScheme.primary : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: MyText(
            text: message.content,
            color: isFromMe ? Colors.white : Colors.black,
            fs: 16,
            fw: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget chatInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: TextFormField(
        controller: _chatInputController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300)),
          hintText: 'Type a message here...',
          hintStyle: const TextStyle(
              color: Colors.grey, fontWeight: FontWeight.normal),
          prefixIcon: IconButton(
            icon: const Icon(Iconsax.add, size: 25),
            onPressed: () {},
          ),
          prefixIconColor: Theme.of(context).colorScheme.primary,
          suffixIcon: Padding(
            padding: const EdgeInsets.all(5),
            child: IconButton.filled(
              onPressed: _sendMessage,
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)))),
              icon: const Icon(Iconsax.direct_right5),
            ),
          ),
          suffixIconColor: Colors.white,
        ),
      ),
    );
  }

  PreferredSize appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: title(context),
        actions: [action()],
        leading: leading(),
        automaticallyImplyLeading: false,
      ),
    );
  }

  IconButton leading() {
    return IconButton.filled(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back),
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
    );
  }

  Padding action() {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: IconButton.filled(
        onPressed: () {},
        icon: const Icon(Icons.more_vert),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white)),
      ),
    );
  }

  Row title(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _user.avatar == 'default_avatar.jpg'
            ? CircleAvatar(
                radius: 25,
                backgroundColor: Theme.of(context).colorScheme.primary,
                backgroundImage:
                    const AssetImage('assets/images/default_avatar.jpg'),
              )
            : CircleAvatar(
                radius: 25,
                backgroundColor: Theme.of(context).colorScheme.primary,
                backgroundImage: NetworkImage(_user.avatar),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  constraints: const BoxConstraints(maxWidth: 120),
                  child: MyText(
                      text: _user.fullName, color: Colors.white, fs: 16)),
              const MyText(
                text: 'Online',
                fw: FontWeight.normal,
                color: Color(0xffdcdcdc),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
