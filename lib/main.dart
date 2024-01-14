import 'dart:convert';

import 'package:chzzk_remote_controller/models/chat_model.dart';
import 'package:chzzk_remote_controller/models/chzzk_model.dart';
import 'package:chzzk_remote_controller/providers/chzzk_provider.dart';
import 'package:flutter/material.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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

  bool _ready = false;

  final provider = ChzzkProvider();

  List<ChatMessageDataModel> chatList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: inputController,
              decoration: const InputDecoration(
                labelText: 'Channel URI',
                hintText: 'Enter your Channel',
                labelStyle: TextStyle(color: Colors.redAccent),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(width: 1, color: Colors.redAccent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(width: 1, color: Colors.redAccent),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            ElevatedButton(
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
                    await provider.getChatAccessToken(inputController.text,
                        liveDetail.content.chatChannelId, 'STREAMING');
                webSocketChannel = WebSocketChannel.connect(
                    Uri.parse('wss://${chzzkChatSessionServerList[1]}/chat'));
                await webSocketChannel.ready;

                debugPrint('@debug->connected!!');
                webSocketChannel.stream.listen((message) {
                  ChatResponseModel response =
                      ChatResponseModel.formJson(jsonDecode(message));
                  switch (response.cmd) {
                    case 0:
                      webSocketChannel.sink.add(jsonEncode({
                        'ver': '2',
                        'cmd': 10000,
                      }));
                      break;
                    case 100:
                      break;

                    /// 단건
                    case 93101:

                    /// List 목록
                    case 93102:
                      ChatMessageResponseModel<List<ChatMessageDataModel>>
                          data = ChatMessageResponseModel.formJson(
                              jsonDecode(message),
                              (p0) => List.from(p0)
                                  .map((e) => ChatMessageDataModel.fromJson(e))
                                  .toList());

                      setState(() {
                        chatList.addAll(data.bdy);
                      });
                      break;

                    /// 연결완료
                    case 10100:
                      setState(() {
                        _ready = true;
                      });
                      break;
                  }
                  debugPrint('@debug->${message}');
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
            Expanded(
                child: ListView.builder(
                    itemCount: chatList.length,
                    itemBuilder: (ctx, index) {
                      var chatData = chatList[index];
                      return Row(
                        children: [Text(chatData.msg)],
                      );
                    }))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    webSocketChannel.sink.close();
    inputController.dispose();
    super.dispose();
  }
}
