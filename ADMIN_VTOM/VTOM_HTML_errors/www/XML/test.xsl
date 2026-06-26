<?xml version="1.0" encoding="ISO-8859-1"?>
<html xmlns:xsl="http://www.w3.org/TR/WD-xsl">
<body style="font-family:Arial; font-size:12pt;">
<xsl:for-each select="racine/enfant">
<div style="background-color:teal; color:white;">
<span style="font-weight:bold; color:white; padding:4px">
<xsl:value-of select="nom"/></SPAN>
- <xsl:value-of select="lien"/>
</div>
<div style="margin-left:20px; font-size:10pt">
<span> Anniversaire le <xsl:value-of select="date"/>
</span>
<span style="font-style:italic"> - <xsl:value-of select="data"/>
</span>
</div>
</xsl:for-each>
</body>
</html>