import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String eventMessage;
  const Loading({Key? key, this.eventMessage = 'Loading...'}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              strokeWidth: 6.0,
              backgroundColor: Colors.white60,
            ),
            const SizedBox(height: 16.0),
            Text(eventMessage),
          ],
        ),
      ),
    );
  }
}
