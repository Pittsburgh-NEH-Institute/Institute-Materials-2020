<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns="http://purl.oclc.org/dsdl/schematron">
    <pattern>
        <rule context="slot">
            <let name="actual_time" value="sum(act/@time/number())"/>
            <!-- warning, rather than error, because extra sessions (e.g., add-on evening ones) might have different durations -->
            <assert test="$actual_time eq 30 or $actual_time eq 90" role="warn"> The sum of the
                activity durations must be equal either 30 or 90 minutes. Actual time is <value-of
                    select="$actual_time"/>.</assert>
            <!-- slot times must be later than preceding slot times -->
            <report test="@time &lt;= preceding-sibling::slot/@time"> Activity time slots must be
                later than preceding time slots. </report>
        </rule>
        <rule context="act[not(preceding-sibling::title = ('Coffee break', 'Lunch'))]">
            <assert test="@type">Activities must have a @type attribute.</assert>
            <assert test="instructors">Activities must specify instructors</assert>
        </rule>
        <rule context="desc[not(list) and not(. = ('Lunch', 'Coffee break'))] | goal">
            <assert test="matches(., '[.?!]$')"><value-of select="name(.)"/> must end in final
                punctuation.</assert>
        </rule>
        <rule context="date">
            <report test="empty(.)">Eek! There’s no date!</report>
        </rule>
        <rule context="instructors">
            <assert test="count(instructor) eq count(distinct-values(instructor))">Instructor is
                listed more than once: <value-of select="."/></assert>
        </rule>
        <rule context="title">
            <report test="matches(., '\n')">Newlines not allowed inside &lt;<value-of
                    select="name(.)"/>&gt; elements</report>
        </rule>
    </pattern>
</sch:schema>
