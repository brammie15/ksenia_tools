import 'dart:convert';

import 'package:http/http.dart' as http;

class Cat {
  final List<dynamic> tags;
  late final String id;

  Cat({
    required this.tags,
    required this.id,
  });

  Cat.fromJson(Map<String, dynamic> json) : id = json['_id'] as String, tags = json['tags'] as List<dynamic>;

}

Future<Cat> fetchCat() async {
  final response = await http
      .get(Uri.parse('https://cataas.com/cat?json=true'));

  if (response.statusCode == 200) {
    return Cat.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load album');
  }
}