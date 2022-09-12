import 'package:etaseta_user/providers/cart_provider.dart';
import 'package:etaseta_user/ui/pages/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/product_provider.dart';
import '../../widgets/main_drawer.dart';
import '../../widgets/product_featured.dart';
import '../../widgets/product_item.dart';

class ProductPage extends StatefulWidget {
  static const String routeName = '/product_page';

  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late ProductProvider productProvider;
  late CartProvider cartProvider;
  int chipValue = 0;

  @override
  void didChangeDependencies() {
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    productProvider.getAllProducts();
    productProvider.getAllCategories();
    productProvider.getAllFeaturedProduct();
    cartProvider.getAllCartItems();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          InkWell(
            onTap: () => Navigator.pushNamed(context, CartPage.routeName),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 32,
                  ),
                  Positioned(
                    top: -2,
                    right: 0,
                    child: Container(
                      alignment: Alignment.center,
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: Consumer<CartProvider>(
                        builder: (context, provider, child) => FittedBox(
                          child: Text(
                            '${provider.totalCartItem}',
                            style: const TextStyle(color: Colors.lightBlue),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              leading: Container(),
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Featured Products',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1.5,
                    ),
                    Consumer<ProductProvider>(
                      builder: (context, provider, _) {
                        // print('featured called');
                        return provider.featuredProductList.isNotEmpty
                            ? ProductFeatured(provider: provider)
                            : const Text('Loading...');
                      },
                    ),
                  ],
                ),
                collapseMode: CollapseMode.parallax, //featured product,
              ),
              floating: true,
              elevation: 0,
              backgroundColor: Colors.white.withOpacity(0),
            ),
          ];
        },
        body: Consumer<ProductProvider>(
          builder: (context, provider, _) => Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Categories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.categoryNameList.length,
                  itemBuilder: (context, index) {
                    final cat = provider.categoryNameList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        selectedColor: Theme.of(context).primaryColor,
                        label: Text(cat),
                        selected: chipValue == index,
                        onSelected: (value) {
                          setState(() {
                            chipValue = value ? index : 0;
                          });
                          if (chipValue == 0) {
                            provider.getAllProducts();
                          } else {
                            provider.getAllProductsByCategory(
                                provider.categoryNameList[chipValue]);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              provider.productList.isEmpty
                  ? const Center(
                      child: Text('No item found'),
                    )
                  : Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
                                childAspectRatio: 0.98),
                        itemCount: provider.productList.length,
                        itemBuilder: (context, index) {
                          final product = provider.productList[index];
                          return ProductItem(
                            productModel: product,
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
