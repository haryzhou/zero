use ExtUtils::MakeMaker;

my @exec_files;
push @exec_files, 'bin/' . $_ for qw/tchnl tsimu/;

WriteMakefile(
    NAME      => 'zero',
    AUTHOR    => 'haryzhou <zcman2005@gmail.com>',
    ABSTRACT  => 'Account System',
    LICENSE   => 'artistic_2',
    VERSION_FROM => 'lib/Zero.pm',
    META_MERGE => {
        requires => { perl => '5.10' },
        resources => {
            homepage    => 'http://mojolicio.us',
            license     => 'http://www.opensource.org/licenses/artistic-license-2.0',
            MailingList => 'http://groups.google.com/group/zero',
            repository  => 'http://github.com/haryzhou/zero',
            bugtracker  => 'http://github.com/haryzhou/zero/issues'
        }
    },

    PREREQ_PM => {
        'Data::Dump'        => 1.21,
        'POE'               => 1.354,
        'POE::Filter::JSON' => 0.04,
    },

    EXE_FILES => [ @exec_files ],
    test      => {
        TESTS => 't/*.t t/*/*.t',
    },
);

