import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration11 extends Migration { 
  @override
  Future upgrade() async {
    database.addColumn("_Task", SchemaColumn.relationship("project", ManagedPropertyType.bigInteger, relatedTableName: "_Project", relatedColumnName: "id", rule: DeleteRule.restrict, isNullable: false, isUnique: false), unencodedInitialValue: "1");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    