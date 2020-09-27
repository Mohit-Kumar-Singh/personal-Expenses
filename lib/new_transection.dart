import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime _selectDate;

  void submit() {
    final enteredTittle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTittle.isEmpty || enteredAmount <= 0) {
      return;
    }

    widget.addTx(
      enteredTittle,
      enteredAmount,
      _selectDate,
    );
    Navigator.of(context).pop();
  }

  void _presentate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'title'),
                controller: titleController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) {
                  return submit();
                },
              ),
              Container(
                height: 70,
                child: Row(children: <Widget>[
                  Expanded(
                    child: Text(_selectDate == null
                        ? 'No date choosen'
                        : DateFormat.yMd().format(_selectDate)),
                  ),
                  FlatButton(
                      onPressed: _presentate,
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        'add date ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                ]),
              ),
              FlatButton(
                onPressed: () {
                  submit();
                },
                child: Text('+ Transection'),
                textColor: Colors.purple,
              )
            ],
          ),
        ),
      ),
    );
  }
}