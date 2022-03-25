import 'package:me/data/models/message.dart';
import 'package:me/data/models/project.dart';
import 'package:me/data/services/api_service.dart';
import 'api_repository_interface.dart';

class APIRepository implements IAPIRepository {
  final APIService _apiService = APIService();
  @override
  Future<List<Project>> getProjects() => _apiService.fetchProjects();
  @override
  Future<bool> sendThanks(Message message) => _apiService.sendThanks(message);
}
