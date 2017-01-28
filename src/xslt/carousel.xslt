<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output indent="yes" method="xml"/>
    <xsl:output method="html"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <xsl:param name="count-item">
            <xsl:value-of select="count(descendant::item)"/>
        </xsl:param>
        <div class="carousel slide" data-interval="1000000" id="myCarousel1">
            <div class="carousel-inner">
                <xsl:for-each select="descendant-or-self::item">
                    <div>
                        <xsl:attribute name="class">
                            <xsl:choose>
                                <xsl:when test="position() = 1">item active</xsl:when>
                                <xsl:otherwise>item</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <div class="image">
                            <xsl:choose>
                                <xsl:when test="link[text()]">
                                    <a class="fancybox fancybox.iframe"><xsl:attribute name="href"><xsl:value-of select="link"/></xsl:attribute>
                                        <img class="img-rounded"><xsl:attribute name="src"><xsl:value-of select="normalize-space(image/path)"/></xsl:attribute><xsl:attribute name="alt"><xsl:value-of select="title"/></xsl:attribute></img>
                                    </a>
                                </xsl:when>
                                <xsl:otherwise><img class="img-rounded"><xsl:attribute name="src"><xsl:value-of select="normalize-space(image/path)"/></xsl:attribute><xsl:attribute name="alt"><xsl:value-of select="title"/></xsl:attribute></img></xsl:otherwise>
                            </xsl:choose>
                        </div>
                        <xsl:if test="$count-item &gt; 1">
                        <a class="carousel-control left pull-left" data-slide="prev" href="#myCarousel1">&#8249;</a>
                        <a class="carousel-control right pull-right" data-slide="next" href="#myCarousel1">&#8250;</a>
                        </xsl:if>
                        <div class="caption">
                            <h3><xsl:value-of select="title"/></h3>
                            <xsl:copy-of select="div"/>
                        </div>
                    </div>
                </xsl:for-each>
            </div>

        </div>
    </xsl:template>

</xsl:stylesheet>
