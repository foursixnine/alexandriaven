use strict;
use warnings;

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/lib" }

use Alexandria::Client;
use feature 'say';

my $url = $ARGV[0] // 'https://freeditorial.com/es/books/la-guerra-de-los-mundos';
my $downloader = Alexandria::Client->new(url => $url);
$downloader->process;
