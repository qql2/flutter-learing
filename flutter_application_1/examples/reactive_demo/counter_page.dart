import 'package:flutter/material.dart';
import './counter_display.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});
  @override
  State<CounterPage> createState() => CounterPageState();
}

class CounterPageState extends State<CounterPage> {
  int counter = 0;
  String text = '';
  void incrementCounter() {
// 调用setState触发UI更新
    setState(() {
      counter++;
      text = '计数: $counter';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter响应式示例'),
      ),
      body: CounterDisplay(
        counter: counter,
        text: text,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
