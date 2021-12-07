import 'package:calculate/btn.dart';
import 'package:calculate/props.dart';
import 'package:expressions/expressions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

List<String> history = [];
String historyLastItem = "";
var isExecCalc = false;

class Calculate extends StatefulWidget {
  const Calculate({
    Key? key,
  }) : super(key: key);

  @override
  State<Calculate> createState() => _CalculateState();
}

class _CalculateState extends State<Calculate> {
  var value = "";
  TextEditingController controller = TextEditingController();

  ScrollController scrollController = ScrollController();

  addSymbol(text) {
    setState(() {
      if (isExecCalc) {
        if (text is int) {
          controller.text = "";
        }
        isExecCalc = false;
      }
      controller.text = controller.text + (text is String ? text : "$text");

      liveHistory();
    });
  }

  clear() {
    controller.text = "";
    setState(() {});
  }

  liveHistory() {
    historyLastItem = controller.text + " = " + calc(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (ctx) => const PropsScreen()));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: const Icon(Icons.menu, color: Colors.black),
            ),
          ),
        ),
        middle: const Text("Simple calculate"),
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < history.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(history[i]),
                        ),
                      Text(historyLastItem),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: CupertinoTextField(
                      readOnly: true,
                      controller: controller,
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    child: const Icon(Icons.backspace),
                    onTap: () {
                      if (controller.text.isEmpty) return;

                      setState(() {
                        List<String> symbols = controller.text.split('')
                          ..removeLast();
                        controller.text = symbols.join('');

                        liveHistory();

                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 0.5)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        AppBtn(
                          title: "Clear",
                          onTap: () => clear(),
                        ),
                        AppBtn(
                          title: "Tax -",
                          onTap: () => addSymbol("*${100 - TaxProcent}*0.01"),
                        ),
                        AppBtn(
                          title: "Tax +",
                          onTap: () => addSymbol("*${100 + TaxProcent}*0.01"),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        AppBtn(
                          title: "+",
                          onTap: () => addSymbol("+"),
                        ),
                        AppBtn(
                          title: "-",
                          onTap: () => addSymbol("-"),
                        ),
                        AppBtn(
                          title: "*",
                          onTap: () => addSymbol("*"),
                        ),
                        AppBtn(
                          title: "/",
                          onTap: () => addSymbol("/"),
                        ),
                        AppBtn(
                          column: 6,
                          title: "(",
                          onTap: () => addSymbol("("),
                        ),
                        AppBtn(
                          title: ")",
                          onTap: () => addSymbol(")"),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        for (var i = 1; i <= 3; i++)
                          AppBtn(
                            title: "$i",
                            onTap: () => addSymbol(i),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        for (var i = 4; i <= 6; i++)
                          AppBtn(
                            title: "$i",
                            onTap: () => addSymbol(i),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        for (var i = 7; i <= 9; i++)
                          AppBtn(
                            title: "$i",
                            onTap: () => addSymbol(i),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        AppBtn(
                          title: "0",
                          onTap: () => addSymbol(0),
                        ),
                        AppBtn(
                          size: 2,
                          title: "=",
                          onTap: () => setState(() {
                            if (controller.text.isEmpty) return;

                            final res = controller.text;

                            controller.text = calc(controller.text);

                            history.add(res + " = " + controller.text);
                            isExecCalc = true;

                            Future.delayed(Duration.zero).then((value) =>
                                scrollController.animateTo(
                                    scrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease));
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

calc(String text) {
  try {
    Expression expression = Expression.parse(text);
    Map<String, dynamic> context1 = {};

    const evaluator = ExpressionEvaluator();

    final res1 = evaluator.eval(expression, context1).toString();

    return res1;
  } catch (e) {
    // Fluttertoast.showToast(
    //   msg: "Не удалось рассчитать",
    //   fontSize: 16.0,
    // );
  }
}
