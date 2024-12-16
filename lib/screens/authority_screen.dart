import 'package:flutter/material.dart';
import '../components/section_title.dart';
import './total_complaints_widget.dart';
import './trends_widget.dart';
import './categories_widget.dart';
import './high_priority_widget.dart';
import './pending_tasks_widget.dart';

class AuthorityDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authority Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(title: 'Total Complaints'),
              TotalComplaintsWidget(),

              SectionTitle(title: 'Complaint Trends'),
              TrendsWidget(),

              SectionTitle(title: 'Categories Overview'),
              CategoriesWidget(),

              SectionTitle(title: 'High Priority Complaints'),
              HighPriorityWidget(),

              SectionTitle(title: 'Pending Tasks'),
              PendingTasksWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

