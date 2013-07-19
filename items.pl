#!/usr/bin/perl

# ?cat=sandwich
# ?type=sandwich_types
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser); 
use CGI qw(:standard);

use DBI;
use strict;

use JSON::XS;

my $json = JSON::XS->new();
$json->pretty(1);

print "Content-type: text/html\n\n";

my $dbargs = {AutoCommit => 0,
                  PrintError => 1};

my $dbh = DBI->connect("dbi:SQLite:dbname=demo.db","","",$dbargs);

my $jsonFunction = param('callback');
my $catParam = param('cat');
my $typeParam = param('type');
my $calcGroupPriceParam = param('calcGroupPrice');
#my $jsonFunction = "";
#my $catParam = "Deli";
my $subsRef;
my @subsArray;
if (defined($catParam)) {
	# Lookup items that are of category
	$subsRef = $dbh->selectall_hashref("SELECT item.item_id,item_name,item_desc,cat_name,item_price FROM item,ItemCat,category WHERE category.cat_name='$catParam' AND item.item_id=ItemCat.item_id AND category.cat_id=ItemCat.cat_id ORDER BY cat_name,item.item_id", "item_id");

#	$subsRef = $dbh->selectall_arrayref("SELECT item.item_id,item_name,item_desc,cat_name,item_price FROM item,ItemCat,category WHERE category.cat_name='$catParam' AND item.item_id=ItemCat.item_id AND category.cat_id=ItemCat.cat_id ORDER BY cat_name,item.item_id");
} elsif (defined($typeParam)) {
	$subsRef = $dbh->selectall_hashref("SELECT CAT2.cat_id,CAT2.cat_name,CAT2.cat_desc FROM category AS CAT1,category as CAT2, Type WHERE CAT1.cat_name='$typeParam' AND CAT1.cat_id=Type.cat_id_x AND Type.cat_id_y=CAT2.cat_id", "cat_id");
} elsif (defined($calcGroupPriceParam)) {
# possible sql injection, make sure item list are numbers
	my @itemlist = split(/,/, $calcGroupPriceParam);
	my @sublist = filterItemsByCategory(@itemlist, 'sandwich');
	if (scalar(@sublist) > 1) {
		print "Error: should only have 1 sub in the group\n";
		exit;
	}
}

while (my($k,$v) = each %$subsRef ) {
	push(@subsArray, $v);
}

#foreach my $href (@subsArray) {
#	push(@subsArray, $href);
#}

my $prettyJson = $json->encode(\@subsArray);
#my $prettyJson = $json->encode($subsRef);

if ($jsonFunction ne "") {
	print $jsonFunction;
}
print "(";
print $prettyJson;
print ")\n";


sub filterItemsByCategory {
	my @itemlist = $_;
	my $cat_name = $_;
	my @results = $dbh->selectrow_array("SELECT cat_id FROM category WHERE cat_name='$cat_name'");
	my $cat_id = $results[0];
	foreach my $item (@itemlist) {
		$item = 'item_id='.$item;
	}
	my $orStr = join(' OR ', @itemlist);
	my @results = $dbh->selectrow_array("SELECT item_id FROM ItemCat WHERE cat_id='$cat_id' AND ($orStr)");
	return @results;
}
