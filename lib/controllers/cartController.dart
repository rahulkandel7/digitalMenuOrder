import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/cart.dart';
import 'userController.dart';

class CartController extends StateNotifier<List<Cart>> {
  CartController(List<Cart> state) : super(state);

  String url =
      "https://www.digitalmenu.bitmapitsolution.com/api/596810BITS/order/${UserController.id}";

  var client = http.Client();

  Future<List<Cart>> fetchCart() async {
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
        for (var v in value['carts']) {
          state.add(
            Cart(
              id: v['id'].toString(),
              title: v['item_name'],
              orderid: v['order_id'].toString(),
              quantity: v['quantity'].toString(),
            ),
          );
        }
      });
    }

    return state;
  }

  List<Cart> findItem(int id) {
    return state.where((element) => int.parse(element.orderid) == id).toList();
  }
}

final cartProvider = StateNotifierProvider<CartController, List<Cart>>((ref) {
  return CartController([]);
});

final cartFetched = FutureProvider((ref) {
  return ref.watch(cartProvider.notifier).fetchCart();
});
