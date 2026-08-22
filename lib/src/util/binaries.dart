import 'dart:io';

/// Run a process.
Future<ProcessResult> run(String executable, List<String> args) async {
  return Process.run(executable, args);
}

/// FFmpeg.
Future<void> ffmpeg(List<String> args) async {
  await run('ffmpeg', args);
}

/// FFmpeg with YP3 x264 patch.
Future<void> ffmpegYp3Patch(List<String> args) async {
  await run('ffmpeg-yp3-patch', args);
}

/// Image Magick convert.
Future<void> imageMagick(List<String> args) async {
  await run('convert', args);
}

/// Calibre ebook-convert.
Future<void> ebookConvert(List<String> args) async {
  await run('ebook-convert', args);
}
