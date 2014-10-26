package SWISH::Filters::pp2html;
use strict;
use vars qw/ $VERSION /;
$VERSION = '0.01';
require File::Spec;

sub new {
   my ( $class ) = @_;
   my $self = bless {
       mimetypes   => [ qr!application/vnd.ms-powerpoint! ],
   }, $class;
   return $self->set_programs( 'ppthtml' );
}

sub filter {
   my ( $self, $doc ) = @_;
   my $content = $self->run_ppthtml( $doc->fetch_filename ) || return;
   
   # use just the file name as title with no path
   my ($title) = ( $content =~ m!<title>(.*?)</title>!io );
   my ($volume,$directories,$file) = File::Spec->splitpath( $title );
   $content =~ s,<title>.*?</title>,<title>$file</title>,i;
 
   # update the document's content type
   $doc->set_content_type( 'text/html' );
   return \$content;
}

1;
__END__

=head1 NAME

SWISH::Filters::pp2html - Perl extension for filtering MS PowerPoint
documents with Swish-e

=head1 DESCRIPTION

This is a plug-in module that uses the xlhtml package to convert MS
PowerPoint documents
to html for indexing by Swish-e.

This filter plug-in requires the xlhtml package which includes ppthtml
available at:

   http://chicago.sourceforge.net/xlhtml

Currently produces document titles like /tmp/foo1234.  Need to alter
to pass actual
document title.


=head1 AUTHOR

Randy Thomas

=head1 SEE ALSO

L<SWISH::Filter>

