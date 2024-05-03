import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        hintColor: Colors.white,
        scaffoldBackgroundColor: Colors.blueGrey[50],
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String equation = '';
  String result = '';

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        equation = '';
        result = '';
      } else if (buttonText == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(equation);
          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          result = 'Error';
        }
      } else {
        equation += buttonText;
      }
    });
  }

  Widget buildButton(String buttonText, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => buttonPressed(buttonText),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(24.0),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 32.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Calculator',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Text(
              equation,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              result,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          const Divider(height: 1.0, color: Colors.black),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButton('7', Colors.black12),
              buildButton('8', Colors.black12),
              buildButton('9', Colors.black12),
              buildButton('/', Colors.brown),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButton('4', Colors.black12),
              buildButton('5', Colors.black12),
              buildButton('6', Colors.black12),
              buildButton('*', Colors.brown),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButton('1', Colors.black12),
              buildButton('2', Colors.black12),
              buildButton('3', Colors.black12),
              buildButton('-', Colors.brown),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButton('0', Colors.black12),
              buildButton('C', Colors.brown),
              buildButton('=', Colors.brown),
              buildButton('+', Colors.brown),
            ],
          ),
        ],
      ),
    );
  }
}
