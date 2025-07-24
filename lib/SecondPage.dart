import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'notifications.dart';
import 'widget/NotificationUI.dart';
import 'package:timezone/timezone.dart' as tz;

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  DateTime _focusedDay = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  DateTime? _selectedDay;
  DateTime First_Calendar = DateTime(DateTime.now().year, 1, 1);
  DateTime Last_calendar = DateTime(2080, 12, 31);

  // Map of calendar events (key: date, value: list of labels)
  Map<DateTime, List<TimeOfDay>> _events = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reminder Calendar")),
      body: SingleChildScrollView(
        child:Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TableCalendar(
                firstDay: First_Calendar,
                lastDay: DateTime.utc(2035, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: (day) => _getEventsForDay(day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = DateTime(selectedDay.year,selectedDay.month,selectedDay.day);
                    _focusedDay = DateTime(focusedDay.year,focusedDay.month,focusedDay.day);
                  });
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(height: 20),


              FilledButton(
                onPressed: () => _showScheduleOptions(context),  
                child: Text("Add Reminder"),
              ),


              
              SizedBox(height: 20),
              if(_selectedDay != null) ...[
                Text("Reminders on  ${_selectedDay!.toLocal().toString().split(' ')[0]} ",
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
                ..._getEventsForDay(_selectedDay!).map((e) => notifButton(time:e),
                ),
              ],
              ElevatedButton(
              onPressed: () {
                Scheduler(
                  DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day), // start date
                  [
                    [TimeOfDay(hour: 9, minute: 0)],               // Day 1
                    [TimeOfDay(hour: 10, minute: 30)],             // Day 2
                    [TimeOfDay(hour: 8, minute: 15), TimeOfDay(hour: 14, minute: 0)], // Day 3
                  ],
                  Last_calendar
                );
              },
              child: Text("Schedule Events"),
            ),
            ],
          ),
        ),
      )
    );
  }

  void _pickDateTimeAndScheduleOnce(){
    _pickDateTimeAndSchedule();
  }
  void _pickDailySchedule(BuildContext context) async {
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? Time;

  await showDialog(
    context: context,
    builder: (context) {
      final startController = TextEditingController();
      final endController = TextEditingController();
      final tController = TextEditingController();

      return AlertDialog(
        title: Text("Custom Schedule"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: startController,
                readOnly: true,
                decoration: InputDecoration(labelText: "Start Date"),
                onTap: () async {
                  final pickedstart = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (pickedstart != null) {
                    startDate = pickedstart;
                    startController.text = pickedstart.toLocal().toString().split(' ')[0];
                  }
                },
              ),
              TextField(
                controller: endController,
                readOnly: true,
                decoration: InputDecoration(labelText: "End Date"),
                onTap: () async {
                  final pickedend = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (pickedend != null) {
                    endDate = pickedend;
                    endController.text = pickedend.toLocal().toString().split(' ')[0];
                  }
                },
              ),              
              TextField(
                controller: tController,
                readOnly: true,
                decoration: InputDecoration(labelText: "Time"),
                onTap: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: 8, minute: 0),
                    );

                  if (pickedTime != null) {
                    Time = pickedTime;
                    tController.text = pickedTime.toString().split(' ')[0];
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Scheduler(startDate!, [[Time!]],endDate!);   
              Navigator.pop(context);         
            },
            child: Text("Done"),
          ),
        ],
      );
    },
  );
}

  void _pickCustomSchedule() async {
    DateTime? startDate;
    DateTime? endDate;
    int? Periode;

    await showDialog(
      context: context,
      builder: (context) {
        final startController = TextEditingController();
        final endController = TextEditingController();
        final pController = TextEditingController();

        return AlertDialog(
          title: Text("Custom Schedule"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: startController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: "Start Date"),
                  onTap: () async {
                    final pickedstart = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (pickedstart != null) {
                      startDate = pickedstart;
                      startController.text = pickedstart.toLocal().toString().split(' ')[0];
                    }
                  },
                ),
                TextField(
                  controller: endController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: "End Date"),
                  onTap: () async {
                    final pickedend = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (pickedend != null) {
                      endDate = pickedend;
                      endController.text = pickedend.toLocal().toString().split(' ')[0];
                    }
                  },
                ),              
                TextField(
                  controller: pController,
                  decoration: InputDecoration(labelText: "Period (number of time sets)"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (pController.text.isNotEmpty) {
                  Periode = int.tryParse(pController.text);
                }
                /* add the function that adds periode of alarms */
                List<List<TimeOfDay>>times = [];
                for(int p=0;p<Periode!;p++){
                  List<TimeOfDay>? TMP = await showTimePickerPopup(context,p+1);
                  if (TMP != null) times.add(TMP);
                }
                Navigator.pop(context);
                print("times :");
                print(times);
                Scheduler(startDate!, times, endDate!);
              },
              child: Text("Done"),
            ),
          ],
        );
      },
    );
  }

  void _showScheduleOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Schedule Type"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Once"),
                onTap: () {
                  Navigator.pop(context);
                  _pickDateTimeAndScheduleOnce();
                },
              ),
              ListTile(
                title: Text("Daily"),
                onTap: () {
                  Navigator.pop(context);
                  _pickDailySchedule(context);
                },
              ),
              ListTile(
                title: Text("Custom"),
                onTap: () {
                  Navigator.pop(context);
                  _pickCustomSchedule();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void Scheduler(DateTime startdate, List<List<TimeOfDay>> each_day,DateTime enddate){
    int day = 0;
    if (enddate.isAfter(Last_calendar)){
      enddate = Last_calendar;
    }
    while(startdate.isBefore(enddate) || startdate.isAtSameMomentAs(enddate)){
      for (int i = 0;i<each_day[day].length;i++){
        TimeOfDay Time = each_day[day][i];
        setState(() {
          _events.putIfAbsent(startdate, () => []).add(Time);
        });
      }

      day+=1;
      startdate=startdate.add(Duration(days: 1));
      if(day == each_day.length) day=0;
    }
    print(_events);
  }

  List<TimeOfDay> _getEventsForDay(DateTime day) {
    final cleanDate = DateTime( day.year, day.month,day.day);
    return _events[cleanDate] ?? [];
  }

  Future<void> _pickDateTimeAndSchedule() async {
    final now = DateTime.now();

    // Pick date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDay ?? now,
      firstDate: now,
      lastDate: DateTime(2030),
    );

    if (pickedDate == null) return;

    // Pick time
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 8, minute: 0),
    );

    if (pickedTime == null) return;

    // Combine date and time
    final DateTime scheduledTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    final label = "Reminder at ${pickedTime.format(context)}";

    // Add to local events map
    final cleanDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
    setState(() {
      _events.putIfAbsent(cleanDate, () => []).add(pickedTime);
    });

    // Schedule the notification
    await scheduleNotification(scheduledTime, "Reminder", label);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Scheduled notification for $label")),
    );
  }
}

Future<List<TimeOfDay>?> showTimePickerPopup(BuildContext context, int day) async {
  List<TimeOfDay> selectedTimes = []; // Correctly initialize as a list

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Select day $day of the periode'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text("Add Time"),
                  onPressed: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: 8, minute: 0),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedTimes.add(picked); // Add to list
                      });
                    }
                  },
                ),
                SizedBox(height: 16),
                if (selectedTimes.isEmpty)
                  Text("No times selected yet.")
                else
                  SizedBox(
                    height: 150,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: selectedTimes.map((time) {
                          return ListTile(
                            leading: Icon(Icons.access_time),
                            title: Text(time.format(context)),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                child: Text("Done"),
                onPressed: () {
                  Navigator.pop(context, selectedTimes); // Return list on close
                },
              ),
            ],
          );
        },
      );
    },
  );

  return selectedTimes; // Return the list after dialog closes
}
