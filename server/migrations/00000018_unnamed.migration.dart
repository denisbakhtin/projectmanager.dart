import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration18 extends Migration { 
  @override
  Future upgrade() async {
   		database.alterColumn("_Attachment", "base64string", (c) {c.isNullable = true;});
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    