#!/bin/sh
sqlite3 demo.db < schema.sql
sqlite3 demo.db < all_subs.sql
sqlite3 demo.db < all_condiments.sql
sqlite3 demo.db < all_vegetables.sql
