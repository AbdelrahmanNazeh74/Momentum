import 'package:hive/hive.dart';
import 'package:momentum/features/HomeScreen/data/models/priority.dart';

class PriorityAdapter extends TypeAdapter<Priority> {
  @override
  final int typeId = 3;

  @override
  Priority read(BinaryReader reader) {
    return Priority.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, Priority obj) {
    writer.writeByte(obj.index);
  }
}
