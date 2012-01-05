<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="i18n-support.xsl"/>

    <xsl:param name="lang" select="'de'"/>
    <xsl:output method="html"/>

    <xsl:template match="/profile">
        <html>
            <head>
                <title>
                    <xsl:call-template name="i18n"><xsl:with-param name="key">Profile</xsl:with-param></xsl:call-template>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="concat(person/firstName, ' ', person/lastName)"/>
                </title>
                <style type="text/css">
body {
    font-family: "Droid Sans", Arial, Helvetica, sans-serif;
    margin-left: 0.5em;
}
td {
    vertical-align: top;
}
h1, h2 {
    page-break-after: avoid;
}
.box {
    border: solid #CCC 1px;
    width: 100%;
    max-width: 880px;
    page-break-inside: avoid;
}
.person {
}
.foto {
    float: right;
    border: 0;
}
.label {
    font-weight: bold;
    width: 160px;
}
.value {
    font-weight: normal;
}
ul.qualification {
    list-style-type: none;
    padding-left: 0;
    margin-top: 0;
    margin-bottom: 0;
}
.companyOrLine {
    font-weight: bold;
}
                </style>
            </head>
            <body>
                <h1><xsl:call-template name="i18n"><xsl:with-param name="key">Profile</xsl:with-param></xsl:call-template>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="concat(person/firstName, ' ', person/lastName)"/></h1>
                <p>
                    <xsl:call-template name="i18n"><xsl:with-param name="key">Last edit</xsl:with-param></xsl:call-template>:
                    <xsl:value-of select="lastEditDate"/></p>
                <xsl:apply-templates select="person"/>
                <xsl:apply-templates select="competencies"/>
                <xsl:apply-templates select="workExperience"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="person">
        <h2><xsl:call-template name="i18n"><xsl:with-param name="key">Personal Details / Overview</xsl:with-param></xsl:call-template></h2>
        <table class="person box">
            <tr>
                <td class="label"><xsl:call-template name="i18n"><xsl:with-param name="key">Name</xsl:with-param></xsl:call-template>:</td>
                <td class="value"><xsl:value-of select="concat(firstName, ' ', lastName)"/></td>
                <td rowspan="7"><img class="foto" src="{photo_lowres}" alt="{concat('Foto von ', firstName, ' ', lastName)}"/></td>
            </tr>
            <tr>
                <td class="label"><xsl:call-template name="i18n"><xsl:with-param name="key">Address</xsl:with-param></xsl:call-template>:</td>
                <td class="value"><xsl:value-of select="street"/><br/><xsl:value-of select="city"/></td>
            </tr>
            <tr>
                <td class="label"><xsl:call-template name="i18n"><xsl:with-param name="key">Telephone</xsl:with-param></xsl:call-template>:</td>
                <td class="value"><xsl:value-of select="telephone"/></td>
            </tr>
            <tr>
                <td class="label"><xsl:call-template name="i18n"><xsl:with-param name="key">E-Mail</xsl:with-param></xsl:call-template>:</td>
                <td class="value"><a href="mailto:{email}"><xsl:value-of select="email"/></a></td>
            </tr>
            <tr>
                <td class="label"><xsl:call-template name="i18n"><xsl:with-param name="key">Internet</xsl:with-param></xsl:call-template>:</td>
                <td class="value">
                <xsl:for-each select="web">
                    <a href="{.}"><xsl:value-of select="."/></a><br/>
                </xsl:for-each>
                </td>
            </tr>
            <tr>
                <td class="label"><xsl:call-template name="i18n"><xsl:with-param name="key">Date of birth</xsl:with-param></xsl:call-template>:</td>
                <td class="value"><xsl:value-of select="dateOfBirth"/></td>
            </tr>
            <tr>
                <td class="label"><xsl:call-template name="i18n"><xsl:with-param name="key">workingSince</xsl:with-param></xsl:call-template>:</td>
                <td class="value"><xsl:value-of select="workingSince"/></td>
            </tr>
            <tr>
                <td class="label"><xsl:call-template name="i18n"><xsl:with-param name="key">qualifications</xsl:with-param></xsl:call-template>:</td>
                <td class="value" colspan="2">
                    <ul class="qualification">
                    <xsl:for-each select="qualifications/education">
                        <li><xsl:value-of select="text()"/></li>
                    </xsl:for-each>
                    </ul>
                </td>
            </tr>
            <tr>
                <td class="label"><xsl:call-template name="i18n"><xsl:with-param name="key">Languages</xsl:with-param></xsl:call-template>:</td>
                <td class="value" colspan="2">
                <xsl:for-each select="languages/language">
                    <xsl:if test="position() != 1"><xsl:text>, </xsl:text></xsl:if>
                    <xsl:value-of select="text()"/>
                </xsl:for-each>
                </td>
            </tr>
            <tr>
                <td class="label"><xsl:call-template name="i18n"><xsl:with-param name="key">Core Area</xsl:with-param></xsl:call-template>:</td>
                <td class="value" colspan="2"><xsl:value-of select="coreArea"/></td>
            </tr>
            <tr>
                <td class="label"><xsl:call-template name="i18n"><xsl:with-param name="key">Area of work</xsl:with-param></xsl:call-template>:</td>
                <td class="value" colspan="2"><xsl:value-of select="areaOfWork"/></td>
            </tr>
        </table>
    </xsl:template>

    <xsl:template match="competencies">
        <h2><xsl:call-template name="i18n"><xsl:with-param name="key">Competencies</xsl:with-param></xsl:call-template></h2>
        <table class="box">
            <xsl:for-each select="./*">
            <tr>
                <td class="label"><xsl:call-template name="i18n"><xsl:with-param name="key"><xsl:value-of select="name()"/></xsl:with-param></xsl:call-template>:</td>
                <td class="value"><xsl:value-of select="text()"/></td>
            </tr>
            </xsl:for-each>
        </table>
    </xsl:template>

    <xsl:template match="workExperience">
        <h2><xsl:call-template name="i18n"><xsl:with-param name="key">Work experience</xsl:with-param></xsl:call-template></h2>
        <xsl:for-each select="project">
        <table class="box">
            <tr>
                <td class="label"><xsl:value-of select="period"/>:</td>
                <td class="value">
                    <span class="companyOrLine"><xsl:value-of select="companyOrLine"/></span>
                    <xsl:text>, </xsl:text>
                    <span class="line1info"><xsl:value-of select="line1info"/></span>
                    <xsl:for-each select="activities">
                        <div class="activities"><xsl:apply-templates /></div>
                    </xsl:for-each>
                </td>
            </tr>
            <tr>
                <td class="label"><xsl:call-template name="i18n"><xsl:with-param name="key">Roles</xsl:with-param></xsl:call-template>:</td>
                <td class="value">
                    <xsl:for-each select="roles">
                        <div class="roles"><xsl:apply-templates /></div>
                    </xsl:for-each>
                </td>
            </tr>
            <tr>
                <td class="label"><xsl:call-template name="i18n"><xsl:with-param name="key">Software</xsl:with-param></xsl:call-template>:</td>
                <td class="value">
                    <xsl:for-each select="software">
                        <div class="software"><xsl:apply-templates /></div>
                    </xsl:for-each>
                </td>
            </tr>
        </table>
        <br/>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
