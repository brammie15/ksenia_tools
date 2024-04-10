
import 'dart:async';

import 'package:nfc_manager/nfc_manager.dart';

typedef TagReadCallback = void Function(NfcTag tag);

String convertTagToKseniaFormat(Map<String, dynamic> tagData){
  List<int> ints = tagData["nfca"]["identifier"];
  List<String> hexes = List.empty(growable: true);
  for (var element in ints) {
    hexes.add(element.toRadixString(16));
  }
  String finalString = "";
  for (var element in hexes) {
    finalString += element.toString();
  }
  return finalString.toUpperCase();
  //God i hope i wrote this right
}

void tagRead(TagReadCallback onTagRead) {
  NfcManager.instance.startSession(onDiscovered: (tag) async {
    onTagRead(tag);
  }, alertMessage: "Reading a tag!");
}