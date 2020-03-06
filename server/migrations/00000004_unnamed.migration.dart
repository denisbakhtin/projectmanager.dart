import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration4 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("_Todo", SchemaColumn("spent", ManagedPropertyType.integer, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false), unencodedInitialValue: "0");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    