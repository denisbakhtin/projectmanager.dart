import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration15 extends Migration { 
  @override
  Future upgrade() async {
   		database.createTable(SchemaTable("_Attachment", [SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("filename", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("url", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false)]));
		database.addColumn("_Attachment", SchemaColumn.relationship("task", ManagedPropertyType.bigInteger, relatedTableName: "_Task", relatedColumnName: "id", rule: DeleteRule.cascade, isNullable: true, isUnique: false));
		database.addColumn("_Attachment", SchemaColumn.relationship("owner", ManagedPropertyType.bigInteger, relatedTableName: "_User", relatedColumnName: "id", rule: DeleteRule.cascade, isNullable: false, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    