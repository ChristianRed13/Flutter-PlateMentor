import 'package:flutter/material.dart';

class UpdatesScreen extends StatelessWidget {
  static const id = 'update_screen';
  final List<String> updates = [
    'The books, magazines and comic books that now have individual titles, will also be persistent. Instead of disappearing after being read, there will be a cooldown period that dictates how much time must pass before the character’s moodles can benefit from re-reading said item.',
    'In conjunction with this revision of literature items, we’ve gone over the mechanics of the Illiterate traits. Illiterate characters are unable to read literature items, but in some cases, such as Comic Books, Catalogues, Photos, and “certain magazines”, they will be able to enjoy looking at the item instead of reading it. In build 42 Illiterate characters will also be unable to read or write player generated notes using sheets of paper or notebooks, write notes on maps (although they can still put symbols on them), read the text on the annotated map items, or understand the nutritional information on packaged food.',
    'We’ve done a common sense implementation of needing light to read. If there is insufficient light in a character’s square, and they don’t have an active light source, they will be unable to read (or “look at” for illiterate characters) printed matter, unable to read nutritional information on packaged food, and unable to open maps.'
  ];

  UpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Updates'),
        backgroundColor: Theme.of(context).primaryColorLight,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade300,
      body: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Plate Mentor v1.0.0.0',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Wrap(
                  children: List.generate(updates.length, (index) {
                    return Container(
                      padding: EdgeInsets.all(25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '➤ ',
                            style: TextStyle(fontSize: 16),
                          ),
                          Expanded(
                            child: Text(
                              '${updates[index]}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
