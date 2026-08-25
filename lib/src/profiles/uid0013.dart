import 'dart:io';

import 'package:mp3cd/src/model/converter.dart';
import 'package:mp3cd/src/util/arg_builder.dart';
import 'package:mp3cd/src/util/binaries.dart';
import 'package:mp3cd/src/util/video_extensions.dart';
import 'package:path/path.dart';

/// [Uid0013].
class Uid0013 extends Converter {
  /// Creates a new [Uid0013].
  Uid0013({required super.inputFile, required super.outputFile});

  @override
  String get id => 'uid0013';

  @override
  Future<void> audio() async {
    final targetOutputFile = (outputFile != null)
        ? outputFile!
        : File('${withoutExtension(inputFile.path)}.mp3');

    final argBuilder = ArgBuilder()
      ..single('-nostdin')
      ..single('-n')
      ..pair('-i', inputFile.path)
      ..pair('-f', 'mp3')
      ..pair('-ar:a', 16000)
      ..pair('-ac:a', 1)
      ..pair('-q:a', 8)
      ..single(targetOutputFile.path);

    await ffmpeg(argBuilder.args);
  }

  @override
  Future<void> image() async {
    final targetOutputFile = (outputFile != null)
        ? outputFile!
        : File('${withoutExtension(inputFile.path)}.$id.jpg');

    const size = '160x128';
    final argBuilder = ArgBuilder()
      ..single(inputFile.path)
      ..pair('-interlace', 'none')
      ..single('-auto-orient')
      ..pair('-colorspace', 'sRGB')
      ..single('-strip')
      ..pair('-rotate', '-90<')
      ..pair('-resize', '$size^')
      ..pair('-gravity', 'center')
      ..pair('-extent', size)
      ..single(targetOutputFile.path);

    await imageMagick(argBuilder.args);
  }

  @override
  Future<void> text() async {
    final targetOutputFile = (outputFile != null)
        ? outputFile!
        : File('${withoutExtension(inputFile.path)}.txt');

    await ebookConvert([inputFile.path, targetOutputFile.path]);
  }

  @override
  Future<void> video() async {
    final targetOutputFile = (outputFile != null)
        ? outputFile!
        : File('${withoutExtension(inputFile.path)}.$id.avi');

    final argBuilder = ArgBuilder()
      ..single('-nostdin')
      ..single('-n')
      ..pair('-i', inputFile.path);

    const size = '160:128';
    const fpsMax = 25;
    final fps = (await inputFile.getAverageFps() ?? fpsMax).clamp(1, fpsMax);

    if (await inputFile.hasAudio()) {
      argBuilder
        ..pair('-map', '0:v:0')
        ..pair('-map', '0:a:0')
        ..pair('-ar:a', 22050);
    } else {
      argBuilder
        ..pair('-f', 'lavfi')
        ..pair('-i', 'anullsrc=channel_layout=mono:sample_rate=16000')
        ..pair('-map', '0:v:0')
        ..pair('-map', '1:a')
        ..pair('-ar:a', 16000)
        ..single('-shortest');
    }

    argBuilder
      ..pair('-f', 'avi')
      ..pair('-c:v', 'mjpeg')
      ..pair(
        '-filter:v',
        'transpose=cclock:passthrough=landscape,scale=$size:force_original_aspect_ratio=increase:flags=area,crop=$size,hflip',
      )
      ..pair('-sws_flags', 'accurate_rnd+full_chroma_int+full_chroma_inp')
      ..pair('-pix_fmt:v', 'yuvj420p')
      ..pair('-r:v', fps)
      ..pair('-b:v', '600k')
      ..pair('-c:a', 'pcm_s16le')
      ..pair('-ac:a', 2);

    final passLogDirectory = await Directory.systemTemp.createTemp(
      basename(targetOutputFile.path),
    );
    final argsPass1 = ArgBuilder()
      ..args.addAll(argBuilder.args)
      ..pair('-pass', 1)
      ..pair('-passlogfile', join(passLogDirectory.path, 'log'))
      ..single('-an')
      ..pair('-f', 'null')
      ..single(Platform.isWindows ? 'NUL' : '/dev/null');

    final argsPass2 = ArgBuilder()
      ..args.addAll(argBuilder.args)
      ..pair('-pass', 2)
      ..pair('-passlogfile', join(passLogDirectory.path, 'log'))
      ..single(targetOutputFile.path);

    await ffmpeg(argsPass1.args);
    await ffmpeg(argsPass2.args);
    await passLogDirectory.delete(recursive: true);
  }
}
