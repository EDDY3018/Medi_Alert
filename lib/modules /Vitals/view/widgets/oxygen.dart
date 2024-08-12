// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_field

import 'package:flutter/material.dart';
import 'package:medi_alert/modules%20/Vitals/view/widgets/addDataOxy.dart';
import 'package:medi_alert/utils/navigator.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class OxygenSaturationPage extends StatefulWidget {
  @override
  _OxygenSaturationPageState createState() => _OxygenSaturationPageState();
}

class _OxygenSaturationPageState extends State<OxygenSaturationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Oxygen Saturation'),
        leading: IconButton(
            onPressed: () {
              customNavigator(context, AddDataPage());
            },
            icon: Icon(Icons.more_horiz)),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Day'),
            Tab(text: 'Week'),
            Tab(text: 'Month'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildCalendarView(CalendarView.day),
          buildCalendarView(CalendarView.week),
          buildCalendarView(CalendarView.month),
        ],
      ),
    );
  }

  Widget buildCalendarView(CalendarView view) {
    return SfCalendar(
      view: view,
      onTap: (CalendarTapDetails details) {
        if (details.targetElement == CalendarElement.calendarCell) {
          setState(() {
            _selectedDate = details.date!;
          });
        }
      },
    );
  }
}
