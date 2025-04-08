import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qisa/common/enum/result_state.dart';
import 'package:qisa/data/api/api_service.dart';
import 'package:qisa/provider/story_detail_provider.dart';
import 'package:qisa/utils/info_util.dart';

class StoryDetailScreen extends StatelessWidget {
  final String storyId;

  const StoryDetailScreen({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StoryDetailProvider>(
      create:
          (context) =>
              StoryDetailProvider(apiService: ApiService(), id: storyId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail Story'),
          backgroundColor: Colors.white,
        ),
        body: Consumer<StoryDetailProvider>(
          builder: (context, provider, _) {
            switch (provider.state) {
              case ResultState.loading:
                return const Center(child: CircularProgressIndicator());
              case ResultState.error:
                InfoUtil.showToast(provider.message);
                return Container();
              case ResultState.noData:
                InfoUtil.showToast(provider.message);
                return Container();
              case ResultState.hasData:
                var story = provider.result!.story;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        Container(
                          height: 300,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(story.photoUrl),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              const SizedBox(height: 24),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Name',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    story.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Description',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    story.description,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }
}
