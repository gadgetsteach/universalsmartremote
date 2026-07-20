import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:universalsmartremote/main.dart';
import 'package:universalsmartremote/presentation/home/providers/ir_provider.dart';
import 'package:universalsmartremote/domain/repositories/ir_repository.dart';

class MockIrRepository extends Mock implements IrRepository {}

void main() {
  testWidgets('HomeScreen displays IR Blaster Detected when available', (WidgetTester tester) async {
    // Override the provider to return true
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          irEmitterCheckProvider.overrideWith((ref) => Future.value(true)),
        ],
        child: const UniversalSmartRemoteApp(),
      ),
    );

    // Wait for FutureProvider to resolve
    await tester.pumpAndSettle();

    expect(find.text('IR Blaster Detected'), findsOneWidget);
    expect(find.byIcon(Icons.sensors), findsOneWidget);
  });

  testWidgets('HomeScreen displays unsupported message when IR is unavailable', (WidgetTester tester) async {
    // Override the provider to return false
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          irEmitterCheckProvider.overrideWith((ref) => Future.value(false)),
        ],
        child: const UniversalSmartRemoteApp(),
      ),
    );

    // Wait for FutureProvider to resolve
    await tester.pumpAndSettle();

    expect(find.text('This device does not support Infrared.'), findsOneWidget);
    expect(find.byIcon(Icons.sensors_off), findsOneWidget);
  });
}
