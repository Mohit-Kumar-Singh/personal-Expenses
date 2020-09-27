import 'new_transection.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'transection.dart';
import 'transection_list.dart';
import 'chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  //     // if we want to work our app only in potrait mode
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.cyan,

        // fontFamily: 'Indie',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  //String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final List<Transection> _userTransections = [
    // Transection(
    //   id: 't1',
    //   title: 'new shoes',
    //   amount: 1700,
    //   date: DateTime.now(),
    // ),
    // Transection(
    //   id: 't2',
    //   title: 'tshirt',
    //   amount: 499,
    //   date: DateTime.now(),
    // )
  ];
  bool showChart = false;

  List<Transection> get _recentTransection {
    return _userTransections.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransection(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transection(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
    );
    setState(() {
      _userTransections.add(newTx);
    });
  }

  void _startAddnewtransection(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return GestureDetector(
            child: NewTransaction(_addNewTransection),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deletTransection(String id) {
    setState(() {
      _userTransections.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final landscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appbar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Transections'),
            trailing: Row(
              children: [],
            ),
          )
        : AppBar(
            title: Text('Personal Expences'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddnewtransection(context),
              )
            ],
          );
    final txlist = Container(
        height: (mediaQuery.size.height -
                appbar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransecionList(_userTransections, _deletTransection));

    final page = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (landscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('show chart'),
                  //switch.adaptive show different kind of switch for diff os (andriod / ios)
                  Switch.adaptive(
                      value: showChart,
                      onChanged: (val) {
                        setState(() {
                          showChart = val;
                        });
                      }),
                ],
              ),
            if (!landscape)
              Container(
                  height: (mediaQuery.size.height -
                          appbar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.3,
                  child: Chart(_recentTransection)),
            if (!landscape) txlist,
            showChart
                ? Container(
                    height: (mediaQuery.size.height -
                            appbar.preferredSize.height -
                            mediaQuery.padding.top) *
                        0.7,
                    child: Chart(_recentTransection))
                : txlist
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(child: page, navigationBar: appbar)
        : Scaffold(
            appBar: appbar,
            body: page,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    //platform.isIOS import dart.io for checking of the os platform
                    onPressed: () {
                      return _startAddnewtransection(context);
                    },
                    child: Text(
                      '+',
                      style: TextStyle(
                        fontSize: 35,
                      ),
                    ),
                  ),
          );
  }
}
