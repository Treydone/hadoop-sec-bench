#!/usr/bin/env bash

set -o errexit
set -o pipefail

# Option defaults
ARGS=
file="./mapping.json"
verbosity=2
dry=0
reporter="cli"

# Gets the command name without path
cmd(){ echo `basename $0`; }

# Help command output
usage(){
echo "\
`cmd` [OPTION...]
-f, --file; The json mapping file with argument (default: $file)
-d, --dry; Dry run (default: $dry)
-r, --reporter; InSpec reporter to use (default: $reporter)
-v, --verbose; Enable verbose output (include multiple times for more
             ; verbosity, e.g. -vvv)
" | column -t -s ";"
}

### verbosity levels
silent_lvl=0
crt_lvl=1
err_lvl=2
wrn_lvl=3
ntf_lvl=4
inf_lvl=5
dbg_lvl=6

## esilent prints output even in silent mode
colblk='\033[0;30m' # Black - Regular
colred='\033[0;31m' # Red
colgrn='\033[0;32m' # Green
colylw='\033[0;33m' # Yellow
colpur='\033[0;35m' # Purple
colwht='\033[0;97m' # White
colrst='\033[0m'    # Text Reset
function esilent () { verb_lvl=$silent_lvl elog "$@" ;}
function enotify () { verb_lvl=$ntf_lvl elog "$@" ;}
function eok ()    { verb_lvl=$ntf_lvl elog "${colgrn}SUCCESS${colrst} - $@" ;}
function ewarn ()  { verb_lvl=$wrn_lvl elog "${colylw}WARNING${colrst} - $@" ;}
function einfo ()  { verb_lvl=$inf_lvl elog "${colwht}INFO${colrst} ---- $@" ;}
function edebug () { verb_lvl=$dbg_lvl elog "${colgrn}DEBUG${colrst} --- $@" ;}
function eerror () { verb_lvl=$err_lvl elog "${colred}ERROR${colrst} --- $@" ;}
function ecrit ()  { verb_lvl=$crt_lvl elog "${colpur}FATAL${colrst} --- $@" ;}
function edumpvar () { for var in $@ ; do edebug "$var=${!var}" ; done }
function elog() {
        if [ $verbosity -ge $verb_lvl ]; then
                datestring=`date +"%Y-%m-%d %H:%M:%S"`
                echo -e "$datestring - $@"
        fi
}

# There's two passes here. The first pass handles the long options and
# any short option that is already in canonical form. The second pass
# uses `getopt` to canonicalize any remaining short options and handle
# them
opts="fvtd:"
for pass in 1 2; do
    while [ -n "$1" ]; do
        case $1 in
            --) shift; break;;
            -*) case $1 in
                -h|--help)     usage;exit 0;;
                -d|--dry)      dry=1;;
                -f|--file)     file=$2; shift;;
                -r|--reporter) reporter=$2; shift;;
                -v|--verbose)  verbosity=$(($verbosity + 1));;
                --*)           error $1;;
                -*)            if [ $pass -eq 1 ]; then ARGS="$ARGS $1";
                               else error $1; fi;;
                esac;;
            *)  if [ $pass -eq 1 ]; then ARGS="$ARGS $1";
                else error $1; fi;;
       esac
       shift
   done
   if [ $pass -eq 1 ]; then ARGS=`getopt $opts $ARGS`
       if [ $? != 0 ]; then usage; exit 2; fi; set -- $ARGS
   fi
done

# Handle extra arguments
if [ -n "$*" ]; then
    echo "`cmd`: Extra arguments -- $*"
    echo "Try '`cmd` -h' for more information."
    exit 1
fi

if [ $dry -ge 0 ]; then
        ewarn "DRY MODE ON"
fi
edebug "Using file ${file} with reporter ${reporter}"

#Example: mapping.json
#{
# "host1": {"target": "ssh://root:password@host1", "components": ["hdfs-client", "hbase-client"]},
# "host2": {"target": "ssh://root:password@host2", "components": ["hdfs-namenode", "hdfs-http", "hbase-master"]},
# "host3": {"target": "ssh://root:password@host3", "components": ["hdfs-datanode", "hbase-regionserver"]},
# "host4": {"target": "ssh://root:password@host4", "components": ["hdfs-secondarynamenode", "hbase-rest"]}
#}
hosts=$(cat $file | jq -r 'keys | .[]')
for host in $hosts; do
      einfo "Benching $host..."
      target=$(cat $file | jq -r ".[\"${host}\"][\"target\"]")
      edebug "(using target: ${target})"

      opts="--reporter $reporter --target ${target}"
      # run 'detect'
      if [ $dry -ge 0 ]; then
              eok "DRY MODE - Running detect"
      else
              inspec detect ${opts}
      fi
      # run linux-baselinux
      if [ $dry -ge 0 ]; then
              eok "DRY MODE - Running linux baseline"
      else
              inspec exec https://github.com/dev-sec/linux-baseline ${opts}
      fi
      # run common
      if [ $dry -ge 0 ]; then
              eok "DRY MODE - Running common"
      else
              inspec exec common ${opts}
      fi

      # By map of component, run the appropro=iate commands
      components=$(cat $file | jq -r ".[\"${host}\"][\"components\"] | .[]")
      for component in components; do
              einfo "   Benching ${component}..."
              #inspec exec hdfs --target ssh://root:password@target --attrs attributes/hdp.yml attributes/hdfs.yml
              #inspec exec hive --target ssh://root:password@target --attrs attributes/hdp.yml attributes/hive.yml
              #inspec exec hbase --target ssh://root:password@target --attrs attributes/hdp.yml attributes/hbase.yml
      done

done

eok
