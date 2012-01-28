<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="lang" select="'en'"/>
    <xsl:variable name="i18n_doc" select="document('i18n.xml')/i18n"/>
    <xsl:template name="i18n">
        <xsl:param name="key"/>
        <xsl:param name="force-lang" select="$lang"/>
        <xsl:variable name="val" select="$i18n_doc/entry[@key=$key]/msg[lang($force-lang)]"/>
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
    <xsl:template name="i18n-address-microformat">
        <xsl:param name="city"/>
        <xsl:param name="state"/>
        <xsl:param name="zip"/>
        <xsl:choose>
            <xsl:when test="$lang = 'en'">
                <span itemprop="locality"><xsl:value-of select="$city"/></span>
                <xsl:text>, </xsl:text>
                <span itemprop="region"><xsl:value-of select="$state"/></span>
                <xsl:text> </xsl:text>
                <span itemprop="postal-code"><xsl:value-of select="$zip"/></span>
            </xsl:when>
            <xsl:otherwise>
                <span itemprop="postal-code"><xsl:value-of select="$zip"/></span>
                <xsl:text> </xsl:text>
                <span itemprop="locality"><xsl:value-of select="$city"/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="i18n-address">
        <xsl:param name="city"/>
        <xsl:param name="state"/>
        <xsl:param name="zip"/>
        <xsl:choose>
            <xsl:when test="$lang = 'en'">
                <xsl:value-of select="concat($city, ', ', $state, ' ', $zip)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($zip, ' ', $city)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="i18n-fullname">
        <xsl:param name="person"/>
        <xsl:if test="$person/title">
            <xsl:value-of select="concat($person/title, ' ')"/>
        </xsl:if>
        <xsl:value-of select="concat($person/firstName, ' ')"/>
        <xsl:if test="$person/middleName">
            <xsl:value-of select="concat($person/middleName, ' ')"/>
        </xsl:if>
        <xsl:value-of select="$person/lastName"/>
        <xsl:if test="$person/suffix">
            <xsl:value-of select="concat(' ', $person/suffix)"/>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
