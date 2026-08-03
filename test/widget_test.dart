import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easy_reader/data/local/database/app_database.dart';
import 'package:easy_reader/main.dart';
import 'package:easy_reader/presentation/common/providers.dart';

void main() {
  testWidgets('mostra la libreria vuota al primo avvio', (
    WidgetTester tester,
  ) async {
    // Database in memoria: nei widget test non sono disponibili i platform
    // channel (path_provider) usati dal database reale.
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(
          AppDatabase.forTesting(NativeDatabase.memory()),
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const EasyReaderApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('La mia libreria'), findsOneWidget);
    expect(find.text('Nessun libro ancora'), findsOneWidget);

    // drift schedula un timer a durata zero quando lo stream query viene
    // chiuso: lo si lascia scattare qui, in modo controllato, prima che il
    // framework di test verifichi l'assenza di timer pendenti a fine test.
    container.dispose();
    await tester.pump(Duration.zero);
  });
}
