import 'dart:convert';

import 'package:chzzk_remote_controller/bloc/chzzk/chzzk_bloc.dart';
import 'package:chzzk_remote_controller/models/chat_model.dart';
import 'package:chzzk_remote_controller/models/chzzk_model.dart';
import 'package:chzzk_remote_controller/providers/chzzk_provider.dart';
import 'package:chzzk_remote_controller/repository/chzzk_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chzzk Chat Testing',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(255, 255, 255, 1.0),
          primary: Color.fromRGBO(0, 255, 163, .9),
          secondary: Color.fromRGBO(65, 39, 118, 1.0),
          background: Color.fromRGBO(20, 21, 23, 1.0),
        ),
        textTheme: TextTheme(
            displayMedium: TextStyle(
                fontSize: 15,
                height: 1.25,
                color: Color.fromRGBO(255, 255, 255, 1.0)),
            bodyMedium: TextStyle(
                fontSize: 15,
                height: 1.25,
                color: Color.fromRGBO(255, 255, 255, 1.0))),
        fontFamily: 'Pretendard',
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Chzzk Chat Testing'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController inputController = TextEditingController();
  late WebSocketChannel webSocketChannel;
  ScrollController chatListScrollController = ScrollController();
  ScrollController donationListScrollController = ScrollController();

  bool _ready = false;

  final provider = ChzzkProvider();

  List<ChatMessageDataModel> chatList = [];
  List<ChatMessageDataModel> donationList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: SvgPicture.asset(
          'assets/images/logo.svg',
          width: 91,
          height: 30,
          fit: BoxFit.fitHeight,
        ),
      ),
      body: _bodyContainer(),
    );
  }

  Widget _bodyContainer() {
    return BlocProvider(
      create: (context) => ChzzkBloc(ChzzkRepository()),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: inputController,
                    decoration: const InputDecoration(
                      labelText: 'Channel URI',
                      hintText: 'Enter your Channel',
                      labelStyle: TextStyle(color: Colors.redAccent),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                            BorderSide(width: 1, color: Colors.redAccent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                            BorderSide(width: 1, color: Colors.redAccent),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_ready) {
                        webSocketChannel.sink.close();
                        setState(() {
                          _ready = false;
                        });
                        return;
                      }

                      ChzzkAPICommonModel<ChzzkLiveDetail> liveDetail =
                          await provider.getLiveDetail(inputController.text);
                      ChzzkAPICommonModel<ChzzkAccessToken> accessToken =
                          await provider.getChatAccessToken(
                              inputController.text,
                              liveDetail.content.chatChannelId,
                              'STREAMING');
                      webSocketChannel = WebSocketChannel.connect(Uri.parse(
                          'wss://${chzzkChatSessionServerList[1]}/chat'));
                      await webSocketChannel.ready;

                      debugPrint('@debug->connected!!');
                      webSocketChannel.stream.listen((message) {
                        ChatResponseModel response =
                            ChatResponseModel.fromJson(jsonDecode(message));
                        try {
                          switch (response.cmd) {
                            case 0:
                              webSocketChannel.sink.add(jsonEncode({
                                'ver': '2',
                                'cmd': 10000,
                              }));
                              break;
                            case 100:
                              break;

                            case 93101:
                            case 93102:
                              ChatMessageResponseModel<
                                      List<ChatMessageDataModel>> data =
                                  ChatMessageResponseModel.fromJson(
                                      jsonDecode(message),
                                      (p0) => List.from(p0)
                                          .map((e) =>
                                              ChatMessageDataModel.fromJson(e))
                                          .toList());

                              setState(() {
                                for (var element in data.bdy) {
                                  if (element.extras?.payAmount != null) {
                                    donationList.add(element);
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((timeStamp) {
                                      donationListScrollController.animateTo(0,
                                          duration:
                                              const Duration(milliseconds: 1),
                                          curve: Curves.linear);
                                    });
                                  } else {
                                    chatList.add(element);
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((timeStamp) {
                                      chatListScrollController.animateTo(
                                          chatListScrollController
                                              .position.maxScrollExtent,
                                          duration:
                                              const Duration(milliseconds: 1),
                                          curve: Curves.linear);
                                    });
                                  }
                                }
                              });
                              break;

                            /// 연결완료
                            case 10100:
                              setState(() {
                                _ready = true;
                              });
                              break;
                          }
                        } catch (e) {
                          debugPrint('@error->$e');
                          debugPrint('@debug->$message');
                        }
                      });

                      webSocketChannel.sink.add(jsonEncode({
                        'ver': '2',
                        'cmd': 100,
                        'svcid': 'game',
                        'cid': liveDetail.content.chatChannelId,
                        'bdy': {
                          'uid': null,
                          'devType': 2001,
                          'accTkn': accessToken.content.accessToken,
                          'auth': 'READ'
                        },
                        'tid': 1,
                      }));

                      setState(() {});
                    },
                    child: Text(_ready ? 'Disconnect' : 'Connect'),
                  ),
                )
              ],
            ),
            Expanded(
                child: Row(
              children: [
                SizedBox(
                    width: MediaQuery.sizeOf(context).width / 2,
                    child: ListView.builder(
                        controller: chatListScrollController,
                        itemCount: chatList.length,
                        itemBuilder: (ctx, index) {
                          var chatData = chatList[index];
                          return Row(
                            children: [
                              // chatData.profile.profileImageUrl != null
                              //     ? Image.network(chatData.profile.profileImageUrl!)
                              //     : const SizedBox(),
                              Text('${chatData.profile.nickname} : '),
                              Text(chatData.msg)
                            ],
                          );
                        })),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width / 2,
                  child: ListView.builder(
                      controller: donationListScrollController,
                      itemCount: donationList.length,
                      reverse: true,
                      itemBuilder: (ctx, index) {
                        var donationData = donationList[index];
                        return Container(
                          color: Theme.of(context).colorScheme.secondary,
                          padding: EdgeInsets.fromLTRB(6, 4, 6, 4),
                          child: Column(
                            children: [
                              Text(donationData.profile.nickname),
                              Text(donationData.msg),
                              Text(donationData.extras!.payAmount.toString())
                            ],
                          ),
                        );
                      }),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    webSocketChannel.sink.close();
    chatListScrollController.dispose();
    donationListScrollController.dispose();
    inputController.dispose();
    super.dispose();
  }
}
