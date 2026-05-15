import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:social_login/asset.dart';
import 'package:social_login/constants.dart';

class ChatGptFlutter extends StatefulWidget {
  const ChatGptFlutter({super.key});

  @override
  State<ChatGptFlutter> createState() => _ChatGptFlutterState();
}

class _ChatGptFlutterState extends State<ChatGptFlutter> {
  // for call api we use this
  final openAI = OpenAI.instance.build(
    token: Constant.openAIKey,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 15),
    ),
    enableLog: true,
  );

  //for currentUser
  final ChatUser currentUser = ChatUser(
    id: '1',
    firstName: 'John',
    lastName: 'Sharma',
    profileImage: Assets.chatSvg,
  );
// for chat gpt user.
  final ChatUser currentChatGptUser = ChatUser(
    id: '2',
    firstName: 'chat',
    lastName: 'gpt',
    profileImage:
        'https://t4.ftcdn.net/jpg/04/48/05/77/360_F_448057700_kIiPhMzOa2K0xAwxKAgyWpBLsEBGEZ2j.jpg',
  );

  // for message list.
  List<ChatMessage> messages = <ChatMessage>[];
  // use to show the typing arrow
  List<ChatUser> typingUsers = <ChatUser>[];

// for send message
  Future<void> getChatGptResponse(ChatMessage message) async {
    setState(() {
      messages.insert(0, message);
      typingUsers.add(currentChatGptUser);
    });
    List<Messages> messageHistory = messages.reversed.map((m) {
      if (m.user == currentUser) {
        return Messages(role: Role.user, content: m.text);
      } else {
        return Messages(role: Role.assistant, content: m.text);
      }
    }).toList();

    //send data.
    final request = ChatCompleteText(
      model: GptTurboChatModel(),
      messages: messageHistory,
      maxToken: 200,
    );
    final response = await openAI.onChatCompletion(
      request: request,
    );
    // loop for get actual messages.
    for (var element in response!.choices) {
      if (element.message != null) {
        setState(() {
          messages.insert(
            0,
            ChatMessage(
                user: currentChatGptUser,
                createdAt: DateTime.now(),
                text: element.message!.content),
          );
        });
      }
    }
    setState(() {
      typingUsers.remove(currentChatGptUser);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('init call');
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('deactivate call');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('dispose call');
  }

  @override
  void didChangeDependencies() {
    print('didChange  call');

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    print('didUpdate call');

    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'chat GPT flutter',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: DashChat(
          currentUser: currentUser,
          typingUsers: typingUsers,
          messageOptions: const MessageOptions(
            currentUserContainerColor: Colors.lightGreen,
            containerColor: Colors.green,
            textColor: Colors.white,
            showCurrentUserAvatar: true,
            showOtherUsersAvatar: true,
          ),
          onSend: getChatGptResponse,
          messages: messages),
    );
  }
}
