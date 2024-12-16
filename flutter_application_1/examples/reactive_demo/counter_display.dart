import 'package:flutter/material.dart';

class CounterDisplay extends StatelessWidget {
  final int counter;
  final String text;
  const CounterDisplay({
    super.key,
    required this.counter,
    required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            text,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            '$counter',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}
