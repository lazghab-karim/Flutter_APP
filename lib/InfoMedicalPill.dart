import 'package:flutter/material.dart';

class InfoMedicalPill{
  String name;
  TimeOfDay time;
  String notes;
  InfoMedicalPill({required this.name,this.notes="",required this.time});

  void setNotes(String newNotes){
    notes = newNotes;
  }

  void setName(String newName){
    name= newName;
  }
  @override
  String toString() {
    return "name : $name, time : $time, notes : $notes ";
  }
}
  
class InfoMedicalPillAlarm{
  InfoMedicalPill pill;
  InfoMedicalPillAlarm(this.pill);
}

class MapOfAlarms{
  Map<DateTime, List<InfoMedicalPill>>alarmsTime={};
  Map<String, List<DateTime>>pillsTime={};

  void addAlarm(DateTime daytime, String name, [String? notes] ){
    DateTime date = DateTime(daytime.year,daytime.month,daytime.day);
    TimeOfDay time = TimeOfDay(hour: daytime.hour, minute: daytime.minute);
    print("addAlarm: time: $time, name: $name, notes: $notes");
    InfoMedicalPill md = InfoMedicalPill(time: time, name: name, notes: notes??'');

    alarmsTime.putIfAbsent(date, () => []).add(md);
    pillsTime.putIfAbsent(name, () => []).add(daytime);
  }

  void removeAlarmUsiungDateTime(DateTime daytime){
    
    DateTime day = DateTime(daytime.year,daytime.month,daytime.day);
    TimeOfDay time = TimeOfDay(hour: daytime.hour, minute: daytime.minute);
    if (alarmsTime.containsKey(day)) {
      List<InfoMedicalPill> pills = alarmsTime[day]??[];

      // Find pills to remove
      List<InfoMedicalPill> toRemove = pills.where((pill) => pill.time == time).toList();

      for (var pill in toRemove) {
        pills.remove(pill); // remove from alarmsTime

        // Build full datetime
        DateTime fullDateTime = DateTime(
          day.year,
          day.month,
          day.day,
          pill.time.hour,
          pill.time.minute,
        );

        // Remove from pillsTime
        if (pillsTime.containsKey(pill.name)) {
          if(pillsTime[pill.name]!=null){
            pillsTime[pill.name]!.removeWhere((dt) =>
              dt.year == fullDateTime.year &&
              dt.month == fullDateTime.month &&
              dt.day == fullDateTime.day &&
              dt.hour == fullDateTime.hour &&
              dt.minute == fullDateTime.minute
            );
          }

          // Optional: remove pill name if its list is empty
          if (pillsTime[pill.name]!=null && pillsTime[pill.name]!.isEmpty) {
            pillsTime.remove(pill.name);
          }
        }
      }

      // Optional: remove the day entry if empty
      if (pills.isEmpty) {
        alarmsTime.remove(day);
      }
    }
  }

  void removeAlarmUsiungDateTimeAndName(DateTime daytime, String name){
    
    DateTime day = DateTime(daytime.year,daytime.month,daytime.day);
    TimeOfDay time = TimeOfDay(hour: daytime.hour, minute: daytime.minute);
    if (alarmsTime.containsKey(day)) {
      List<InfoMedicalPill> pills = alarmsTime[day]??[];

      // Find pills to remove
      List<InfoMedicalPill> toRemove = pills.where((pill) => pill.time == time && pill.name == name).toList();

      for (var pill in toRemove) {
        pills.remove(pill); // remove from alarmsTime

        // Build full datetime
        DateTime fullDateTime = DateTime(
          day.year,
          day.month,
          day.day,
          pill.time.hour,
          pill.time.minute,
        );

        // Remove from pillsTime
        if (pillsTime.containsKey(pill.name)) {
          if( pillsTime[pill.name]!=null ){
            pillsTime[pill.name]!.removeWhere((dt) =>
              dt.year == fullDateTime.year &&
              dt.month == fullDateTime.month &&
              dt.day == fullDateTime.day &&
              dt.hour == fullDateTime.hour &&
              dt.minute == fullDateTime.minute
            );
          }

          // Optional: remove pill name if its list is empty
          if (pillsTime[pill.name]!.isEmpty) {
            pillsTime.remove(pill.name);
          }
        }
      }

      // Optional: remove the day entry if empty
      if (pills.isEmpty) {
        alarmsTime.remove(day);
      }
    }
  }

  @override
  String toString() {
    return "alarmsTime: $alarmsTime \npillsTime: $pillsTime ";
  }

  List<DateTime> getDateTimesFromName(String name){
    return pillsTime[name] ?? [];
  }
  bool alarmsTimeIsEmpty(DateTime day){
    day = DateTime(day.year,day.month,day.day);
    return alarmsTime[day]!.isEmpty;
  }

  bool pillsTimeIsEmpty(String name){
    return pillsTime[name]!.isEmpty;
  }
  
  List<InfoMedicalPill> getPillsFromDate(DateTime day){
    day = DateTime(day.year,day.month,day.day);
    return alarmsTime[day] ?? [];
  }

}