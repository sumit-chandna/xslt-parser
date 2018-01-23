<?xml version = "1.0" encoding = "UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes" />
	<xsl:param name="tickettLoc" />
	<xsl:param name="dutCode" />
	<xsl:param name="agentCurrency" />
	<xsl:param name="agentCountry" />
	<xsl:param name="options" />
	<xsl:param name="originCityIndicator" />
	<xsl:param name="airlineOption" />
	<xsl:param name="airline" />
	<xsl:template match="AirShoppingRQ ">
		<xsl:variable name="adtCount17.2"
			select="count(DataLists/PassengerList/Passenger[PTC='ADT'])" />
		<xsl:variable name="infCount17.2"
			select="count(DataLists/PassengerList/Passenger[PTC='INF'])" />
		<xsl:variable name="chdCount17.2"
			select="count(DataLists/PassengerList/Passenger[PTC='CHD'])" />
		<xsl:variable name="adtCount"
			select="count(Travelers/Traveler/AnonymousTraveler[PTC='ADT'])" />
		<xsl:variable name="infCount"
			select="count(Travelers/Traveler/AnonymousTraveler[PTC='INF'])" />
		<xsl:variable name="chdCount"
			select="count(Travelers/Traveler/AnonymousTraveler[PTC='CHD'])" />
		<WS_PSC5A>
			<TIC_LOC>
				<xsl:value-of select="$tickettLoc" />
			</TIC_LOC>
			<DUT_COD>
				<xsl:value-of select="$dutCode" />
			</DUT_COD>
			<ISO_CUR_COD>
				<xsl:value-of select="$agentCurrency" />
			</ISO_CUR_COD>
			<ISO_CTY_SAL>
				<xsl:value-of select="$agentCountry" />
			</ISO_CTY_SAL>
			<ISO_CTY_TIC>
				<xsl:value-of select="$agentCountry" />
			</ISO_CTY_TIC>
			<xsl:for-each select="$options">
				<OPT>
					<xsl:value-of select="normalize-space()" />
				</OPT>
			</xsl:for-each>
			<POI_ORI>
				<CIT>
					<xsl:value-of
						select="CoreQuery/OriginDestinations/OriginDestination[1]/Departure/AirportCode" />
				</CIT>
				<CIT_IND>
					<xsl:value-of select="$originCityIndicator" />
				</CIT_IND>
			</POI_ORI>
			<ARL_INF>
				<ARL_OPT>
					<xsl:value-of select="$airlineOption" />
				</ARL_OPT>
				<ARL_COD>
					<xsl:value-of select="$airline" />
				</ARL_COD>
			</ARL_INF>
			<xsl:if test="$adtCount >0">
				<PTC_INF>
					<NUM_PAX>
						<xsl:value-of select="$adtCount" />
					</NUM_PAX>
					<PTC>ADT</PTC>
				</PTC_INF>
			</xsl:if>
			<xsl:if test="$chdCount >0">
				<PTC_INF>
					<NUM_PAX>
						<xsl:value-of select="$chdCount" />
					</NUM_PAX>
					<PTC>CHD</PTC>
				</PTC_INF>
			</xsl:if>
			<xsl:if test="$infCount >0">
				<PTC_INF>
					<NUM_PAX>
						<xsl:value-of select="$infCount" />
					</NUM_PAX>
					<PTC>INF</PTC>
				</PTC_INF>
			</xsl:if>
			<xsl:if test="$adtCount17.2 >0">
				<PTC_INF>
					<NUM_PAX>
						<xsl:value-of select="$adtCount17.2" />
					</NUM_PAX>
					<PTC>ADT</PTC>
				</PTC_INF>
			</xsl:if>
			<xsl:if test="$chdCount17.2 >0">
				<PTC_INF>
					<NUM_PAX>
						<xsl:value-of select="$chdCount17.2" />
					</NUM_PAX>
					<PTC>CHD</PTC>
				</PTC_INF>
			</xsl:if>
			<xsl:if test="$infCount17.2 >0">
				<PTC_INF>
					<NUM_PAX>
						<xsl:value-of select="$infCount17.2" />
					</NUM_PAX>
					<PTC>INF</PTC>
				</PTC_INF>
			</xsl:if>

			<xsl:for-each select="CoreQuery/OriginDestinations/OriginDestination">
				<DES_INF>
					<DEP_DAT>
						<xsl:value-of
							select="format-date(Departure/Date, '[D01][MN,*-3]', 'en', (), ())" />
					</DEP_DAT>
					<CAB_CLA>Y</CAB_CLA><!-- to be done -->
					<POI_DES>
						<CIT>
							<xsl:value-of select="Arrival/AirportCode" />
						</CIT>
						<CIT_IND>N</CIT_IND><!-- to be done -->
					</POI_DES>
				</DES_INF>
			</xsl:for-each>
		</WS_PSC5A>
	</xsl:template>
</xsl:stylesheet>