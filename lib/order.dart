import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Order extends StatelessWidget {
  const Order({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    height: MediaQuery.of(context).size.height*0.3,
    width: MediaQuery.of(context).size.width,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(22),
        topRight: Radius.circular(22),
      ),
    ),

    // Order Details Widget.
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: Lottie.asset('assets/animassets/loader.json'),
              ),
              const Text(
                'Connecting you to bowser',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width*0.78,
              decoration: BoxDecoration(
                color: Colors.red[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Cancel Order',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            onTap: () {
              // Should toggle order details widget.
              Navigator.pop(context);
            },
          ),
        ),
      ],
    ),
  );
}
