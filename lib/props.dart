import 'package:flutter/cupertino.dart';

double TaxProcent = 12;

class PropsScreen extends StatefulWidget {
  const PropsScreen({Key? key}) : super(key: key);

  @override
  State<PropsScreen> createState() => _PropsScreenState();
}

class _PropsScreenState extends State<PropsScreen> {
  TextEditingController taxController =
      TextEditingController(text: '$TaxProcent');

  @override
  void initState() {
    super.initState();

    taxController.addListener(() {
      TaxProcent = double.parse(taxController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text("Settings"),),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text('Tax %')),
                  Container(
                    child: CupertinoTextField(
                      keyboardType: TextInputType.number,
                      controller: taxController,
                    ),
                    width: 100,
                  ),
                ],
              ),
              Expanded(child: SizedBox())
            ],
          ),
        ),
      ),
    );
  }
}
