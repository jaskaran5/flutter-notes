import 'package:flutter/material.dart';

class ScrollError extends StatelessWidget {
  const ScrollError({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Content First ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'hhhaha',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        minLines: 1,
                        maxLines: 50,
                        decoration: InputDecoration(
                          hintText: 'hhhaha',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'hhhaha',
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.blue),
                          tapTargetSize: MaterialTapTargetSize.padded,
                        ),
                        child: const Text('send'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
