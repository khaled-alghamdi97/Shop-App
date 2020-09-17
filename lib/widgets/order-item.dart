import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem({this.order});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: Column(
          children: [
            ListTile(
              title: Text(
                "\$${widget.order.price}",
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                DateFormat.yMEd().format(widget.order.dateTime).toString(),
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              ),
            ),
            if (isExpanded)
              Container(
                  height: 50,
                  width: double.infinity,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    itemBuilder: (context, index) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${widget.order.items[index].title}"),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                            "x${widget.order.items[index].quantity}  \$${widget.order.items[index].price}")
                      ],
                    ),
                    itemCount: widget.order.items.length,
                  ))
          ],
        ));
  }
}
