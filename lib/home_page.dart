import 'package:flutter/material.dart';
import 'SecondPage.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class HoverFilledButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const HoverFilledButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  _HoverFilledButtonState createState() => _HoverFilledButtonState();
}

class _HoverFilledButtonState extends State<HoverFilledButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton(
          onPressed: widget.onPressed,
          onHover: (hovering) {
            setState(() {
              _isHovered = hovering;
            });
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              _isHovered ? Colors.grey : Colors.blue,
            ),
            foregroundColor: WidgetStateProperty.all(Colors.white),
            minimumSize: WidgetStateProperty.all(Size(150, 50)),
          ),
          child: Text(widget.text),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
        )
      ]
    );
  }
}


class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("cash UP"),
        centerTitle: true
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HoverFilledButton(
              onPressed: () {},
              text : "LOGIN"
            ),
            HoverFilledButton(
              onPressed: () {},
              text : "REGISTER"
            ),

            HoverFilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondPage()),
                );
              },
              text : "ENTER"
            ),
          ] 
        ),
      )
    );
  }
}

