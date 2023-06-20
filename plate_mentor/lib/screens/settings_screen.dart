import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  static const id = 'settings_screen';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isLightTheme = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Theme.of(context).primaryColorLight,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade300,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          children: [
            //measurement
            SelectableOptionWidget(
              isTop: true,
              onTap: () {
                // Handle the onTap event here
                _showMeasurementOptionsPopup(context);
              },
              optionText: 'Measurement Units', // selectable option by popup
              selectedText: 'Metric/Imperial', // what is currently selected
            ),
            //language
            SelectableOptionWidget(
              isTop: false,
              onTap: () {
                // Handle the onTap event here
                _showLanguageOptionsPopup(context);
              },
              optionText: 'Language', // selectable option by popup
              selectedText: 'English', // what is currently selected
            ),
            //theme
            Material(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context).primaryColorLight),
                        ),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Theme', // selectable option by popup
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            isLightTheme
                                ? 'Light'
                                : 'Dark', // what is currently selected
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15.5),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context).primaryColorLight),
                      ),
                    ),
                    child: Switch(
                        activeColor: Theme.of(context).primaryColorLight,
                        value: isLightTheme,
                        onChanged: (check) {
                          setState(() {
                            isLightTheme = check;
                          });
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showMeasurementOptionsPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        //change apps measurement to imperial
                      },
                      child: Text(
                        'Imperial',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        //change apps measurement to metrics
                      },
                      child: Text(
                        'Metrics',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showLanguageOptionsPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        //change apps language to English
                      },
                      child: Text(
                        'English',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        //change apps language to German
                      },
                      child: Text(
                        'German',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class SelectableOptionWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String optionText;
  final String selectedText;
  final bool isTop;

  const SelectableOptionWidget({
    required this.onTap,
    required this.optionText,
    required this.selectedText,
    required this.isTop,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      child: InkWell(
        borderRadius: isTop
            ? BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )
            : null,
        onTap: onTap,
        splashColor: Colors.grey,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom:
                        BorderSide(color: Theme.of(context).primaryColorLight),
                  ),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      optionText, // selectable option by popup
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      selectedText, // what is currently selected
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
