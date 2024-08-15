// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:medi_alert/modules%20/Vitals/view/widgets/addDataOxy.dart';
import 'package:medi_alert/utils/navigator.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../vitals_page.dart';

class OxygenSaturationPage extends StatefulWidget {
  @override
  _OxygenSaturationPageState createState() => _OxygenSaturationPageState();
}

class _OxygenSaturationPageState extends State<OxygenSaturationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  final List<Appointment> _appointments = []; // Store appointments

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Oxygen Saturation'),
        leading: IconButton(
          onPressed: () {
            customNavigator(context, VitalsPage());
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddDataPage(date: _selectedDate)),
              );
              if (result != null) {
                setState(() {
                  _appointments.add(result);
                });
              }
            },
            icon: Icon(Icons.add),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Day'),
            Tab(text: 'Week'),
            Tab(text: 'Month'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: TabBarView(
              controller: _tabController,
              children: [
                buildCalendarView(CalendarView.day),
                buildCalendarView(CalendarView.week),
                buildCalendarView(CalendarView.month),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: _appointments.length,
              itemBuilder: (context, index) {
                final appointment = _appointments[index];
                return Container(
                  color: const Color.fromARGB(72, 156, 198, 158),
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Today, ${TimeOfDay.now().format(context)}'),
                    subtitle: Text(appointment.subject),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCalendarView(CalendarView view) {
    return SfCalendar(
      view: view,
      dataSource: AppointmentDataSource(_appointments),
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

// Custom data source for the calendar
class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
