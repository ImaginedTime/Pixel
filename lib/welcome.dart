import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import './home.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            // image: AssetImage('./assets/welcome1.png'),
            image: MediaQuery.of(context).size.width > 600
                ? const AssetImage('./assets/welcome.png')
                : const AssetImage('./assets/welcome1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FadeInUp(
                  duration: const Duration(milliseconds: 750),
                  from: 30.0,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Pixel",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 56.0,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 750),
                  from: 20.0,
                  delay: const Duration(milliseconds: 250),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Every pixel tells a story",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FadeInUp(
                  duration: const Duration(milliseconds: 750),
                  from: 20.0,
                  delay: const Duration(milliseconds: 500),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: WidgetStateProperty.all(0.0),
                      minimumSize: WidgetStateProperty.all(const Size(200, 60)),
                      backgroundColor: WidgetStateProperty.all(Colors.black),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        // MaterialPageRoute(builder: (context) => const Home()));
                        PageRouteBuilder(
                          pageBuilder: (BuildContext context, _, __) =>
                              const Home(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: const Text("Explore now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        )),
                  ),
                ),
                const SizedBox(height: 40.0),
                const Text(
                  "Made with ❤️ by Uday",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
