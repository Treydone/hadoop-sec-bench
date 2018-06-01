#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

colblk='\033[0;30m' # Black - Regular
colred='\033[0;31m' # Red
colgrn='\033[0;32m' # Green
colylw='\033[0;33m' # Yellow
colpur='\033[0;35m' # Purple
colwht='\033[0;97m' # White
colrst='\033[0m'    # Text Reset

verbosity=2

### verbosity levels
silent_lvl=0
crt_lvl=1
err_lvl=2
wrn_lvl=3
ntf_lvl=4
inf_lvl=5
dbg_lvl=6

## esilent prints output even in silent mode
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

while getopts ":v:" opt ; do
        case $opt in
        v)
                verbosity=$(($verbosity+2))
                ;;
        esac
done

echo $verbosity
ewarn "this is a warning"
eerror "this is an error"
einfo "this is an information"
edebug "debugging"
ecrit "CRITICAL MESSAGE!"

OPTIND=1
edumpvar OPTIND



#inspec exec hdfs -t ssh://root:password@target --attrs attributes/server-attributes.yml
#inspec detect

eok
