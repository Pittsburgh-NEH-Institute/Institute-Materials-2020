<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="text" omit-xml-declaration="yes"/>
    <!-- ================================================================ -->
    <!-- Stylesheet variables                                             -->
    <!-- ================================================================ -->
    <xsl:variable name="root" as="document-node()" select="/"/>
    <!-- ================================================================ -->
    <!-- User-defined functions                                           -->
    <!-- ================================================================ -->
    <xsl:function name="djb:timeRange" as="xs:string">
        <!-- ============================================================ -->
        <!-- timeRange()                                                  -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $startTime as xs:time                                      -->
        <!--   $duration as xs:double                                     -->
        <!--                                                              -->
        <!-- Returns: hyphenated time range as xs:string                  -->
        <!-- ============================================================ -->
        <xsl:param name="startTime" as="xs:time"/>
        <xsl:param name="duration" as="xs:double"/>
        <xsl:variable name="end-time" as="xs:string" select="
                format-time($startTime + xs:duration(xs:dayTimeDuration(concat('PT', $duration, 'M'))), '[h]:[m01]')
                "/>
        <xsl:sequence select="format-time($startTime, '[h]:[m01]') || '–' || $end-time"/>
    </xsl:function>
    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->
    <xsl:template match="/">
        <!-- ============================================================ -->
        <!-- Create weekly and then daily schedules for publication       -->
        <!-- ============================================================ -->
        <xsl:apply-templates select="//week"/>
        <xsl:apply-templates select="//week" mode="daily"/>
        <!-- ============================================================ -->
        <!-- Create daily (no weekly) schedules with instructor names     -->
        <!-- Create separate schedules for each instructor                -->
        <!--   (musician’s view, mode instructor_individual)              -->
        <!-- ============================================================ -->
        <xsl:apply-templates select="//week" mode="instructor_daily"/>
        <xsl:for-each select="distinct-values(//instructor)">
            <xsl:apply-templates select="$root" mode="instructor_individual">
                <xsl:with-param name="instructor" tunnel="yes" select="."/>
            </xsl:apply-templates>
        </xsl:for-each>
    </xsl:template>
    <!-- ================================================================ -->
    <!-- =                                                              = -->
    <!-- Templates for weekly plans (for publication)                     -->
    <!-- =                                                              = -->
    <!-- ================================================================ -->
    <xsl:template match="week">
        <xsl:variable name="time_slots" select="distinct-values(descendant::slot/@time)"
            as="xs:string+"/>
        <xsl:variable name="currentWeek" select="." as="element(week)"/>
        <xsl:variable name="filename" as="xs:string"
            select="'week_' || @num || '/week_' || @num || '_plan.md'"/>
        <xsl:result-document method="text" omit-xml-declaration="yes" href="{$filename}">
            <xsl:value-of select="'# Week ' || @num || ' plan: ' || ./title || '&#x0a;' || '&#x0a;'"/>
            <xsl:text>Time | </xsl:text>
            <xsl:apply-templates select="day"/>
            <xsl:text>&#x0a;----</xsl:text>
            <xsl:for-each select="day">
                <xsl:text> | ----</xsl:text>
            </xsl:for-each>
            <xsl:text>&#x0a;</xsl:text>
            <xsl:for-each select="$time_slots">
                <xsl:variable name="currentSlot" select="current()" as="xs:string"/>
                <xsl:variable name="slotContents" as="xs:string+">
                    <xsl:for-each select="$currentWeek/day">
                        <xsl:if test="current()/slot/@time = $currentSlot">
                            <xsl:value-of select="current()/slot[@time = $currentSlot]/title"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="timeFunction">
                    <xsl:value-of select="
                            djb:timeRange(xs:time($currentSlot), max(for $day in $currentWeek/day
                            return
                                sum($day/slot[@time = $currentSlot]/act/@time)))"/>
                    <!-- sending the duration to function by finding max of sum of the day where the slot in which the current time is the same as the slot's time, then drilling down to the act to get time to sum -->
                </xsl:variable>
                <!--<xsl:message select="sum($currentWeek/act/@time)"/>-->
                <xsl:sequence
                    select="$timeFunction, ' | ', string-join($slotContents, ' | '), '&#x0a;'"/>
            </xsl:for-each>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="day">
        <xsl:variable name="linkname" as="xs:string"
            select="'week_' || ../@num || '_day_' || position() || '_plan.md'"/>
        <xsl:variable name="daynames" as="xs:string"
            select="normalize-space(concat(' [', @d, '](', $linkname, ')', ' | '))"/>
        <xsl:value-of select="$daynames"/>
    </xsl:template>
    <!-- ================================================================ -->
    <!-- =                                                              = -->
    <!--  Templates for daily plans (for publication)                     -->
    <!-- =                                                              = -->
    <!-- ================================================================ -->
    <xsl:template match="week" mode="daily">
        <xsl:apply-templates mode="daily" select="day"/>
    </xsl:template>
    <xsl:template match="day" mode="daily">
        <xsl:variable name="filename" as="xs:string"
            select="'week_' || ../@num || '/week_' || ../@num || '_day_' || position() || '_plan.md'"/>
        <xsl:variable name="feedbackname" as="xs:string"
            select="'week_' || ../@num || '_day_' || position() || '_feedback.md'"/>
        <xsl:result-document method="text" omit-xml-declaration="yes" href="{$filename}">
            <xsl:value-of
                select="'# Week ' || ../@num || ', Day ' || position() || ': ' || @d || ', ' || date || '&#x0a;'"/>

            <!-- synopsis -->
            <xsl:text>## Synopsis&#x0a;</xsl:text>
            <xsl:apply-templates select="syn" mode="daily"/>
            <!-- outcome goals -->
            <xsl:text>## Outcome goals&#x0a;</xsl:text>
            <xsl:apply-templates select="./slot//goal" mode="daily"/>
            <!-- legend -->
            <xsl:text>&#x0a;## Legend

* **Presentation:** by instructors
* **Discussion:** instructors and participants
* **Talk lab:** participants discuss or plan in small groups
* **Code lab:** participants code alone or in small groups&#x0a;&#x0a;* * *&#x0a;</xsl:text>

            <!-- tables for slots -->
            <xsl:apply-templates select="slot" mode="daily"/>
            <!-- feedback -->
            <xsl:text>We’ll end each day with a request for feedback, based on a general version of the day’s outcome goals, and we’ll try to adapt on the fly to your responses. You can fill out a feedback form at [insert URL here]</xsl:text>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="syn" mode="daily">
        <xsl:text>&#x0a;</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&#x0a;&#x0a;</xsl:text>
    </xsl:template>
    <!-- ================================================================ -->
    <!-- Create and styles time headers                                   -->
    <!-- ================================================================ -->
    <xsl:template match="slot" mode="daily">
        <xsl:value-of
            select="'## ' || djb:timeRange(@time, sum(act/@time)) || ': ' || title || '&#x0a;&#x0a;'"/>
        <xsl:if test="desc">
            <xsl:value-of select="desc, '&#x0a;&#x0a;'"/>
        </xsl:if>
        <xsl:if test="not(title = ('Coffee break', 'Lunch'))">
            <xsl:text>Time | Topic | Type&#x0a;</xsl:text>
            <xsl:text>---- | ---- | ---- &#x0a;</xsl:text>
            <xsl:apply-templates select="act" mode="daily"/>
            <xsl:text>&#x0a;</xsl:text>
        </xsl:if>
    </xsl:template>
    <!-- ================================================================ -->
    <!-- Create activity times in table                                   -->
    <!-- ================================================================ -->
    <xsl:template match="act" mode="daily">
        <xsl:value-of
            select="@time || ' min | ' || normalize-space(desc) || ' | ' || translate(@type, '_', ' ') || '&#x0a;'"
        />
    </xsl:template>
    <!-- ================================================================ -->
    <!-- Create list of goals                                             -->
    <!-- ================================================================ -->
    <xsl:template match="goal" mode="daily">
        <xsl:text>* </xsl:text>
        <xsl:apply-templates select="normalize-space(.)"/>
        <xsl:text>&#x0a;</xsl:text>
    </xsl:template>
    <!-- ================================================================ -->
    <!-- =                                                              = -->
    <!-- Templates for weekly plans with instructor names (not used)      -->
    <!-- =                                                              = -->
    <!-- ================================================================ -->
    <xsl:template match="week" mode="instructor">
        <xsl:variable name="time_slots" select="distinct-values(descendant::slot/@time)"
            as="xs:string+"/>
        <xsl:variable name="currentWeek" select="." as="element(week)"/>
        <xsl:variable name="filename" as="xs:string"
            select="'instructor/week_' || @num || '/week_' || @num || '_plan.md'"/>
        <xsl:result-document method="text" omit-xml-declaration="yes" href="{$filename}">
            <xsl:value-of select="'# Week ' || @num || ' plan: ' || ./title || '&#x0a;' || '&#x0a;'"/>
            <xsl:text>Time | </xsl:text>
            <xsl:apply-templates select="day" mode="instructor"/>
            <xsl:text>&#x0a;----</xsl:text>
            <xsl:for-each select="day">
                <xsl:text> | ----</xsl:text>
            </xsl:for-each>
            <xsl:text>&#x0a;</xsl:text>
            <xsl:for-each select="$time_slots">
                <xsl:variable name="currentSlot" select="current()" as="xs:string"/>
                <xsl:variable name="slotContents" as="xs:string+">
                    <xsl:for-each select="$currentWeek/day">
                        <xsl:if test="current()/slot/@time = $currentSlot">
                            <xsl:value-of select="current()/slot[@time = $currentSlot]/title"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="timeFunction">
                    <xsl:value-of select="
                            djb:timeRange(xs:time($currentSlot), max(for $day in $currentWeek/day
                            return
                                sum($day/slot[@time = $currentSlot]/act/@time)))"/>
                    <!-- sending the duration to function by finding max of sum of the day where the slot in which the current time is the same as the slot's time, then drilling down to the act to get time to sum -->
                </xsl:variable>
                <!--<xsl:message select="sum($currentWeek/act/@time)"/>-->
                <xsl:sequence
                    select="$timeFunction, ' | ', string-join($slotContents, ' | '), '&#x0a;'"/>
            </xsl:for-each>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="day" mode="instructor">
        <xsl:variable name="linkname" as="xs:string"
            select="'instructor/week_' || ../@num || '_day_' || position() || '_plan.md'"/>
        <xsl:variable name="daynames" as="xs:string"
            select="normalize-space(concat(' [', @d, '](', $linkname, ')', ' | '))"/>
        <xsl:value-of select="$daynames"/>
    </xsl:template>
    <!-- ================================================================ -->
    <!-- =                                                              = -->
    <!-- Templates for daily plans with instructor names                  -->
    <!-- =                                                              = -->
    <!-- ================================================================ -->
    <xsl:template match="week" mode="instructor_daily">
        <xsl:apply-templates mode="instructor_daily" select="day"/>
    </xsl:template>
    <xsl:template match="day" mode="instructor_daily">
        <xsl:variable name="filename" as="xs:string"
            select="'instructor/week_' || ../@num || '/week_' || ../@num || '_day_' || position() || '_plan.md'"/>
        <xsl:variable name="feedbackname" as="xs:string"
            select="'instructor/week_' || ../@num || '_day_' || position() || '_feedback.md'"/>
        <xsl:result-document method="text" omit-xml-declaration="yes" href="{$filename}">
            <xsl:value-of
                select="'# Week ' || ../@num || ', Day ' || position() || ': ' || @d || ', ' || date || '&#x0a;'"/>
            <xsl:text>[Link to instructor-view navigation page](../daily_instructor_view.md)&#x0a;&#x0a;</xsl:text>
            <!-- synopsis -->
            <xsl:text>## Synopsis&#x0a;</xsl:text>
            <xsl:apply-templates select="syn" mode="daily"/>
            <!-- outcome goals -->
            <xsl:text>## Outcome goals&#x0a;</xsl:text>
            <xsl:apply-templates select="./slot//goal" mode="daily"/>
            <!-- legend -->
            <xsl:text>&#x0a;## Legend

* **Presentation:** by instructors
* **Discussion:** instructors and participants
* **Talk lab:** participants discuss or plan in small groups
* **Code lab:** participants code alone or in small groups&#x0a;&#x0a;* * *&#x0a;</xsl:text>

            <!-- tables for slots -->
            <xsl:apply-templates select="slot" mode="instructor_daily"/>
            <!-- feedback -->
            <xsl:text>We’ll end each day with a request for feedback, based on a general version of the day’s outcome goals, and we’ll try to adapt on the fly to your responses. You can fill out a feedback form at [insert URL here]</xsl:text>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="syn" mode="instructor_daily">
        <xsl:text>&#x0a;</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&#x0a;&#x0a;</xsl:text>
    </xsl:template>
    <!-- ================================================================ -->
    <!-- Create and styles time headers                                   -->
    <!-- ================================================================ -->
    <xsl:template match="slot" mode="instructor_daily">
        <xsl:value-of
            select="'## ' || djb:timeRange(@time, sum(act/@time)) || ': ' || title || '&#x0a;&#x0a;'"/>
        <xsl:if test="desc">
            <xsl:value-of select="desc, '&#x0a;&#x0a;'"/>
        </xsl:if>
        <xsl:if test="repos">
            <xsl:apply-templates select="repos" mode="instructor_daily"/>
        </xsl:if>
        <xsl:if test="not(title = ('Coffee break', 'Lunch'))">
            <xsl:text>Time | Topic | Type | Instructor&#x0a;</xsl:text>
            <xsl:text>---- | ---- | ---- | ---- &#x0a;</xsl:text>
            <xsl:apply-templates select="act" mode="instructor_daily"/>
            <xsl:text>&#x0a;</xsl:text>
        </xsl:if>
    </xsl:template>
    <!-- ================================================================ -->
    <!-- Create activity times in table                                   -->
    <!-- ================================================================ -->
    <xsl:template match="act" mode="instructor_daily">
        <xsl:value-of
            select="@time || ' min | ' || normalize-space(desc) || ' | ' || translate(@type, '_', ' ') || '|' || string-join(descendant::instructor, ', ') || '&#x0a;'"
        />
    </xsl:template>
    <!-- ================================================================ -->
    <!-- Create list of goals                                             -->
    <!-- ================================================================ -->
    <xsl:template match="goal" mode="instructor_daily">
        <xsl:text>* </xsl:text>
        <xsl:apply-templates select="normalize-space(.)"/>
        <xsl:text>&#x0a;</xsl:text>
    </xsl:template>
    <!-- ================================================================ -->
    <!-- Create links to repos for project stages                         -->
    <!-- ================================================================ -->
    <xsl:template match="repos" mode="instructor_daily">
        <xsl:text>&#x0a;&#x0a;</xsl:text>
        <xsl:apply-templates select="repo" mode="instructor_daily"/>
        <xsl:text>&#x0a;&#x0a;</xsl:text>
    </xsl:template>
    <xsl:template match="repo" mode="instructor_daily">
        <xsl:value-of select="concat('[', repo-name, ']', '(', repo-link, ')', '&#x0a;')"/>
    </xsl:template>
    <!-- ================================================================ -->
    <!-- =                                                              = -->
    <!-- Templates for individual instructor (musician’s) view            -->
    <!-- =                                                              = -->
    <!-- ================================================================ -->
    <xsl:template match="/" mode="instructor_individual">
        <!-- ============================================================ -->
        <!-- Create instructor-specific document                          -->
        <!-- ============================================================ -->
        <xsl:param name="instructor" tunnel="yes" as="xs:string" required="yes"/>
        <xsl:variable name="filename" as="xs:string"
            select="'instructor/' || $instructor || '_plan.md'"/>
        <xsl:result-document method="text" omit-xml-declaration="yes" href="{$filename}">
            <xsl:value-of select="concat('# Session plan: ', $instructor, '&#x0a;&#x0a;')"/>
            <xsl:text>[Link to instructor-view navigation page](daily_instructor_view.md)&#x0a;&#x0a;</xsl:text>
            <xsl:apply-templates mode="instructor_individual"
                select="descendant::week[descendant::instructor = $instructor]"/>
        </xsl:result-document>
    </xsl:template>
    <xsl:template mode="instructor_individual" match="week">
        <!-- ============================================================ -->
        <!-- Create instructor-specific week                              -->
        <!-- ============================================================ -->
        <xsl:param name="instructor" tunnel="yes" as="xs:string" required="yes"/>
        <xsl:value-of select="concat('## Week ', @num, '&#x0a;&#x0a;')"/>
        <xsl:apply-templates mode="instructor_individual"
            select="day[descendant::instructor = $instructor]"/>
    </xsl:template>
    <xsl:template mode="instructor_individual" match="day">
        <!-- ============================================================ -->
        <!-- Create instructor-specific day                               -->
        <!-- ============================================================ -->
        <xsl:param name="instructor" tunnel="yes" as="xs:string" required="yes"/>
        <xsl:value-of select="concat('### ', @d, ', ', date, '&#x0a;&#x0a;')"/>
        <xsl:apply-templates mode="instructor_individual"
            select="descendant::slot[descendant::instructor = $instructor]"/>
    </xsl:template>
    <xsl:template match="slot" mode="instructor_individual">
        <!-- ============================================================ -->
        <!-- Create and styles time headers                               -->
        <!-- ============================================================ -->
        <xsl:value-of
            select="'#### ' || djb:timeRange(@time, sum(act/@time)) || ': ' || title || '&#x0a;&#x0a;'"/>
        <xsl:if test="desc">
            <xsl:value-of select="desc, '&#x0a;&#x0a;'"/>
        </xsl:if>
        <xsl:text>Time | Topic | Type | Instructor&#x0a;</xsl:text>
        <xsl:text>---- | ---- | ---- | ---- &#x0a;</xsl:text>
        <xsl:apply-templates select="act" mode="instructor_individual"/>
        <xsl:text>&#x0a;</xsl:text>
    </xsl:template>
    <xsl:template match="act" mode="instructor_individual">
        <xsl:param name="instructor" tunnel="yes" required="yes"/>
        <xsl:variable name="current-act" as="element(act)" select="."/>
        <!-- ============================================================ -->
        <!-- Create activity times in table                               -->
        <!-- ============================================================ -->
        <xsl:variable name="column-values" as="xs:string+"
            select="concat(@time, ' min'), normalize-space(desc), translate(@type, '_', ' '), string-join(descendant::instructor, ', ')"/>
        <xsl:for-each select="$column-values">
            <xsl:choose>
                <xsl:when test="$current-act/descendant::instructor = $instructor">
                    <xsl:value-of select="concat('**', ., '**')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="position() ne last()">
                <xsl:value-of select="' | '"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:value-of select="'&#x0a;'"/>
    </xsl:template>
</xsl:stylesheet>
