import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration20 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("_Project", SchemaColumn("contents", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    