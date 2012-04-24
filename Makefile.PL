use ExtUtils::MakeMaker;

WriteMakefile
  (
   NAME         => 'BioGRID-TAB2',
   VERSION      => '0.1',
   dist         => { COMPRESS => 'gzip --best', SUFFIX => 'gz' },
  );
