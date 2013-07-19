create table item (
	item_id INTEGER PRIMARY KEY,
	item_name text,
	item_desc text,
	item_price real
);

create table category (
	cat_id INTEGER PRIMARY KEY,
	cat_name text,
	cat_desc text
);

create table ItemCat (
	item_id INTEGER,
	cat_id INTEGER
);

create table Type (
	cat_id_x INTEGER,
	cat_id_y INTEGER
);
