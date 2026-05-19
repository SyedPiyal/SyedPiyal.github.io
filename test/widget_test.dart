import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/data/datasources/static_datasource.dart';
import 'package:portfolio/data/repositories/portfolio_repository_impl.dart';
import 'package:portfolio/main.dart';
import 'package:portfolio/presentation/state/portfolio_notifier.dart';

void main() {
  testWidgets('Portfolio main view load smoke test', (WidgetTester tester) async {
    // 1. Arrange
    final staticDataSource = StaticPortfolioDataSource();
    final repository = PortfolioRepositoryImpl(dataSource: staticDataSource);
    final portfolioNotifier = PortfolioNotifier(repository: repository);

    // 2. Act & Build our app and trigger a frame.
    await tester.pumpWidget(
      MyApp(notifier: portfolioNotifier),
    );

    // 3. Assert - Check that we can find the app bootstrap loader text
    expect(find.text('SYED'), findsWidgets);
  });
}
