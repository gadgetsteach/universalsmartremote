import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/channels/ir_channel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _hasIrEmitter = false;

  @override
  void initState() {
    super.initState();
    _checkIrEmitter();
  }

  Future<void> _checkIrEmitter() async {
    final hasIr = await IrChannel.hasIrEmitter();
    setState(() {
      _hasIrEmitter = hasIr;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universal Smart Remote'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _hasIrEmitter ? Icons.sensors : Icons.sensors_off,
              size: 64,
              color: _hasIrEmitter ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              _hasIrEmitter 
                  ? 'IR Blaster Detected' 
                  : 'This device does not support Infrared.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
