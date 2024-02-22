import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:home_workout/constants/colors/app_color.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatUser myself = ChatUser(id: '1', firstName: 'Rahull');

  ChatUser bot = ChatUser(
    id: '2',
    firstName: 'Gemini',
  );

  List<ChatMessage> allMessages = [];
  List<ChatUser> typing = [];
  final oururl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyAWiXQdF6VmnM4etd5rCTT81hmrQnEmjKg';
  final header = {'Content-Type': 'application/json'};
  getdata(ChatMessage m) async {
    typing.add(bot);
    allMessages.insert(0, m);
    setState(() {});
    var data = {
      "contents": [
        {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
    };
    await http
        .post(Uri.parse(oururl), headers: header, body: jsonEncode(data))
        .then(
      (value) {
        if (value.statusCode == 200) {
          var result = jsonDecode(value.body);
          print(result['candidates'][0]['content']['parts'][0]['text']);
          ChatMessage m1 = ChatMessage(
              user: bot,
              createdAt: DateTime.now(),
              text: result['candidates'][0]['content']['parts'][0]['text']);
          allMessages.insert(0, m1);
          setState(() {});
        } else
          ('error occured');
      },
    ).catchError((e) {});
    typing.remove(bot);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            shadowColor: AppColor.blueColor,
            backgroundColor: Colors.grey.shade300,
            automaticallyImplyLeading: false,
            expandedHeight: 100.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://as1.ftcdn.net/v2/jpg/01/62/79/30/1000_F_162793029_LaUDuiMah7NnLSJ8Q2e7tCxfwZ6gigIt.jpg',
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.6),
                      BlendMode.dstATop,
                    ),
                  ),
                ),
              ),
              title: Text('Chat Screen',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      color: AppColor.blueColor,
                      fontSize: 29,
                      fontWeight: FontWeight.w700)),
            ),
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: DashChat(
                inputOptions: InputOptions(
                  autocorrect: true,
                  cursorStyle: CursorStyle(color: AppColor.blueColor, width: 2),
                  inputMaxLines: 5,
                  inputToolbarStyle: BoxDecoration(
                      color: AppColor.blackColor,
                      backgroundBlendMode: BlendMode.overlay,
                      // image: DecorationImage(
                      //   image: Image.network(
                      //           'https://as1.ftcdn.net/v2/jpg/01/62/79/30/1000_F_162793029_LaUDuiMah7NnLSJ8Q2e7tCxfwZ6gigIt.jpg',color: Colors.black,)
                      //       .image,
                      //   // fit: BoxFit.cover,
                      // ),
                      borderRadius: BorderRadius.circular(20)),
                  inputTextStyle: TextStyle(
                    fontFamily: 'Quicksand',
                    color: AppColor.blueColor,
                    fontWeight: FontWeight.w700,
                  ),
                  inputToolbarPadding: EdgeInsets.all(10),
                  inputToolbarMargin: EdgeInsets.all(4),
                ),
                messageOptions: MessageOptions(
                  currentUserContainerColor: Colors.grey.shade300,
                  currentUserTextColor: AppColor.blueColor,
                  timeFormat: DateFormat(),
                  containerColor: Colors.grey.shade200.withOpacity(.88),
                  textColor: AppColor.blackColor,
                  marginDifferentAuthor: EdgeInsets.only(top: 10, bottom: 10),
                  marginSameAuthor: EdgeInsets.only(left: 20),
                  currentUserTimeTextColor: AppColor.blueColor,
                ),
                messageListOptions: MessageListOptions(showDateSeparator: true),
                quickReplyOptions: QuickReplyOptions(
                  quickReplyStyle: BoxDecoration(color: AppColor.blueColor),
                ),
                typingUsers: typing,
                currentUser: myself,
                onSend: (ChatMessage m) {
                  getdata(m);
                },
                messages: allMessages,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
