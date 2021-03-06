#!/usr/bin/env bash
# environment file for install eclipse
set -e

# linux shell color support.
BLACK="\\033[30m"
RED="\\033[31m"
GREEN="\\033[32m"
YELLOW="\\033[33m"
BLUE="\\033[34m"
MAGENTA="\\033[35m"
CYAN="\\033[36m"
WHITE="\\033[37m"
NORMAL="\\033[0m"
LIGHT="\\033[1m"
INVERT="\\033[7m"

if [ ${1:-NOCONFIG} = "NOCONFIG" ]; then
    eclipse_version="2018-09"
else
    eclipse_version=$1
fi

mirror="http://mirrors.neusoft.edu.cn"
mirror_bak="https://mirrors.tuna.tsinghua.edu.cn/"

if [ "${eclipse_version}" = "2018-09" ]; then
    has_R=""
else
    has_R="-R"
fi

base_url="${mirror}/eclipse/technology/epp/downloads/release/${eclipse_version}/R/eclipse-cpp-${eclipse_version}${has_R}"

###  function for download and extract to assign path ####
# $1 download URL
# $2 local path
function down_load
{
    local down_file=`echo "$1" | awk -F "/" '{print $NF}'`
    local file_ext=${down_file##*.}
    if [ $(curl -I -o /dev/null -s -w %{http_code} $1) != 200 ]; then
        echo "Query $1 not exist."
        return 1
    fi
    if ! curl -OL $1; then
        echo "Download $1 failed."
        return 2
    fi

    if [ -d $2 ]; then
        rm -rf $2
    fi
    mkdir -p $2

    if [ $file_ext = "gz" -o $file_ext = "bz2" ]; then
        tar -vxf ${down_file} -C $2 --strip-components 1
        rm -rf ${down_file}
    fi
}

# Cleanup process
if ps aux | grep eclipse | grep -v $0 | grep -vq grep; then
    echo -e "${LIGHT}${YELLOW} WARNNING!!! CLOSE ECLIPSE AND SAVE eclipse-workspace.${NORMAL}"
    exit 1
fi
# Cleanup temp file
rm -rf ${HOME}/.eclipse/

if [ $(uname -m) = "x86_64" ]; then
    case $(uname) in
    Linux)
        down_url="${base_url}-linux-gtk-x86_64.tar.gz"
        down_load ${down_url} ${HOME}/.local/eclipse && \
            rm -rf ${HOME}/bin/eclipse && \
            ln -s ${HOME}/.local/eclipse/eclipse ${HOME}/bin/eclipse
    ;;
    Darwin)
        down_url="${base_url}-macosx-cocoa-x86_64.dmg"
        down_file=`echo "${down_url}" | awk -F "/" '{print $NF}'`
        down_file_path=${HOME}/Downloads/${down_file}
        rm -rf ${down_file_path}
        wget -P ${HOME}/Downloads/ ${down_url}
        if [ -d /Volumes/Eclipse ]; then
            hdiutil detach /Volumes/Eclipse
        fi
        hdiutil attach ${down_file_path}
        sudo rm -rf /Applications/Eclipse.app
        sudo cp -r /Volumes/Eclipse/Eclipse.app /Applications/
        hdiutil detach /Volumes/Eclipse
        rm -rf ${down_file_path}
        sudo gsed -r \
            -e 's/^-Xms.*/-Xms512m/' \
            -e 's/^-Xmx.*/-Xmx2048m/' \
            -e '/smallFonts/d' \
            -i /Applications/Eclipse.app/Contents/Eclipse/eclipse.ini
    ;;
    *)
        echo "Operating system not support."
    ;;
    esac

else
    echo "Machine architecture no support."

fi

