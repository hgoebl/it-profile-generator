<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="1.0">
    <xsl:import href="i18n-support.xsl"/>

    <xsl:param name="lang" select="'de'"/>
    <xsl:variable name="page-height"><xsl:call-template name="i18n"><xsl:with-param name="key">page-height</xsl:with-param></xsl:call-template></xsl:variable>
    <xsl:variable name="page-width"><xsl:call-template name="i18n"><xsl:with-param name="key">page-width</xsl:with-param></xsl:call-template></xsl:variable>
    <xsl:variable name="fullName">
        <xsl:call-template name="i18n-fullname"><xsl:with-param name="person" select="/profile/person"/></xsl:call-template>
    </xsl:variable>

    <xsl:output method="xml"/>

    <xsl:attribute-set name="font">
        <xsl:attribute name="font-family">'Droid Sans', Arial, Helvetica, sans-serif</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="link">
        <xsl:attribute name="color">#0000CC</xsl:attribute>
        <xsl:attribute name="text-decoration">underline</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="h1" use-attribute-sets="font">
        <xsl:attribute name="font-size">16pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="keep-with-next">10</xsl:attribute>
        <xsl:attribute name="space-before">10mm</xsl:attribute>
        <xsl:attribute name="space-after">4mm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="h2" use-attribute-sets="h1">
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="space-before">5mm</xsl:attribute>
        <xsl:attribute name="space-after">3mm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="box">
        <xsl:attribute name="font-family">Arial, Helvetica, sans-serif</xsl:attribute>
        <xsl:attribute name="space-before">2mm</xsl:attribute>
        <xsl:attribute name="space-after">2mm</xsl:attribute>
        <xsl:attribute name="border-style">solid</xsl:attribute>
        <xsl:attribute name="border-color">#CCCCCC</xsl:attribute>
        <xsl:attribute name="border-width">0.3mm</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="cell">
        <xsl:attribute name="padding">1.5mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:template name="row-2-cols">
        <xsl:param name="label"/>
        <xsl:param name="value"/>
        <xsl:param name="colspan" select="'1'"/>
        <fo:table-row>
            <fo:table-cell xsl:use-attribute-sets="cell">
                <fo:block font-weight="bold"><xsl:copy-of select="$label"/></fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="cell" number-columns-spanned="{$colspan}">
                <fo:block><xsl:copy-of select="$value"/></fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>

    <xsl:template name="h1">
        <xsl:param name="value"/>
        <fo:block xsl:use-attribute-sets="h1"><xsl:copy-of select="$value"/></fo:block>
    </xsl:template>

    <xsl:template name="h2">
        <xsl:param name="value"/>
        <fo:block xsl:use-attribute-sets="h2"><xsl:copy-of select="$value"/></fo:block>
    </xsl:template>

    <xsl:template name="single-row-table-left-right">
        <xsl:param name="left"/>
        <xsl:param name="right"/>
        <fo:table table-layout="fixed" width="100%">
            <fo:table-column column-width="proportional-column-width(1)"/>
            <fo:table-column column-width="proportional-column-width(1)"/>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell>
                        <fo:block text-align="start"><xsl:copy-of select="$left"/></fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block text-align="end"><xsl:copy-of select="$right"/></fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template match="a">
        <fo:basic-link external-destination="{.}" xsl:use-attribute-sets="link">
            <xsl:value-of select="."/>
        </fo:basic-link>
    </xsl:template>

    <xsl:template match="/profile">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <fo:layout-master-set>
                <fo:simple-page-master
                        master-name="Master"
                        page-height="{$page-height}"
                        page-width="{$page-width}"
                        margin-top="10mm"
                        margin-bottom="10mm"
                        margin-left="10mm"
                        margin-right="10mm">
                    <fo:region-body
                            margin-top="10mm"
                            margin-bottom="16mm"
                            margin-left="5mm"
                            margin-right="5mm"/>
                    <fo:region-before
                            extent="16mm"/>
                    <fo:region-after
                            extent="10mm"/>
                </fo:simple-page-master>
            </fo:layout-master-set>
            <fo:declarations>
                <x:xmpmeta xmlns:x="adobe:ns:meta/">
                    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
                        <rdf:Description rdf:about="" xmlns:dc="http://purl.org/dc/elements/1.1/">
                            <!-- Dublin Core properties go here -->
                            <dc:title>
                                <xsl:call-template name="i18n"><xsl:with-param name="key">Profile</xsl:with-param></xsl:call-template>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$fullName"/>
                                <xsl:text>, </xsl:text>
                                <xsl:call-template name="i18n"><xsl:with-param name="key">Last Update</xsl:with-param></xsl:call-template>
                                <xsl:text>: </xsl:text>
                                <xsl:value-of select="lastEditDate"/>
                            </dc:title>
                            <dc:creator>
                                <xsl:value-of select="$fullName"/>
                            </dc:creator>
                        </rdf:Description>
                        <rdf:Description rdf:about="" xmlns:xmp="http://ns.adobe.com/xap/1.0/">
                            <!-- XMP properties go here -->
                            <xmp:CreatorTool>Apache FOP, IntelliJ IDEA, Linux Mint</xmp:CreatorTool>
                        </rdf:Description>
                    </rdf:RDF>
                </x:xmpmeta>
            </fo:declarations>
            <fo:page-sequence master-reference="Master">
                <fo:static-content flow-name="xsl-region-before">
                    <xsl:call-template name="single-row-table-left-right">
                        <xsl:with-param name="right">
                            <xsl:call-template name="i18n"><xsl:with-param name="key">Profile</xsl:with-param></xsl:call-template>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="$fullName"/>
                        </xsl:with-param>
                        <xsl:with-param name="left">
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:static-content>
                <fo:static-content flow-name="xsl-region-after">
                    <xsl:call-template name="single-row-table-left-right">
                        <xsl:with-param name="left">
                            <xsl:call-template name="i18n"><xsl:with-param name="key">Last Update</xsl:with-param></xsl:call-template>
                            <xsl:text>: </xsl:text>
                            <xsl:value-of select="lastEditDate"/>
                        </xsl:with-param>
                        <xsl:with-param name="right">
                            <xsl:call-template name="i18n"><xsl:with-param name="key">Page</xsl:with-param></xsl:call-template>
                            <xsl:text> </xsl:text>
                            <fo:page-number/>
                            <xsl:text> </xsl:text>
                            <xsl:call-template name="i18n"><xsl:with-param name="key">of</xsl:with-param></xsl:call-template>
                            <xsl:text> </xsl:text>
                            <fo:page-number-citation-last ref-id="last-page"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:static-content>
                <fo:flow flow-name = "xsl-region-body">
                    <xsl:call-template name="h1">
                        <xsl:with-param name="value">
                            <xsl:call-template name="i18n"><xsl:with-param name="key">Profile</xsl:with-param></xsl:call-template>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="$fullName"/>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:apply-templates select="person"/>
                    <xsl:apply-templates select="competencies"/>
                    <xsl:apply-templates select="workExperience"/>
                    <fo:block id="last-page"/>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>

    <xsl:template match="person">
        <xsl:call-template name="h2">
            <xsl:with-param name="value">
                <xsl:call-template name="i18n"><xsl:with-param name="key">Personal Details / Overview</xsl:with-param></xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
        <fo:table table-layout="fixed" width="100%" xsl:use-attribute-sets="box">
            <fo:table-column column-width="40mm"/>
            <fo:table-column column-width="75mm"/>
            <fo:table-column column-width="proportional-column-width(1)"/>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell xsl:use-attribute-sets="cell">
                        <fo:block font-weight="bold"><xsl:call-template name="i18n"><xsl:with-param name="key">Name</xsl:with-param></xsl:call-template>:</fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell">
                        <fo:block><xsl:value-of select="$fullName"/></fo:block>
                    </fo:table-cell>
                    <fo:table-cell number-rows-spanned="7" xsl:use-attribute-sets="cell">
                        <fo:block text-align="end">
                            <fo:external-graphic src="{photo_hires}" content-width="42mm"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <xsl:call-template name="row-2-cols">
                    <xsl:with-param name="label"><xsl:call-template name="i18n"><xsl:with-param name="key">Address</xsl:with-param></xsl:call-template>:</xsl:with-param>
                    <xsl:with-param name="value"><xsl:value-of select="street"/><fo:block/>
                        <xsl:call-template name="i18n-address">
                            <xsl:with-param name="city" select="city"/>
                            <xsl:with-param name="zip" select="zip"/>
                            <xsl:with-param name="state" select="state"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="row-2-cols">
                    <xsl:with-param name="label"><xsl:call-template name="i18n"><xsl:with-param name="key">Telephone</xsl:with-param></xsl:call-template>:</xsl:with-param>
                    <xsl:with-param name="value"><xsl:value-of select="telephone"/></xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="row-2-cols">
                    <xsl:with-param name="label"><xsl:call-template name="i18n"><xsl:with-param name="key">E-Mail</xsl:with-param></xsl:call-template>:</xsl:with-param>
                    <xsl:with-param name="value">
                        <fo:basic-link external-destination="mailto:{email}" xsl:use-attribute-sets="link">
                            <xsl:value-of select="email"/>
                        </fo:basic-link>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="row-2-cols">
                    <xsl:with-param name="label"><xsl:call-template name="i18n"><xsl:with-param name="key">Internet</xsl:with-param></xsl:call-template>:</xsl:with-param>
                    <xsl:with-param name="value">
                        <xsl:for-each select="web">
                            <fo:basic-link external-destination="{.}" xsl:use-attribute-sets="link">
                                <xsl:value-of select="."/>
                            </fo:basic-link>
                            <fo:block/>
                        </xsl:for-each>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="row-2-cols">
                    <xsl:with-param name="label"><xsl:call-template name="i18n"><xsl:with-param name="key">Date of birth</xsl:with-param></xsl:call-template>:</xsl:with-param>
                    <xsl:with-param name="value"><xsl:value-of select="dateOfBirth"/></xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="row-2-cols">
                    <xsl:with-param name="label"><xsl:call-template name="i18n"><xsl:with-param name="key">workingSince</xsl:with-param></xsl:call-template>:</xsl:with-param>
                    <xsl:with-param name="value"><xsl:value-of select="workingSince"/></xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="row-2-cols">
                    <xsl:with-param name="label"><xsl:call-template name="i18n"><xsl:with-param name="key">qualifications</xsl:with-param></xsl:call-template>:</xsl:with-param>
                    <xsl:with-param name="colspan">2</xsl:with-param>
                    <xsl:with-param name="value">
                    <xsl:for-each select="qualifications/education">
                        <fo:block><xsl:value-of select="text()"/></fo:block>
                    </xsl:for-each>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="row-2-cols">
                    <xsl:with-param name="label"><xsl:call-template name="i18n"><xsl:with-param name="key">Languages</xsl:with-param></xsl:call-template>:</xsl:with-param>
                    <xsl:with-param name="colspan">2</xsl:with-param>
                    <xsl:with-param name="value">
                        <xsl:for-each select="languages/language">
                            <xsl:if test="position() != 1"><xsl:text>, </xsl:text></xsl:if>
                            <xsl:value-of select="text()"/>
                        </xsl:for-each>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="row-2-cols">
                    <xsl:with-param name="label"><xsl:call-template name="i18n"><xsl:with-param name="key">Core Area</xsl:with-param></xsl:call-template>:</xsl:with-param>
                    <xsl:with-param name="colspan">2</xsl:with-param>
                    <xsl:with-param name="value"><xsl:value-of select="coreArea"/></xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="row-2-cols">
                    <xsl:with-param name="label"><xsl:call-template name="i18n"><xsl:with-param name="key">Area of work</xsl:with-param></xsl:call-template>:</xsl:with-param>
                    <xsl:with-param name="colspan">2</xsl:with-param>
                    <xsl:with-param name="value"><xsl:value-of select="areaOfWork"/></xsl:with-param>
                </xsl:call-template>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template match="competencies">
        <xsl:call-template name="h2">
            <xsl:with-param name="value"><xsl:call-template name="i18n"><xsl:with-param name="key">Competencies</xsl:with-param></xsl:call-template></xsl:with-param>
        </xsl:call-template>
        <fo:table table-layout="fixed" width="100%" xsl:use-attribute-sets="box">
            <fo:table-column column-width="40mm"/>
            <fo:table-column column-width="75mm"/>
            <fo:table-column column-width="proportional-column-width(1)"/>
            <fo:table-body>
                <xsl:for-each select="./*">
                    <xsl:call-template name="row-2-cols">
                        <xsl:with-param name="label"><xsl:call-template name="i18n"><xsl:with-param name="key"><xsl:value-of select="name()"/></xsl:with-param></xsl:call-template>:</xsl:with-param>
                        <xsl:with-param name="colspan">2</xsl:with-param>
                        <xsl:with-param name="value"><xsl:value-of select="text()"/></xsl:with-param>
                    </xsl:call-template>
                </xsl:for-each>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template match="workExperience">
        <xsl:call-template name="h2">
            <xsl:with-param name="value"><xsl:call-template name="i18n"><xsl:with-param name="key">Work experience</xsl:with-param></xsl:call-template></xsl:with-param>
        </xsl:call-template>
        <xsl:for-each select="project">
        <fo:table table-layout="fixed" width="100%" xsl:use-attribute-sets="box">
            <fo:table-column column-width="40mm"/>
            <fo:table-column column-width="75mm"/>
            <fo:table-column column-width="proportional-column-width(1)"/>
            <fo:table-body>
                <xsl:call-template name="row-2-cols">
                    <xsl:with-param name="label"><xsl:value-of select="period"/>:</xsl:with-param>
                    <xsl:with-param name="colspan">2</xsl:with-param>
                    <xsl:with-param name="value">
                        <fo:block>
                        <fo:inline font-weight="bold"><xsl:value-of select="companyOrLine"/></fo:inline>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="line1info"/>
                        </fo:block>
                        <xsl:for-each select="activities">
                            <fo:block><xsl:apply-templates /></fo:block>
                        </xsl:for-each>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="row-2-cols">
                    <xsl:with-param name="label"><xsl:call-template name="i18n"><xsl:with-param name="key">Roles</xsl:with-param></xsl:call-template>:</xsl:with-param>
                    <xsl:with-param name="colspan">2</xsl:with-param>
                    <xsl:with-param name="value">
                    <xsl:for-each select="roles">
                        <fo:block><xsl:apply-templates /></fo:block>
                    </xsl:for-each>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="row-2-cols">
                    <xsl:with-param name="label"><xsl:call-template name="i18n"><xsl:with-param name="key">Software</xsl:with-param></xsl:call-template>:</xsl:with-param>
                    <xsl:with-param name="colspan">2</xsl:with-param>
                    <xsl:with-param name="value">
                    <xsl:for-each select="software">
                        <fo:block><xsl:apply-templates /></fo:block>
                    </xsl:for-each>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:table-body>
        </fo:table>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
