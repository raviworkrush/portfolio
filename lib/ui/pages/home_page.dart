import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:me/bloc/message/message_cubit.dart';
import 'package:me/bloc/project/project_cubit.dart';
import 'package:me/data/models/message.dart';
import 'package:me/data/models/project.dart';
import 'package:me/data/utils/contants.dart';
import 'package:me/data/utils/responsive.dart';
import 'package:me/data/utils/ui_helpers.dart';
import 'package:me/ui/widgets/loading.dart';
import 'package:me/ui/widgets/social_accounts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 6), () {
      _showForm(context);
    });
  }

  void _showForm(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.orange),
              ),
              backgroundColor: Colors.black,
              title: const Text('Hey There!', textAlign: TextAlign.center),
              content: BlocConsumer<MessageCubit, MessageState>(
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
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (input) =>
                              input!.validateName() ? null : 'Invalid name',
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
                          validator: (input) => input!.validateEmail()
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
                          child: Text(
                            'Submit',
                            style: Theme.of(context).textTheme.button,
                          ),
                          onPressed: () {
                            if (_nameController.text.isNotEmpty &&
                                _emailController.text.isNotEmpty &&
                                _nameController.text.validateName() &&
                                _emailController.text.validateEmail()) {
                              context.read<MessageCubit>().sendMessage(
                                    Message(
                                      name: _nameController.text,
                                      email: _emailController.text,
                                      message: _messageController.text,
                                      dateTime:
                                          DateTime.now().toIso8601String(),
                                    ),
                                  );
                            } else {
                              showMessage(context, 'Error!',
                                  'Please enter valid details!');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            primary: Colors.orange,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: OutlinedButton(
                            child: Text(
                              'Cancel',
                              style: Theme.of(context).textTheme.button,
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 56.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ));
  }

  void _showLinks(BuildContext context, Project project) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.orange),
              ),
              backgroundColor: Colors.black,
              title: project.name?.isNotEmpty == true
                  ? Text('${project.name}', textAlign: TextAlign.center)
                  : const SizedBox.shrink(),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    project.demoUrl?.isNotEmpty == true
                        ? ListTile(
                            title: const Text('Demo Video'),
                            trailing: const Icon(Icons.play_arrow),
                            onTap: () {
                              //launch(project.demoUrl);
                              launchURL(context, '${project.demoUrl}');
                            },
                          )
                        : const SizedBox.shrink(),
                    project.appUrl?.isNotEmpty == true
                        ? ListTile(
                            title: const Text('Application Link'),
                            trailing: const Icon(Icons.android),
                            onTap: () {
                              //launch(project.appUrl);
                              launchURL(context, '${project.appUrl}');
                            },
                          )
                        : const SizedBox.shrink(),
                    project.webUrl?.isNotEmpty == true
                        ? ListTile(
                            title: const Text('Web Link'),
                            trailing: const Icon(Icons.language),
                            onTap: () {
                              launchURL(context, '${project.webUrl}');
                            },
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Text(
                    'Okay!',
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    primary: Colors.orange,
                  ),
                )
              ],
            ));
  }

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
                        'This is a simple Portfolio web application made with Flutter. This app is made by Ravi Kovind. This app is open sourced on GitHub.'),
                    trailing: const Icon(FontAwesomeIcons.github),
                    onTap: () {
                      launchURL(
                          context, 'https://github.com/ravikovind/portfolio');
                    },
                  ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.email),
            onPressed: () {
              _showForm(context);
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
                      child: Lottie.asset('assets/animations/json_2.json',
                          fit: BoxFit.contain,
                          reverse: true,
                          height: MediaQuery.of(context).size.width * 0.5),
                    )
                  : const SizedBox.shrink(),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    Text(
                      "Hey there! I am ",
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: isDeviceDesktop(context) ? 20 : 16.0),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      "Ravi Kovind",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isDeviceDesktop(context) ? 48.0 : 36.0,
                      ),
                    ),
                    Text(
                      "Flutter Dev || Learner || NITain.",
                      style: TextStyle(
                        fontSize: isDeviceDesktop(context) ? 24 : 16.0,
                      ),
                    ),
                    const SocialAccounts(
                      alignment: MainAxisAlignment.start,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      "I have recently graduated from NIT Allahabad,\nspecializing in building & designing \nexceptional websites, \napplications, and everything in between.",
                      style: TextStyle(
                        fontSize: isDeviceDesktop(context) ? 18.0 : 16.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        side: const BorderSide(width: 2, color: Colors.orange),
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
                          style: Theme.of(context).textTheme.button?.copyWith(
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
                horizontal: MediaQuery.of(context).size.width * 0.1,
                vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "About",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Text(
                  kAbout,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16.0,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
          ),
          BlocConsumer<ProjectCubit, ProjectState>(
            listener: (context, state) {
              if (state is ProjectError) {
                showMessage(context, 'Error!', state.message);
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
                      horizontal: MediaQuery.of(context).size.width * 0.1,
                      vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 16.0,
                      ),
                      const Text(
                        "Projects",
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
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
                          return ListTile(
                            title: Text('${project.name}'),
                            subtitle: Text('${project.description}'),
                            onTap: () => _showLinks(context, project),
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
                  const Text("Get in Touch",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold)),
                  const Text(
                    "Currently looking for new Opportunities.\nI’m available for any information needed from my end.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
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
                        style: Theme.of(context).textTheme.caption,
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
                    "thank you for Visiting.",
                  ),
                  const Text(
                    "Made with Love in India",
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
