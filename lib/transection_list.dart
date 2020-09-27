import 'package:flutter/material.dart';
import 'transection.dart';
import 'package:intl/intl.dart';
//import 'user_transection.dart';

class TransecionList extends StatelessWidget {
  final List<Transection> transections;
  final Function deleteTx;

  TransecionList(this.transections, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: transections.isEmpty
          ? LayoutBuilder(builder: (ctx, constrains) {
              return Column(children: <Widget>[
                Text(
                  'No Transection',
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: constrains.maxHeight * 0.6,
                  child: Image.asset(
                    'images/color.jpg',
                    fit: BoxFit.cover,
                  ),
                )
              ]);
            })
          : ListView.builder(
              //listview take all the heihght of parent height if there parent is no
              //parent then it take input height and nothing visible on screen
              // list view work same as SinglechildScrollView both do the scrolling function for screen
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                            child: Text('\$${transections[index].amount}')),
                      ),
                    ),
                    title: Text(
                      transections[index].title,
                      style: Theme.of(context).textTheme.title,
                    ),
                    subtitle: Text(
                        DateFormat.yMMMd().format(transections[index].date)),
                    trailing: MediaQuery.of(context).size.width > 400
                        ? FlatButton.icon(
                            onPressed: () => deleteTx(transections[index].id),
                            icon: Icon(Icons.delete),
                            label: Text('Delete'))
                        : IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () => deleteTx(transections[index].id),
                          ),
                  ),
                );
              },
              itemCount: transections.length,
              //     children: transections.map((tx) {
              //       return
              //     }).toList(),
              //  ),
            ),
    );
  }
}
