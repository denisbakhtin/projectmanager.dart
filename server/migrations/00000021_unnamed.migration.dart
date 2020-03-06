import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration21 extends Migration { 
  @override
  Future upgrade() async {
   		database.createTable(SchemaTable("_Session", [SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("comment", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("createdAt", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("updatedAt", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false)]));
		database.addColumn("_Session", SchemaColumn.relationship("owner", ManagedPropertyType.bigInteger, relatedTableName: "_User", relatedColumnName: "id", rule: DeleteRule.restrict, isNullable: false, isUnique: false));
		database.addColumn("_Activity", SchemaColumn.relationship("session", ManagedPropertyType.bigInteger, relatedTableName: "_Session", relatedColumnName: "id", rule: DeleteRule.restrict, isNullable: true, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    