<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="lang" select="'en'"/>
    <xsl:variable name="i18n_doc" select="document('i18n.xml')/i18n"/>
    <xsl:template name="i18n">
        <xsl:param name="key"/>
        <xsl:variable name="val" select="$i18n_doc/entry[@key=$key]/msg[lang($lang)]"/>
        <xsl:choose>
            <xsl:when test="$val">
                <xsl:value-of select="$val"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- for debug purposes uncomment this line <xsl:text>!!NOT DEFINED!! </xsl:text> -->
                <xsl:value-of select="$key"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
