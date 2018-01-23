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

	<xsl:template match="OriginDestinationList">
		<OriginDestinationList>
			<xsl:for-each select="//FlightList/Flight">
				<xsl:if
					test="SegmentReferences[not (@OnPoint = preceding::SegmentReferences/@OnPoint)]">
					<xsl:if
						test="SegmentReferences[not (@OffPoint = preceding::SegmentReferences/@OffPoint)]">
						<OriginDestination refs="EK">
							<xsl:attribute name="OriginDestinationKey">
                <xsl:text>OD</xsl:text>
                <xsl:value-of select="position()" />
              </xsl:attribute>
							<xsl:attribute name="refs">
                <xsl:value-of select="@AirlineRef" />
              </xsl:attribute>
							<xsl:variable name="onPoint" select="SegmentReferences/@OnPoint" />
							<xsl:variable name="offPoint" select="SegmentReferences/@OffPoint" />
							<DepartureCode>
								<xsl:value-of select="$onPoint"></xsl:value-of>
							</DepartureCode>
							<ArrivalCode>
								<xsl:value-of select="$offPoint"></xsl:value-of>
							</ArrivalCode>
							<FlightReferences>
								<xsl:attribute name="OnPoint">
                  <xsl:value-of select="$onPoint" />
                </xsl:attribute>
								<xsl:attribute name="OffPoint">
                  <xsl:value-of select="$offPoint" />
                </xsl:attribute>
								<xsl:for-each
									select="//FlightList/Flight/SegmentReferences[@OnPoint = $onPoint][@OffPoint = $offPoint]">
									<!--[@OnPoint = $onPoint and @OffPoint = $offPoint]"> -->
									<!--<xsl:if test="@OnPoint = $onPoint and @OffPoint = $offPoint"> -->
									<xsl:value-of select="../@FlightKey" />
									<xsl:if test="position() != last()">
										<xsl:text> </xsl:text>
									</xsl:if>
									<!--</xsl:if> -->
								</xsl:for-each>
								<!--<xsl:for-each select="//FlightList/Flight/SegmentReferences"> 
									<xsl:text>a</xsl:text> <xsl:value-of select="../@FlightKey"/> <xsl:if test="position() 
									!= last()"> <xsl:text> </xsl:text> </xsl:if> </xsl:for-each> -->
							</FlightReferences>
						</OriginDestination>
					</xsl:if>
				</xsl:if>
			</xsl:for-each>
		</OriginDestinationList>
	</xsl:template>

	<xsl:template match="*/text()[normalize-space()]">
		<xsl:value-of select="normalize-space()" />
	</xsl:template>

	<xsl:template match="*/text()[not(normalize-space())]" />
</xsl:stylesheet>