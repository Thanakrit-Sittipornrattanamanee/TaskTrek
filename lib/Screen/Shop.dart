import 'package:flutter/material.dart';

class ThemeModel {
  final String name;
  final String description;
  final double price;

  ThemeModel(
      {required this.name, required this.description, required this.price});
}

final List<ThemeModel> themes = [
  ThemeModel(
      name: "Bright Light",
      description: "A vibrant and bright theme.",
      price: 2.99),
  ThemeModel(
      name: "Dark Mode",
      description: "A sleek and modern dark theme.",
      price: 2.99),
  ThemeModel(
      name: "Pastel Colors",
      description: "Soft pastel colors for a gentle look.",
      price: 3.99),
];

class ThemeStore extends StatefulWidget {
  @override
  _ThemeStoreState createState() => _ThemeStoreState();
}

class _ThemeStoreState extends State<ThemeStore> {
  List<ThemeModel> cart = [];

  void addToCart(ThemeModel theme) {
    setState(() {
      cart.add(theme);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:false, // ตั้งค่านี้เป็น false เพื่อไม่ให้แสดงปุ่มย้อนกลับอัตโนมัติ
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage(cart: cart)),
              );
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: themes.length,
        itemBuilder: (context, index) {
          final theme = themes[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(theme.name,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(theme.description),
              trailing: Text("\$${theme.price.toStringAsFixed(2)}"),
              onTap: () => addToCart(theme),
            ),
          );
        },
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<ThemeModel> cart;

  CartPage({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final item = cart[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text("\$${item.price.toStringAsFixed(2)}"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.payment),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Purchase Confirmation"),
              content: Text("Do you want to purchase the themes in your cart?"),
              actions: <Widget>[
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text("Purchase"),
                  onPressed: () {
                     Navigator.pop(context);  // Close the dialog
                    Navigator.pop(context);  // Go back to ThemeStore page
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
