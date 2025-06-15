import 'package:flutter/material.dart';

class WatchlistFooter extends StatelessWidget {
  final int count;
  final int max;

  const WatchlistFooter({super.key, required this.count, this.max = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count / $max Stocks',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
