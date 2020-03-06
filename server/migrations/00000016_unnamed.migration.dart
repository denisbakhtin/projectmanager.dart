import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration16 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("_Attachment", SchemaColumn("size", ManagedPropertyType.integer, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    