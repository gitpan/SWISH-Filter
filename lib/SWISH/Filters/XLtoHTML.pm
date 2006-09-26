package SWISH::Filters::XLtoHTML;
use strict;
require File::Spec;
use vars qw/ $VERSION /;

$VERSION = '0.03';

sub new
{
    my ($class) = @_;

    my $self =
      bless {
            mimetypes => [qr!application/vnd.ms-excel!, qr!application/excel!,],
            }, $class;

    return $self->use_modules(qw/ Spreadsheet::ParseExcel  HTML::Entities /);

}

sub filter
{
    my ($self, $doc) = @_;

    # We need a file name to pass to the conversion function
    my $file = $doc->fetch_filename;

    my ($content_ref, $meta) = get_xls_content_ref($file);
    
    return unless $content_ref;

    # update the document's content type
    $doc->set_content_type('text/html');

    # If filtered must return either a reference to the doc or a pathname.
    return (\$content_ref, $meta);

}

sub get_xls_content_ref
{
    my $file = shift;

    my $oExcel = Spreadsheet::ParseExcel->new;
    return unless $oExcel;

    my $oBook = $oExcel->Parse($file) || return;
    my ($iR, $iC, $oWkS, $oWkC, $ExcelWorkBook);

    # Here we gather up all the workbook metadata

    my ($vol, $dirs, $filename) = File::Spec->splitpath($oBook->{File});
    my $ExcelFilename   = encode_entities($filename);
    my $ExcelSheetCount = encode_entities($oBook->{SheetCount});
    my $ExcelAuthor     = encode_entities($oBook->{Author} || '');
    my $ExcelVersion    = encode_entities($oBook->{Version} || '');

    # Name of the first worksheet
    my $ExcelFirstWorksheetName =
      encode_entities($oBook->{Worksheet}[0]->{Name});

    my %meta = (
         'title' => "$ExcelFirstWorksheetName - $ExcelFilename v.$ExcelVersion",
         'Filename'   => $ExcelFilename,
         'Version'    => $ExcelVersion,
         'Author'     => $ExcelAuthor,
         'Sheetcount' => $ExcelSheetCount
    );

    my $ReturnValue = <<EOF;
<html>
<head>
    <title>$meta{title}</title>
EOF

    for my $n (grep { $_ ne 'title' } keys %meta)
    {
        $ReturnValue .= qq(    <meta name="$n" content="$meta{$n}">\n);
    }

    $ReturnValue .= "</head>\n";

    # Here we collect content from each worksheet
    for (my $iSheet = 0 ; $iSheet < $oBook->{SheetCount} ; $iSheet++)
    {

        # For each Worksheet do the following
        $oWkS = $oBook->{Worksheet}[$iSheet];

        # Name of the worksheet
        my $ExcelWorkSheet =
          "<h2>" . encode_entities($oWkS->{Name}) . "</h2>\n";
        $ExcelWorkSheet .= "<table>\n";

        for (my $iR = $oWkS->{MinRow} ;
             defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow} ;
             $iR++)
        {

            # For each row do the following
            $ExcelWorkSheet .= "<tr>\n";

            for (my $iC = $oWkS->{MinCol} ;
                 defined $oWkS->{MaxCol} && $iC <= $oWkS->{MaxCol} ;
                 $iC++)
            {

                # For each cell do the following
                $oWkC = $oWkS->{Cells}[$iR][$iC];

                my $CellData = encode_entities($oWkC->Value) if ($oWkC);
                $ExcelWorkSheet .= "\t<td>" . $CellData . "</td>\n"
                  if $CellData;
            }
            $ExcelWorkSheet .= "</tr>\n";

            # Our last duty
            $ExcelWorkBook .= $ExcelWorkSheet;
            $ExcelWorkSheet = "";
        }
        $ExcelWorkBook .= "</table>\n";
    }

    $ReturnValue .= <<EOF;
<body>
$ExcelWorkBook
</body>
</html>
EOF


    return ($ReturnValue, \%meta);
}

__END__

=head1 NAME

SWISH::Filters::XLtoHTML - MS Excel to HTML filter module

=head1 DESCRIPTION

SWISH::Filters::XLtoHTML extracts data from MS Excel spreadsheets for indexing.

Depends on two perl modules:

    Spreadsheet::ParseExcel
    HTML::Entities;


=head1 SUPPORT

Please contact the Swish-e discussion list.
http://swish-e.org/

=cut

