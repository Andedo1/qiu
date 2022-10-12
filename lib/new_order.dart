import 'package:flutter/material.dart';
import 'package:qiu/order.dart';

class New extends StatelessWidget {
  const New({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: MediaQuery.of(context).size.height*0.5,
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
            Container(
              height: MediaQuery.of(context).size.height*0.35,
              width: MediaQuery.of(context).size.width*0.78,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(22)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Individual order',
                          style: TextStyle(
                              color: Colors.lightBlueAccent
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Text(
                          'Order Details',
                          style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Icon(
                          Icons.my_location,
                          color: Colors.lightBlueAccent,
                          size: 16,
                        ),
                        SizedBox(width: 10,),
                        Text(
                          'Location',
                          style: TextStyle(
                              color: Colors.lightBlueAccent
                          ),
                        )
                      ],
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              VerticalDivider(
                                thickness: 1,
                                color: Colors.lightBlueAccent,
                                width: 18,
                              ),
                              SizedBox(width: 10,),
                              Text(
                                '44 Riverside drive',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.black54,
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(
                          Icons.production_quantity_limits,
                          color: Colors.lightBlueAccent,
                          size: 16,
                        ),
                        SizedBox(width: 10,),
                        Text(
                          'Amount of water',
                          style: TextStyle(
                              color: Colors.lightBlueAccent
                          ),
                        )
                      ],
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              VerticalDivider(
                                thickness: 1,
                                color: Colors.lightBlueAccent,
                                width: 18,
                              ),
                              SizedBox(width: 10,),
                              Text(
                                '2000 Litres',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(
                          Icons.price_change_outlined,
                          color: Colors.lightBlueAccent,
                          size: 16,
                        ),
                        SizedBox(width: 10,),
                        Text(
                          'Cost',
                          style: TextStyle(
                              color: Colors.lightBlueAccent
                          ),
                        ),
                      ],
                    ),
                    IntrinsicHeight(
                      child: Row(
                        children: const [
                          VerticalDivider(
                            thickness: 1,
                            color: Colors.lightBlueAccent,
                            width: 18,
                          ),
                          SizedBox(width: 10,),
                          Text(
                            'KES 4000',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width*0.78,
                  decoration: BoxDecoration(
                    color: Colors.green[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Make Order',
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
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    context: context,
                    builder: (context) {
                      return const Order();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
}
