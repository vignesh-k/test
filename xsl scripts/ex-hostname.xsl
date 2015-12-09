<?xml version="1.0" standalone="yes"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:junos="http://xml.juniper.net/junos/*/junos"
xmlns:xnm="http://xml.juniper.net/xnm/1.1/xnm"
xmlns:jcs="http://xml.juniper.net/junos/commit-scripts/1.0">
<xsl:import href="../import/junos.xsl"/>
<xsl:variable name="arguments">
<argument>
<name></name>
<description></description>
</argument>
</xsl:variable>
<xsl:param name="dns"/>
<xsl:template match="/">
<op-script-results>
<xsl:variable name="query">
<xsl:choose>
<xsl:when test="$dns">
<command>
<xsl:value-of select="concat('show host ', $dns)"/>
</command>
</xsl:when>
<xsl:when test="$hostname">
<command>
<xsl:value-of select="concat('show host ', $hostname)"/>
</command>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="result" select="jcs:invoke($query)"/>
<xsl:variable name="host" select="$result"/>
<output>
<xsl:value-of select="concat('Name: ', $host)"/>
</output>
</op-script-results>
</xsl:template>
</xsl:stylesheet>
