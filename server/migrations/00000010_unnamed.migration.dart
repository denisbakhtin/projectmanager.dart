import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration10 extends Migration { 
  @override
  Future upgrade() async {
   		database.createTable(SchemaTable("_Project", [SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("title", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("archived", ManagedPropertyType.boolean, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("createdAt", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("updatedAt", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false)]));
      database.addColumn("_Project", SchemaColumn.relationship("owner", ManagedPropertyType.bigInteger, relatedTableName: "_User", relatedColumnName: "id", rule: DeleteRule.restrict, isNullable: false, isUnique: false), unencodedInitialValue: "14");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {
    await store.execute("INSERT INTO _Project (title,archived,createdat,updatedat,owner_id) VALUES ('Default', false, '2019-10-07 15:00:18.547393','2019-10-07 15:00:18.547393',14)");
  }
}
    