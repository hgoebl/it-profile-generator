#!/bin/bash
#
# Converts i18n.xml (multi-language) to many i18n.json.{lang} files.
#

. ./setenv.sh

CWD=$(pwd)

XSLT_DIR=${CWD}/xslt
JQM_DIR=${CWD}/m/jqm
I18N_OUT_DIR=${CWD}/m/data

if [ ! -d ${I18N_OUT_DIR} ]; then
    mkdir ${I18N_OUT_DIR}
fi
$NODE ${CWD}/node-app/cli-i18n.js --space=2 ${XSLT_DIR}/i18n.xml ${I18N_OUT_DIR}

while read LANG
do

    # generate jQuery Mobile page for language
    $FOP -xml ${JQM_DIR}/index.multilang.html -xsl ${XSLT_DIR}/html-replace-data-i18n.xsl \
        -foout ${JQM_DIR}/index.html.${LANG} -param lang ${LANG}

done < ${I18N_OUT_DIR}/supported-languages.txt
