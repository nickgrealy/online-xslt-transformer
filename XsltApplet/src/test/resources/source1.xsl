<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>
<xsl:output method='xml' version='1.0' encoding='utf-8' indent='yes'/>
  <xsl:template match='/'>
<x><xsl:value-of select='//b' /></x>
</xsl:template>
</xsl:stylesheet>