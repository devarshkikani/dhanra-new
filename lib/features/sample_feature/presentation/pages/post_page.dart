import 'package:flutter/material.dart';
import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/features/sample_feature/presentation/bloc/post_bloc.dart';
import 'package:dhanra_new/features/sample_feature/presentation/bloc/post_event.dart';
import 'package:dhanra_new/features/sample_feature/presentation/bloc/post_state.dart';
import 'package:dhanra_new/features/sample_feature/presentation/widgets/post_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PostBloc>()..add(const FetchPostsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Production AI-First Posts'),
          centerTitle: true,
        ),
        body: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostLoadedState) {
              if (state.posts.isEmpty) {
                return const Center(child: Text('No posts available.'));
              }
              return ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  return PostCard(post: state.posts[index]);
                },
              );
            } else if (state is PostErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<PostBloc>().add(const FetchPostsEvent());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
