use ExtUtils::MakeMaker;
WriteMakefile(
    NAME              => 'SWISH::Filter',
    VERSION_FROM      => 'lib/SWISH/Filter.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
);

#
# TODO: SWISH::Filter::Install -- for fetching/installing supporting packages
#
