import 'package:carousel_slider/carousel_slider.dart';
import 'package:etaseta_user/providers/product_provider.dart';
import 'package:flutter/material.dart';

class ProductFeatured extends StatelessWidget {
  ProductFeatured({Key? key, required this.provider}) : super(key: key);

  ProductProvider provider;

  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(seconds: 1));
    return Card(
      elevation: 5,
      child: CarouselSlider.builder(
        itemCount: provider.featuredProductList.length,
        itemBuilder: (context, index, realIndex) {
          final fProduct = provider.featuredProductList[index];
          return Card(
            elevation: 5,
            child: Stack(children: [
              FadeInImage.assetNetwork(
                placeholder: 'assets/images/img.png',
                image: fProduct.imageUrl!,
                fadeInCurve: Curves.bounceInOut,
                fadeInDuration: const Duration(seconds: 2),
                width: double.infinity,
                height: 150,
                fit: BoxFit.fill,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  alignment: Alignment.center,
                  color: Colors.black38,
                  child: Text(
                    fProduct.name!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ]),
          );
        },
        options: CarouselOptions(
          height: 150,
          aspectRatio: 16 / 9,
          viewportFraction: 0.7,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
