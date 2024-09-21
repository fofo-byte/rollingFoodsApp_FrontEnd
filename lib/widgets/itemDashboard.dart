import 'package:flutter/material.dart';

class Itemdashboard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final Function onTap;

  const Itemdashboard(
      {super.key,
      required this.color,
      required this.icon,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                textAlign: TextAlign.center,
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                onTap();
              }),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
