import 'package:flutter/cupertino.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  ShoppingCartPageState createState() => ShoppingCartPageState();
}

class ShoppingCartPageState extends State<ShoppingCartPage>{
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('购物车'),
    );
  }

}