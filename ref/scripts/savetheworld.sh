#!/bin/bash
function usage() {
   echo "Usage: [c3server|c3client|c3test]"
}

declare -a client_commits=(
.git/objects/64/e4fdad883358223c900a43f95efbc94f3afee4
.git/objects/f0/b72e48fc8051b8686169c80b7456c818dbfb8a
);

declare -a server_commits=(
.git/objects/2c/cd6bd4946f0a3f26425f79051f333cfa7b6479
.git/objects/3b/fbafed5a5aa6c6797bb65dc34133a62bfbad2e
);

declare -a test_commits=(
.git/objects/50/bd56d5a045bcf5b83bbe996975ff7423ac1eef
.git/objects/93/6c0863c77f2ae7beb492ba1f19ffa0b2c83ef4
);

my_dir=`pwd`

server_repo="${my_dir}/c3server"
client_repo="${my_dir}/c3client"
test_repo="${my_dir}/c3test"

param=""
if [ "$#" -eq 0 ];then
    usage && exit 1
else
   param=$1;
fi

repo=
commits=

if [ "$param" = "c3server" ]; then
  repo=$server_repo
  commits=("${server_commits[@]}")
elif [ "$param" = "c3client" ]; then
  repo=$client_repo
  commits=("${client_commits[@]}")
elif [ "$param" = "c3test" ]; then
  repo=$test_repo
  commits=("${test_commits[@]}")
else
    echo "unknown param" && usage && exit 1
fi

if [ -d $repo ];then

    declare -a founds=()
    #echo "Searching ${#commits[*]} commits in $repo" # the length of the array

    for x in ${commits[@]}; do
        abs_path="$repo/$x"
        if [ -f "$abs_path" ]; then
            #echo "!!! found $abs_path"
            founds[${#founds[*]}]=${param}/$x  # append
            #cp $abs_path $tmp_dir
        #else
            #echo "no luck with $abs_path"
        fi
    done

    if [ "${#founds[*]}" != "0" ]; then
        tar_file="${my_dir}/${param}_commits_${#founds[*]}of${#commits[*]}_${USER}.tgz"
        rm $tar_file >> /dev/null 2>&1
        tar czf ${tar_file} ${founds[*]}
        echo "tar file created at ${tar_file}"
    else
        echo "Nothing found in your ${param} clone. Thanks for helping ${USER}"
    fi
    #echo "Found ${#founds[*]}/${#commits[*]} in $repo" # the length of the array
    #echo ${founds[*]} # all the items
    
else
    echo "${repo} does not exist"
fi



