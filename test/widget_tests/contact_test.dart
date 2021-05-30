import 'package:Toogle/Presentation/pages/contact.dart';
import 'package:Toogle/Presentation/pages/myHomePage.dart';
import 'package:Toogle/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  testWidgets('Testing Contact screen', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MyHomePage(),
    ));
    // followed immediately by this second pump without arguments
    await tester.pump();
    var contactFinder = find.byKey(Key("555"));
    expect(contactFinder, findsNothing);
  });
}
