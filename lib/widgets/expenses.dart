import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:expense_tracker_v1/widgets/chart/bar_chart.dart';
import 'package:expense_tracker_v1/widgets/chart/chart_bar_udemy.dart';
import 'package:expense_tracker_v1/widgets/chart/chart_udemy.dart';
import 'package:expense_tracker_v1/widgets/chart/line_chart.dart';
import 'package:expense_tracker_v1/widgets/chart/pie_chart.dart';
import 'package:expense_tracker_v1/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker_v1/models/expense.dart';
import 'package:expense_tracker_v1/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  List<String> _pictures = [];

  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Flutter Course',
        amount: 19,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Cinema',
        amount: 24.90,
        date: DateTime.now(),
        category: Category.leisure),
    Expense(
        title: 'Laptop',
        amount: 340.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Borgir',
        amount: 34.99,
        date: DateTime.now(),
        category: Category.food),
  ];

  List<Expense> getRegisteredExpenses() {
    return _registeredExpenses;
  }

  void scannerPress() async {
    List<String> pictures;
    try {
      pictures = await CunningDocumentScanner.getPictures() ?? [];
      if (!mounted) return;
      setState(() {
        _pictures = pictures;
      });
    } catch (exception) {
      // Handle exception here
    }
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense Deleted.'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker V1'),
        actions: [
          IconButton(
            onPressed: () {
              _openAddExpenseOverlay();
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: scannerPress,
            icon: const Icon(Icons.camera_alt_rounded),
          ),
          // Below
          // for (var picture in _pictures)
          //   Image.file(
          //     File(picture),
          //   ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: FlutterCarousel(
              options: FlutterCarouselOptions(
                aspectRatio: 1.2,
                showIndicator: true,
                slideIndicator: CircularSlideIndicator(),
              ),
              items: [1, 2, 3, 4].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    if (i == 1) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        child: BarChartSample1(),
                      );
                    } else if (i == 2) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        child: PieChartSample3(
                            expenses: _ExpensesState().getRegisteredExpenses()),
                      );
                    } else if (i == 3) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          child: Chart(
                            expenses: _registeredExpenses,
                          ));
                    } else {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(top: 5, bottom: 30),
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        child: const LineChartSample1(),
                      );
                    }
                  },
                );
              }).toList(),
            ),
          ),
          const Text('Expense Category'),
          FlutterCarousel(
            options: FlutterCarouselOptions(
              height: 100,
              showIndicator: false,
              slideIndicator: CircularSlideIndicator(),
              indicatorMargin: 10,
            ),
            items: [1, 2, 3].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  if (i == 1) {
                    return const Card(
                      child: Text('Category 1'),
                    );
                  } else if (i == 2) {
                    return const Card(
                      child: Text('Category 1'),
                    );
                  } else {
                    return const Card(
                      child: Text('Category 1'),
                    );
                  }
                },
              );
            }).toList(),
          ),
          const Text('Expenses List'),
          Expanded(
            child: ExpensesList(
              expenses: _registeredExpenses,
              onRemoveExpense: _removeExpense,
            ),
          ),
        ],
      ),
    );
  }
}
