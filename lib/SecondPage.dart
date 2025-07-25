import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'notifications.dart';
import 'InfoMedicalPill.dart';
import 'widget/NotificationUI.dart';



class AlarmInfo{
  String name;
  String dosage;
  int amountForThisAlarm;
  TimeOfDay timeOfThePill;
  String notes;
  AlarmInfo({required this.name, required this.timeOfThePill,this.amountForThisAlarm=-1,this.notes="",this.dosage=""});
}

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
  MapOfAlarms _events = MapOfAlarms();
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
                  if (_selectedDay !=null && !_events.alarmsTimeIsEmpty(_selectedDay!)){
                    showNotificationThatDay(_selectedDay!);
                  }
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
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _focusedDay=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
                  });
                },
                child: Text("Return to today"),
              ),
              SizedBox(height: 20),

              ElevatedButton(
              onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: First_Calendar,
                    lastDate: Last_calendar,
                  );
                  if (picked != null) {
                    setState(() {
                      _focusedDay=DateTime(picked.year,picked.month,picked.day);
                      _selectedDay = DateTime(picked.year,picked.month,picked.day);
                    });
                  }

              },
              child: Text("search for Day"),
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
  String notes="";
  String? name;
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? Time;

  await showDialog(
    context: context,
    builder: (context) {
      final nameController = TextEditingController();
      final notesController = TextEditingController();
      final startController = TextEditingController();
      final endController = TextEditingController();
      final tController = TextEditingController();

      return AlertDialog(
        title: Text("Custom Schedule"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Pill name"),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: notesController,
                decoration: InputDecoration(labelText: "Pill notes"),
                keyboardType: TextInputType.text,
              ),
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
                if (nameController.text.isNotEmpty) {
                  name =nameController.text;
                }
                if (notesController.text.isNotEmpty) {
                  notes =notesController.text;
                }else{
                  notes="";
                }
                print("name: $name, notes: $notes, time: $Time, startdate: $startDate, enddate: $endDate");
                if( startDate!=null && endDate!=null && Time!=null && name!=null){

                  InfoMedicalPill pills=InfoMedicalPill(name: name!,notes: notes!, time: Time!);
                  Scheduler(startDate!, [[pills]],endDate!);   

                }
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
    String? notes;
    String? name;
    DateTime? startDate;
    DateTime? endDate;
    int? Periode;

    await showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();
        final notesController = TextEditingController();
        final startController = TextEditingController();
        final endController = TextEditingController();
        final pController = TextEditingController();

        return AlertDialog(
          title: Text("Custom Schedule"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Pill name"),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: notesController,
                  decoration: InputDecoration(labelText: "Pill notes"),
                  keyboardType: TextInputType.text,
                ),

                TextField(
                  controller: startController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: "Start Date"),
                  onTap: () async {
                    final pickedstart = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: First_Calendar,
                      lastDate: Last_calendar,
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
                name = nameController.text;
                notes = notesController.text;
                if(Periode!=null && name!=null && startDate!=null && endDate!=null){

                  /* add the function that adds periode of alarms */
                  List<List<TimeOfDay>>times = [];
                  for(int p=0;p<Periode!;p++){
                    List<TimeOfDay>? TMP = await showTimePickerPopup(context,p+1);
                    if (TMP != null) times.add(TMP);
                  }
                  List<List<InfoMedicalPill>>Pills=[];
                  times.forEach((eachday){
                    List<InfoMedicalPill>TMP=[];
                    eachday.forEach((time){
                      TMP.add(InfoMedicalPill(name: name!, time: time,notes:notes!));
                    });
                    Pills.add(TMP);

                  });
                  print("times : $times");
                  Scheduler(startDate!, Pills, endDate!);

                }
                Navigator.pop(context);
              },
              child: Text("Done"),
            ),
          ],
        );
      },
    );
  }
  
  
  void showNotificationThatDay(DateTime day) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
        title: Text("notifications for ${day.year}/${day.month}/${day.day}"),
        content: SingleChildScrollView(
            child: Column(children: [
              if(_selectedDay!=null)...[
                ..._getEventsForDay(_selectedDay!).map((e) => [
                  notifButton(time: e.time),
                  SizedBox(height: 20),
                ]).expand((widgetList) => widgetList),
                ]
              ]
            ),
          )
        );
      
      }
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

  void Scheduler(DateTime startdate, List<List<InfoMedicalPill>> each_day,DateTime enddate){
    int day = 0;
    if (enddate.isAfter(Last_calendar)){
      enddate = Last_calendar;
    }
    DateTime currect_today = startdate;
    while(currect_today.isBefore(enddate) || currect_today.isAtSameMomentAs(enddate)){
      for (int i = 0;i<each_day[day].length;i++){
        InfoMedicalPill pill = each_day[day][i];
        DateTime daytime = DateTime(currect_today.year,currect_today.month,currect_today.day,
                                    pill.time.hour,pill.time.minute);
        if(daytime==null || pill.name==null){
          print("YESS IT4S NOLL");
        }
        setState(() {
          _events.addAlarm(daytime, pill.name);
        });
      }

      day+=1;
      currect_today=currect_today.add(Duration(days: 1));
      if(day == each_day.length) day=0;
    }
    print(_events);
  }

  List<InfoMedicalPill> _getEventsForDay(DateTime day) {
    final cleanDate = DateTime( day.year, day.month,day.day);
    return _events.getPillsFromDate(cleanDate);
  }

  Future<void> _pickDateTimeAndSchedule() async {
    String? name;
    String? notes;
    DateTime? pickedDate;
    TimeOfDay? pickedTime;
    final now = DateTime.now();
    await showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();
        final notesController = TextEditingController();
        final datetimeController = TextEditingController();

        return AlertDialog(
          title: Text("Daily Schedule"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Pill name"),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: notesController,
                  decoration: InputDecoration(labelText: "Pill notes"),
                  keyboardType: TextInputType.text,
                ),

                TextField(
                  controller: datetimeController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: "pick date and time"),
                  onTap: () async {
                    final pickeddate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: First_Calendar,
                      lastDate: Last_calendar,
                    );
                    if (pickeddate != null) {
                      pickedDate = pickeddate;
                      datetimeController.text = pickeddate.toLocal().toString().split(' ')[0];
                    }
                    final TimeOfDay? pickedtime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: 8, minute: 0),
                    );
                    if (pickedtime != null && pickedDate!=null){
                      pickedTime = pickedtime;
                      pickedDate=DateTime(pickedDate!.year,pickedDate!.month,pickedDate!.day,
                                          pickedtime.hour,pickedtime.minute);
                    }

                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                name = nameController.text;
                notes = notesController.text;
                if( pickedTime!=null && pickedDate!=null ){
                  final label = "Reminder at ${pickedTime!.format(context)}";

                  setState(() {
                    _events.addAlarm(pickedDate!,name!, notes);
                  });

                  // Schedule the notification
                  await scheduleNotification(pickedDate!, "Reminder", label);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Scheduled notification for $label")),
                  );
                }
                Navigator.pop(context); // Return list on close

              },
              child: Text("Done"),
            ),

          ],
        );
      },
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
                  label: Text("Add Pill Alarm"),
                  onPressed: () async {

                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: 8, minute: 0),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedTimes.add(pickedTime); // Add to list
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
