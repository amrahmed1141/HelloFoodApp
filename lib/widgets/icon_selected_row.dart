import 'package:flutter/material.dart';


class IconSelectedRow extends StatefulWidget {
  final Function(String) onCategorySelected; // Callback function

  const IconSelectedRow({super.key, required this.onCategorySelected});

  @override
  State<IconSelectedRow> createState() => _IconSelectedRowState();
}

class _IconSelectedRowState extends State<IconSelectedRow> {
  bool iceCream = false;
  bool pizza = false;
  bool burger = false;
  bool salads = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async {
            setState(() {
              iceCream = true;
              pizza = false;
              burger = false;
              salads = false;
            });
            widget.onCategorySelected('Ice-Cream'); // Trigger callback
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iceCream ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                'assets/icons/ice-cream.png',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                color: iceCream ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            setState(() {
              iceCream = false;
              pizza = true;
              burger = false;
              salads = false;
            });
            widget.onCategorySelected('Pizza'); // Trigger callback
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: pizza ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                'assets/icons/pizza.png',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                color: pizza ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            setState(() {
              iceCream = false;
              pizza = false;
              burger = true;
              salads = false;
            });
            widget.onCategorySelected('Burger'); // Trigger callback
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: burger ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                'assets/icons/burger.png',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                color: burger ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            setState(() {
              iceCream = false;
              pizza = false;
              burger = false;
              salads = true;
            });
            widget.onCategorySelected('Salad'); // Trigger callback
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: salads ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                'assets/icons/salad.png',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                color: salads ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}