import 'package:flutter/material.dart';
import 'package:web_corp/domain/models/employee.dart';
import 'package:web_corp/ui/widgets/employee_card.dart';

class EmployeeScreen extends StatelessWidget{

  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Сотрудники')
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: employees.length,
        itemBuilder: (context, index) => EmployeeCard(employee: employees[index]),
      ),
    );
  }
}