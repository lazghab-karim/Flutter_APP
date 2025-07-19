
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
  void _showReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reminder'),
        content: Text('Reminder is set for ${widget.time.format(context)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
          onPressed:() =>  _showReminderDialog(context),
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
          child: Text("• ${widget.time.format(context)}"),
        );
  }
}