// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloaded_lesson_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadedLessonModelAdapter extends TypeAdapter<DownloadedLessonModel> {
  @override
  final int typeId = 0;

  @override
  DownloadedLessonModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadedLessonModel(
      courseId: fields[0] as String,
      lessonId: fields[1] as String,
      filePath: fields[2] as String,
      originalUrl: fields[3] as String,
      status: fields[4] as String,
      progress: fields[5] as double,
      fileSize: fields[6] as int,
      downloadedAt: fields[7] as DateTime,
      errorMessage: fields[8] as String?,
      lessonTitle: fields[9] as String?,
      courseTitle: fields[10] as String?,
      courseSlug: fields[11] as String?,
      courseDetailJson: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadedLessonModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.courseId)
      ..writeByte(1)
      ..write(obj.lessonId)
      ..writeByte(2)
      ..write(obj.filePath)
      ..writeByte(3)
      ..write(obj.originalUrl)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.progress)
      ..writeByte(6)
      ..write(obj.fileSize)
      ..writeByte(7)
      ..write(obj.downloadedAt)
      ..writeByte(8)
      ..write(obj.errorMessage)
      ..writeByte(9)
      ..write(obj.lessonTitle)
      ..writeByte(10)
      ..write(obj.courseTitle)
      ..writeByte(11)
      ..write(obj.courseSlug)
      ..writeByte(12)
      ..write(obj.courseDetailJson);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadedLessonModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
