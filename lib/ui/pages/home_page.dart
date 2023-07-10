import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:me/bloc/message/message_cubit.dart';
import 'package:me/bloc/project/project_cubit.dart';
import 'package:me/data/models/message.dart';
import 'package:me/data/utils/contants.dart';
import 'package:me/data/utils/responsive.dart';
import 'package:me/data/utils/ui_helpers.dart';
import 'package:me/ui/widgets/loading.dart';
import 'package:me/ui/widgets/social_accounts.dart';
import 'package:string_contains/string_contains.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 6), () {
      welcome(context);
    });
  }

  Future<void> welcome(BuildContext context) async => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.black,
        builder: (context) => Form(
          key: formKey,
          child: BlocConsumer<MessageCubit, MessageState>(
            listener: (context, state) {
              if (state is MessageSent) {
                Navigator.of(context).pop();
                showMessage(context, 'Success!', state.message);
              } else if (state is MessageError) {
                Navigator.of(context).pop();
                showMessage(context, 'Error!', state.message);
              }
            },
            builder: (context, state) {
              if (state is MessageSending) {
                return const Loading();
              }
              return SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  child: Column(
                    children: [
                      Text(
                        'Hey There! Welcome!',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        controller: _nameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (input) =>
                            input?.isEmpty == true || (input?.length ?? 0) < 3
                                ? 'Please enter your name!'
                                : null,
                        decoration: const InputDecoration(
                          hintText: "Enter your name",
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        controller: _emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (input) => input.containsEmail()
                            ? null
                            : 'Please enter valid email!',
                        decoration: const InputDecoration(
                          hintText: "Enter your email",
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: "Enter your message",
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() == true) {
                            context.read<MessageCubit>().sendMessage(
                                  Message(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    message: _messageController.text,
                                    dateTime: DateTime.now().toIso8601String(),
                                  ),
                                );
                          } else {
                            showMessage(
                              context,
                              'Error!',
                              'Please enter valid details!',
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56.0),
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text(
                          'Submit',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: OutlinedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );

  // void _showLinks(BuildContext context, Project project) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       surfaceTintColor: Colors.black45,
  //       title: project.name?.isNotEmpty == true
  //           ? Text('${project.name}', textAlign: TextAlign.center)
  //           : const SizedBox.shrink(),
  //       content: SingleChildScrollView(
  //         child: Column(
  //           children: [
  //             project.demoUrl?.isNotEmpty == true
  //                 ? ListTile(
  //                     title: const Text('Demo Video'),
  //                     trailing: const Icon(Icons.play_arrow),
  //                     onTap: () {
  //                       launchURL(context, '${project.demoUrl}');
  //                     },
  //                   )
  //                 : const SizedBox.shrink(),
  //             project.appUrl?.isNotEmpty == true
  //                 ? ListTile(
  //                     title: const Text('Application Link'),
  //                     trailing: const Icon(Icons.android),
  //                     onTap: () {
  //                       //launch(project.appUrl);
  //                       launchURL(context, '${project.appUrl}');
  //                     },
  //                   )
  //                 : const SizedBox.shrink(),
  //             project.webUrl?.isNotEmpty == true
  //                 ? ListTile(
  //                     title: const Text('Web Link'),
  //                     trailing: const Icon(Icons.language),
  //                     onTap: () {
  //                       launchURL(context, '${project.webUrl}');
  //                     },
  //                   )
  //                 : const SizedBox.shrink(),
  //           ],
  //         ),
  //       ),
  //       actions: <Widget>[
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //           style: ElevatedButton.styleFrom(
  //             minimumSize: const Size(double.infinity, 56.0),
  //             backgroundColor: Colors.orange,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(12.0),
  //             ),
  //           ),
  //           child: Text(
  //             'Okay!',
  //             style: Theme.of(context).textTheme.labelLarge,
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'Portfolio',
                applicationVersion: '1.0.0',
                applicationIcon: const FlutterLogo(),
                applicationLegalese: 'Ravi Kovind © 2022',
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: const Text('About'),
                    subtitle: const Text(
                      'This is a simple Portfolio web application made with Flutter.',
                    ),
                    trailing: const Icon(FontAwesomeIcons.github),
                    onTap: () {
                      launchURL(
                        context,
                        'https://github.com/ravikovind/portfolio',
                      );
                    },
                  ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.email),
            onPressed: () {
              welcome(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              isDeviceDesktop(context)
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: Lottie.asset(
                        'assets/animations/json_2.json',
                        fit: BoxFit.contain,
                        reverse: true,
                        height: MediaQuery.of(context).size.width * 0.5,
                      ),
                    )
                  : const SizedBox.shrink(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    Text(
                      "Hey there! I am ",
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                wordSpacing: 2.0,
                              ),
                    ),
                    Text(
                      "Ravi Kovind",
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: isDeviceDesktop(context) ? 72.0 : 48.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      "Flutter Dev || Lead Dev || NIT Allahabad",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w200,
                          ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    const SocialAccounts(
                      alignment: MainAxisAlignment.start,
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    Text(
                      "Unleashing Limitless Potential:\nExpertly Crafting Cutting-Edge\nCross-Platform Applications,\nExceptional Websites,\nand Everything in Between\nand Redefining Digital Excellence.",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            letterSpacing: 2.4,
                            wordSpacing: 2.4,
                          ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        side: BorderSide(
                          width: 1,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      onPressed: () {
                        launchURL(context, 'mailto:$kEmail');
                      },
                      icon: const Icon(
                        Icons.mail,
                      ),
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Get In Touch',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontSize:
                                        isDeviceDesktop(context) ? 18.0 : 16.0,
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: 16.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  "About",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Text(
                  kAbout,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        letterSpacing: 2.4,
                        wordSpacing: 2.4,
                      ),
                ),
              ],
            ),
          ),
          BlocConsumer<ProjectCubit, ProjectState>(
            listener: (context, state) {
              if (state is ProjectError) {
                showMessage(
                  context,
                  'Error!',
                  state.message,
                );
              }
            },
            builder: (context, state) {
              if (state is ProjectLoading) {
                return const Loading(
                  eventMessage: 'Loading Projects...',
                );
              } else if (state is ProjectLoaded) {
                final projects = state.projects;
                if (projects.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: 16.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        "Projects",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      ListView.builder(
                        itemCount: projects.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final project = projects[index];
                          return ExpansionTile(
                            title: Text(
                              '${project.name}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    fontSize:
                                        isDeviceDesktop(context) ? 18.0 : 16.0,
                                    letterSpacing: 2.4,
                                    wordSpacing: 2.4,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                  ),
                            ),
                            initiallyExpanded: true,
                            subtitle: Text('${project.description}'),
                            childrenPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            children: [
                              Builder(builder: (context) {
                                if (project.appUrl.isNullOrEmpty) {
                                  return const SizedBox.shrink();
                                }
                                return ListTile(
                                  title: Text(
                                    'Try Application',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          fontSize: isDeviceDesktop(context)
                                              ? 18.0
                                              : 16.0,
                                          letterSpacing: 2.4,
                                          wordSpacing: 2.4,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer,
                                        ),
                                  ),
                                  trailing: const Icon(
                                    Icons.android,
                                    color: Colors.green,
                                  ),
                                  onTap: () {
                                    launchURL(context, '${project.appUrl}');
                                  },
                                );
                              }),
                              Builder(builder: (context) {
                                if (project.webUrl.isNullOrEmpty) {
                                  return const SizedBox.shrink();
                                }

                                final webUrl = project.webUrl.notNullValue;

                                /// load this url in webview sized box media query 0.5
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height,
                                  child: WebViewWidget(
                                    controller: WebViewController()
                                      ..loadRequest(
                                        Uri.parse(webUrl),
                                      ),
                                  ),
                                );

                                // return ListTile(
                                //   title: Text(
                                //     'Check Website',
                                //     style: Theme.of(context)
                                //         .textTheme
                                //         .labelLarge
                                //         ?.copyWith(
                                //           fontSize: isDeviceDesktop(context)
                                //               ? 18.0
                                //               : 16.0,
                                //           letterSpacing: 2.4,
                                //           wordSpacing: 2.4,
                                //           color:
                                //               Theme.of(context).colorScheme.error,
                                //         ),
                                //   ),
                                //   trailing: const Icon(
                                //     Icons.language,
                                //     color: Colors.blue,
                                //   ),
                                //   onTap: () {
                                //     launchURL(context, '${project.webUrl}');
                                //   },
                                // );
                              }),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Get in Touch",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  "Open for new Opportunities.\nI’m available for any information needed from my end.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        letterSpacing: 2.4,
                        wordSpacing: 2.4,
                      ),
                ),
                const SizedBox(
                  height: 16,
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    side: const BorderSide(
                      width: 1.0,
                      color: Colors.orange,
                    ),
                  ),
                  onPressed: () {
                    launchURL(context, 'mailto:$kEmail');
                  },
                  icon: const Icon(
                    Icons.mail,
                  ),
                  label: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      kEmail,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const SocialAccounts(),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Thank you for Visiting.",
                ),

                /// all rights reserved @ravikovind ${DateTime.now().year} 🎉 text
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "© ${DateTime.now().year} Ravi Kovind.\nMade with Love❤️ in India 🇮🇳",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
