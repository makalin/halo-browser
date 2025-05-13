import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:halo_browser/screens/browser_screen.dart';
import 'package:halo_browser/providers/browser_provider.dart';
import 'package:halo_browser/providers/theme_provider.dart';

void main() {
  late BrowserProvider browserProvider;
  late ThemeProvider themeProvider;

  setUp(() {
    browserProvider = BrowserProvider();
    themeProvider = ThemeProvider();
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BrowserProvider>.value(value: browserProvider),
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
      ],
      child: const MaterialApp(
        home: BrowserScreen(),
      ),
    );
  }

  group('BrowserScreen', () {
    testWidgets('renders tab bar', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(CustomTabBar), findsOneWidget);
    });

    testWidgets('renders address bar', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(AddressBar), findsOneWidget);
    });

    testWidgets('renders web view', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(InAppWebView), findsOneWidget);
    });

    testWidgets('shows loading indicator when loading', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      browserProvider.setLoading(true);
      await tester.pump();
      expect(find.byType(LinearProgressIndicator), findsOneWidget);

      browserProvider.setLoading(false);
      await tester.pump();
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });
  });
} 