<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html"/>

<xsl:template match="user-guide">
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
      <h3>Version <xsl:value-of select="version"/></h3>
      <xsl:apply-templates select="section"/>
    </body>
  </html>
</xsl:template>

<xsl:template match="section">
  <h3>
    <xsl:value-of select="@name"/>
  </h3>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="subsection">
  <h4>
    <xsl:value-of select="@name"/>
  </h4>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="p">
  <p style="margin-left: 0.25in">
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="feature-list">
  <ul>
    <xsl:apply-templates select="feature"/>
  </ul>
</xsl:template>

<xsl:template match="feature">
  <li>
    <xsl:apply-templates/>
  </li>
</xsl:template>

<xsl:template match="addon-list">
  <table style="margin-left: 0.25in" cellspacing="0">
    <xsl:apply-templates select="addon"/>
  </table>
</xsl:template>

<xsl:template match="addon">
  <tr>
    <td style="padding: 2pt 16pt 2pt 0; vertical-align: top">
      <b>
        <xsl:value-of select="@name"/>
      </b>
    </td>
    <td style="padding: 2pt 0 2pt 0; vertical-align: top">
      <xsl:apply-templates/>
    </td>
  </tr>
</xsl:template>

<xsl:template match="slash">
  <p style="margin-left: 0.25in">
    <b><xsl:value-of select="desc"/></b>
  </p>
  <xsl:apply-templates select="command"/>
</xsl:template>

<xsl:template match="command">
  <p style="margin: 0; margin-left: 0.5in">
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="valuelist">
  <table style="margin-left: 0.5in">
    <xsl:apply-templates select="value"/>
  </table>
</xsl:template>

<xsl:template match="valuelist/value">
  <tr>
    <td style="padding-right: 8pt">
      <xsl:value-of select="@name"/>
    </td>
    <td>
      <xsl:apply-templates/>
    </td>
  </tr>
</xsl:template>

<xsl:template match="list">
  <table style="margin-left: 0.5in">
    <xsl:apply-templates select="value"/>
  </table>
</xsl:template>

<xsl:template match="list/value">
  <tr>
    <td>
      <xsl:apply-templates/>
    </td>
  </tr>
</xsl:template>

<xsl:template match="example">
  <p style="margin-left: 0.25in">
    <i>
      <xsl:value-of select="desc"/>
    </i>
  </p>
  <xsl:apply-templates select="text"/>
</xsl:template>

<xsl:template match="example/text">
  <p style="margin: 0; margin-left: 0.5in">
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="block">
  <p style="margin: 0; margin-left: 0.5in">
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="variable-list">
  <table style="margin-left: 0.5in; margin-right: 0.5in; border-collapse: collapse;" width="90%" cellspacing="0">
    <tr>
      <td style="width: 100pt"><b>Name</b></td>
      <td><b>Description</b></td>
      <td style="width: 100pt"><b>Format Type</b></td>
    </tr>
    <xsl:apply-templates select="var"/>
  </table>
</xsl:template>

<xsl:template match="var">
  <tr>
    <td style="border: 1px solid black; padding: 1px 4px">
      <xsl:value-of select="code"/>
    </td>
    <td style="border: 1px solid black; padding: 1px 4px">
      <xsl:value-of select="desc"/>
    </td>
    <td style="border: 1px solid black; padding: 1px 4px">
      <xsl:value-of select="type"/>
      <xsl:text> </xsl:text>
    </td>
  </tr>
</xsl:template>

<xsl:template match="deprecated-variables">
  <table style="margin-left: 0.5in; margin-right: 0.5in; border-collapse: collapse;" width="90%" cellspacing="0">
    <tr>
      <td style="width: 100pt"><b>Name</b></td>
      <td><b>Description</b></td>
      <td style="width: 100pt"><b>Replaced by</b></td>
    </tr>
    <xsl:apply-templates select="depvar"/>
  </table>
</xsl:template>

<xsl:template match="depvar">
  <tr>
    <td style="border: 1px solid black; padding: 1px 4px">
      <xsl:value-of select="code"/>
    </td>
    <td style="border: 1px solid black; padding: 1px 4px">
      <xsl:value-of select="desc"/>
    </td>
    <td style="border: 1px solid black; padding: 1px 4px">
      <xsl:value-of select="repl"/>
      <xsl:text> </xsl:text>
    </td>
  </tr>
</xsl:template>

<xsl:template match="format-list">
  <table style="margin-left: 0.5in; margin-right: 0.5in; border-collapse: collapse;" width="90%" cellspacing="0">
    <tr>
      <td style="width: 100pt"><b>Format</b></td>
      <td><b>Description</b></td>
      <td style="width: 100pt"><b>Example</b></td>
    </tr>
    <xsl:apply-templates select="format"/>
  </table>
</xsl:template>

<xsl:template match="format">
  <tr>
    <td style="border: 1px solid black; padding: 1px 4px">
      <xsl:value-of select="spec"/>
    </td>
    <td style="border: 1px solid black; padding: 1px 4px">
      <xsl:value-of select="desc"/>
    </td>
    <td style="border: 1px solid black; padding: 1px 4px; white-space: nowrap">
      <xsl:value-of select="example"/>
      <xsl:text> </xsl:text>
    </td>
  </tr>
</xsl:template>

<xsl:template match="equip-list">
  <table style="margin-left: 0.5in; margin-right: 0.5in; border-collapse: collapse;" cellspacing="0">
    <tr>
      <td style="width: 100pt"><b>Format</b></td>
      <td style="width: 250pt"><b>Refers to the item equipped in the slot for:</b></td>
    </tr>
    <xsl:apply-templates select="format"/>
  </table>
</xsl:template>

<xsl:template match="equip-list/format">
  <tr>
    <td style="border: 1px solid black; padding: 1px 4px">
      <xsl:value-of select="spec"/>
    </td>
    <td style="border: 1px solid black; padding: 1px 4px">
      <xsl:value-of select="desc"/>
    </td>
  </tr>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="text()">
  <xsl:value-of select="."/>
</xsl:template>

</xsl:stylesheet>
