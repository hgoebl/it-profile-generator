#!/bin/bash
#
# IT CV/Profile Generator
#

. ./setenv.sh

PROFILE=$1

INPUT_DIR=${_CWD}/profiles/${PROFILE}
XSLT_DIR=${_CWD}/xslt

if [ ! -d ${INPUT_DIR} ]; then
    echo "input profile directory not found"
    echo ${INPUT_DIR}
    exit 1
fi

cd ${INPUT_DIR}

if [ -f supported-languages.txt ]; then

    # process multi-language profile

    if [ ! -f ${PROFILE}.multilang.xml ]; then
        echo "input profile not found (file does not exist)"
        echo ${PROFILE}.multilang.xml
        exit 2
    fi

    # generate index.html (overview)
    $FOP -xml ${PROFILE}.multilang.xml -xsl ${XSLT_DIR}/profile-index.xsl -foout index.html -param nickname ${PROFILE}

    while read LANG
    do
        XML=${PROFILE}.xml.${LANG}
        FO=${PROFILE}.fo.${LANG}

        # translate multi-language profile to destination language
        $FOP -xml ${PROFILE}.multilang.xml -xsl ${XSLT_DIR}/profile-filter-language.xsl -foout ${XML} -param lang ${LANG}

        # translate to JSON
        $NODE ${_CWD}/node-app/cli-to-json.js               \
            --lang=${LANG}                                  \
            --encoding=utf8 --space=0                       \
            ${XML} ${PROFILE}.json.${LANG}

        # translate to Text
        $NODE ${_CWD}/node-app/cli-to-text.js               \
            --lang=${LANG}                                  \
            --encoding=utf8 --colwidths=18,75 --distance=1  \
            ${PROFILE}.json.${LANG} ${PROFILE}.txt.${LANG}

        # translate to vCard
        $NODE ${_CWD}/node-app/cli-to-vcard.js                \
            ${PROFILE}.json.${LANG} ${PROFILE}.vcf.${LANG}

        # generate QR-Code of vCard
        $QRENCODE -o ${PROFILE}-vcf-qrcode.png.${LANG} < ${PROFILE}.vcf.${LANG}

        # generate html
        $FOP -xml ${XML} -xsl ${XSLT_DIR}/profile-html4.xsl -foout ${PROFILE}.html.${LANG} -param lang ${LANG}

        # generate intermediate FO files
        $FOP -xml ${XML} -xsl ${XSLT_DIR}/profile-fop.xsl -foout ${FO} -param lang ${LANG}

        # generate rich-text-format (rtf)
        $FOP -fo ${FO} -rtf ${PROFILE}.rtf.${LANG}

        # generate PDF
        $FOP -fo ${FO} -pdf ${PROFILE}.pdf.${LANG}

        # removing intermediate files
        #rm ${FO}

        # translate mobile-content html-snippets to destination language
        $FOP -xml mobile-content.multilang.xml -xsl ${XSLT_DIR}/profile-filter-language.xsl \
            -foout mobile-content.xml.${LANG} \
            -param lang ${LANG}

    done < supported-languages.txt

else

    # single-language profile
    # TODO dry! It's almost the same as for multi-language processing -> function?
    # TODO support language from profile!!

    if [ ! -f ${PROFILE}.xml ]; then
        echo "input profile not found (file does not exist)"
        echo ${PROFILE}.xml
        exit 2
    fi

    LANG=en
    echo "!!!!"
    echo "Currently only en (English) is supported for single-language profiles"
    echo "Until support exists, please change this script (LANG=xx)"
    echo "!!!!"

    XML=${PROFILE}.xml
    FO=${PROFILE}.fo

    # generate index.html (overview)
    $FOP -xml ${XML} -xsl ${XSLT_DIR}/profile-index.xsl -foout index.html -param nickname ${PROFILE}

    # translate to JSON
    $NODE ${_CWD}/node-app/cli-to-json.js               \
        --encoding=utf8 --space=0                       \
        ${XML} ${PROFILE}.json

    # translate to Text
    $NODE ${_CWD}/node-app/cli-to-text.js               \
        --encoding=utf8 --colwidths=18,75 --distance=1  \
        ${PROFILE}.json ${PROFILE}.txt

    # translate to vCard
    $NODE ${_CWD}/node-app/cli-to-vcard.js              \
        ${PROFILE}.json ${PROFILE}.vcf

    # generate QR-Code of vCard
    $QRENCODE -o ${PROFILE}-vcf-qrcode.png < ${PROFILE}.vcf

    # generate html
    $FOP -xml ${XML} -xsl ${XSLT_DIR}/profile-html4.xsl -foout ${PROFILE}.html -param lang ${LANG}

    # generate intermediate FO files
    $FOP -xml ${XML} -xsl ${XSLT_DIR}/profile-fop.xsl -foout ${FO} -param lang ${LANG}

    # generate rich-text-format (rtf)
    $FOP -fo ${FO} -rtf ${PROFILE}.rtf

    # generate PDF
    $FOP -fo ${FO} -pdf ${PROFILE}.pdf

    # removing intermediate files
    rm ${FO}

fi

cd ${_CWD}

unset _CWD
