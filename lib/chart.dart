import 'package:flutter/material.dart';
import 'transection.dart';
import 'package:intl/intl.dart';
import 'chartbar.dart';

class Chart extends StatelessWidget {
  final List<Transection> recentTransections;

  Chart(this.recentTransections);

  List<Map<String, Object>> get groupedTransectionsValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      var totalsum = 0.0;
      for (var i = 0; i < recentTransections.length; i++) {
        if (recentTransections[i].date.day == weekDay.day &&
            recentTransections[i].date.year == weekDay.year) {
          totalsum += recentTransections[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalsum,
      };
    }).reversed.toList();
  }

  double get totalSpendig {
    return groupedTransectionsValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransectionsValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: Chartbar(
                data['day'],
                data['amount'],
                totalSpendig == 0.0
                    ? 0.0
                    : (data['amount'] as double) / totalSpendig,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
