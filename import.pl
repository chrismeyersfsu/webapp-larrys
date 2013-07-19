#!/usr/bin/perl

use DBI;
use strict;

my @data;
my $catId;
my $itemId;
main:
{
	while (my $line = <STDIN>) {
		chomp($line);
		push(@data, $line);
	}

    my $dbargs = {AutoCommit => 0,
                  PrintError => 1};

    my $dbh = DBI->connect("dbi:SQLite:dbname=demo.db","","",$dbargs);


	
	$dbh->do("insert into category (cat_name) values ('$ARGV[0]')");
	$catId = $dbh->func('last_insert_rowid');

	for (my $i=0; $i < @data; $i+=3) {
		my $item = $data[$i];
		my $desc = $data[$i+1];
		my $price = $data[$i+2];
		$dbh->do("insert into item (item_name,item_desc,item_price) values ('$item','$desc','$price')");
		$itemId = $dbh->func('last_insert_rowid');
		$dbh->do("insert into ItemCat (cat_id,item_id) values ('$catId','$itemId')");
	}


    if ($dbh->err()) { die "$DBI::errstr\n"; }

    $dbh->commit();
    $dbh->disconnect();
}
