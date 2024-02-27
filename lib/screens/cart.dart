import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nguyen_manh_dung/skeletons/product_detail.dart';
import 'package:nguyen_manh_dung/widgets/text.dart';
import 'package:intl/intl.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

  late Future _data;

  Future _getData() async {
    return await FirebaseFirestore.instance
        .collection('carts')
        .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
  }

  void reload() {
    print('deleted cart');
    setState(() {
      _data = _getData();
    });
  }

  @override
  void initState() {
    _data = _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: MyText(text: 'My Cart', fs: 20)),
        automaticallyImplyLeading: false,
      ),
      // bottomNavigationBar: Container(
      //   color: Colors.red,
      //   height: 250,
      // ),
      body: FutureBuilder(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ProductDetailSkeleton();
          }
          if (!snapshot.hasData) {
            return const Center(child: MyText(text: 'No Data...'));
          }
          final List<QueryDocumentSnapshot<Map<String, dynamic>>>? items =
              snapshot.data?.docs;
          return Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: items?.length,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemBuilder: (context, index) {
                return CartItem(data: items?[index], reload: reload);
              },
            ),
          );
        },
      ),
      // body: StreamBuilder(
      //   stream: _data,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const ProductDetailSkeleton();
      //     }
      //     if (!snapshot.hasData) {
      //       return const Center(child: MyText(text: 'No Data...'));
      //     }
      //     final List<QueryDocumentSnapshot<Map<String, dynamic>>>? items =
      //         snapshot.data?.docs;
      //     return Padding(
      //       padding: const EdgeInsets.only(bottom: 100),
      //       child: ListView.builder(
      //         scrollDirection: Axis.vertical,
      //         shrinkWrap: true,
      //         itemCount: items?.length,
      //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      //         itemBuilder: (context, index) {
      //           return CartItem(data: items?[index], reload: reload);
      //         },
      //       ),
      //     );
      //   },
      // ),
    );
  }
}

class CartItem extends StatefulWidget {
  const CartItem({super.key, required this.data, required this.reload});

  final QueryDocumentSnapshot<Map<String, dynamic>>? data;

  final Function reload;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  final _fs = FirebaseFirestore.instance.collection('carts');

  final formatCurrency = NumberFormat.currency(locale: 'vi');

  double _dx = 0.0;

  late String _productId;
  late String _productName;
  late int _productPrice;
  late String _productThumbnail;
  late String _productSize;
  late int _productQuantity;

  int getTotalPrice(int productPrice, int quantity) {
    return (productPrice * quantity);
  }

  void _increase() {
    _updateCartQuantity();
    setState(() {
      _productQuantity++;
    });
  }

  void _decrease() {
    if (_productQuantity <= 1) return;
    _updateCartQuantity();
    setState(() {
      _productQuantity--;
    });
  }

  Future<void> _updateCartQuantity() async {
    try {
      final cart = await _fs
          .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .where('product_id', isEqualTo: _productId)
          .where('size', isEqualTo: _productSize)
          .get();
      await _fs.doc(cart.docs[0].id).update({'quantity': _productQuantity});
      print('Update cart quantity successfully');
    } catch (e) {
      print('Update cart quanity failed: $e');
    }
  }

  Future<void> _deleteCart() async {
    try {
      final cart = await _fs
          .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .where('product_id', isEqualTo: _productId)
          .where('size', isEqualTo: _productSize)
          .get();
      await _fs.doc(cart.docs[0].id).delete();
      widget.reload();
      print('Delete cart successfully');
    } catch (e) {
      print('Delete cart failed: $e');
    }
  }

  @override
  void initState() {
    _productThumbnail = widget.data?['product_thumbnail'];
    _productPrice = widget.data?['product_price'];
    _productName = widget.data?['product_name'];
    _productSize = widget.data?['size'];
    _productQuantity = widget.data?['quantity'];
    _productId = widget.data?['product_id'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        setState(() {
          _dx = details.primaryVelocity! < 0 ? -20 : 0;
        });
      },
      child: Transform.translate(
        offset: Offset(_dx, 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset('assets/images/$_productThumbnail')),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(text: _productName, fs: 16),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: MyText(
                              text: 'Size: $_productSize',
                              color: Colors.black45),
                        ),
                        MyText(
                            text: formatCurrency.format(
                                getTotalPrice(_productPrice, _productQuantity)),
                            fs: 16),
                        Row(
                          children: [
                            IconButton.filled(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.black12)),
                              onPressed: _decrease,
                              icon: const Icon(
                                Iconsax.minus,
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 5, right: 5),
                              child: MyText(
                                  text: _productQuantity.toString(),
                                  fs: 18,
                                  fw: FontWeight.w600),
                            ),
                            IconButton.filled(
                              onPressed: _increase,
                              icon:
                                  const Icon(Iconsax.add, color: Colors.white),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: _dx < 0,
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: IconButton(
                          onPressed: () {
                            _deleteCart();
                          },
                          icon: const Icon(Iconsax.trash, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
