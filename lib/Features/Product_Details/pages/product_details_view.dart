import 'package:e_commerce_app/Core/extentions/extentions.dart';
import 'package:e_commerce_app/Data/data_sources/home/home_datasource.dart';
import 'package:e_commerce_app/Domain/entity/home/product_entity.dart';
import 'package:e_commerce_app/Features/Home/manager/states.dart';
import 'package:e_commerce_app/Features/Product_Details/widgets/product_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import '../../Home/manager/cubit.dart';

class ProductDetailsView extends StatefulWidget {
  ProductDataEntity product;

  ProductDetailsView(this.product, {super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  List<Color> colors = [
    Colors.black,
    Colors.grey,
    Colors.red,
    Colors.blue,
    Colors.green,
  ];

  int selectedColorIndex = -1;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return BlocProvider(
      create: (context) => HomeCubit(HomeRemoteDto()),
      child: BlocConsumer<HomeCubit, HomeStates>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: theme.primaryColor),
              title: Text("Product Details",
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.primaryColor)),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageSlideshow(
                    width: double.infinity,
                    height: mediaQuery.height * 0.4,
                    initialPage: 0,
                    indicatorColor: theme.primaryColor,
                    indicatorBackgroundColor: Colors.grey,
                    indicatorPadding: 8,
                    indicatorBottomPadding: 10,
                    indicatorRadius: 5,
                    autoPlayInterval: 3000,
                    isLoop: true,
                    children: widget.product.images?.map((imageUrl) {
                          return Image.network(
                              imageUrl); // Convert URL to Image widget
                        }).toList() ??
                        [],
                  ).setVerticalPadding(context, 0.013),
                  SizedBox(
                    height: mediaQuery.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: mediaQuery.width * 0.6,
                        child: Text(
                          widget.product.title ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      Text(
                        "EGP  ${widget.product.price}",
                        style: theme.textTheme.bodyMedium,
                      )
                    ],
                  ).setVerticalPadding(context, 0.02),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              border:
                                  Border.all(color: Colors.blueGrey, width: 1)),
                          child: Text(
                            " ${widget.product.sold} Sold",
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 13,
                            ),
                            const ImageIcon(
                                AssetImage("assets/images/icons/star.png"),
                                size: 17,
                                color: Color(0XFFFDD835)),
                            Text(
                              widget.product.ratingsAverage.toString(),
                              style: theme.textTheme.displaySmall,
                            ),
                            Text(
                              " (${widget.product.ratingsQuantity})",
                              style: theme.textTheme.displaySmall,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius: BorderRadius.circular(35),
                              border:
                                  Border.all(color: Colors.blueGrey, width: 1)),
                          child: Row(
                            children: [
                              const Icon(CupertinoIcons.minus_circle,
                                  color: Colors.white),
                              const SizedBox(
                                width: 15,
                              ),
                              Text("1", style: theme.textTheme.bodyLarge),
                              const SizedBox(
                                width: 15,
                              ),
                              const Icon(
                                CupertinoIcons.add_circled,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Description",
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.left,
                  ).setVerticalPadding(context, 0.015),
                  Text(
                    "Title : ${widget.product.title} \n",
                    style: theme.textTheme.displaySmall
                        ?.copyWith(color: Colors.blueGrey),
                    maxLines: 8,
                  ),
                  Text(
                    "Description : ${widget.product.description}\n",
                    style: theme.textTheme.displaySmall
                        ?.copyWith(color: Colors.blueGrey),
                    maxLines: 8,
                  ),
                  Text(
                    "Color",
                    style: theme.textTheme.bodyMedium,
                  ).setVerticalPadding(context, 0.02),
                  Row(
                    children: [
                      for (int index = 0; index < colors.length; index++)
                        ProductColor(
                          color: colors[index],
                          select: index == selectedColorIndex,
                          onColorSelected: (isSelected) {
                            setState(() {
                              if (isSelected) {
                                selectedColorIndex = index;
                              } else {
                                selectedColorIndex = -1;
                              }
                            });
                          },
                        ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Total price",
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: const Color(0xFF6A6695)),
                          ),
                          Text(
                            "EGP ${widget.product.price}",
                            style: theme.textTheme.bodyMedium,
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          HomeCubit.get(context)
                              .addToCart(widget.product.id ?? "");
                        },
                        child: Container(
                          width: mediaQuery.width * 0.6,
                          height: mediaQuery.height * 0.07,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: theme.primaryColor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add_shopping_cart_outlined,
                                color: Colors.white,
                                size: 25,
                              ),
                              SizedBox(
                                width: mediaQuery.width * 0.03,
                              ),
                              Text(
                                "Add to cart",
                                style: theme.textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ).setOnlyVerticalPadding(context, top: 0.02, bottom: 0.01)
                ],
              )
                  .setHorizontalPadding(context, 0.07)
                  .setOnlyVerticalPadding(context, bottom: 0.04, top: 0.01),
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}