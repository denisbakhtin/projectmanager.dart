import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration19 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("_Attachment", SchemaColumn.relationship("project", ManagedPropertyType.bigInteger, relatedTableName: "_Project", relatedColumnName: "id", rule: DeleteRule.cascade, isNullable: true, isUnique: false));
		database.addColumn("_Attachment", SchemaColumn.relationship("comment", ManagedPropertyType.bigInteger, relatedTableName: "_Comment", relatedColumnName: "id", rule: DeleteRule.cascade, isNullable: true, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    