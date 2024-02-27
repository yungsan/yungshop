import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:nguyen_manh_dung/models/cart.dart';
import 'package:nguyen_manh_dung/skeletons/product_detail.dart';
import 'package:nguyen_manh_dung/widgets/text.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    super.key,
    required this.id,
  });

  final String id;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late String _productName;

  late String _productThumbnail;

  late String _productId;

  late int _productPrice;

  int _quantity = 1;

  int _currentSize = 0;

  final List<String> _sizeName = ['S', 'M', 'L', 'XL', '2XL', '3XL'];

  final List<bool> _sizeBoolList = [true, false, false, false, false, false];

  final formatCurrency = NumberFormat.currency(locale: 'vi');

  final _auth = FirebaseAuth.instance;

  final _fs = FirebaseFirestore.instance;

  late Future _data;

  int getTotalPrice(int productPrice, int quantity) {
    return (productPrice * quantity);
  }

  void _showSnackbar(text) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      content: MyText(text: text),
      action: SnackBarAction(label: 'Done', onPressed: () {}),
    ));
  }

  Future _getData(String id) async {
    return await _fs
        .collection('products')
        .doc(id)
        .get(const GetOptions(source: Source.cache));
  }

  Future<void> _addToCart() async {
    String? uid = _auth.currentUser?.uid;
    try {
      final cart = await _fs
          .collection('carts')
          .where('user_id', isEqualTo: uid)
          .where('product_id', isEqualTo: _productId)
          .where('size', isEqualTo: _sizeName[_currentSize])
          .get();
      if (cart.size == 0) {
        final data = Cart(
          userId: uid,
          productId: _productId,
          productName: _productName,
          productPrice: _productPrice,
          productThumbnail: _productThumbnail,
          quantity: _quantity,
          size: _sizeName[_currentSize],
        ).toMap();
        await _fs.collection('carts').add(data);
        _showSnackbar('Add to Cart successfully!');
      } else {
        final cartId = cart.docs[0].id;
        await _fs
            .collection('carts')
            .doc(cartId)
            .update({'quantity': cart.docs[0]['quantity'] + _quantity});
        print('Update cart successfully');
      }
    } catch (e) {
      print('Add to cart Error: $e');
    }
  }

  @override
  void initState() {
    _productId = widget.id;
    _data = _getData(_productId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return const CircularProgressIndicator();
          return const ProductDetailSkeleton();
        }
        _productThumbnail = snapshot.data?['product_thumbnail'];
        _productPrice = snapshot.data?['product_price'];
        _productName = snapshot.data?['product_name'];
        return Scaffold(
          extendBody: true,
          appBar: appBar(context),
          bottomNavigationBar: getBottomNavBar(context),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                thumbnail(_productThumbnail),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 0, left: 20, right: 20, bottom: 150),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      categoryAndRate('unisex style', 4.5),
                      productName(_productName),
                      sizes(),
                      selectedColor(context),
                      const Divider(color: Colors.black12, height: 30),
                      description(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getBottomNavBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(width: 1, color: Colors.black26)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 0),
          )
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: formatCurrency.format(_productPrice),
                  style: const TextStyle(
                    color: Color(0xFF944A01),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              getBottomSheet(context);
            },
            icon: const Icon(Iconsax.shopping_bag5),
            label: const MyText(
              text: 'Add to Cart',
              color: Colors.white,
              fs: 18,
              fw: FontWeight.normal,
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
              iconColor: MaterialStateProperty.all(Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> getBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SizedBox(
                width: double.infinity,
                height: 250,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                    'assets/images/$_productThumbnail')),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(text: _productName, fs: 16),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: MyText(
                                      text: 'Size: ${_sizeName[_currentSize]}',
                                      color: Colors.black45),
                                ),
                                MyText(
                                    text: formatCurrency.format(getTotalPrice(
                                        _productPrice, _quantity)),
                                    fs: 16),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (_quantity == 1) return;
                                        setState(() {
                                          _quantity--;
                                        });
                                      },
                                      icon: Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(Iconsax.minus),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: MyText(
                                          text: _quantity.toString(),
                                          fs: 18,
                                          fw: FontWeight.w600),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _quantity++;
                                        });
                                      },
                                      icon: Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(Iconsax.add,
                                            color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _addToCart,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.primary),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15)),
                          ),
                          child: const MyText(
                              text: 'Add to Cart',
                              fs: 18,
                              fw: FontWeight.normal,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ));
          });
        });
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const MyText(text: 'Product Details', fs: 18),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      actions: [actionItem()],
    );
  }

  Widget productName(String productName) {
    return MyText(
      text: productName,
      fs: 20,
      fw: FontWeight.w600,
      top: 10,
      bottom: 10,
    );
  }

  Widget selectedColor(BuildContext context) {
    return Row(
      children: [
        const MyText(
          text: 'Select Color: ',
          fs: 18,
          fw: FontWeight.w500,
          top: 20,
          bottom: 5,
        ),
        MyText(
          text: 'Brown',
          color: Theme.of(context).colorScheme.primary,
          fs: 18,
          fw: FontWeight.w900,
          top: 15,
        )
      ],
    );
  }

  Widget categoryAndRate(String category, double rate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyText(
          text: category.toUpperCase(),
          color: Colors.grey,
          fw: FontWeight.w400,
        ),
        Row(
          children: [
            const Icon(Iconsax.star1, size: 25, color: Colors.amber),
            MyText(text: rate.toString(), color: Colors.grey, fs: 16)
          ],
        ),
      ],
    );
  }

  Widget description() {
    return const Wrap(
      children: [
        MyText(
          text: 'Product Details',
          fs: 18,
          fw: FontWeight.w500,
          top: 10,
          bottom: 5,
        ),
        Text.rich(
          style: TextStyle(fontSize: 16, color: Colors.black45),
          TextSpan(
            children: [
              TextSpan(
                  text:
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam "),
              TextSpan(
                text: "Read more",
                style: TextStyle(
                  color: Color(0xFF944A01),
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xff944a01),
                  decorationThickness: 2,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget sizes() {
    return Wrap(children: [
      const MyText(
        text: 'Select Size',
        fs: 18,
        fw: FontWeight.w500,
        top: 10,
        bottom: 5,
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ToggleButtons(
            isSelected: _sizeBoolList,
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < _sizeBoolList.length; i++) {
                  _sizeBoolList[i] = (i == index);
                  if (i == index) _currentSize = i;
                }
              });
            },
            fillColor: Colors.transparent,
            renderBorder: false,
            selectedColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.w500),
            splashColor: Colors.transparent,
            children: List.generate(
              _sizeBoolList.length,
              (index) => Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                margin: const EdgeInsets.only(right: 10, top: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: index == _currentSize
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                  color: index == _currentSize
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                ),
                child: Text(_sizeName[index]),
              ),
            )),
      ),
    ]);
  }

  Widget thumbnail(String thumbnail) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xffEEE5DB)),
      child: Image.asset('assets/images/$thumbnail'),
    );
  }

  Widget actionItem() {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(50.0)),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: const IconButton(
          icon: Icon(Iconsax.heart, color: Colors.black, size: 25),
          onPressed: null,
        ),
      ),
    );
  }
}
