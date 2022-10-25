import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class UserController extends StateNotifier<List<User>> {
  UserController(List<User> state) : super(state);

  static int id = 0;

  static String token = '';
  static String photopath = '';
  static String message = '';
  static String name = '';

  String url = "https://www.digitalmenu.bitmapitsolution.com/api/596810BITS/";

  var client = http.Client();

  Future<int> login(String email, String password, String tokens) async {
    final jsons = {'email': email, 'password': password, 'deviceToken': tokens};

    final response = await http.post(
      Uri.parse('${url}login'),
      headers: {'Accept': 'application/json'},
      body: jsons,
    );

    var body = json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 201) {
      state.clear();
      state.add(
        User(
          id: body['user']['id'],
          name: body['user']['name'],
          photoPath: body['user']['photopath'] ?? '',
          token: body['token'],
        ),
      );

      id = body['user']['id'];
      name = body['user']['name'];
      token = body['token'];
      photopath = body['user']['photopath'] ?? '';
    }
    message =
        body['message'].toString().replaceAll('[', '').replaceAll(']', '');

    return response.statusCode;
  }

  logout() async {
    final urls = Uri.parse('${url}logout');

    await client.post(urls, headers: {
      'Authorization': 'Bearer ${state[0].token}',
    });
  }
}

final userProvider = StateNotifierProvider<UserController, List<User>>((ref) {
  return UserController([]);
});
