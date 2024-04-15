import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _text = 'Press the button and statr speaking';

  @override
  void initState() {
    _initState();
    super.initState();
  }

  void _initState() async {
    _isListening = await _speechToText.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: !_isListening,
        glowRadiusFactor: 1,
        glowColor: Colors.red,
        duration: Duration(milliseconds: 2000),
        repeat: true,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: FloatingActionButton(
            onPressed: _listen,
            backgroundColor: Colors.red,
            child: Icon(
              !_isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 80,
            left: 30,
            right: 30,
          ),
          child: Text(
            _text.toLowerCase(),
            style: const TextStyle(
              fontSize: 32,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  void _listen() async {
    if (_isListening) {
      _isListening = false;
      setState(() {});

      final options = SpeechListenOptions(
        listenMode: ListenMode.confirmation,
        cancelOnError: true,
        partialResults: true,
        autoPunctuation: true,
        enableHapticFeedback: true,
        sampleRate: 2,
      );
      _speechToText.listen(
        listenOptions: options,
        onResult: (val) {
          _text = val.recognizedWords;
          setState(() {});
        },
      );
    } else {
      await _speechToText.stop();
      _isListening = true;
      setState(() {});
    }
  }
}
