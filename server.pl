#!/usr/bin/perl
{
package MyWebServer;

use HTTP::Server::Simple::CGI;
our @ISA = qw(HTTP::Server::Simple::CGI);

my @scripts = ( "items.pl" );

sub handle_request {
	my $self = shift;
	my $cgi  = shift;
  
	my $rootdir = ".";
	my $path = $rootdir . $cgi->path_info();

	if (-e $path) {
		print "HTTP/1.1 200 OK\r\n";
		my @output = qx/$path/;
		print @output;
	} else {
		print "HTTP/1.0 404 Not found\r\n";
		print $cgi->header,
			  $cgi->start_html($path . ' Not found'),
			  $cgi->h1($path . ' Not found'),
			  $cgi->end_html;
	}
}
}

# start the server on port 8080
#my $pid = MyWebServer->new(8080)->background();
#print "Use 'kill $pid' to stop server.\n"
my $pid = MyWebServer->new(8080)->run();
