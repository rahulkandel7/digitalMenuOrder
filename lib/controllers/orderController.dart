import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/order.dart';
import 'userController.dart';

class OrderController extends StateNotifier<List<Order>> {
  OrderController(List<Order> state) : super(state);

  String url =
      "https://www.digitalmenu.bitmapitsolution.com/api/596810BITS/order/${UserController.id}";

  var client = http.Client();

  Future<List<Order>> fetchOrder() async {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${UserController.token}',
      },
    );
    final parsed = json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      state.clear();

      parsed.forEach((key, value) {
        state.add(
          Order(
            id: value['id'].toString(),
            title: value['table'],
            status: value['status'],
          ),
        );
      });
    }

    return state;
  }

  Future<void> updateOrder(String id, String status) async {
    final response = await client.post(
      Uri.parse(
          "https://www.digitalmenu.bitmapitsolution.com/api/596810BITS/order/update"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${UserController.token}',
      },
      body: jsonEncode(
        {
          'orderid': id,
          'status': status,
        },
      ),
    );

    print(response.body);

    if (response.statusCode == 200) {
      fetchOrder();
    }
  }
}

final orderProvider =
    StateNotifierProvider<OrderController, List<Order>>((ref) {
  return OrderController([]);
});

final orderFetched = FutureProvider((ref) {
  return ref.watch(orderProvider.notifier).fetchOrder();
});
