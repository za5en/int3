import 'package:flutter/material.dart';

class Load extends StatelessWidget {
  const Load({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).hoverColor,
      body: SafeArea(
        child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2.25,
                    ),
                    const Text(
                      'Search System loaded',
                      // style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      //       fontSize: 30,
                      //       fontFamily: 'Comfortaa',
                      //       fontWeight: FontWeight.w700,
                      //     ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/home', (route) => false);
                        },
                        child: const Text('start')),
                  ],
                ))),
      ),
    );
  }
}
