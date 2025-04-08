import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qisa/common/enum/input_type.dart';
import 'package:qisa/common/enum/result_state.dart';
import 'package:qisa/common/router/page_manager.dart';
import 'package:qisa/data/api/api_service.dart';
import 'package:qisa/data/models/request/request_add_story_model.dart';
import 'package:qisa/provider/img_provider.dart';
import 'package:qisa/provider/story_add_provider.dart';
import 'package:qisa/ui/widgets/button_widget.dart';
import 'package:qisa/ui/widgets/input_widget.dart';
import 'package:qisa/utils/helper.dart';
import 'package:qisa/utils/info_util.dart';

class StoryAddScreen extends StatefulWidget {
  final Function() onAddedStory;
  const StoryAddScreen({super.key, required this.onAddedStory});

  @override
  State<StoryAddScreen> createState() => _StoryAddScreenState();
}

class _StoryAddScreenState extends State<StoryAddScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StoryAddProvider>(
      create: (context) => StoryAddProvider(apiService: ApiService()),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Add Story'),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Expanded(
                        child: Consumer<ImgProvider>(
                          builder: (context, provider, _) {
                            if (provider.imagePath != null) {
                              return Container(
                                height: 250,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: FileImage(File(provider.imagePath!)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }
                            return Container(
                              height: 250,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.image,
                                size: 80,
                                color: Colors.grey.withValues(alpha: 0.5),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed:
                                () => _onImageView(context, ImageSource.camera),
                            child: const Text('Camera'),
                          ),
                          ElevatedButton(
                            onPressed:
                                () =>
                                    _onImageView(context, ImageSource.gallery),
                            child: const Text('Gallery'),
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 30),
                            InputWidget(
                              controller: descriptionController,
                              labelText: 'Description',
                              hintText: 'Your Description',
                              maxLines: 5,
                              type: InputType.description,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter description.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Consumer<StoryAddProvider>(
                              builder: (context, provider, _) {
                                _handleState(provider);
                                return ButtonWidget(
                                  text: 'UPLOAD',
                                  isLoading:
                                      (provider.state == ResultState.loading),
                                  onPressed: () {
                                    final imgProvider =
                                        context.read<ImgProvider>();
                                    if (_formKey.currentState?.validate() ==
                                            true &&
                                        imgProvider.imagePath != null) {
                                      provider.addStory(
                                        RequestAddStoryModel(
                                          photo: File(imgProvider.imagePath!),
                                          description:
                                              descriptionController.text,
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onImageView(BuildContext context, ImageSource source) async {
    final provider = context.read<ImgProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _handleState(StoryAddProvider provider) {
    switch (provider.state) {
      case ResultState.hasData:
        HelperNav.afterBuildWidgetCallback(() {
          context.read<PageManager>().returnData(true);
          widget.onAddedStory();
          InfoUtil.showToast(provider.message);
        });
        break;
      case ResultState.noData:
        InfoUtil.showToast(provider.message);
        break;
      case ResultState.error:
        InfoUtil.showToast(provider.message);
        break;
      default:
        break;
    }
  }
}
