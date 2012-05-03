use ExtUtils::MakeMaker;

WriteMakefile
  (
   NAME      => 'BioGRID',
   VERSION   => '0.1',
   dist      => { COMPRESS => 'gzip --best', SUFFIX => 'gz' },
   PREREQ_PM => { Term::ProgressBar => 0 },
  );
