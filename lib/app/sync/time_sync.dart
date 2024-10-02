abstract class TimeSync {
  Future<Duration?> getDifference();
  Future<String> getName();
  String getID();
  String toJson();
  void loadFromJson(String jsonStr);
}