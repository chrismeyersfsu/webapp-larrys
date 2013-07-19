PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
INSERT INTO "category" VALUES(NULL,'condiment','additives');
INSERT INTO "item" VALUES(NULL,'mustard','images/mustard.png',0.0);
INSERT INTO "ItemCat" VALUES((SELECT max(item_id) FROM item), (SELECT max(cat_id) FROM category));
INSERT INTO "item" VALUES(NULL,'mayonnaise','images/mayo.gif',0.0);
INSERT INTO "ItemCat" VALUES((SELECT max(item_id) FROM item), (SELECT max(cat_id) FROM category));
COMMIT;
