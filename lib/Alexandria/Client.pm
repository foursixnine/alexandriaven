package Alexandria::Client;
use Mojo::Base 'Mojo::UserAgent';
use Config::YAML;
use Carp qw(croak);
use feature 'say';

has [qw(config service req site)];

has url => sub { croak 'url needs to be defined!' x 3 };

sub new {
    my $self = shift->SUPER::new(@_);

    # Mojoliciou's default timeout is 60 seconds
    $self->inactivity_timeout(60);
    $self->max_redirects(2);

    return $self;
}

sub process {
    my ($self) = @_;
    say 'We are ready! for $self->url = '. $self->url;
    $self->req($self->get($self->url));
    $self->site($self->req->result);
    $self->get_title();
    $self->get_author();
    $self->download();
    return $self;
}

sub get_title {
    my ($self) = @_;
    my ($title) = $self->site->dom->at('h1.expandbook__title');
    say $title->text;
    return $self;
}

sub get_author {
    my ($self) = @_;
    my ($title) = $self->site->dom->at('h2.expandbook__author > a');
    say $title->text;
    return $self;
}

sub download {
    my ($self) = @_;
    use Data::Dump qw(pp);
    # build a new Mojo::UserAgent
    # get it to prepare a promise for both pdf
    # get it to use content disposition to get the filename
    # to get used by save_to
    #headers->content_disposition
    for my $type (qw(epub pdf)) { 
        say "Going for $type";
        my $res = $self->max_redirects(3)->get($self->url.'/downloadbookepub/'.$type)->result;
        pp $res;
    }
}

1;

__END__

=encoding utf8

=head1 NAME

L<Alexandria::Client> - special version of Mojo::UserAgent that will handle preparation for
downloading files from a given URL.

=head1 SYNOPSIS

L<Alexandria::Client>
# create new UserAgent that is meant to talk to websites to download contents from a file
my $downloader = Alexandria::Client->new(url => 'https://freeditorial.com/es/books/la-guerra-de-los-mundos');

=head1 DESCRIPTION

L<Alexandria::Client> inherits from L<Mojo::UserAgent>.
Configuration files are read from ~/.config/alexandria/client.yml or /etc/alexandria/client.yml

See L<Mojo::UserAgent> for more.

=head1 ATTRIBUTES

L<Alexandria::Client> implmements the following attributes.

=head2 config 

YAML config goes hee.

=head2 url

The url to be used it will be used to initialize the actual downloader
my $url = 'https://freeditorial.com/es/books/la-guerra-de-los-mundos';
my $downloader = Alexandria::Client->new(url => $url);

=head2 service

Refers to the website being used to aquire the files. See also C<Alexandria::Client::*>

=head1 METHODS

=head2 new

my $url = 'https://freeditorial.com/es/books/la-guerra-de-los-mundos';
my $downloader = Alexandria::Client->new(url => $url);
Generate the L<Alexandria::Client> object.

=head1 CONFIG FILE FORMAT

The config file is in YAML, no configuration is possible at this moment

=head1 SEE ALSO

L<Mojo::UserAgent>, L<Config::YAML>

=cut

# vim: set sw=4 et:
