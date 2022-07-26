import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngs_run_calculator/main.dart' as app;
import 'package:ngs_run_calculator/widgets/sample_list.dart' show SampleItem;

void main() {
  testWidgets('end to end test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Verify the initial state
    expect(find.text('Select a sequencing platform to see the sample list'), findsOneWidget);

    /////////// Select a sequencing platform
    // Select the platform
    final Finder seqPlatform = find.byKey(const Key('selectSeqPlatform'));
    await tester.tap(seqPlatform);
    await tester.pumpAndSettle();
    final seqPlatformItem = find.text('HiSeq 2500, Illumina').last;
    await tester.tap(seqPlatformItem);
    await tester.pumpAndSettle();

    // Select the mode
    final Finder seqPlatformMode = find.byKey(const Key('selectSeqPlatformMode'));
    await tester.tap(seqPlatformMode);
    await tester.pumpAndSettle();
    final seqPlatformModeItem = find.text('HiSeq SBS V4, Single Flow Cell').last;
    await tester.tap(seqPlatformModeItem);
    await tester.pumpAndSettle();

    // Select the params
    final Finder seqPlatformParams = find.byKey(const Key('selectSeqPlatformParams'));
    await tester.tap(seqPlatformParams);
    await tester.pumpAndSettle();
    final seqPlatformParamsItem = find.text('2x125, 500 Gbp').last;
    await tester.tap(seqPlatformParamsItem);
    await tester.pumpAndSettle();

    // Verify that the sequencing platform is set
    expect(find.text('Select a sequencing platform to see the sample list'), findsNothing);
    expect(find.text('The calculated load of 500 Gbp'), findsOneWidget);

    /////////// Add a sample isCoverageX = false
    // Select the sample type
    final Finder sampleType = find.byKey(const Key('addSampleType'));
    await tester.tap(sampleType);
    await tester.pumpAndSettle();
    var sampleTypeItem = find.text('Amplicon-based metagenome').last;
    await tester.tap(sampleTypeItem);
    await tester.pumpAndSettle();
    // Enter the samples num
    await tester.enterText(find.byKey(const Key('addSampleNum')), '1000');
    // Enter the samples coverage
    await tester.enterText(find.byKey(const Key('addSampleCoverage')), '20000');

    // press the add button
    Finder addSampleButton = find.byKey(const Key('addSample')).last;
    await tester.scrollUntilVisible(
      addSampleButton,
      100.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(addSampleButton);
    await tester.pumpAndSettle();

    //verify that the sample has been added
    final Finder sampleList = find.byKey(const Key('sampleList'));
    expect(find.descendant(of: sampleList, matching: find.byType(SampleItem)), findsOneWidget);
    expect(
        find.descendant(
            of: sampleList, matching: find.textContaining('1000 of Amplicon-based metagenome')),
        findsOneWidget);
    expect(find.descendant(of: sampleList, matching: find.textContaining('5 Gbp (1%)')),
        findsOneWidget);

    /////////// Add a sample isCoverageX = true
    // Select the sample type
    await tester.tap(sampleType);
    await tester.pumpAndSettle();
    sampleTypeItem = find.text('Human exome').last;
    await tester.tap(sampleTypeItem);
    await tester.pumpAndSettle();
    // Enter the samples num
    await tester.enterText(find.byKey(const Key('addSampleNum')), '10');
    // Enter the samples coverage
    await tester.enterText(find.byKey(const Key('addSampleCoverage')), '100');
    // Enter the samples size
    await tester.enterText(find.byKey(const Key('addSampleSize')), '10mbp');

    // press the add button
    await tester.scrollUntilVisible(
      addSampleButton,
      100.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(addSampleButton);
    await tester.pumpAndSettle();

    //verify that the sample has been added
    expect(find.descendant(of: sampleList, matching: find.byType(SampleItem)), findsNWidgets(2));
    expect(find.descendant(of: sampleList, matching: find.textContaining('10 of Human exome')),
        findsOneWidget);
    expect(find.descendant(of: sampleList, matching: find.textContaining('10 Gbp (2%)')),
        findsOneWidget);

    /////////// Edit the sample isCoverageX = true
    await tester.tap(find.descendant(of: sampleList, matching: find.byTooltip('Edit Human exome')));
    await tester.pumpAndSettle();
    // Edit the samples size
    await tester.enterText(find.byKey(const Key('editSampleSize')), '20mbp');
    await tester.tap(find.byKey(const Key('editSample')).last);
    await tester.pumpAndSettle();

    //verify that the sample has been edited
    expect(find.descendant(of: sampleList, matching: find.byType(SampleItem)), findsNWidgets(2));
    expect(find.descendant(of: sampleList, matching: find.textContaining('10 Gbp (2%)')),
        findsNothing);
    expect(find.descendant(of: sampleList, matching: find.textContaining('20 Gbp (4%)')),
        findsOneWidget);

    /////////// Delete the sample isCoverageX = false
    await tester.tap(find.descendant(
        of: sampleList, matching: find.byTooltip('Delete Amplicon-based metagenome')));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Confirm'));
    await tester.pumpAndSettle();
    //verify that the sample has been deleted
    expect(find.descendant(of: sampleList, matching: find.byType(SampleItem)), findsOneWidget);
    expect(
        find.descendant(
            of: sampleList, matching: find.textContaining('1000 of Amplicon-based metagenome')),
        findsNothing);
  });
}
