<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    exclude-result-prefixes="hh" version="1.0" xmlns:hh="http://www.hannonhill.com/XSL/Functions"
    >
    <xsl:import href="../bert/src/xslt/include/format-date.xslt"/>
    <xsl:strip-space elements="*"/>
    <xsl:output indent="yes" method="html"/>

    <!-- Set other variables -->
    <xsl:variable name="max">4</xsl:variable>

    <xsl:template match="/">
        <div class="tabbable">

            <div class="tab-content homepage">
                <xsl:apply-templates select="system-data-structure"/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="system-data-structure">
        <ul class="nav nav-tabs">
            <xsl:for-each select="tab">
                <li>
                    <xsl:attribute name="class">
                        <xsl:choose>
                            <xsl:when test="position() = 1">active</xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:attribute>
                    <a data-toggle="tab">
                        <xsl:attribute name="href">#<xsl:value-of select="tab_id"/></xsl:attribute>
                        <xsl:value-of select="tab_label"/>
                    </a>
                </li>
            </xsl:for-each>
        </ul>

        <xsl:for-each select="tab">
            <div>
                <xsl:attribute name="class">
                    <xsl:choose>
                        <xsl:when test="position() = 1">tab-pane active</xsl:when>
                        <xsl:otherwise>tab-pane</xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:value-of select="tab_id"/>
                </xsl:attribute>
                <xsl:copy-of select="child::tab_content/*"/>
                <xsl:choose>
                    <xsl:when test="ancestor-or-self::tab/tab_id = 'tab1'">
                        <xsl:for-each select="ablock/content">
                        <xsl:call-template name="news"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="ancestor-or-self::tab/tab_id = 'tab2'">

                        <xsl:for-each select="ablock/content">
                        <xsl:call-template name="events"/>
                        </xsl:for-each>
                        <div align="center" style="padding:0 30px;"><hr/></div>

                            <a href="http://www.uas.alaska.edu/calendar/academic/index.html">View Full Academic Calendar &#187;</a>

                    </xsl:when>
                </xsl:choose>

            </div>
        </xsl:for-each>
    </xsl:template>


    <xsl:template name="events">
        <div>
            <xsl:call-template name="day1">
                <xsl:with-param name="count" select="0"/>
            </xsl:call-template>
        </div>
    </xsl:template>

    <xsl:template name="news">
        <div class="newsbox">

            <xsl:for-each select="descendant-or-self::system-page/system-data-structure">
                <div class="article">
                    <xsl:call-template name="article"/>
                </div>
            </xsl:for-each>

            <br class="clearit"/>
            <div>

                        <ul class="unstyled">
                            <li><a href="http://www.uas.alaska.edu/pr/uas-in-news.html">UAS in the News Archives &#187;</a></li>
                            <li><a href="http://www.uas.alaska.edu/pr/">Press Releases &#187;</a></li>
                        </ul>
            </div>
            <br class="clearit"/>
        </div>
    </xsl:template>


    <xsl:template name="article">
        <xsl:param name="path-folder">http://www.uas.alaska.edu/<xsl:choose>
            <xsl:when test="contains(descendant-or-self::image/path,'Departments')"><xsl:value-of select="substring-after(descendant-or-self::image/path,'Departments/')"/></xsl:when>
            <xsl:when test="contains(descendant-or-self::image/path,'Programs')"><xsl:value-of select="substring-after(descendant-or-self::image/path,'Programs/')"/></xsl:when>
            <xsl:when test="contains(descendant-or-self::image/path,'Marketing')"><xsl:value-of select="substring-after(descendant-or-self::image/path,'Marketing/')"/></xsl:when>
            <xsl:when test="contains(descendant-or-self::image/path,'Support')"><xsl:value-of select="substring-after(descendant-or-self::image/path,'Support/')"/></xsl:when>
            <xsl:when test="contains(descendant-or-self::image/path,'Clubs')"><xsl:value-of select="substring-after(descendant-or-self::image/path,'Clubs/')"/></xsl:when>
            <xsl:when test="contains(descendant-or-self::image/path,'Other')"><xsl:value-of select="substring-after(descendant-or-self::image/path,'/uas.alaska.edu/Other/')"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="descendant-or-self::image/path"/></xsl:otherwise>
        </xsl:choose>
        </xsl:param>
        <xsl:choose>
            <xsl:when test="descendant-or-self::image/path = '/'"/>
            <xsl:when test="descendant-or-self::image/path = ''"/>
            <xsl:otherwise>
                <div class="floatRight"><img><xsl:attribute name="src"><xsl:value-of select="normalize-space($path-folder)"/></xsl:attribute>
                    <xsl:attribute name="alt">
                        <xsl:value-of select="image-label"/>
                    </xsl:attribute></img></div>
            </xsl:otherwise>
        </xsl:choose>

        <h4>
            <xsl:value-of select="Title"/>
        </h4>

        <p>
            <span class="muted" style="font-weight:bold;"><xsl:value-of select="Publisher"/></span> - <xsl:value-of select="Description"/>
            <a class="external" target="_blank"><xsl:attribute name="href"><xsl:value-of select="Link"/></xsl:attribute> ...More</a>
        </p>
        <div align="center" style="padding:0 30px;"><hr/></div>
    </xsl:template>

        <xsl:template name="day1">
        <xsl:param name="count"/>
        <xsl:if test="descendant::date = $day1">
            <h4>TODAY: <xsl:value-of select="$dow"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
                <xsl:value-of select="substring-before(substring-after($day1, '-'), '-')"/></h4>
            <xsl:apply-templates select="system-index-block">
                <xsl:with-param name="target_day">
                    <xsl:value-of select="$day1"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$count &lt; $max">
            <xsl:call-template name="day2"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day1])"/></xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="day2">
        <xsl:param name="count"/>
        <xsl:if test="descendant::date = $day2">
            <h4><xsl:value-of select="$dow2"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
                <xsl:value-of select="substring-before(substring-after($day2, '-'), '-')"/></h4>
            <xsl:apply-templates select="system-index-block">
                <xsl:with-param name="target_day">
                    <xsl:value-of select="$day2"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$count &lt; $max">
            <xsl:call-template name="day3"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day2])"/></xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="day3">
        <xsl:param name="count"/>
        <xsl:if test="descendant::date = $day3">
            <h4><xsl:value-of select="$dow3"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
                <xsl:value-of select="substring-before(substring-after($day3, '-'), '-')"/></h4>
            <xsl:apply-templates select="system-index-block">
                <xsl:with-param name="target_day">
                    <xsl:value-of select="$day3"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$count &lt; $max">
            <xsl:call-template name="day4"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day3])"/></xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="day4">
        <xsl:param name="count"/>
        <xsl:if test="descendant::date = $day4">
            <h4><xsl:value-of select="$dow4"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
                <xsl:value-of select="substring-before(substring-after($day4, '-'), '-')"/></h4>
            <xsl:apply-templates select="system-index-block">
                <xsl:with-param name="target_day">
                    <xsl:value-of select="$day4"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$count &lt; $max">
            <xsl:call-template name="day5"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day4])"/></xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="day5">
        <xsl:param name="count"/>
        <xsl:if test="descendant::date = $day5">
            <h4><xsl:value-of select="$dow4"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
                <xsl:value-of select="substring-before(substring-after($day5, '-'), '-')"/></h4>
            <xsl:apply-templates select="system-index-block">
                <xsl:with-param name="target_day">
                    <xsl:value-of select="$day5"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$count &lt; $max">
            <xsl:call-template name="day6"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day5])"/></xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="day6">
        <xsl:param name="count"/>
        <xsl:if test="descendant::date = $day6">
            <h4><xsl:value-of select="$dow6"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
                <xsl:value-of select="substring-before(substring-after($day6, '-'), '-')"/></h4>
            <xsl:apply-templates select="system-index-block">
                <xsl:with-param name="target_day">
                    <xsl:value-of select="$day6"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$count &lt; $max">
            <xsl:call-template name="day7"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day6])"/></xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="day7">
        <xsl:param name="count"/>
        <xsl:if test="descendant::date = $day7">
            <h4><xsl:value-of select="$dow7"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
                <xsl:value-of select="substring-before(substring-after($day7, '-'), '-')"/></h4>
            <xsl:apply-templates select="system-index-block">
                <xsl:with-param name="target_day">
                    <xsl:value-of select="$day7"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$count &lt; $max">
            <xsl:call-template name="day8"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day7])"/></xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="day8">
        <xsl:param name="count"/>
        <xsl:if test="descendant::date = $day8">
            <h4><xsl:value-of select="$dow"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
                <xsl:value-of select="substring-before(substring-after($day8, '-'), '-')"/></h4>
            <xsl:apply-templates select="system-index-block">
                <xsl:with-param name="target_day">
                    <xsl:value-of select="$day8"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$count &lt; $max">
            <xsl:call-template name="day9"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day8])"/></xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="day9">
        <xsl:param name="count"/>
        <xsl:if test="descendant::date = $day9">
            <h4><xsl:value-of select="$dow2"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
                <xsl:value-of select="substring-before(substring-after($day9, '-'), '-')"/></h4>
            <xsl:apply-templates select="system-index-block">
                <xsl:with-param name="target_day">
                    <xsl:value-of select="$day9"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$count &lt; $max">
            <xsl:call-template name="day10"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day9])"/></xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="day10">
        <xsl:param name="count"/>
        <xsl:if test="descendant::date = $day10">
            <h4><xsl:value-of select="$dow3"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
                <xsl:value-of select="substring-before(substring-after($day10, '-'), '-')"/></h4>
            <xsl:apply-templates select="system-index-block">
                <xsl:with-param name="target_day">
                    <xsl:value-of select="$day10"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$count &lt; $max">
            <xsl:call-template name="day11"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day10])"/></xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="day11">
        <xsl:param name="count"/>
        <xsl:if test="descendant::date = $day11">
            <h4><xsl:value-of select="$dow4"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
                <xsl:value-of select="substring-before(substring-after($day11, '-'), '-')"/></h4>
            <xsl:apply-templates select="system-index-block">
                <xsl:with-param name="target_day">
                    <xsl:value-of select="$day11"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$count &lt; $max">
            <xsl:call-template name="day12"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day11])"/></xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="day12">
        <xsl:param name="count"/>
        <xsl:if test="descendant::date = $day12">
            <h4><xsl:value-of select="$dow5"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
                <xsl:value-of select="substring-before(substring-after($day12, '-'), '-')"/></h4>
            <xsl:apply-templates select="system-index-block">
                <xsl:with-param name="target_day">
                    <xsl:value-of select="$day12"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$count &lt; $max">
            <xsl:call-template name="day13"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day12])"/></xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="day13">
        <xsl:param name="count"/>
        <xsl:if test="descendant::date = $day13">
            <h4><xsl:value-of select="$dow6"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
                <xsl:value-of select="substring-before(substring-after($day13, '-'), '-')"/></h4>
            <xsl:apply-templates select="system-index-block">
                <xsl:with-param name="target_day">
                    <xsl:value-of select="$day13"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$count &lt; $max">
            <xsl:call-template name="day14"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day13])"/></xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="day14">
        <xsl:param name="count"/>
        <xsl:if test="descendant::date = $day14">
            <h4><xsl:value-of select="$dow6"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
                <xsl:value-of select="substring-before(substring-after($day14, '-'), '-')"/></h4>
            <xsl:apply-templates select="system-index-block">
                <xsl:with-param name="target_day">
                    <xsl:value-of select="$day14"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:if>
    <xsl:if test="$count &lt; $max">
        <xsl:call-template name="day15"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day14])"/></xsl:call-template>
    </xsl:if>
    </xsl:template>


<xsl:template name="day15">
    <xsl:param name="count"/>
    <xsl:if test="descendant::date = $day15">
        <h4><xsl:value-of select="$dow"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
            <xsl:value-of select="substring-before(substring-after($day15, '-'), '-')"/></h4>
        <xsl:apply-templates select="system-index-block">
            <xsl:with-param name="target_day">
                <xsl:value-of select="$day15"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:if>
    <xsl:if test="$count &lt; $max">
        <xsl:call-template name="day16"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day15])"/></xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="day16">
    <xsl:param name="count"/>
    <xsl:if test="descendant::date = $day16">
        <h4><xsl:value-of select="$dow2"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
            <xsl:value-of select="substring-before(substring-after($day16, '-'), '-')"/></h4>
        <xsl:apply-templates select="system-index-block">
            <xsl:with-param name="target_day">
                <xsl:value-of select="$day16"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:if>
    <xsl:if test="$count &lt; $max">
        <xsl:call-template name="day17"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day16])"/></xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="day17">
    <xsl:param name="count"/>
    <xsl:if test="descendant::date = $day17">
        <h4><xsl:value-of select="$dow3"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
            <xsl:value-of select="substring-before(substring-after($day17, '-'), '-')"/></h4>
        <xsl:apply-templates select="system-index-block">
            <xsl:with-param name="target_day">
                <xsl:value-of select="$day17"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:if>
    <xsl:if test="$count &lt; $max">
        <xsl:call-template name="day18"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day17])"/></xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="day18">
    <xsl:param name="count"/>
    <xsl:if test="descendant::date = $day18">
        <h4><xsl:value-of select="$dow4"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
            <xsl:value-of select="substring-before(substring-after($day18, '-'), '-')"/></h4>
        <xsl:apply-templates select="system-index-block">
            <xsl:with-param name="target_day">
                <xsl:value-of select="$day18"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:if>
    <xsl:if test="$count &lt; $max">
        <xsl:call-template name="day19"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day18])"/></xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="day19">
    <xsl:param name="count"/>
    <xsl:if test="descendant::date = $day19">
        <h4><xsl:value-of select="$dow5"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
            <xsl:value-of select="substring-before(substring-after($day19, '-'), '-')"/></h4>
        <xsl:apply-templates select="system-index-block">
            <xsl:with-param name="target_day">
                <xsl:value-of select="$day19"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:if>
    <xsl:if test="$count &lt; $max">
        <xsl:call-template name="day20"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day19])"/></xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="day20">
    <xsl:param name="count"/>
    <xsl:if test="descendant::date = $day20">
        <h4><xsl:value-of select="$dow6"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
            <xsl:value-of select="substring-before(substring-after($day20, '-'), '-')"/></h4>
        <xsl:apply-templates select="system-index-block">
            <xsl:with-param name="target_day">
                <xsl:value-of select="$day20"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:if>
    <xsl:if test="$count &lt; $max">
        <xsl:call-template name="day21"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day20])"/></xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="day21">
    <xsl:param name="count"/>
    <xsl:if test="descendant::date = $day21">
        <h4><xsl:value-of select="$dow7"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
            <xsl:value-of select="substring-before(substring-after($day21, '-'), '-')"/></h4>
        <xsl:apply-templates select="system-index-block">
            <xsl:with-param name="target_day">
                <xsl:value-of select="$day21"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:if>
    <xsl:if test="$count &lt; $max">
        <xsl:call-template name="day22"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day21])"/></xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="day22">
    <xsl:param name="count"/>
    <xsl:if test="descendant::date = $day22">
        <h4><xsl:value-of select="$dow"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
            <xsl:value-of select="substring-before(substring-after($day22, '-'), '-')"/></h4>
        <xsl:apply-templates select="system-index-block">
            <xsl:with-param name="target_day">
                <xsl:value-of select="$day22"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:if>
    <xsl:if test="$count &lt; $max">
        <xsl:call-template name="day23"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day22])"/></xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="day23">
    <xsl:param name="count"/>
    <xsl:if test="descendant::date = $day23">
        <h4><xsl:value-of select="$dow2"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
            <xsl:value-of select="substring-before(substring-after($day23, '-'), '-')"/></h4>
        <xsl:apply-templates select="system-index-block">
            <xsl:with-param name="target_day">
                <xsl:value-of select="$day23"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:if>
    <xsl:if test="$count &lt; $max">
        <xsl:call-template name="day24"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day23])"/></xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="day24">
    <xsl:param name="count"/>
    <xsl:if test="descendant::date = $day24">
        <h4><xsl:value-of select="$dow3"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
            <xsl:value-of select="substring-before(substring-after($day24, '-'), '-')"/></h4>
        <xsl:apply-templates select="system-index-block">
            <xsl:with-param name="target_day">
                <xsl:value-of select="$day24"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:if>
    <xsl:if test="$count &lt; $max">
        <xsl:call-template name="day25"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day24])"/></xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="day25">
    <xsl:param name="count"/>
    <xsl:if test="descendant::date = $day25">
        <h4><xsl:value-of select="$dow4"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
            <xsl:value-of select="substring-before(substring-after($day25, '-'), '-')"/></h4>
        <xsl:apply-templates select="system-index-block">
            <xsl:with-param name="target_day">
                <xsl:value-of select="$day25"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:if>
    <xsl:if test="$count &lt; $max">
        <xsl:call-template name="day26"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day25])"/></xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="day26">
    <xsl:param name="count"/>
    <xsl:if test="descendant::date = $day26">
        <h4><xsl:value-of select="$dow5"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
            <xsl:value-of select="substring-before(substring-after($day26, '-'), '-')"/></h4>
        <xsl:apply-templates select="system-index-block">
            <xsl:with-param name="target_day">
                <xsl:value-of select="$day26"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:if>
    <xsl:if test="$count &lt; $max">
        <xsl:call-template name="day27"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day26])"/></xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="day27">
    <xsl:param name="count"/>
    <xsl:if test="descendant::date = $day27">
        <h4><xsl:value-of select="$dow6"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
            <xsl:value-of select="substring-before(substring-after($day27, '-'), '-')"/></h4>
        <xsl:apply-templates select="system-index-block">
            <xsl:with-param name="target_day">
                <xsl:value-of select="$day27"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:if>
    <xsl:if test="$count &lt; $max">
        <xsl:call-template name="day28"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day27])"/></xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="day28">
    <xsl:param name="count"/>
    <xsl:if test="descendant::date = $day28">
        <h4><xsl:value-of select="$dow7"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
            <xsl:value-of select="substring-before(substring-after($day28, '-'), '-')"/></h4>
        <xsl:apply-templates select="system-index-block">
            <xsl:with-param name="target_day">
                <xsl:value-of select="$day28"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:if>
    <xsl:if test="$count &lt; $max">
        <xsl:call-template name="day29"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day28])"/></xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="day29">
    <xsl:param name="count"/>
    <xsl:if test="descendant::date = $day29">
        <h4><xsl:value-of select="$dow"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
            <xsl:value-of select="substring-before(substring-after($day29, '-'), '-')"/></h4>
        <xsl:apply-templates select="system-index-block">
            <xsl:with-param name="target_day">
                <xsl:value-of select="$day29"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:if>
    <xsl:if test="$count &lt; $max">
        <xsl:call-template name="day30"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day29])"/></xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="day30">
    <xsl:param name="count"/>
    <xsl:if test="descendant::date = $day30">
        <h4><xsl:value-of select="$dow2"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
            <xsl:value-of select="substring-before(substring-after($day30, '-'), '-')"/></h4>
        <xsl:apply-templates select="system-index-block">
            <xsl:with-param name="target_day">
                <xsl:value-of select="$day30"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:if>
    <xsl:if test="$count &lt; $max">
        <xsl:call-template name="day31"><xsl:with-param name="count" select="$count + count(descendant::DateTime[date = $day30])"/></xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="day31">
    <xsl:param name="count"/>
    <xsl:if test="descendant::date = $day31">
        <h4><xsl:value-of select="$dow2"/>, <xsl:value-of select="$month_text"/><![CDATA[. ]]>
            <xsl:value-of select="substring-before(substring-after($day31, '-'), '-')"/></h4>
        <xsl:apply-templates select="system-index-block">
            <xsl:with-param name="target_day">
                <xsl:value-of select="$day31"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:if>
       <xsl:if test="$count = 0">
           <p>No more events for <xsl:value-of select="$month_text"/>.</p>
    </xsl:if>
</xsl:template>

    <!-- This template sets the parameters and calls the Event-Group Template -->

    <xsl:template match="system-index-block">
        <xsl:param name="target_day"/>

        <xsl:for-each select="descendant::DateTime/date">
            <xsl:sort data-type="text" order="ascending" select="../am-pm"/>
            <xsl:sort data-type="text" order="ascending" select="../hour"/>
            <xsl:sort data-type="text" order="ascending" select="../minute"/>
            <xsl:if test="contains(.,$target_day)">
                <div class="vevent">
                    <xsl:value-of select="../hour"/><![CDATA[   ]]>
                    <xsl:value-of select="../minute"/><![CDATA[   ]]>
                    <xsl:value-of select="../am-pm"/><![CDATA[ - ]]>
                    <a data-toggle="modal"><xsl:attribute name="href">#details_<xsl:value-of select="ancestor-or-self::system-page/@id"/>_<xsl:value-of select="position()"/></xsl:attribute>
                        <xsl:value-of select="ancestor::Event/Event_Name"/>
                    </a>
                </div>
                <xsl:call-template name="modal"> <xsl:with-param name="count"><xsl:value-of select="position()"/></xsl:with-param></xsl:call-template>
            </xsl:if>
        </xsl:for-each>

    </xsl:template>


    <xsl:template name="modal">
        <xsl:param name="count"/>
        <div aria-hidden="true" aria-labelledby="myModalLabel" class="modal hide fade" role="dialog" tabindex="-1"><xsl:attribute name="id">details_<xsl:value-of select="ancestor-or-self::system-page/@id"/>_<xsl:value-of select="$count"/></xsl:attribute>
            <div class="modal-header">
                <button aria-hidden="true" class="close" data-dismiss="modal" type="button">X</button>
                <h3><xsl:value-of select="ancestor::Event/Event_Name"/></h3>
            </div>
            <div class="modal-body">
                <xsl:choose>
                    <xsl:when test="string(ancestor::Event/Description)">
                        <div>
                            <xsl:choose>
                                <xsl:when test="ancestor::Event/image/path">
                                    <xsl:choose>
                                        <xsl:when test="ancestor::Event/image/path ! = '/'">
                                            <img class="imageFloatRight disappear" width="25%">
                                                <xsl:attribute name="src">
                                                    <xsl:value-of select="normalize-space(ancestor::Event/image/path)"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="alt"><xsl:value-of select="ancestor::Event/Sponsor"/></xsl:attribute>
                                            </img>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:value-of select="ancestor::Event/Description"/>
                        </div>
                    </xsl:when>
                </xsl:choose>

                <xsl:if test="ancestor::Event/Sponsor[text()]">
                    <div class="row-fluid">
                        <div class="span3">Sponsor:</div>
                        <div class="span9">
                            <xsl:value-of select="ancestor::Event/Sponsor"/>
                        </div>
                    </div>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="ancestor::Event/locationSelect = 'Sitka Campus'"/>
                    <xsl:when test="string(ancestor::Event/locationSelect)">
                        <div class="row-fluid">
                            <div class="span3">Campus:</div>
                            <div class="span8 location">
                                <xsl:value-of select="substring-before(ancestor::Event/locationSelect, ':')"/>
                            </div>
                        </div>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>

                <xsl:if test="ancestor::Event/Cost[text()]">
                    <xsl:choose>
                        <xsl:when test="ancestor::Event/Cost = 'N/A'"/>
                        <xsl:when test="ancestor::Event/Cost = '0'"/>
                        <xsl:otherwise>
                            <div class="row-fluid">
                                <div class="span3">Cost:</div>
                                <div class="span9">
                                    <xsl:value-of select="ancestor::Event/Cost"/>
                                </div>
                            </div>
                        </xsl:otherwise>
                    </xsl:choose>

                </xsl:if>
                <xsl:if test="ancestor::Event/Phone[text()]">
                    <div class="row-fluid">
                        <div class="span3">Phone:</div>
                        <div class="span9 tel">
                            <a target="_self">
                                <xsl:attribute name="href">tel:<xsl:value-of select="ancestor::Event/Phone"/></xsl:attribute>
                                <xsl:value-of select="ancestor::Event/Phone"/>
                            </a>
                        </div>
                    </div>
                </xsl:if>
                <xsl:if test="ancestor::Event/Email[text()]">
                    <div class="row-fluid">
                        <div class="span3">Email:</div>
                        <div class="span9 email">
                            <a>
                                <xsl:attribute name="href">mailto:<xsl:value-of select="ancestor::Event/Email"/></xsl:attribute>
                                <xsl:value-of select="ancestor::Event/Email"/>
                            </a>
                        </div>
                    </div>
                </xsl:if>
                <xsl:if test="ancestor::Event/URL[text()]">
                    <div class="row-fluid">
                        <div class="span3">Website:</div>
                        <div class="span8 url">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="ancestor::Event/URL"/>
                                </xsl:attribute>
                                <xsl:value-of select="ancestor::Event/URL"/>
                            </a>
                        </div>
                    </div>
                </xsl:if>
                <xsl:if test="count(ancestor::Event/DateTime/date) &gt; 1">
                    <div class="row-fluid">
                        <div class="span3">Dates</div>
                        <div class="span9">


                            <ul>
                                <xsl:for-each select="ancestor::Event/DateTime/date">
                                    <xsl:sort select="substring-after(substring-after(., '-'),'-')"/>
                                    <xsl:sort select="substring-before(., '-')"/>
                                    <xsl:sort select="substring-before(substring-after(., '-'),'-')"/>
                                    <li>
                                        <xsl:choose>
                                            <xsl:when test="substring-before(., '-') ='01'">January</xsl:when>
                                            <xsl:when test="substring-before(., '-') ='1'">January</xsl:when>
                                            <xsl:when test="substring-before(., '-') ='02'">February</xsl:when>
                                            <xsl:when test="substring-before(., '-') ='2'">February</xsl:when>
                                            <xsl:when test="substring-before(., '-') ='03'">March</xsl:when>
                                            <xsl:when test="substring-before(., '-') ='3'">March</xsl:when>
                                            <xsl:when test="substring-before(., '-') ='04'">April</xsl:when>
                                            <xsl:when test="substring-before(., '-') ='4'">April</xsl:when>
                                            <xsl:when test="substring-before(., '-') ='05'">May</xsl:when>
                                            <xsl:when test="substring-before(., '-') ='5'">May</xsl:when>
                                            <xsl:when test="substring-before(., '-') ='06'">June</xsl:when>
                                            <xsl:when test="substring-before(., '-') ='6'">June</xsl:when>
                                            <xsl:when test="substring-before(., '-') ='07'">July</xsl:when>
                                            <xsl:when test="substring-before(., '-') ='7'">July</xsl:when>
                                            <xsl:when test="substring-before(., '-') ='08'">August</xsl:when>
                                            <xsl:when test="substring-before(., '-') ='8'">August</xsl:when>
                                            <xsl:when test="substring-before(., '-') ='09'">September</xsl:when>
                                            <xsl:when test="substring-before(., '-') ='9'">September</xsl:when>
                                            <xsl:when test="substring-before(., '-') ='10'">October</xsl:when>
                                            <xsl:when test="substring-before(., '-') ='11'">November</xsl:when>
                                            <xsl:when test="substring-before(., '-') ='12'">December</xsl:when>
                                        </xsl:choose><xsl:text disable-output-escaping="yes">&#160;</xsl:text>
                                        <xsl:value-of select="substring-before(substring-after(., '-'),'-')"/>,<xsl:text disable-output-escaping="yes">&#160;</xsl:text><xsl:value-of select="substring-after(substring-after(., '-'),'-')"/>,<xsl:text disable-output-escaping="yes">&#160;</xsl:text><xsl:value-of select="../Day_of_Week"/>
                                        <xsl:text disable-output-escaping="yes">&#160;</xsl:text><xsl:value-of select="../hour"/><xsl:value-of select="../minute"/>
                                        <xsl:text disable-output-escaping="yes">&#160;</xsl:text>
                                        <xsl:value-of select="../am-pm"/>
                                        <xsl:if test="../End_Time[text()]"><xsl:text disable-output-escaping="yes">&#160;</xsl:text>until
                                            <xsl:value-of select="../End_Time"/></xsl:if>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </div>
                    </div>
                </xsl:if>
            </div>
            <div class="modal-footer">
                <a aria-hidden="true" class="close" data-dismiss="modal">Close</a>

            </div>
        </div>
    </xsl:template>


    <xalan:component functions="convertDate" prefix="date-converter">
        <xalan:script lang="javascript">function convertDate(date)
            {
            var d = new Date(date);
            // Splits date into components
            var temp = d.toString().split(' ');
            var month = temp[1];
            var day = temp[2];
            var year = temp[3];

            if (month == "Jan") {month=01};
            if (month == "Feb") {month=02};
            if (month == "Mar") {month=03};
            if (month == "Apr") {month=04};
            if (month == "May") {month=05};
            if (month == "Jun") {month=06};
            if (month == "Jul") {month=07};
            if (month == "Aug") {month=08};
            if (month == "Sep") {month=09};
            if (month == "Oct") {month=10};
            if (month == "Nov") {month=11};
            if (month == "Dec") {month=12};

            var retString = month + '-' + day + '-' + year;

            return retString;
            }</xalan:script>
    </xalan:component>
</xsl:stylesheet>
