<?xml version="1.0" encoding="UTF-8"?>
<!--
    Filters out all elements (and sub-elements) where the language doesn't fit.
    The result should be a XML document w/out xml:lang attributes and with
    exactly one chosen language.

    Parameter: {String} [lang = 'en']
  -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="i18n-support.xsl"/>

    <xsl:param name="lang" select="'en'"/>
    <xsl:output method="xml" omit-xml-declaration="yes"/>

    <xsl:template match="/">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="//*[@xml:lang and not(lang($lang))]"/>

    <xsl:template match="@xml:lang"/>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
