#!/bin/sh

: << =cut

=head1 NAME

lynis - A munin plugin that collects lynis hardening index and the amount of tests performed on your nodes

=head1 APPLICABLE SYSTEMS

Lynis 1.3.9+

=head1 CONFIGURATION

The following is default configuration

  [lynis]
    env.resultsfile=/var/log/lynis-report.dat

=head1 PARAMETERS SUPPORTED

  config
  autoconf

=head1 BUGS

None known so far. If you find any, let me know.

=head1 AUTHOR

Christian trabold (ctrabold) - c<< <info@christian-trabold.de> >>

=head1 LICENSE

MIT

=head1 MAGIC MARKERS

  #%# family=auto
  #%# capabilities=autoconf

=cut

if [ -z $resultsfile  ]; then
  _target=/var/log/lynis-report.dat
else
  _target=$resultsfile
fi

case $1 in
  autoconf)
    if [ -f $_target ]; then
      echo yes
    else
      echo "no ($_target not readable)"
    fi
    exit 0;;

  config)
  cat <<'EOM'
graph_title Lynis report status
graph_info Shows hardening index of the node and the amount of tests performed by lynis.
graph_args --base 1000 -l 0
graph_scale no
graph_category lynis
graph_vlabel Index
hardening_index.label index
lynis_tests_done.label tests
EOM
  exit 0;;
esac

printf "hardening_index.value "
grep hardening_index    ${_target} | cut -d= -f2 || 0
printf "lynis_tests_done.value "
grep lynis_tests_done   ${_target} | cut -d= -f2 || 0
