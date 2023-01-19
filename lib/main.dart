import 'dart:convert';

import 'package:chat_gbt/apiKey.dart';
import 'package:chat_gbt/chatMessageWidget.dart';
import 'package:chat_gbt/modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

const backgroundcolor = Color(0xff343541);
const resultAreacolor = Color(0xff444654);

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bool isLoading;
  TextEditingController myController = TextEditingController();
  final myScrollController = ScrollController();
  final List<ChatMessage> message = [];
  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  Future<String> getResponse(String query) async {
    const apikey = apiSecretkey;
    var url = Uri.https("api.openai.com", "/v1/completions");

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $apikey",
    };

    final body = jsonEncode({
      "model": "text-davinci-003",
      "prompt": query,
      "temperature": 0,
      "max_tokens": 2000,
      "top_p": 1,
      "frequency_penalty": 0.0,
      "presence_penalty": 0.0
    });

    final response = await http.post(url, headers: headers, body: body);

    // Decode the response
    Map<String, dynamic> newResponse = jsonDecode(response.body);
    return newResponse['choices'][0]['text'];
  }

  // Future<String> genarateResponse(String prompt) async {
  //   final apiKey = apiSecretkey;
  //   var url = Uri.https("api.openai.com", "/v1/completions");
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $apiKey',
  //     },
  //     body: jsonEncode({
  //       'model': 'text-davinci-003',
  //       'prompt': prompt,
  //       'temperature': 0,
  //       'max_token': 2000,
  //       'top_p': 1,
  //       'frequency_penalty': 0.0,
  //       'presence_penalty': 0.0,
  //     }),
  //   );
  //   Map<String, dynamic> newresponse = jsonDecode(response.body);
  //   return newresponse['choices'][0]['text'];
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "OpenAI's ChatGPT Flutter",
              ),
            ),
            centerTitle: true,
            backgroundColor: backgroundcolor),
        backgroundColor: backgroundcolor,
        body: Column(
          children: [
            Expanded(child: resultContainer()),
            Visibility(
              visible: isLoading,
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                myTxtField(),
                submitButton(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Expanded myTxtField() {
    return Expanded(
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(color: Colors.white),
        controller: myController,
        decoration: const InputDecoration(
            fillColor: resultAreacolor,
            filled: true,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            disabledBorder: InputBorder.none),
      ),
    );
  }

  Widget submitButton() {
    return Visibility(
      visible: !isLoading,
      child: Container(
        color: Colors.black,
        child: IconButton(
            onPressed: () {
              setState(() {
                message.add(ChatMessage(
                    text: myController.text,
                    chatMessageType: ChatMessageType.user));
                isLoading = true;
              });
              var input = myController.text;

              myController.clear();
              Future.delayed(Duration(milliseconds: 50))
                  .then((value) => scrollDow());
              getResponse(input).then((value) {
                setState(() {
                  isLoading = false;
                  message.add(ChatMessage(
                      text: value, chatMessageType: ChatMessageType.bot));
                });
              });
              myController.clear();
              Future.delayed(Duration(milliseconds: 50)).then((value) {
                return scrollDow();
              });
            },
            icon: const Icon(
              Icons.send_rounded,
              color: Colors.white,
            )),
      ),
    );
  }

  void scrollDow() {
    myScrollController.animateTo(myScrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  ListView resultContainer() {
    return ListView.builder(
      controller: myScrollController,
      itemCount: message.length,
      itemBuilder: (context, index) {
        var messages = message[index];
        return ChatMessageWidget(
            chatMessageType: messages.chatMessageType, text: messages.text);
      },
    );
  }
}
