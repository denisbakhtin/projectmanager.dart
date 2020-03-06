abstract class Serializable {
  Serializable();
  Serializable fromMap(Map<String, dynamic> map){
    return null;
  }
  Map<String, dynamic> asMap(){
    return null;
  }
  void some() {}
}