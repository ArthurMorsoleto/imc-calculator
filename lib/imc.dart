import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Imc extends StatefulWidget {
  @override
  _ImcState createState() => _ImcState();
}

class _ImcState extends State<Imc> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _imcResult = "";
  String _classificationResult = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("IMC Calculator"),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  child: Image.asset("assets/imcLogo.png",
                      width: 150, height: 150),
                  alignment: Alignment.bottomCenter),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                      hintText: 'height',
                      icon: Icon(Icons.height_sharp),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: TextField(
                    controller: _weightController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                        hintText: 'weight',
                        icon: Icon(Icons.accessibility_sharp),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Text(
                    '$_imcResult',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Text(
                    '$_classificationResult',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ))
            ],
          )),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal,
        onTap: _onItemTap,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.clear, color: Colors.white),
              title: Text("clear", style: TextStyle(color: Colors.white))),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_to_home_screen, color: Colors.white),
              title: Text("calculate", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  void _onItemTap(int index) {
    if (index == 0) {
      clearFields();
    } else if (validateFields()) {
      showSnackBar("Height and Weight must not be empty");
    } else {
      try {
        double weight = double.parse(_weightController.text);
        double height = double.parse(_heightController.text);
        double imc = (weight / (height * height));

        var classification = "";
        if (imc < 18.5) {
          classification = "MAGREZA";
        } else if (imc >= 18.5 && imc <= 24.9) {
          classification = "NORMAL";
        } else if (imc >= 25.0 && imc <= 29.9) {
          classification = "SOBREPESO";
        } else if (imc >= 30 && imc <= 39.9) {
          classification = "OBESIDADE";
        } else {
          classification = "OBESIDADE GRAVE";
        }

        setState(() {
          _imcResult = "IMC: ${imc.toStringAsFixed(2)}";
          _classificationResult = 'Classification: $classification';
        });
      } catch (e) {
        showSnackBar("Height and Weight must be valid values");
      }
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(scaffoldKey.currentContext)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void clearFields() {
    setState(() {
      _heightController.clear();
      _weightController.clear();
      _imcResult = "";
    });
  }

  bool validateFields() {
    return _heightController.text.isEmpty || _weightController.text.isEmpty;
  }
}
