import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/features/sample_feature/domain/entities/post.dart';
import 'package:dhanra_new/features/sample_feature/presentation/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await getIt.reset();
    await configureDependencies();
  });

  testWidgets('PostCard renders post title and body', (tester) async {
    const tPost = Post(
      id: 1,
      userId: 1,
      title: 'Sample Title',
      body: 'Sample Body Content',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PostCard(post: tPost),
        ),
      ),
    );

    expect(find.text('Sample Title'), findsOneWidget);
    expect(find.text('Sample Body Content'), findsOneWidget);
  });
}
