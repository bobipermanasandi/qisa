import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qisa/common/enum/result_state.dart';
import 'package:qisa/common/router/page_manager.dart';
import 'package:qisa/data/api/api_service.dart';
import 'package:qisa/provider/story_provider.dart';
import 'package:qisa/ui/widgets/card_item_widget.dart';
import 'package:qisa/utils/helper.dart';
import 'package:qisa/utils/info_util.dart';

class HomeScreen extends StatefulWidget {
  final Function(String) onTapped;
  final Function() onAddStories;
  final Function() onLogout;
  const HomeScreen({
    super.key,
    required this.onTapped,
    required this.onAddStories,
    required this.onLogout,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _key = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    HelperNav.afterBuildWidgetCallback(() async {
      final pageManager = context.read<PageManager>();
      final shoudRefresh = await pageManager.waitForResult();

      if (shoudRefresh) {
        _key.currentState?.show();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StoryProvider(apiService: ApiService()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Qisa'),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () => widget.onLogout(),
              icon: Icon(Icons.logout_rounded),
            ),
          ],
        ),
        body: Center(
          child: Consumer<StoryProvider>(
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
                  return RefreshIndicator(
                    key: _key,
                    onRefresh: () => provider.getStories(),
                    child: ListView.separated(
                      itemCount: provider.stories.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final storyItem = provider.stories[index];
                        return CardItemWidget(
                          story: storyItem,
                          onTapped: widget.onTapped,
                        );
                      },
                    ),
                  );
                default:
                  return Container();
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff9f050d),
          onPressed: () => widget.onAddStories(),
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
