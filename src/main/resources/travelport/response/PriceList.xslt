<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	exclude-result-prefixes="msxsl" xmlns:exsl="http://exslt.org/common">
	<xsl:output method="xml" indent="yes" />

	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="PriceClassList">
		<PriceClassList>
			<PriceClass PriceClassID="Economy">
				<Name>Economy</Name>
				<Code>3</Code>
				<Descriptions>
					<Description>
						<xsl:for-each select="//OriginDestinationList/OriginDestination">
							<OriginDestinationReference>
								<xsl:value-of select="@OriginDestinationKey" />
							</OriginDestinationReference>
						</xsl:for-each>
					</Description>
				</Descriptions>
				<DisplayOrder>3</DisplayOrder>
			</PriceClass>
		</PriceClassList>
	</xsl:template>

	<xsl:template match="*/text()[normalize-space()]">
		<xsl:value-of select="normalize-space()" />
	</xsl:template>

	<xsl:template match="*/text()[not(normalize-space())]" />
</xsl:stylesheet>