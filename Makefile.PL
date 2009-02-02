use ExtUtils::MakeMaker;
WriteMakefile(
    NAME              => 'SWISH::Filter',
    VERSION_FROM      => 'lib/SWISH/Filter.pm', # finds $VERSION
    PREREQ_PM         => {
        'Test::More'   => 0,
        'URI'          => 0,
        'Getopt::Long' => 0,
        'Pod::Usage'   => 0,
        'Data::Dumper' => 0,
        'MIME::Types'  => 0,


    }, # e.g., Module::Name => 1.1
);

#
# TODO: SWISH::Filter::Install -- for fetching/installing supporting packages
#
