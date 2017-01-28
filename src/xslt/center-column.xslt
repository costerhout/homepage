<?xml version="1.0" encoding="UTF-8"?>
<!--
@Author: Colin Osterhout <ctosterhout>
@Date:   2016-12-05T09:16:40-09:00
@Email:  ctosterhout@alaska.edu
@Project: Front Page
@Last modified by:   ctosterhout
@Last modified time: 2016-12-07T14:48:36-09:00
-->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    >
    <!--
    <xsl:import href="../bert/src/xslt/bs2/bs2-default.xslt"/>
    <xsl:import href="../bert/src/xslt/bs2/bs2-event-list-simple.xslt"/>
 -->
    <xsl:import href="/_assets/stylesheets/bert/bs2/bs2-default.xslt"/>
    <xsl:import href="/_assets/stylesheets/bert/bs2/bs2-event-list-simple.xslt"/>

    <xsl:strip-space elements="*"/>
    <xsl:output indent="yes" method="html"/>

    <!-- Set up variables that downstream templates (event listing) will pick up on -->
    <xsl:param name="sLayout" select="'inline'"/>
    <xsl:param name="nArticleLimit" select="5"/>
    <xsl:param name="sTitle"/>


    <!-- Supply template to work with the most recent UAS In the News articles -->
    <xsl:template match="system-index-block[system-page]">
        <div class="newsbox">
            <xsl:apply-templates select=".//system-data-structure" mode="frontpage-news"/>
            <div>
                <ul class="unstyled">
                    <li><a href="/pr/uas-in-news">UAS in the News Archives &#187;</a></li>
                    <li><a href="/pr/index">Press Releases &#187;</a></li>
                </ul>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="system-data-structure" mode="frontpage-news">
        <xsl:variable name="sUrlImage">
            <xsl:if test="normalize-space(image/path) != '/'">
                <xsl:call-template name="pathfilter">
                    <xsl:with-param name='path' select='image/path'/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>

        <xsl:variable name="sAltImage">
            <xsl:if test="normalize-space(image/path) != '/'">
                <xsl:choose>
                    <xsl:when test="image-label/text()">
                        <xsl:value-of select="image-label"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(Title)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:variable>

        <article>
            <xsl:if test="normalize-space($sUrlImage) != ''">
                <div class="float-right">
                    <img src="{normalize-space($sUrlImage)}" alt="$sAltImage"/>
                </div>
            </xsl:if>
            <h4><xsl:value-of select="Title"/></h4>
            <p>
                <span class="byline"><xsl:value-of select="Publisher"/></span> - <xsl:value-of select="Description"/>
                <a class="external" target="_blank" href="{Link}"> ...More</a>
            </p>
        </article>
    </xsl:template>
</xsl:stylesheet>
