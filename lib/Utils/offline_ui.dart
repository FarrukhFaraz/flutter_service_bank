import 'package:flutter/material.dart';
import 'package:service_bank/Utils/colors.dart';

class OfflineUI extends StatelessWidget {
  const OfflineUI({Key? key, required this.function}) : super(key: key);

  final Function function;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhite,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/no_internet.jpg",
                width: MediaQuery.of(context).size.width * 0.8,
              ),
              const Text("No internet connection\nPlease try again"),
              const SizedBox(height: 6),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    // backgroundColor: bgWhite,
                    // foregroundColor: kBlack,
                    elevation: 1),
                onPressed: () {
                  function();
                },
                child: const Text("Retry"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
