#!/usr/bin/perl

my @subNames, @subDescriptions;
my $subCount=0;
my @subCategories;
my @data;

while ($line = <STDIN>) {
	push(@data, $line);
}

	my @subsArray = ();

	chomp(@data);
	for ($i=0; $i < @data; $i+=2) {
		my $sub = $data[$i];
		my $desc = $data[$i+1];
		$sub = trim($sub);
		$desc = trim($desc);
		my $price_base = int(rand(5)) + 8;
		my $price_dec = int(rand(100));

		print "$sub\n";
		print "$desc\n";
		print "\$" . $price_base . "." . $price_dec . "\n";
	}

sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}
