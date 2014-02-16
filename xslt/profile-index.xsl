<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="i18n-support.xsl"/>

    <xsl:param name="lang" select="'en'"/>
    <xsl:param name="nickname" select="'param-nickname-not-provided'"/>
    <xsl:output method="html"/>
    <xsl:variable name="fullName">
        <xsl:call-template name="i18n-fullname"><xsl:with-param name="person" select="/profile/person"/></xsl:call-template>
    </xsl:variable>

    <xsl:template match="/profile">
        <html>
            <head>
                <title>
                    <xsl:call-template name="i18n"><xsl:with-param name="key">Profile</xsl:with-param></xsl:call-template>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$fullName"/>
                </title>
                <style type="text/css">
body {
    font-family: "Droid Sans", Arial, Helvetica, sans-serif;
    margin-left: 0.5em;
}
h1, h2 {
    page-break-after: avoid;
}
.flag {
    margin-right: 0.5em;
}
dd {
    margin-bottom: 1em;
}
.langbox {
    padding: 10px;
    display: inline;
    float: left;
    margin-right: 20px;
    margin-bottom: 20px;
    border: 1px solid gray;
}
                </style>
            </head>
            <body>
                <xsl:choose>
                    <xsl:when test="count(availableLanguages) != 1">
                        <xsl:call-template name="body-multilang"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="body-singlelang"/>
                    </xsl:otherwise>
                </xsl:choose>
            </body>
        </html>
    </xsl:template>

    <xsl:template name="body-singlelang">
        <xsl:variable name="force-lang" select="availableLanguages[0]/text()"/>
        <div class="langbox">
            <h1>
                <xsl:call-template name="i18n">
                    <xsl:with-param name="key">Profile</xsl:with-param>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$fullName"/>
            </h1>
            <xsl:call-template name="last-update">
                <xsl:with-param name="force-lang" select="$force-lang"/>
            </xsl:call-template>
            <xsl:call-template name="doclist">
                <xsl:with-param name="lang-ext" select="''"/>
            </xsl:call-template>
        </div>
    </xsl:template>

    <xsl:template name="body-multilang">
        <xsl:for-each select="availableLanguages">
            <xsl:variable name="force-lang" select="text()"/>
            <div class="langbox">
                <h1>
                    <img height="11" width="16" class="flag">
                        <xsl:attribute name="src">
                            <xsl:text>../../s/flags/</xsl:text>
                            <xsl:call-template name="i18n">
                                <xsl:with-param name="key">flag-icon</xsl:with-param>
                                <xsl:with-param name="force-lang" select="$force-lang"/>
                            </xsl:call-template>
                            <xsl:text>.gif</xsl:text>
                        </xsl:attribute>
                    </img>
                    <xsl:call-template name="i18n">
                        <xsl:with-param name="key">language</xsl:with-param>
                        <xsl:with-param name="force-lang" select="$force-lang"/>
                    </xsl:call-template>
                    <xsl:text>: </xsl:text>
                    <xsl:call-template name="i18n">
                        <xsl:with-param name="key">Profile</xsl:with-param>
                        <xsl:with-param name="force-lang" select="$force-lang"/>
                    </xsl:call-template>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$fullName"/>
                </h1>
                <xsl:call-template name="last-update">
                    <xsl:with-param name="force-lang" select="$force-lang"/>
                </xsl:call-template>
                <xsl:call-template name="doclist">
                    <xsl:with-param name="lang-ext" select="concat('.', text())"/>
                </xsl:call-template>
            </div>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="last-update">
        <xsl:param name="force-lang"/>
        <p>
            <xsl:call-template name="i18n">
                <xsl:with-param name="key">Last Update</xsl:with-param>
                <xsl:with-param name="force-lang" select="$force-lang"/>
            </xsl:call-template>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="/profile/lastEditDate[@xml:lang = $force-lang or not(@xml:lang)]"/>
        </p>
    </xsl:template>

    <xsl:template name="doclist">
        <xsl:param name="lang-ext" select="''"/>
        <dl>
            <xsl:call-template name="dl-item-doclink">
                <xsl:with-param name="format-name" select="'HTML'"/>
                <xsl:with-param name="format-ext" select="'.html'"/>
                <xsl:with-param name="lang-ext" select="$lang-ext"/>
            </xsl:call-template>
            <xsl:call-template name="dl-item-doclink">
                <xsl:with-param name="format-name" select="'PDF (Portable Document Format)'"/>
                <xsl:with-param name="format-ext" select="'.pdf'"/>
                <xsl:with-param name="lang-ext" select="$lang-ext"/>
            </xsl:call-template>
            <xsl:call-template name="dl-item-doclink">
                <xsl:with-param name="format-name" select="'Text'"/>
                <xsl:with-param name="format-ext" select="'.txt'"/>
                <xsl:with-param name="lang-ext" select="$lang-ext"/>
            </xsl:call-template>
            <xsl:call-template name="dl-item-doclink">
                <xsl:with-param name="format-name" select="'vCard'"/>
                <xsl:with-param name="format-ext" select="'.vcf'"/>
                <xsl:with-param name="lang-ext" select="$lang-ext"/>
            </xsl:call-template>
            <xsl:call-template name="dl-item-imglink">
                <xsl:with-param name="format-name" select="'vCard (QR-Code)'"/>
                <xsl:with-param name="format-ext" select="'-vcf-qrcode.png'"/>
                <xsl:with-param name="lang-ext" select="$lang-ext"/>
            </xsl:call-template>
        </dl>
    </xsl:template>

    <xsl:template name="dl-item-doclink">
        <xsl:param name="format-name"/>
        <xsl:param name="format-ext"/>
        <xsl:param name="lang-ext" select="''"/>
        <dt><xsl:value-of select="$format-name"/></dt>
        <dd>
            <a target="_blank" href="{concat($nickname, $format-ext, $lang-ext)}">
                <xsl:value-of select="concat($nickname, $format-ext, $lang-ext)"/>
            </a>
        </dd>
    </xsl:template>

    <xsl:template name="dl-item-imglink">
        <xsl:param name="format-name"/>
        <xsl:param name="format-ext"/>
        <xsl:param name="lang-ext" select="''"/>
        <dt><xsl:value-of select="$format-name"/></dt>
        <dd>
            <img target="_blank" src="{concat($nickname, $format-ext, $lang-ext)}"/>
        </dd>
    </xsl:template>

</xsl:stylesheet>
