import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:pre_order_flutter_app/entities/product_category.dart';
import 'package:pre_order_flutter_app/main.dart';
import 'package:pre_order_flutter_app/models/app_model.dart';
import 'package:pre_order_flutter_app/screens/order_layer/cart_screen.dart';
import 'package:pre_order_flutter_app/screens/order_layer/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductListScreenTab {
  String title;
  Widget widget;

  ProductListScreenTab(this.title, this.widget);
}

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Consumer<AppModel>(builder: (_, model, __) {
              return AlertDialog(
                title: Text('お買い物を中断しますか？'),
                content: Text('カート中身がすべて削除されますがよろしいでしょうか？'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      model.updateTopScreenTabIndex(0);
                      model.allDeleteMyCart();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.redAccent,
                    ),
                    child: Text(
                      'お買い物を中断する',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.blueAccent,
                    ),
                    child: Text(
                      'お買い物を続ける',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            });
          },
        );
      },
      child: Consumer<AppModel>(builder: (_, model, __) {
        var productCategoryList = model.productCategoryList;
        var tabList = productCategoryList
            .map(
              (productCategory) => ProductListScreenTab(
                productCategory.name,
                ProductCardListBody(productCategory),
              ),
            )
            .toList();
        tabList.add(
          ProductListScreenTab(
            'すべて',
            ProductCardListBody(null),
          ),
        );
        return DefaultTabController(
          length: tabList.length,
          child: Scaffold(
            appBar: AppBar(
              title: Column(
                children: [
                  Image.asset(
                    'assets/images/showroom_logo.png',
                    height: 16,
                    width: 97,
                  ),
                  AppBarTitle(),
                ],
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                      icon: Consumer<AppModel>(builder: (_, model, __) {
                    final totalProductCount = model.myCart?.totalQuantity ?? 0;
                    return totalProductCount == 0
                        ? Icon(Icons.shopping_cart)
                        : Badge(
                            badgeContent: Text(
                              '$totalProductCount',
                              style: TextStyle(color: Colors.white),
                            ),
                            child: Icon(Icons.shopping_cart),
                          );
                  }), onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScreen(),
                      ),
                    );
                  }),
                ),
              ],
              bottom: TabBar(
                isScrollable: true,
                labelPadding: EdgeInsets.symmetric(horizontal: 40),
                tabs: tabList.map(
                  (ProductListScreenTab tab) {
                    return Tab(text: tab.title);
                  },
                ).toList(),
              ),
            ),
            body: TabBarView(
              children: tabList.map((tab) => tab.widget).toList(),
            ),
            floatingActionButton: FloatingCartButton(),
          ),
        );
      }),
    );
  }
}

class ProductCategoryTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (_, model, __) {
      final productCategoryList = model.productCategoryList;
      return TabBar(
        tabs: productCategoryList.map(
          (ProductCategory productCategory) {
            return Tab(text: productCategory.name);
          },
        ).toList(),
      );
    });
  }
}

class AppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (_, model, __) {
      final selectedStore = model.selectedStore;
      return Text('${selectedStore.name} 商品一覧');
    });
  }
}

class ProductCardListBody extends StatelessWidget {
  final ProductCategory selectedTabProductCategory;
  ProductCardListBody(this.selectedTabProductCategory);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (context, model, child) {
      var productList = model.searchedProductList;
      if (selectedTabProductCategory != null) {
        productList = productList
            .where((product) =>
                product.categoryId == selectedTabProductCategory.id)
            .toList();
      }
      final listTiles = productList
          .map(
            (product) => SizedBox(
              height: 175.0,
              child: Card(
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    model.resetProductCounter();
                    model.updateSelectedProduct(product);
                    analytics.logViewItem(
                      itemId: product.id.toString(),
                      itemName: product.name,
                      itemCategory: product.categoryId.toString(),
                    );
                    analytics.logViewItem(
                      itemId: product.id.toString(),
                      itemName: product.name,
                      itemCategory: product.categoryId.toString(),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Image.network(
                          product.imageUrl,
                          height: 100,
                        ),
                        Container(
                          width: double.infinity,
                          child: Text(
                            product.name,
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: Text(
                            '¥ ' + product.price.toString(),
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList();
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SearchTextField(),
            Divider(),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: listTiles,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class SearchTextField extends StatefulWidget {
  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (_, model, __) {
      return TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Search',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: () {
              _controller.clear();
              model.onChange('');
            },
            icon: Icon(Icons.clear),
          ),
        ),
        onChanged: (text) {
          model.onChange(text);
          analytics.logSearch(searchTerm: text);
        },
      );
    });
  }
}

class FloatingCartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CartScreen(),
          ),
        );
      },
      icon: Icon(Icons.shopping_cart),
      label: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          'カートを確認する',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
