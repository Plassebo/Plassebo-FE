import 'package:flutter/material.dart';
import 'package:plassebo_flutter/screens/favorites.dart';
import 'package:plassebo_flutter/screens/myinfo.dart';
import 'package:plassebo_flutter/screens/nearby.dart';
import 'package:plassebo_flutter/widgets/header.dart';
import 'package:plassebo_flutter/widgets/drawer_menu.dart';
import 'package:plassebo_flutter/widgets/footer.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:plassebo_flutter/data/provider/rule_chat.dart';

class Chatting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ContainerScreen();
  }
}

class ContainerScreen extends StatefulWidget {
  @override
  _ContainerScreen createState() => _ContainerScreen();
}

class _ContainerScreen extends State<ContainerScreen> {
  int _selectedIndex = -1;

  final List<Widget> _pages = [
    MyInfo(),
    NearBy(),
    Favorites(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      debugPrint(index.toString());
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(),
        drawer: DrawerMenu(),
        body: _selectedIndex == -1
            ? ChattingScreen()
            : _pages.elementAt(_selectedIndex),
        bottomNavigationBar: Footer(
          onItemTapped: _onItemTapped,
          pages: _pages,
          selectedIndex: _selectedIndex,
        ));
  }
}

class ChattingScreen extends StatefulWidget {
  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final TextEditingController _textController = TextEditingController();
  var _userEnteredMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [Expanded(child: ChatContainer()), _chattingField()],
      ),
    );
  }

  Widget _chattingField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Color(0xFFFFFFFF),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: Offset(8, 8),
              )
            ]),
        margin: const EdgeInsets.symmetric(horizontal: 36),
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                decoration:
                    InputDecoration.collapsed(hintText: "원하는 맛집에 대해 물어보세요!"),
                onChanged: (val) {
                  _userEnteredMessage = val;
                },
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Transform.rotate(
                  angle: 0.8,
                  child: IconButton(
                      icon: Image.network(
                        "https://s3-alpha-sig.figma.com/img/48ae/07a6/0facdf382e94bdcfad0d459a3f98cd84?Expires=1691971200&Signature=Df81~cbTpwILKTb8Vuw2BVcc0dgOH02ckHWSYDHuSUm7F3PKHmL6PVeT4QGOOpwU6duh2cziVuUMIKDVNDNd1FZhJ7KD7l-uu8uDDLN4aXXXskfQRn2swdxgRxbR88wfGF01gn5ORHXZK8SiSnBXGBFPEPQca3c8k2Vzt~sqkZCUumtP22-nMqJEDfqemTzPAzUtXnHa~xV5kXaHi5L4GQhDbymQpKIUYydq8PrZqzRv16HG4BEvWMypOxpUhj-v-qWvwM0TRgt~Xc5kqdM0IwU1TqsGb2aPvVZrxpRVQIyMd87g0G9VJrBdTMjN3zmPSTa6zKPpb-FUsaHCmj3Biw__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4",
                        width: 25,
                        height: 25,
                        fit: BoxFit.fill,
                      ),
                      onPressed: _userEnteredMessage.isEmpty
                          ? () {
                              debugPrint(_userEnteredMessage.trim());
                              debugPrint("enter something");
                            }
                          : _handleSubmitted),
                ))
          ],
        ),
      ),
    );
  }

  void _handleSubmitted() {
    debugPrint("handle submit");
    FirebaseFirestore.instance.collection('chat').add(
        {'text': _userEnteredMessage, 'time': Timestamp.now(), 'isUser': true});

    getResponse(_userEnteredMessage);
    _textController.clear();
  }
}

class ChatContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chat")
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final chatDocs = snapshot.data!.docs;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (context, index) {
                  return chatDocs[index]['isUser']
                      ? MyChat(chat: chatDocs[index]['text'])
                      : BotChat(chat: chatDocs[index]['text']);
                }),
          );
        });
  }
}

class ChatTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          "해운대 맛집",
          style: TextStyle(
              color: Color(0xFF797979),
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class BotChat extends StatelessWidget {
  final String chat;
  const BotChat({required this.chat});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFF608CFF),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Text(chat,
                style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF)))),
      ],
    );
  }
}

class MyChat extends StatelessWidget {
  final String chat;
  const MyChat({required this.chat});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFDCE6FF),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: Text(chat,
              style: TextStyle(fontSize: 18, color: Color(0xFF292929))),
        )
      ],
    );
  }
}
