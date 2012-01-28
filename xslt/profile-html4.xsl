<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="i18n-support.xsl"/>

    <xsl:param name="lang" select="'de'"/>
    <xsl:output method="html"/>
    <xsl:variable name="fullName">
        <xsl:call-template name="i18n-fullname"><xsl:with-param name="person" select="/profile/person"/></xsl:call-template>
    </xsl:variable>

    <xsl:template match="/profile">
        <html lang="{$lang}" xml:lang="{$lang}">
            <head>
                <meta name="description">
                    <xsl:attribute name="content">
                        <xsl:call-template name="i18n"><xsl:with-param name="key">meta-description</xsl:with-param></xsl:call-template>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$fullName"/>
                    </xsl:attribute>
                </meta>
                <meta name="keywords">
                    <xsl:attribute name="keywords">
                        <xsl:call-template name="i18n"><xsl:with-param name="key">meta-keywords</xsl:with-param></xsl:call-template>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="normalize-space(person/coreArea)"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="normalize-space(person/areaOfWork)"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="normalize-space(person/city)"/>
                    </xsl:attribute>
                </meta>
                <meta name="author" content="{$fullName}"/>
                <meta name="generator" content="https://github.com/hgoebl/it-profile-generator"/>
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
                    <xsl:value-of select="$fullName"/></h1>
                <p>
                    <xsl:call-template name="i18n"><xsl:with-param name="key">Last Update</xsl:with-param></xsl:call-template>:
                    <xsl:value-of select="lastEditDate"/></p>
                <xsl:apply-templates select="person"/>
                <xsl:apply-templates select="competencies"/>
                <xsl:apply-templates select="workExperience"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="person">
        <h2><xsl:call-template name="i18n"><xsl:with-param name="key">Personal Details / Overview</xsl:with-param></xsl:call-template></h2>
        <div itemscope="itemscope" itemtype="http://data-vocabulary.org/Person">
        <table class="person box">
            <tr>
                <td class="label"><xsl:call-template name="i18n"><xsl:with-param name="key">Name</xsl:with-param></xsl:call-template>:</td>
                <td class="value"><span itemprop="name"><xsl:value-of select="$fullName"/></span></td>
                <td rowspan="7">
					<xsl:if test="photo_lowres">
                        <meta itemprop="photo" content="{photo_lowres}"/>
						<img class="foto" src="{photo_lowres}">
							<xsl:attribute name="alt">
								<xsl:call-template name="i18n"><xsl:with-param name="key">Photo of</xsl:with-param></xsl:call-template>
								<xsl:text> </xsl:text>
								<xsl:value-of select="$fullName"/>
							</xsl:attribute>
						</img>
					</xsl:if>
                </td>
            </tr>
            <tr>
                <td class="label"><xsl:call-template name="i18n"><xsl:with-param name="key">Address</xsl:with-param></xsl:call-template>:</td>
                <td class="value">
                    <div itemprop="address" itemscope="itemscope" itemtype="http://data-vocabulary.org/Address">
                    <span itemprop="street-address"><xsl:value-of select="street"/></span><br/>
                    <xsl:call-template name="i18n-address-microformat">
                        <xsl:with-param name="city" select="city"/>
                        <xsl:with-param name="zip" select="zip"/>
                        <xsl:with-param name="state" select="state"/>
                    </xsl:call-template>
                    <meta itemprop="country-name" content="{country}"/>
                    </div>
                </td>
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
                    <xsl:if test="position() = 1">
                        <meta itemprop="url" content="{.}"/>
                    </xsl:if>
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
        </div>
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
