<?xml version="1.0" encoding="UTF-8"?>
<!--
    Sets the text content of elements with "data-i18n" attribute.
    Makes the html page more production-ready.

    Parameter: {String} [lang = 'en']
  -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="i18n-support.xsl"/>

    <xsl:param name="lang" select="'en'"/>
    <xsl:output method="html" version="5"/>
    <xsl:output omit-xml-declaration="yes" indent="no" cdata-section-elements="script"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- switch script sources to production mode -->
    <xsl:template match="@data-src-prod"/>
    <xsl:template match="script[@src and @data-src-prod]">
        <script src="{current()/@data-src-prod}"/>
    </xsl:template>

    <!-- switch css hrefs to production mode -->
    <xsl:template match="@data-href-prod"/>
    <xsl:template match="link[@rel='stylesheet' and @href and @data-href-prod]">
        <link rel="stylesheet" href="{current()/@data-href-prod}"/>
    </xsl:template>

    <!-- erase data-i18n attribute -->
    <xsl:template match="@data-i18n"/>

    <!-- erase all elements with a data-ignore attribute -->
    <xsl:template match="*[@data-ignore]"/>

    <!-- replace text from elements with data-i18n elements by key -->
    <xsl:template match="//*[@data-i18n]">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
            <xsl:call-template name="i18n">
                <xsl:with-param name="key">
                    <xsl:value-of select="./@data-i18n"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>

    <!-- copy all attributes and nodes -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
