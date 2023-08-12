import 'package:flutter/material.dart';

class BMICalculatorScreen extends StatefulWidget {
  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  String? gender;
  double? heightFeet;
  double? heightInches;
  double? weight;

  void calculateBMI() {
    if (gender == null || heightFeet == null || heightInches == null || weight == null ||
        gender!.isEmpty || heightFeet!.isNaN || heightInches!.isNaN || weight!.isNaN) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all the fields.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    double heightInMeters = ((heightFeet ?? 0.0) * 12 + (heightInches ?? 0.0)) * 0.0254;
    double bmi = weight! / (heightInMeters * heightInMeters);
    String category;

    if (bmi < 18.5) {
      category = 'Underweight';
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      category = 'Normal weight';
    } else if (bmi >= 25 && bmi <= 29.9) {
      category = 'Overweight';
    } else {
      category = 'Obese';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Your BMI'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Your BMI is: ${bmi.toStringAsFixed(1)}'),
              SizedBox(height: 16.0),
              Text('Category: $category'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            padding:  EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DropdownButtonFormField(
                  value: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'Male',
                      child: Text('Male'),
                    ),
                    DropdownMenuItem(
                      value: 'Female',
                      child: Text('Female'),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Gender',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      heightFeet = double.tryParse(value)!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Height (Feet)',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      heightInches = double.tryParse(value)!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Height (Inches)',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      weight = double.tryParse(value)!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Weight (kg)',
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  child: Text('Calculate BMI'),
                  onPressed: calculateBMI,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
