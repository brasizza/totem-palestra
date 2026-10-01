import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:totem_palestra/totem_palestra.dart';

void main() {
  runApp(const MyApp());
}

const _flutterNavy = Color(0xFF02569B);
const _flutterBlue = Color(0xFF0175C2);
const _flutterSky = Color(0xFF13B9FD);
const _purple = Color(0xFF6A1B9A);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Totem Palestra',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _flutterNavy,
        brightness: Brightness.dark,
      ),
      home: const PrintHomePage(),
    );
  }
}

class PrintHomePage extends StatefulWidget {
  const PrintHomePage({super.key});

  @override
  State<PrintHomePage> createState() => _PrintHomePageState();
}

class _PrintHomePageState extends State<PrintHomePage>
    with SingleTickerProviderStateMixin {
  String _platformVersion = 'Unknown';
  bool _printing = false;
  final _totemPalestraPlugin = TotemPalestra();
  final _textController = TextEditingController(text: 'EU AMO FLUTTER');
  late final AnimationController _heartController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    _textController.addListener(() => setState(() {}));
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _totemPalestraPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _printLine() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _printing) return;

    setState(() => _printing = true);

    String message;
    bool success;
    try {
      await _totemPalestraPlugin.printLine(text);
      message = 'Enviado para a impressora!';
      success = true;
    } on PlatformException catch (e) {
      message = 'Falha ao imprimir: ${e.code} ${e.message ?? ''}';
      success = false;
    }

    if (!mounted) return;

    setState(() => _printing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: success ? Colors.green.shade600 : Colors.red.shade600,
        content: Row(
          children: [
            Icon(success ? Icons.check_circle : Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const _Background(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildPreview(),
                      const SizedBox(height: 32),
                      _buildTextField(),
                      const SizedBox(height: 16),
                      _buildPrintButton(),
                      const SizedBox(height: 32),
                      _buildPlatformChip(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    final text = _textController.text.trim();

    return _GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          ScaleTransition(
            scale: Tween(begin: 0.85, end: 1.15).animate(
              CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
            ),
            child: const Icon(
              Icons.favorite,
              size: 56,
              color: Color(0xFFFF4D8D),
              shadows: [Shadow(color: Color(0x88FF4D8D), blurRadius: 24)],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween(begin: 0.95, end: 1.0).animate(animation),
                  child: child,
                ),
              ),
              child: text.isEmpty
                  ? Text(
                      'Digite algo abaixo...',
                      key: const ValueKey('placeholder'),
                      style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    )
                  : FittedBox(
                      key: ValueKey(text),
                      fit: BoxFit.scaleDown,
                      child: ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.white, Color(0xFFB3ECFF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            height: 1.1,
                            shadows: [
                              Shadow(
                                color: Color(0x66000000),
                                offset: Offset(0, 4),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _textController,
      textCapitalization: TextCapitalization.characters,
      textInputAction: TextInputAction.send,
      onSubmitted: (_) => _printLine(),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: 'Digite sua mensagem',
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
        prefixIcon: const Icon(Icons.edit, color: Colors.white),
        suffixIcon: _textController.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: _textController.clear,
              ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.15),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.6)),
        ),
      ),
    );
  }

  Widget _buildPrintButton() {
    final canPrint = !_printing && _textController.text.trim().isNotEmpty;

    return SizedBox(
      height: 60,
      child: FilledButton.icon(
        onPressed: canPrint ? _printLine : null,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: _flutterNavy,
          disabledBackgroundColor: Colors.white.withValues(alpha: 0.4),
          disabledForegroundColor: _flutterNavy.withValues(alpha: 0.6),
          elevation: 6,
          shadowColor: Colors.black45,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        icon: _printing
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: _flutterNavy,
                ),
              )
            : const Icon(Icons.print_rounded, size: 26),
        label: Text(_printing ? 'Imprimindo...' : 'Enviar para impressora'),
      ),
    );
  }

  Widget _buildPlatformChip() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          'Running on: $_platformVersion',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_flutterNavy, _flutterBlue, _flutterSky, _purple],
            stops: [0.0, 0.35, 0.65, 1.0],
          ),
        ),
        child: Stack(
          children: const [
            _Blob(top: -80, left: -60, size: 260, color: _flutterSky),
            _Blob(bottom: -100, right: -80, size: 320, color: Color(0xFFFF4D8D)),
            _Blob(top: 220, right: -120, size: 220, color: _purple),
          ],
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.size,
    required this.color,
  });

  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.55),
          ),
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(28);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: radius,
            border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
          ),
          child: child,
        ),
      ),
    );
  }
}
