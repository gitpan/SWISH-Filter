package SWISH::Filter::MIMETypes;
use strict;
use warnings;
use Carp;

eval { require MIME::Types };
my $has_mime_types;
if ($@) {
    carp(
        "Failed to load MIME::Types\n$@\nInstall MIME::Types for more complete MIME support"
    );
}
else {
    $has_mime_types = MIME::Types->new;
}

# class data (caches from MIME::Types if available)
my %mime_types = (
    doc  => 'application/msword',
    pdf  => 'application/pdf',
    ppt  => 'application/vnd.ms-powerpoint',
    html => 'text/html',
    htm  => 'text/html',
    txt  => 'text/plain',
    text => 'text/plain',
    xml  => 'text/xml',
    mp3  => 'audio/mpeg',
    gz   => 'application/x-gzip',
    xls  => 'application/vnd.ms-excel',
    zip  => 'application/zip',
);

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    return $self;
}

sub get_mime_type {
    my $self = shift;
    my $file = shift or croak "file required";
    my ($ext) = ( $file =~ m/.*\.(.+)$/ );
    $ext ||= $file;
    if ( exists $mime_types{$ext} ) {
        return $mime_types{$ext};
    }
    if ($has_mime_types) {
        my $mime = $has_mime_types->mimeTypeOf($file);
        if ( !$mime ) {
            return;
        }
        else {
            $mime_types{$ext} = "$mime";    # cache string not object
            return $mime_types{$ext};
        }
    }
    return;
}

1;

=head1 SUPPORT

Please contact the Swish-e discussion list.  http://swish-e.org

=head1 AUTHOR

Peter Karman C<perl@peknet.com>

=head1 COPYRIGHT

This library is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

=cut
