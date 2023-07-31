import 'package:flutter/material.dart';
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
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ChattingScreen(),
    ChattingScreen(),
    Page1Screen(),
    Page2Screen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(),
        drawer: DrawerMenu(),
        body: _pages[_selectedIndex],
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
                        "https://s3-alpha-sig.figma.com/img/48ae/07a6/0facdf382e94bdcfad0d459a3f98cd84?Expires=1690761600&Signature=WiL9LUXu1vsKZRwywGPu~ILDNPn4cjQxN7lx094u1twevmHlDfq~sr77QZXbf8ByOzgPWYTYT4NFzP~TuQoAPzjxjVdT-4LtSUi2QoctHRYFNIVu4DZQqsqsWms6sjVCMaVH8tbTL2dL6CxPTTPopsfzhJn9OjfdGTlfEgOTH~ew8hyTtZEPx-hkBMf3CJDMq~6X~gPVCl65H0h0iry458Ovb-DTtRQw7RUHttFrZahsnOJxTfTlfCIdKFDoawkJE5PMe89AZ3UTPi-SWiXmLiyhsZ1nxeqKh-iXoPlfGFoOTPV5rBRZBOarxj8efQj40L66pBUNI5dDCn4Eobrtog__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4",
                        width: 25,
                        height: 25,
                        fit: BoxFit.fill,
                      ),
                      onPressed: _userEnteredMessage.trim().isEmpty
                          ? null
                          : _handleSubmitted),
                ))
          ],
        ),
      ),
    );
  }

  void _handleSubmitted() {
    FirebaseFirestore.instance.collection('chat').add(
        {'text': _userEnteredMessage, 'time': Timestamp.now(), 'isUser': true});
    debugPrint("get response");
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
  const ChatTitle({
    super.key,
  });

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
    return Row(
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
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

// 페이지 1 화면
class Page1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('페이지 1'),
    );
  }
}

// 페이지 2 화면
class Page2Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('페이지 2'),
    );
  }
}
