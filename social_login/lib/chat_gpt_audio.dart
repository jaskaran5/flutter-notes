import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

// for this we need to add microphone permissions for android /ios

class ChatGptAudio extends StatefulWidget {
  const ChatGptAudio({super.key});

  @override
  State<ChatGptAudio> createState() => _ChatGptAudioState();
}

class _ChatGptAudioState extends State<ChatGptAudio> {
  SpeechToText speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat GPT Audio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  // If listening is active show the recognized words
                  speechToText.isListening
                      ? _lastWords
                      // If listening isn't active but could be tell the user
                      // how to start it, otherwise indicate that speech
                      // recognition is not yet ready or not supported on
                      // the target device
                      : _speechEnabled
                          ? 'Tap the microphone to start listening...'
                          : 'Speech not available',
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            // If not yet listening for speech start, otherwise stop
            speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
