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
                  icon: Image.asset('assets/icons/icons8-fast-food-64.png'),
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
                    iconFilter('Pizza');
                  },
                  icon: Image.asset('assets/icons/icons8-pizza-64.png'),
                ),
                const Text('Pizza'),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    iconFilter('Fries');
                  },
                  icon: Image.asset('assets/icons/icons8-fries-64.png'),
                ),
                const Text('Frites'),
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
                    iconFilter('Hotdog');
                  },
                  icon: Image.asset('assets/icons/icons8-hot-dog-64.png'),
                ),
                const Text('Hotdog'),
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
                    iconFilter('Pitta');
                  },
                  icon: Image.asset('assets/icons/icons8-taco-64.png'),
                ),
                const Text('Pitta'),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    iconFilter('Durum');
                  },
                  icon: Image.asset('assets/icons/icons8-wrap-64.png'),
                ),
                const Text('Durum'),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    iconFilter('Glaces');
                  },
                  icon:
                      Image.asset('assets/icons/icons8-ice-cream-cone-64.png'),
                ),
                const Text('Glaces'),
              ],
            ),
          ]),
    );
  }
}
