import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

const firstWidgetKey = Key('Test key first');
const lastWidgetKey = Key('Test key second');
const listViewKey = Key('ListView key');
const tabBarViewKey = Key('TabBarView key');
const firstTabKey = Key('First tab key');
const secondTabKey = Key('Second tab key');

void main() {
  late TestWidgetModel testWidgetModel;
  late ElementaryModelMock model;
  late ElementaryWidget testWidget;
  late ScrollController scrollController;
  late TabController tabController;
  late Widget widget;

  TestWidgetModel testWmFactory(
    BuildContext context,
  ) {
    return testWidgetModel;
  }

  const listViewContent = [
    SizedBox(
      key: firstWidgetKey,
      height: 200,
      width: double.infinity,
    ),
    SizedBox(
      height: 200,
      width: double.infinity,
    ),
    SizedBox(
      height: 200,
      width: double.infinity,
    ),
    SizedBox(
      height: 200,
      width: double.infinity,
    ),
    SizedBox(
      height: 200,
      width: double.infinity,
    ),
    SizedBox(
      key: lastWidgetKey,
      height: 200,
      width: double.infinity,
    ),
  ];

  setUp(
    () {
      model = ElementaryModelMock();
      scrollController = ScrollController();
      testWidget = TestElementaryWidget(
        testWmFactory,
        controller: scrollController,
        listViewContent: listViewContent,
        key: firstTabKey,
      );
      tabController = TabController(length: 2, vsync: const TestVSync());
    },
  );

  testWidgets(
    'When switching between tabs, the state of the tabs should be preserved',
    (tester) async {
      testWidgetModel = TestWidgetModel(
        model: model,
      );
      widget = TestTabScreen(
        testWidget,
        tabController,
        key: tabBarViewKey,
      );
      await tester.pumpWidget(widget);

      // During initialization, the first tab with the
      // beginning of the listViewContent should be displayed.
      expect(find.byKey(firstTabKey), findsOneWidget);
      expect(find.byKey(secondTabKey), findsNothing);
      expect(find.byKey(firstWidgetKey), findsOneWidget);
      expect(find.byKey(lastWidgetKey), findsNothing);

      // Scroll to the end of the listViewContent.
      await tester.drag(find.byKey(listViewKey), const Offset(0, -500));
      await tester.pumpAndSettle();

      // Last widget from the listViewContent should be displayed.
      expect(find.byKey(firstWidgetKey), findsNothing);
      expect(find.byKey(lastWidgetKey), findsOneWidget);

      // Switching between tabs(go to the second tab).
      await tester.drag(find.byKey(tabBarViewKey), const Offset(-500, 0));
      await tester.pumpAndSettle();

      // After switching the second tab should be displayed.
      expect(find.byKey(firstTabKey), findsNothing);
      expect(find.byKey(secondTabKey), findsOneWidget);
      expect(find.byKey(firstWidgetKey), findsNothing);
      expect(find.byKey(lastWidgetKey), findsNothing);

      // Switching between tabs(back to the first tab).
      await tester.drag(find.byKey(tabBarViewKey), const Offset(500, 0));
      await tester.pumpAndSettle();

      // Last widget of the listViewContent on the first tab should be
      // displayed.
      expect(find.byKey(firstTabKey), findsOneWidget);
      expect(find.byKey(secondTabKey), findsNothing);
      expect(find.byKey(firstWidgetKey), findsNothing);
      expect(find.byKey(lastWidgetKey), findsOneWidget);
    },
  );

  testWidgets(
    'If disable saving state of the testWidgetModel, then when switching '
    'between tabs, their state should not be saved',
    (tester) async {
      testWidgetModel = TestWidgetModel(
        model: model,
      );
      widget = TestTabScreen(
        testWidget,
        tabController,
        key: tabBarViewKey,
      );
      await tester.pumpWidget(widget);

      testWidgetModel.setupWantKeepAlive(false);

      // During initialization, the first tab with the
      // beginning of the listViewContent should be displayed.
      expect(find.byKey(firstTabKey), findsOneWidget);
      expect(find.byKey(secondTabKey), findsNothing);
      expect(find.byKey(firstWidgetKey), findsOneWidget);
      expect(find.byKey(lastWidgetKey), findsNothing);

      // Scroll to the end of the listViewContent.
      await tester.drag(find.byKey(listViewKey), const Offset(0, -500));
      await tester.pumpAndSettle();

      // Last widget from the listViewContent should be displayed.
      expect(find.byKey(firstWidgetKey), findsNothing);
      expect(find.byKey(lastWidgetKey), findsOneWidget);

      // Switching between tabs(go to the second tab).
      await tester.drag(find.byKey(tabBarViewKey), const Offset(-500, 0));
      await tester.pumpAndSettle();

      // After switching the second tab should be displayed.
      expect(find.byKey(firstTabKey), findsNothing);
      expect(find.byKey(secondTabKey), findsOneWidget);
      expect(find.byKey(firstWidgetKey), findsNothing);
      expect(find.byKey(lastWidgetKey), findsNothing);

      // Switching between tabs(back to the first tab).
      await tester.drag(find.byKey(tabBarViewKey), const Offset(500, 0));
      await tester.pumpAndSettle();

      // First widget of the listViewContent on the first tab should be
      // displayed.
      expect(find.byKey(firstTabKey), findsOneWidget);
      expect(find.byKey(secondTabKey), findsNothing);
      expect(find.byKey(firstWidgetKey), findsOneWidget);
      expect(find.byKey(lastWidgetKey), findsNothing);
    },
  );

  testWidgets(
    'Switching wantKeepAlive from true(default) to false should change '
    'the behavior of the widget',
    (tester) async {
      testWidgetModel = TestWidgetModel(
        model: model,
        wantKeepAlive: false,
      );
      widget = TestTabScreen(
        testWidget,
        tabController,
        key: tabBarViewKey,
      );
      await tester.pumpWidget(widget);

      // During initialization, the first tab with the
      // beginning of the listViewContent should be displayed.
      expect(find.byKey(firstTabKey), findsOneWidget);
      expect(find.byKey(secondTabKey), findsNothing);
      expect(find.byKey(firstWidgetKey), findsOneWidget);
      expect(find.byKey(lastWidgetKey), findsNothing);

      // Scroll to the end of the listViewContent.
      await tester.drag(find.byKey(listViewKey), const Offset(0, -500));
      await tester.pumpAndSettle();

      // Last widget from the listViewContent should be displayed.
      expect(find.byKey(firstWidgetKey), findsNothing);
      expect(find.byKey(lastWidgetKey), findsOneWidget);

      // Switching between tabs(go to the second tab).
      await tester.drag(find.byKey(tabBarViewKey), const Offset(-500, 0));
      await tester.pumpAndSettle();

      // After switching the second tab should be displayed.
      expect(find.byKey(firstTabKey), findsNothing);
      expect(find.byKey(secondTabKey), findsOneWidget);
      expect(find.byKey(firstWidgetKey), findsNothing);
      expect(find.byKey(lastWidgetKey), findsNothing);

      // Switching between tabs(back to the first tab).
      await tester.drag(find.byKey(tabBarViewKey), const Offset(500, 0));
      await tester.pumpAndSettle();

      // First widget of the listViewContent on the first tab should be
      // displayed.
      expect(find.byKey(firstTabKey), findsOneWidget);
      expect(find.byKey(secondTabKey), findsNothing);
      expect(find.byKey(firstWidgetKey), findsOneWidget);
      expect(find.byKey(lastWidgetKey), findsNothing);

      testWidgetModel.setupWantKeepAlive(true);

      // Scroll to the end of the listViewContent.
      await tester.drag(find.byKey(listViewKey), const Offset(0, -500));
      await tester.pumpAndSettle();

      // Last widget from the listViewContent should be displayed.
      expect(find.byKey(firstWidgetKey), findsNothing);
      expect(find.byKey(lastWidgetKey), findsOneWidget);

      // Switching between tabs(go to the second tab).
      await tester.drag(find.byKey(tabBarViewKey), const Offset(-500, 0));
      await tester.pumpAndSettle();

      // After switching the second tab should be displayed.
      expect(find.byKey(firstTabKey), findsNothing);
      expect(find.byKey(secondTabKey), findsOneWidget);
      expect(find.byKey(firstWidgetKey), findsNothing);
      expect(find.byKey(lastWidgetKey), findsNothing);

      // Switching between tabs(back to the first tab).
      await tester.drag(find.byKey(tabBarViewKey), const Offset(500, 0));
      await tester.pumpAndSettle();

      // First widget of the listViewContent on the first tab should be
      // displayed.
      expect(find.byKey(firstTabKey), findsOneWidget);
      expect(find.byKey(secondTabKey), findsNothing);
      expect(find.byKey(firstWidgetKey), findsNothing);
      expect(find.byKey(lastWidgetKey), findsOneWidget);
    },
  );
}

class IElementaryWidgetModelTest extends IWidgetModel {}

class TestWidgetModel
    extends WidgetModel<TestElementaryWidget, ElementaryModelMock>
    with
        AutomaticKeepAliveWidgetModelMixin<TestElementaryWidget,
            ElementaryModelMock>
    implements
        IElementaryWidgetModelTest {
  final bool wantKeepAlive;

  TestWidgetModel({
    required ElementaryModelMock model,
    this.wantKeepAlive = true,
  }) : super(model);

  @override
  void initWidgetModel() {
    if (!wantKeepAlive) {
      setupWantKeepAlive(false);
    }
    super.initWidgetModel();
  }
}

class TestElementaryWidget
    extends ElementaryWidget<IElementaryWidgetModelTest> {
  final ScrollController controller;
  final List<Widget> listViewContent;

  const TestElementaryWidget(
    WidgetModelFactory<
            WidgetModel<ElementaryWidget<IWidgetModel>, ElementaryModel>>
        wmFactory, {
    required this.controller,
    required this.listViewContent,
    Key? key,
  }) : super(
          wmFactory,
          key: key,
        );

  @override
  Widget build(IElementaryWidgetModelTest wm) {
    return Scaffold(
      body: ListView(
        key: listViewKey,
        controller: controller,
        children: listViewContent,
      ),
    );
  }
}

class TestTabScreen extends StatelessWidget {
  final Widget testWidget;
  final TabController controller;

  const TestTabScreen(
    this.testWidget,
    this.controller, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TabBarView(
        controller: controller,
        children: [
          testWidget,
          Scaffold(
            key: secondTabKey,
            body: ListView(),
          ),
        ],
      ),
    );
  }
}

class ElementaryModelMock extends Mock implements ElementaryModel {}
