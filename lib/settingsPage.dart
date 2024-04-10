import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SettingsRepository {
  final SharedPreferences preferences;

  SettingsRepository({required this.preferences});

  bool? getUseMaterial3() {
    return preferences.getBool("useMaterial3") ?? false;
  }

  Future setUseMaterial3(bool useMaterial3) {
    return preferences.setBool("useMaterial3", useMaterial3);
  }

}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool makeNoise = false;
  bool initialised = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("useMaterial3", makeNoise);
  }

  Future loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool temp = prefs.getBool("useMaterial3") ?? false;
    setState(() {
      makeNoise = temp;
      initialised = true;
    });

  }

  @override
  Widget build(BuildContext context) {
    if(!initialised){
      return CircularProgressIndicator();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Settings Page"),
        leading: BackButton(),

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SettingsList(
            shrinkWrap: true,
            sections: [
              SettingsSection(
                title: const Text('Common'),
                tiles: <SettingsTile>[
                  SettingsTile.switchTile(
                    onToggle: (value) {
                      setState(() {
                        makeNoise = value;
                      });
                      saveData();
                    },
                    initialValue: makeNoise,
                    leading: const Icon(Icons.audiotrack),
                    title: const Text('Make sound (WIP)'),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 20,),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Version 1.0"),
          )
        ],
      ),

    );
  }
}
