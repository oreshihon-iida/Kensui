import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:kensui/widgets/dialogs/scrollable_dialog_content.dart';

void main() {
  testWidgets('ScrollableDialogContent respects maxHeight constraint', (WidgetTester tester) async {
    const maxHeight = 300.0;
    
    await tester.pumpWidget(const MaterialApp(
      home: Material(
        child: Center(
          child: Dialog(
            child: ScrollableDialogContent(
              maxHeight: maxHeight,
              children: [Text('Test')],
            ),
          ),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    final box = tester.renderObject<RenderBox>(find.byType(SingleChildScrollView).first);
    expect(box.constraints.maxHeight, equals(maxHeight));
  });

  testWidgets('ScrollableDialogContent allows scrolling with many children', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ScrollableDialogContent(
          children: List.generate(50, (i) => Text('Item $i')),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    // First item should be visible
    expect(find.text('Item 0'), findsOneWidget);
    
    // Scroll down
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -1000));
    await tester.pumpAndSettle();

    // Last item should now be visible
    expect(find.text('Item 49'), findsOneWidget);
  });

  testWidgets('ScrollableDialogContent applies padding correctly', (WidgetTester tester) async {
    const padding = EdgeInsets.all(24.0);
    
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: ScrollableDialogContent(
          padding: padding,
          children: [Text('Test')],
        ),
      ),
    ));

    await tester.pumpAndSettle();

    final paddingWidget = tester.widget<Padding>(find.byType(Padding));
    expect(paddingWidget.padding, equals(padding));
  });
}
