import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/cartController.dart';
import '../controllers/orderController.dart';
import '../models/order.dart';

class HomepageScreen extends ConsumerStatefulWidget {
  const HomepageScreen({Key? key}) : super(key: key);

  @override
  HomepageScreenState createState() => HomepageScreenState();
}

class HomepageScreenState extends ConsumerState<HomepageScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(orderProvider.notifier).fetchOrder();
    ref.read(cartProvider.notifier).fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                ref.refresh(orderFetched);
                ref.refresh(cartFetched);
              },
              icon: const Icon(Icons.refresh),
            ),
          ],
          bottom: TabBar(
            automaticIndicatorColorAdjustment: true,
            indicatorWeight: 4.0,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: Theme.of(context).textTheme.headline6,
            unselectedLabelColor: Colors.indigo.shade200,
            isScrollable: true,
            tabs: const [
              Tab(
                text: 'Pending Order',
              ),
              Tab(
                text: 'Accepted Order',
              ),
              Tab(
                text: 'Completed Order',
              ),
              Tab(
                text: 'Cancelled Order',
              ),
              Tab(
                text: 'All Order',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ref.watch(orderFetched).when(
                  data: (data) {
                    data = data
                        .where((element) => element.status == 'Pending')
                        .toList();
                    return allorder(data, mediaQuery, context);
                  },
                  error: (e, s) => const Text('No Internet Connection'),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 0.6,
                    ),
                  ),
                ),
            ref.watch(orderFetched).when(
                  data: (data) {
                    data = data
                        .where((element) => element.status == 'Accepted')
                        .toList();
                    return allorder(data, mediaQuery, context);
                  },
                  error: (e, s) => const Text('No Internet Connection'),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 0.6,
                    ),
                  ),
                ),
            ref.watch(orderFetched).when(
                  data: (data) {
                    data = data
                        .where((element) => element.status == 'Completed')
                        .toList();
                    return allorder(data, mediaQuery, context);
                  },
                  error: (e, s) => const Text('No Internet Connection'),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 0.6,
                    ),
                  ),
                ),
            ref.watch(orderFetched).when(
                  data: (data) {
                    data = data
                        .where((element) => element.status == 'Cancelled')
                        .toList();
                    return allorder(data, mediaQuery, context);
                  },
                  error: (e, s) => const Text('No Internet Connection'),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 0.6,
                    ),
                  ),
                ),
            ref.watch(orderFetched).when(
                  data: (data) {
                    return allorder(data, mediaQuery, context);
                  },
                  error: (e, s) => const Text('No Internet Connection'),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 0.6,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  RefreshIndicator allorder(
      List<Order> data, Size mediaQuery, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.refresh(orderFetched);
        ref.refresh(cartFetched);
      },
      child: ListView.builder(
        itemBuilder: (c, i) {
          var _carts =
              ref.read(cartProvider.notifier).findItem(int.parse(data[i].id));

          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: mediaQuery.width * 0.02,
              vertical: mediaQuery.height * 0.013,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: mediaQuery.width * 0.02,
              vertical: mediaQuery.height * 0.013,
            ),
            height: mediaQuery.height * 0.28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.grey.shade100,
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(31, 20, 20, 20),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data[i].title,
                  style: Theme.of(context).textTheme.headline3,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: mediaQuery.height * 0.1,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (c, i) {
                        return Card(
                          elevation: 10.0,
                          shadowColor: Colors.grey.shade50,
                          margin: const EdgeInsets.all(8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    _carts[i].title,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0),
                                  child: Text(
                                    'Quantity: ${_carts[i].quantity}',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: _carts.length,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Text(
                        'Status: ',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                        data[i].status,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.indigo,
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.all(
                            mediaQuery.height * 0.01,
                          ),
                        ),
                        onPressed: () {
                          ref
                              .read(orderProvider.notifier)
                              .updateOrder(data[i].id, 'Accepted');
                          ref.refresh(orderFetched);
                          ref.refresh(cartFetched);
                        },
                        child: Text(
                          'Accepted',
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.all(
                            mediaQuery.height * 0.01,
                          ),
                        ),
                        onPressed: () {
                          ref
                              .read(orderProvider.notifier)
                              .updateOrder(data[i].id, 'Completed');
                          ref.refresh(orderFetched);
                          ref.refresh(cartFetched);
                        },
                        child: Text(
                          'Completed',
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.all(
                            mediaQuery.height * 0.01,
                          ),
                        ),
                        onPressed: () {
                          ref
                              .read(orderProvider.notifier)
                              .updateOrder(data[i].id, 'Cancelled');
                          ref.refresh(orderFetched);
                          ref.refresh(cartFetched);
                        },
                        child: Text(
                          'Cancelled',
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: data.length,
      ),
    );
  }
}
