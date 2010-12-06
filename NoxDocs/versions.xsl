<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html"/>

<xsl:template match="changelog">
  <html>
    <head>
      <title>
        <xsl:value-of select="project"/>
        <xsl:text> - </xsl:text>
        <xsl:value-of select="topic"/>
      </title>
    </head>
    <body>
      <h1><xsl:value-of select="project"/></h1>
      <h2><xsl:value-of select="topic"/></h2>
      <xsl:apply-templates select="version"/>
    </body>
  </html>
</xsl:template>

<xsl:template match="version">
  <h3>
    <xsl:text>Version </xsl:text>
    <xsl:value-of select="@number"/>
    <xsl:text> by </xsl:text>
    <xsl:value-of select="@author"/>
    <xsl:text> on </xsl:text>
    <xsl:value-of select="@date"/>
  </h3>
  <ul>
    <xsl:apply-templates select="change"/>
  </ul>
</xsl:template>

<xsl:template match="change">
  <li>
    <xsl:apply-templates/>
  </li>
</xsl:template>

<xsl:template match="param-list">
  <p>
    <table>
      <xsl:apply-templates/>
    </table>
  </p>
</xsl:template>

<xsl:template match="param">
  <tr>
    <td width="150">
      <xsl:value-of select="@name"/>
    </td>
    <td>
      <xsl:apply-templates/>
    </td>
  </tr>
</xsl:template>

<xsl:template match="node()">
  <xsl:copy>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="text()">
  <xsl:value-of select="."/>
</xsl:template>

</xsl:stylesheet>
