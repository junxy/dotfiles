#!/bin/bash 

VERBOSE=""
DRYRUN=""
PREFIXES=""

function fail()
{
  echo $1 >&2
  exit 1
}

function usage()
{
  local U=""
  U="${U}Usage: $(basename $0) [OPTION] PKG_NAME-VERSION...\n"
  U="$U\tPKG_NAME = c3-client|c3-app|c3-server|c3-help[-BRANCH_NAME]\n"
  U="$U\tVERSION = a valid rpm version\n"
  U="${U}Options:\n"
  U="$U\t--help\n"
  U="$U\t--verbose\n"
  U="$U\t--dry-run\n"
  U="${U}Examples:\n"
  U="$U\t$(basename $0) c3-client-3.1.0.42\n"
  U="$U\t$(basename $0) c3-server-feature_b-3.3.0.54\n"
  echo -e $U
}

function checkArgs()
{
  if [ -z "${PKGS[*]}"  ] ; then
    echo "Missing required argument" >&2; usage >&2 ; exit 1;
  fi
  for PKG in ${PKGS[@]}; do
    # check pkg name
    for i in c3-{client,app,server,help} ; do
      M=$(expr match "$PKG" $i)
      VALID='false'
      if [[ "$M" != "0" ]]; then
        PREFIXES+=("${i}*")
        VALID='true'
        break;
      fi
    done
    if [ "$VALID" = 'false' ]; then
      echo "Unsupported package ${PKG}" >&2;  exit 1;
    fi

    # check pkg version
    
  done
}

function checkRepositories()
{
  test `yum repolist|grep 'C3Software_'|wc -l` = "2"
  if [ "$?" != "0" ]
  then
    echo "C3 repositories are missing" >&2; exit 2;
  fi
}

function stopServer
{
    if test -e  /etc/init.d/c3_server
    then
      /etc/init.d/c3_server stop >&5
    fi
}
function startServer
{
    if test -e  /etc/init.d/c3_server
    then
      /etc/init.d/c3_server start >&5
    fi
}

#getopts
TEMP=`getopt -o +vn --long help,dry-run,verbose -- "$@"`
if [ $? != 0 ] 
then 
  echo "Problem parsing options: $TEMP" >&2 ; usage >&2 ; exit 1
fi

eval set -- $TEMP
while true ; do
   case $1 in
      --help)  usage ; exit 0;;
      -v | --verbose) VERBOSE="true" ; shift;;
      -n | --dry-run) DRYRUN="true" ; shift;;
     --) shift ; break;;
   esac
done

# use 5 as output file descriptor
if [ "$VERBOSE" = 'true' ]; then
  exec 5>&1
else
  exec 5>/dev/null
fi

[[ -n "$DRYRUN" ]] && echo "DRY-RUN enabled" >&5

[[ $(whoami) = 'root' ]] || fail "$(basename $0) must be run as root"

PKGS=("$@")
checkArgs
checkRepositories
if [ -z "$DRYRUN" ]; then
  stopServer
fi

echo "Cleaning YUM repositories..." 

if [[ -z "$DRYRUN" ]]; then
  yum clean all >&5 || fail "Error while cleaning repositories"
fi
# disable globing to prevent expansion in the yum command
set -f
INSTALLED_PKGS=( $(yum --color=never list installed ${PREFIXES[@]} 2> /dev/null | grep c3| awk '{print $1}') )
if [ -n "${INSTALLED_PKGS[*]}" ] ; then
  echo "Removing installed packages: ${INSTALLED_PKGS[*]}"
  if [ -z "$DRYRUN" ]; then
    yum remove -y ${INSTALLED_PKGS[*]} >&5 || fail "Error while removing existing packages: ${INSTALLED_PKGS[*]}"
  fi
else
  echo "No conflicting packages currently installed" >&5
fi


echo "Installing packages: ${PKGS[*]}"

if [ -z "$DRYRUN" ]; then
  yum install -y ${PKGS[*]} >&5 || fail "Error while installing packages: ${PKGS[*]}"
fi


echo "Packages successfully installed" 
if [ -z "$DRYRUN" ]; then
   startServer
fi

exec 5>&-
exit 0


