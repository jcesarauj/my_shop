import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/cart-item-widget.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    final cartItems = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Carrinho"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(25),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Chip(
                    label: Text(
                      'R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Spacer(),
                  OrderButton(cart: cart, cartItems: cartItems)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: cart.itemsCount,
            itemBuilder: (ctx, i) => CartItemWidget(cartItems[i]),
          )),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
    @required this.cartItems,
  }) : super(key: key);

  final Cart cart;
  final List<CartItem> cartItems;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: widget.cart.totalAmount == 0
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });

              await Provider.of<Orders>(context, listen: false)
                  .addOrder(widget.cartItems, widget.cart.totalAmount);

              setState(() {
                _isLoading = false;
              });

              widget.cart.clear();
            },
      child: _isLoading ? CircularProgressIndicator() : Text("COMPRAR"),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
