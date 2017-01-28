<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- <xsl:import href="../bert/src/xslt/include/pathfilter.xslt"/> -->
    <xsl:import href="/_assets/stylesheets/bert/include/pathfilter.xslt"/>
    <xsl:output indent="yes" method="xml"/>
    <xsl:output method="html"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="system-index-block">
        <div class="carousel slide" id="carousel-regional" data-interval="false">
            <div class="carousel-inner">
                <xsl:apply-templates select=".//item"/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="item">
        <xsl:variable name="sClass">
            <xsl:choose>
                <xsl:when test="position() = 1">item active</xsl:when>
                <xsl:otherwise>item</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="urlMoreInfo">
            <xsl:if test="link/text()">
                <xsl:call-template name="pathfilter">
                    <xsl:with-param name="path" select='normalize-space(link)'/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>

        <xsl:variable name="urlImage">
            <xsl:call-template name="pathfilter">
                <xsl:with-param name="path" select='normalize-space(image/path)'/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="rtfImage">
            <img class="img-rounded" src="{$urlImage}" alt="{title}"/>
        </xsl:variable>

        <xsl:variable name="rtfBody">
            <xsl:call-template name="paragraph-wrap">
                <xsl:with-param name="nodeToWrap" select="div"/>
            </xsl:call-template>
        </xsl:variable>

        <div class="{$sClass}">
            <div class="image">
                <xsl:choose>
                    <xsl:when test="$urlMoreInfo != ''">
                        <a href="{$urlMoreInfo}">
                            <xsl:copy-of select="$rtfImage"/>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="$rtfImage"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
            <xsl:if test="count(ancestor::system-index-block//item) &gt; 1">
                <div class="carousel-controls">
                    <a class="carousel-control left pull-left" data-slide="prev" href="#carousel-regional">&#8249;</a>
                    <a class="carousel-control right pull-right" data-slide="next" href="#carousel-regional">&#8250;</a>
                </div>
            </xsl:if>
            <div class="caption">
                <h3><xsl:value-of select="title"/></h3>
                <xsl:copy-of select="$rtfBody"/>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>
