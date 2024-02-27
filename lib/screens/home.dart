import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nguyen_manh_dung/widgets/text.dart';
import 'package:nguyen_manh_dung/screens/product_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<String> _productTypes = [
    'All',
    'Newest',
    'Popular',
    'Man',
    'Woman'
  ];

  final List<bool> _typeSelections = [true, false, false, false, false];

  int _currentType = 0;

  final _searchController = TextEditingController();

  final formatCurrency = NumberFormat.currency(locale: 'vi');

  final _fs = FirebaseFirestore.instance;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: getLeading(),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        actions: [getNotification()],
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: getSearchBar(),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: ListView(
            padding: const EdgeInsets.only(left: 15, right: 15),
            children: [
              getCategories(),
              getProductTypes(),
              FutureBuilder(
                future: _fs.collection('products').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text('No data...');
                  }
                  final items = snapshot.data?.docs;
                  return getProducts(items);
                },
              )
              // StreamBuilder(
              //     stream: _fs.collection("products").snapshots(),
              //     builder: (context, snapshot) {
              //       if (!snapshot.hasData) {
              //         return const Text('No data...');
              //       }
              //       final items = snapshot.data?.docs;
              //       return getProducts(items);
              //     })
            ]),
      ),
    );
  }

  Widget getNotification() {
    return const Padding(
      padding: EdgeInsets.only(right: 20),
      child: IconButton.filled(
          onPressed: null,
          icon: Icon(
            Icons.notifications_active,
            size: 28,
            color: Colors.black,
          )),
    );
  }

  Widget getLeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.location_on_rounded,
                size: 30, color: Theme.of(context).colorScheme.primary),
            const MyText(text: 'New York, USA', fs: 20),
            Icon(Icons.keyboard_arrow_down,
                color: Theme.of(context).colorScheme.primary)
          ],
        ),
      ],
    );
  }

  Widget getSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Expanded(
        child: TextFormField(
          controller: _searchController,
          minLines: 1,
          obscureText: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300)),
            hintText: 'Search',
            hintStyle: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.normal),
            suffixIcon: IconButton.filled(
              onPressed: () {},
              icon: const Icon(Icons.tune, color: Colors.white),
              style: const ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getCategoryItem(String thumbnail, String name) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.grey.shade200),
            child: Image.asset('assets/images/$thumbnail', scale: 1.5),
          ),
          MyText(text: name, fw: FontWeight.w500),
          // ElevatedButton(
          //   onPressed: () {
          //     products.getData();
          //   },
          //   child: Text('adsas'),
          // )
        ],
      ),
    );
  }

  Widget getCategories() {
    return Wrap(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [MyText(text: 'Category', fs: 20), MyText(text: 'See all')],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getCategoryItem('shirt.png', 'T-Shirt'),
            getCategoryItem('pant.png', 'Pant'),
            getCategoryItem('dress.png', 'Dress'),
            getCategoryItem('jacket.png', 'Jacket'),
          ],
        )
      ],
    );
  }

  Widget getProductTypes() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Wrap(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MyText(text: 'Flash Sale', fs: 20),
              Row(
                children: [
                  MyText(
                    text: 'Closing in:  ',
                    color: Colors.grey.shade600,
                  ),
                  Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Center(child: MyText(text: '01'))),
                  const Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: MyText(text: ':', fw: FontWeight.w900)),
                  Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Center(child: MyText(text: '38'))),
                  const Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: MyText(text: ':', fw: FontWeight.w900)),
                  Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Center(child: MyText(text: '56')))
                ],
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ToggleButtons(
                isSelected: _typeSelections,
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < _typeSelections.length; i++) {
                      _typeSelections[i] = i == index;
                      if (i == index) {
                        _currentType = index;
                      }
                    }
                  });
                },
                fillColor: Colors.transparent,
                renderBorder: false,
                selectedColor: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.w500),
                splashColor: Colors.transparent,
                children: List.generate(
                  _productTypes.length,
                  (index) => Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 22),
                    margin: const EdgeInsets.only(right: 10, top: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: index == _currentType
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                      color: index == _currentType
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                    ),
                    child: Text(_productTypes[index]),
                  ),
                )),
          )
        ],
      ),
    );
  }

  Widget getProducts(data) {
    return Expanded(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 30,
          crossAxisSpacing: 20,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 1.7),
        ),
        itemCount: data.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(id: data[index].id),
              ),
            );
          },
          child: getSingleProduct(
            data[index]['product_thumbnail'],
            data[index]['product_name'],
            data[index]['product_price'],
          ),
        ),
      ),
    );
  }

  Widget getSingleProduct(String thumbnail, String name, int price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.amberAccent.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
            child: FittedBox(
              fit: BoxFit.fill,
              child: Image.asset('assets/images/$thumbnail'),
            ),
          ),
        ),
        Flexible(child: MyText(text: name, fs: 16, fw: FontWeight.w500)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              // text: '\$${price.toStringAsFixed(2)}',
              text: formatCurrency.format(price),
              fw: FontWeight.w600,
              fs: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            const Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  size: 18,
                  color: Colors.amber,
                ),
                MyText(
                    text: '4.9',
                    fs: 16,
                    fw: FontWeight.w400,
                    color: Colors.grey),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
