import 'package:me/data/models/message.dart';
import 'package:me/data/models/project.dart';

abstract class IAPIRepository {
  Future<List<Project>> getProjects();
  Future<bool> sendThanks(Message message);
}
