package SWISH::Filters::YAML;
use strict;
use vars qw( $VERSION @ISA );
$VERSION = '0.17';
@ISA     = ('SWISH::Filters::Base');
use Data::Dump qw( dump );

sub new {
    my ($class) = @_;
    my $self = bless {
        mimetypes => [
            qr!application/x-yaml!, qr!application/yaml!,
            qr!text/yaml!,          qr!text/x-yaml!
        ],
    }, $class;
    return $self->use_modules(qw( YAML Search::Tools::XML ));
}

sub filter {
    my ( $self, $doc ) = @_;

    # get the raw content
    my $yaml = $doc->fetch_doc_reference;

    # convert to perl
    my $perl = YAML::Load($$yaml);

    # convert to XML
    my $xml = Search::Tools::XML->perl_to_xml( $perl, 'doc', 1 );

    #warn sprintf("xml: %s\n", Search::Tools::XML->tidy($xml));

    # update the document's content type
    $doc->set_content_type('application/xml');

    # If filtered must return either a reference to the doc or a pathname.
    return ( \$xml );
}

1;

__END__

=head1 NAME

SWISH::Filters::YAML - YAML to XML filter module

=head1 DESCRIPTION

SWISH::Filters::YAML converts YAML-encoded text to valid XML.

Requires CPAN modules L<YAML> and L<Search::Tools::XML>.

=head1 AUTHOR

Peter Karman << karman at cpan dot org >>

=head1 COPYRIGHT

This library is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<SWISH::Filter>

=cut

