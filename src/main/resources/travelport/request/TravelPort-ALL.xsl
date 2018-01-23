<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes" />


	<xsl:template match="WS_PSC5A">

		<AirShoppingRQ Target="Production" Version="17.2">
			<Document>
				<Name>NDC GATEWAY</Name>
				<ReferenceVersion>1.0</ReferenceVersion>
			</Document>
			<Party>
				<Sender>
					<TravelAgencySender>
						<Name>Test sender</Name>
						<Contacts>
							<Contact>
								<EmailContact>
									<Address>abc@tc.com</Address>
								</EmailContact>
							</Contact>
						</Contacts>
						<IATA_Number>35201165</IATA_Number>
						<AgencyID>test</AgencyID>
					</TravelAgencySender>
				</Sender>
			</Party>
			<Parameters>
				<CurrCodes>
					<CurrCode>
						<xsl:value-of select="ISO_CUR_COD" />
					</CurrCode>
				</CurrCodes>
			</Parameters>
			<xsl:variable name="org" select="POI_ORI/CIT" />
			<xsl:variable name="orgDestCount" select="count(DES_INF)" />
			<Travelers>
				<xsl:for-each select="PTC_INF">
					<xsl:variable name="count" select="NUM_PAX" />
					<xsl:variable name="ptcVal" select="PTC" />
					<xsl:for-each select="1 to $count">
						<xsl:variable name="objkey" select="concat($ptcVal, position())" />
						<Traveler>
							<AnonymousTraveler>
								<xsl:attribute name="ObjectKey">
  <xsl:value-of select="$objkey" />
</xsl:attribute>
								<PTC>
									<xsl:value-of select="$ptcVal" />
								</PTC>
							</AnonymousTraveler>
						</Traveler>
					</xsl:for-each>

				</xsl:for-each>
			</Travelers>

			<CoreQuery>
				<OriginDestinations>
					<xsl:for-each select="DES_INF">
						<OriginDestination>
							<xsl:variable name="odkey" select="concat('OD',position())" />
							<xsl:attribute name="OriginDestinationKey">
							
  <xsl:value-of select="$odkey" />
</xsl:attribute>
							<xsl:variable name="org1" select="POI_DES/CIT" />
							<Departure>
								<AirportCode>
									<xsl:choose>
										<xsl:when test="$odkey='OD1'">
											<xsl:value-of select="$org" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$org1" />
										</xsl:otherwise>
									</xsl:choose>
								</AirportCode>
								<xsl:variable name="depDate"
									select="concat(concat(concat('2018-', substring(DEP_DAT,3)),'-'),substring(DEP_DAT, 1, 2))" />
								<Date>
									<xsl:value-of select="$depDate" />
								</Date>
							</Departure>
							<Arrival>
								<AirportCode>
									<xsl:value-of select="POI_DES/CIT" />
								</AirportCode>
							</Arrival>
						</OriginDestination>

					</xsl:for-each>
				</OriginDestinations>
			</CoreQuery>
			<Preferences>
				<Preference>
					<AirlinePreferences>
						<Airline>
							<AirlineID>
								<xsl:value-of select="ARL_INF/ARL_COD" />
							</AirlineID>
						</Airline>
					</AirlinePreferences>
				</Preference>
			</Preferences>
		</AirShoppingRQ>
	</xsl:template>
</xsl:stylesheet>