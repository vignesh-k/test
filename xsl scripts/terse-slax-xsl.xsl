<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:junos="http://xml.juniper.net/junos/*/junos" xmlns:xnm="http://xml.juniper.net/xnm/1.1
/xnm" xmlns:jcs="http://xml.juniper.net/junos/commit-scripts/1.0" version="1.0">
  <xsl:import href="../import/junos.xsl"/>

<!--BoilerPlate included in every op script -->

  <xsl:variable name="arguments"> <!-- Declaring variable named arguments with 2 arguments protocol and interface -->
    <argument>
      <name>interface</name>
      <description>Name of interface to display</description>
    </argument>
    <argument>
      <name>protocol</name>
      <description>Protocol to display (inet, inet6)</description>
    </argument>
  </xsl:variable>

  <xsl:param name="interface"/> <!-- Parameter name should match argument name -->
  <xsl:param name="protocol"/>

  <xsl:template match="/"> <!-- Boiler Plate-->

    <op-script-results>
      <xsl:variable name="rpc">
        <get-interface-information>
          <terse/>
          <xsl:if test="$interface">
            <interface-name>
              <xsl:value-of select="$interface"/>
            </interface-name>
          </xsl:if>
        </get-interface-information>
      </xsl:variable>
      <xsl:variable name="out" select="jcs:invoke($rpc)"/>
      <interface-information junos:style="terse">
        <xsl:choose>
          <xsl:when test="$protocol = &quot;inet&quot; or $protocol = &quot;inet6&quot; or $protocol = &quot;mpls&quot; or $protocol = &quot;tnp&quot;">
            <xsl:for-each select="$out/physical-interface/logical-interface[address-family/address-family-name = $protocol]">
              <xsl:call-template name="intf"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="$protocol">
            <xnm:error>
              <message>
                <xsl:text>invalid protocol: </xsl:text>
                <xsl:value-of select="$protocol"/>
              </message>
            </xnm:error>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="$out/physical-interface/logical-interface">
              <xsl:call-template name="intf"/>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </interface-information>
    </op-script-results>
  </xsl:template>    <!--Boiler Plate-->
  <xsl:template name="intf">
    <xsl:variable name="status">
      <xsl:choose>
        <xsl:when test="admin-status = &quot;up&quot; and oper-status = &quot;up&quot;"/>
        <xsl:when test="admin-status = &quot;down&quot;">
          <xsl:text>offline</xsl:text>
        </xsl:when>
        <xsl:when test="oper-status = &quot;down&quot; and ../admin-status = &quot;down&quot;">
          <xsl:text>p-offline</xsl:text>
        </xsl:when>
        <xsl:when test="oper-status = &quot;down&quot; and ../oper-status = &quot;down&quot;">
          <xsl:text>p-down</xsl:text>
        </xsl:when>
        <xsl:when test="oper-status = &quot;down&quot;">
          <xsl:text>down</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(oper-status, &quot;/&quot;, admin-status)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="desc">
      <xsl:choose>
        <xsl:when test="description">
          <xsl:value-of select="description"/>
        </xsl:when>
        <xsl:when test="../description">
          <xsl:value-of select="../description"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <logical-interface>
      <name>
        <xsl:value-of select="name"/>
      </name>
      <xsl:if test="string-length($desc)">
        <admin-status>
          <xsl:value-of select="$desc"/>
        </admin-status>
      </xsl:if>
      <admin-status>
        <xsl:value-of select="$status"/>
      </admin-status>
      <xsl:choose>
        <xsl:when test="$protocol">
          <xsl:copy-of select="address-family[address-family-name = $protocol]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="address-family"/>
        </xsl:otherwise>
      </xsl:choose>
    </logical-interface>
  </xsl:template>
</xsl:stylesheet> <!-- Boiler Plate-->

