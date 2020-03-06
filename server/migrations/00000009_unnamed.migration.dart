import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration9 extends Migration { 
  @override
  Future upgrade() async {
   		database.deleteColumn("_Task", "spent");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    