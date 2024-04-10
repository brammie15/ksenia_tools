import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksenia_tools/nfcUtils.dart';
import 'package:ksenia_tools/secretPage.dart';
import 'package:ksenia_tools/settingsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'catUtils.dart';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late SharedPreferences prefs;
  bool useMaterial3 = false;

  @override
  void initState() {
    super.initState();
  }

  Future loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    bool temp = prefs.getBool("useMaterial3") ?? false;
    setState(() {
      useMaterial3 = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: useMaterial3,
      ),
      home: const Homepage(title: 'Ksenia Tools'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key, required this.title});

  final String title;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String nfcData = "";
  String noTagMessage = "No Tag Detected!";

  Cat? topCat;
  Cat? bottomCat;

  String topUrl = "";
  String bottomUrl = "";

  bool enableCopyButton = false;

  @override
  void initState() {
    super.initState();
    loadCat();

    tagRead((tag) {
      String data = convertTagToKseniaFormat(tag.data);
      loadCat();
      if (kDebugMode) {
        print("Tag Scanned");
      }

      setState(() {
        enableCopyButton = true;
        nfcData = data;
      });
    });
  }

  void loadCat() async {
    Cat temp1 = await fetchCat();
    Cat temp2 = await fetchCat();
    String baseUrl = "https://cataas.com/cat/";

    setState(() {
      topCat = temp1;
      topUrl = baseUrl + temp1.id;
      print(topUrl);
      bottomCat = temp2;
      bottomUrl = baseUrl + temp2.id;
    });
  }

  // Future<ImageProvider> getImageFromCat(Cat cat) async {
  //   String baseUrl = "https://cataas.com/cat/";
  //   String id = cat.id;
  //   NetworkImage? image = NetworkImage(baseUrl + id);
  //   if(image == null){
  //     return Image(image: AssetImage("assets/404.jpg"));
  //   }
  // }

  Widget buildCatImage(String url) {
    return Image
        .network(url,
        height: MediaQuery.of(context)
        .size
        .height * 0.22,
    errorBuilder: (context, error, stackTrace) {
    return Image(
    image: const AssetImage("assets/404.jpg"),
    height: MediaQuery
        .of(context)
        .size
        .height * 0.22,
    );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: MediaQuery
                .of(context)
                .size
                .height *
                0.1, // 10% of screen height
            child: const Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Center(
                    child: Text("Scan a tag!", style: TextStyle(fontSize: 40)),
                  ),
                ),
                SizedBox(
                  height: 0,
                  child: Divider(
                    indent: 20,
                    endIndent: 20,
                    thickness: 1,
                  ), //overflow fix
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildCatImage(topUrl),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    nfcData != "" ? nfcData + nfcData : noTagMessage,
                    style: const TextStyle(fontSize: 35),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                    onLongPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SecretPage()));
                    },
                    onPressed: !enableCopyButton ? null : () {
                      Clipboard.setData(ClipboardData(text: nfcData + nfcData));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[600],
                      disabledBackgroundColor: Colors.orange.shade100
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        "Copy to Clipboard",
                        style: TextStyle(fontSize: 20),
                      ),
                    )),
                buildCatImage(bottomUrl),
              ],
            ),
          )
        ],
      ),
    );
  }
}
