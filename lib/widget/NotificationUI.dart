
import 'package:flutter/material.dart';

class notifButton extends StatefulWidget {
  final TimeOfDay time;

  const notifButton({
    Key? key,
    required this.time,
  }) : super(key: key);

  @override
  NotificationUI createState() => NotificationUI();
}


class NotificationUI extends State<notifButton> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(16), // optionnel, pour arrondir
      ),
      child: Row(
        children: [
          Center(
            child: Text(
              "• ${widget.time.format(context)}",
              style: TextStyle(color: Colors.white),
            )
          ),
          Expanded( // Takes up the remaining space
            child: Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                
                style: ButtonStyle(
                  fixedSize: WidgetStateProperty.all(Size(2, 2)),
                  backgroundColor: WidgetStateProperty.all(Colors.red[900]),
                ),
                /* remove the date when pressed */
                onPressed:() => {},
                onHover: (hovering){
                  setState(() {
                    _isHovered=hovering;
                  });
                },
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width:10)
        ],
      )
      );

  }
}