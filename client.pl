use strict;
use warnings;

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/lib" }

use Alexandria::Client;
use feature 'say';

my $url = $ARGV[0] // $default_url; # this should be a Mojo::URL instance
my $downloader = Alexandria::Client->new(url => $url);
$downloader->process;
