import 'dart:io';
import 'package:image/image.dart' as img;

/// Pads PNG images with transparent margins to avoid launcher mask clipping.
/// Usage:
///   dart run tool/pad_icons.dart <input1.png> [input2.png ...]
/// Writes files next to the inputs with suffix _padded.png
void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln(
      'Usage: dart run tool/pad_icons.dart [--pad=0.18] <img1.png> [img2.png ...]',
    );
    exit(64);
  }

  // Parse optional --pad parameter (fraction or percent). Default 0.18
  double paddingFraction = 0.18;
  final imagePaths = <String>[];
  for (final arg in args) {
    if (arg.startsWith('--pad=')) {
      final value = arg.substring('--pad='.length);
      final parsed = double.tryParse(value);
      if (parsed != null) {
        paddingFraction = parsed > 1 ? parsed / 100.0 : parsed;
      }
      continue;
    }
    imagePaths.add(arg);
  }

  if (imagePaths.isEmpty) {
    stderr.writeln('No image paths provided.');
    exit(64);
  }

  for (final path in imagePaths) {
    final file = File(path);
    if (!file.existsSync()) {
      stderr.writeln('Skip missing: $path');
      continue;
    }
    final bytes = file.readAsBytesSync();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      stderr.writeln('Unsupported image: $path');
      continue;
    }

    final int padX = (decoded.width * paddingFraction).round();
    final int padY = (decoded.height * paddingFraction).round();

    final int newW = decoded.width + padX * 2;
    final int newH = decoded.height + padY * 2;

    final canvas = img.Image(width: newW, height: newH);
    // Start fully transparent.
    img.fill(canvas, color: img.ColorUint8.rgba(0, 0, 0, 0));
    img.compositeImage(canvas, decoded, dstX: padX, dstY: padY);

    final outputBytes = img.encodePng(canvas);
    final lower = path.toLowerCase();
    final outPath =
        lower.endsWith('.png')
            ? path.substring(0, path.length - 4) + '_padded.png'
            : path + '_padded.png';
    File(outPath).writeAsBytesSync(outputBytes);
    stdout.writeln('Wrote: $outPath');
    // Also write a monochrome version for Android themed icons.
    final mono = img.Image.from(canvas);
    for (int y = 0; y < mono.height; y++) {
      for (int x = 0; x < mono.width; x++) {
        final px = mono.getPixel(x, y);
        final a = px.a; // keep original alpha
        mono.setPixelRgba(x, y, 255, 255, 255, a);
      }
    }
    final monoBytes = img.encodePng(mono);
    final monoPath = outPath.replaceFirst('_padded.png', '_padded_mono.png');
    File(monoPath).writeAsBytesSync(monoBytes);
    stdout.writeln('Wrote: $monoPath');
  }
}
