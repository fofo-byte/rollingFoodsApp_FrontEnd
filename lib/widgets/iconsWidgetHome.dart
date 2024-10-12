import 'package:flutter/material.dart';

class Iconswidgethome extends StatelessWidget {
  final Function(String) iconFilter;
  const Iconswidgethome({super.key, required this.iconFilter});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween, // Espacement égal entre les icônes
          children: [
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    iconFilter('Burger');
                  },
                  icon: Image.asset('assets/icons/icons8-cheeseburger-64.png'),
                ),
                const Text('Burger'),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    iconFilter('Chicken');
                  },
                  icon: Image.asset('assets/icons/icons8-chicken-box-64.png'),
                ),
                const Text('Fried Chicken'),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    iconFilter('Chinese');
                  },
                  icon: Image.asset(
                      'assets/icons/icons8-chinese-fried-rice-64.png'),
                ),
                const Text('Chinese'),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    iconFilter('Fast Food');
                  },
                  icon: Image.asset('assets/icons/icons8-fast-food-64.png'),
                ),
                const Text('Fast Food'),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    iconFilter('pizza');
                  },
                  icon: Image.asset('assets/icons/icons8-pizza-64.png'),
                ),
                const Text('pizza'),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    iconFilter('Sandwich');
                  },
                  icon: Image.asset('assets/icons/icons8-sandwich-64.png'),
                ),
                const Text('Sandwich'),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    iconFilter('Sushi');
                  },
                  icon: Image.asset('assets/icons/icons8-sushi-64.png'),
                ),
                const Text('Sushi'),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    iconFilter('Tacos');
                  },
                  icon: Image.asset('assets/icons/icons8-taco-64.png'),
                ),
                const Text('Tacos'),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    iconFilter('Wrap');
                  },
                  icon: Image.asset('assets/icons/icons8-wrap-64.png'),
                ),
                const Text('Wrap'),
              ],
            ),
          ]),
    );
  }
}
