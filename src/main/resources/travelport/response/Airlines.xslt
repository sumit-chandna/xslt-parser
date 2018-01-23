<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:exsl="http://exslt.org/common" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:ns1="xxs" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:jscript="http://www.transvision.dk" exclude-result-prefixes="msxsl jscript">
	<!--xmlns:msxsl="urn:schemas-microsoft-com:xslt" -->
	<xsl:output method="xml" indent="yes" />

	<xsl:variable name="KeyValuePairs"
		select="document('KeyValuePair.xml')/KeyValuePairs" />
	<xsl:template match="*">
		<AirShoppingRS TransactionIdentifier="TRN12345" Version="17.2">
			<Document>
				<Name>NDC GATEWAY</Name>
				<ReferenceVersion>1.0</ReferenceVersion>
			</Document>
			<Success />
			<Warnings>
				<xsl:call-template name="Warnings"></xsl:call-template>
			</Warnings>
			<ShoppingResponseID>
				<xsl:call-template name="ShoppingResponse"></xsl:call-template>
			</ShoppingResponseID>
			<OffersGroup>
				<AirlineOffers>
					<!--<xsl:call-template name="AirlineOffers-AirlineOfferSnapshot"></xsl:call-template> 
						<xsl:call-template name="AirlineOffers-Offer"></xsl:call-template> -->
					TODO
				</AirlineOffers>
			</OffersGroup>
			<DataLists>
				<xsl:call-template name="Datalist-Passsengerlist"></xsl:call-template>
				<xsl:call-template name="Datalist-BaggageAllowanceList"></xsl:call-template>
				<xsl:call-template name="Datalist-Farelist"></xsl:call-template>
				<xsl:call-template name="Datalist-FlightSegmentList"></xsl:call-template>
				<xsl:call-template name="Datalist-FlightList"></xsl:call-template>
				<xsl:call-template name="Datalist-OriginDestinationList"></xsl:call-template>
				<xsl:call-template name="Datalist-PriceClassList"></xsl:call-template>
			</DataLists>
			<SourceList>
				<xsl:copy-of
					select="/SOAP-ENV:Envelope/SOAP-ENV:Body/ns1:ProviderTransactionResponse/RSP" />
			</SourceList>
		</AirShoppingRS>
	</xsl:template>
	<xsl:template name="Warnings">
		<Warning>
			<xsl:attribute name="Owner">
        <xsl:value-of
				select="/SOAP-ENV:Envelope/SOAP-ENV:Body/ns1:ProviderTransactionResponse/RSP/PSW5A/ALT_INF/FLI_GRP/FLI_INF/ARL_COD" />
      </xsl:attribute>
			Due to combinability, fare results may be different once added to the
			shopping cart
		</Warning>
	</xsl:template>
	<xsl:template name="ShoppingResponse">
		<Owner>
			<xsl:value-of
				select="/SOAP-ENV:Envelope/SOAP-ENV:Body/ns1:ProviderTransactionResponse/RSP/PSW5A/ALT_INF/FLI_GRP/FLI_INF/ARL_COD" />
		</Owner>
		<ResponseID>
			<xsl:value-of
				select="/SOAP-ENV:Envelope/SOAP-ENV:Body/ns1:ProviderTransactionResponse/RSP/PSW5A/@trackingid" />
		</ResponseID>
	</xsl:template>



	<xsl:template name="Datalist-Passsengerlist">
		<PassengerList>
			<xsl:for-each select="//RSP/PSW5A/ALT_INF[1]/PTC_FAR_INF">
				<xsl:sort select="PTC" />
				<xsl:call-template name="Datalist-Passsengerlist-Passenger">
					<xsl:with-param name="count" select="NUM_PAX" />
					<xsl:with-param name="counter" select="1" />
				</xsl:call-template>

			</xsl:for-each>
		</PassengerList>
	</xsl:template>
	<xsl:template name="Datalist-Passsengerlist-Passenger">
		<xsl:param name="count" select="1" />
		<xsl:param name="counter" select="1" />
		<xsl:if test="$count > 0">
			<Passenger>
				<xsl:attribute name="PassengerID">
          <xsl:text>T</xsl:text>
          <xsl:number value="position()" />
          <xsl:number value="$counter" />
        </xsl:attribute>
				<PTC>
					<xsl:value-of select="PTC" />
				</PTC>
			</Passenger>
			<xsl:call-template name="Datalist-Passsengerlist-Passenger">
				<xsl:with-param name="count" select="$count - 1" />
				<xsl:with-param name="counter" select="$counter + 1" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="Datalist-BaggageAllowanceList">
		<BaggageAllowanceList>
			<BaggageAllowance
				BaggageAllowanceID="CHBIDA4MJXRZBN2M4SSDSAE14HBFOF5SOH2UKRNBVLIVRERNKQJDDHTE">
				<BaggageCategory>Checked</BaggageCategory>
				<PieceAllowance>
					<ApplicableParty>Traveler</ApplicableParty>
					<TotalQuantity>0</TotalQuantity>
					<PieceMeasurements Quantity="0" />
				</PieceAllowance>
			</BaggageAllowance>
		</BaggageAllowanceList>
	</xsl:template>
	<xsl:template name="Datalist-Farelist">
		<FareList>
			<xsl:for-each
				select="//RSP/PSW5A/ALT_INF[1]/TRI_INF/PTC_DTL_INF[not(FAR_BAS_COD=preceding::PTC_DTL_INF/FAR_BAS_COD)]">
				<FareGroup>
					<xsl:attribute name="ListKey">
            <xsl:text>FBCODE_</xsl:text>
            <xsl:value-of select="PTC" />
            <xsl:text>_</xsl:text>
            <xsl:number value="position()" />
          </xsl:attribute>
					<Fare>
						<FareCode>70J</FareCode>
					</Fare>
					<FareBasisCode>
						<Code>
							<xsl:value-of select="FAR_BAS_COD" />
						</Code>
					</FareBasisCode>
				</FareGroup>
			</xsl:for-each>
		</FareList>
	</xsl:template>

	<xsl:template name="Datalist-FlightSegmentList">
		<FlightSegmentList>
			<xsl:for-each select="//RSP/PSW5A/ALT_INF/FLI_GRP">
				<xsl:variable name="parentId" select="position()"></xsl:variable>
				<xsl:for-each select="FLI_INF[not (FLI_NUM = preceding::FLI_INF/FLI_NUM)]">
					<FlightSegment ElectronicTicketInd="true"
						SecureFlight="true">
						<xsl:attribute name="SegmentKey">
              <xsl:text>SEG</xsl:text>
              <xsl:number value="$parentId" />
              <xsl:number value="position()" />
            </xsl:attribute>
						<xsl:attribute name="FlightNumber">
              <xsl:value-of select="FLI_NUM" />
            </xsl:attribute>
						<xsl:attribute name="parentIdentifier">
              <xsl:number value="$parentId" />
            </xsl:attribute>
						<xsl:attribute name="selfIdentifier">
              <xsl:number value="position()" />
            </xsl:attribute>
						<Departure>
							<xsl:variable name="departureAirport" select="DEP_ARP"></xsl:variable>
							<AirportCode>
								<xsl:value-of select="$departureAirport" />
							</AirportCode>
							<Date>
								<xsl:call-template name="parseDate">
									<xsl:with-param name="date" select="FLI_DAT" />
									<xsl:with-param name="interval" select="''" />
								</xsl:call-template>
							</Date>
							<Time>
								<xsl:call-template name="parseTime">
									<xsl:with-param name="time" select="DEP_TIM" />
								</xsl:call-template>
							</Time>
							<AirportName>
								<xsl:value-of
									select="$KeyValuePairs/AirportNames/Airport[@Key=$departureAirport]" />
							</AirportName>
						</Departure>
						<Arrival>
							<xsl:variable name="arrivalAirport" select="ARR_ARP"></xsl:variable>
							<AirportCode>
								<xsl:value-of select="$arrivalAirport" />
							</AirportCode>
							<Date>
								<xsl:if test="DEP_ARR_DAT_DIF">
									<xsl:call-template name="parseDate">
										<xsl:with-param name="date" select="FLI_DAT" />
										<xsl:with-param name="interval" select="DEP_ARR_DAT_DIF" />
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="not(DEP_ARR_DAT_DIF)">
									<xsl:call-template name="parseDate">
										<xsl:with-param name="date" select="FLI_DAT" />
										<xsl:with-param name="interval" select="''" />
									</xsl:call-template>
								</xsl:if>
							</Date>
							<Time>
								<xsl:call-template name="parseTime">
									<xsl:with-param name="time" select="ARR_TIM" />
								</xsl:call-template>
							</Time>
							<AirportName>
								<xsl:value-of
									select="$KeyValuePairs/AirportNames/Airport[@Key=$arrivalAirport]" />
							</AirportName>
						</Arrival>
						<MarketingCarrier>
							<xsl:variable name="marketingCarrier" select="ARL_COD"></xsl:variable>
							<AirlineID>
								<xsl:value-of select="$marketingCarrier" />
							</AirlineID>
							<Name>
								<xsl:value-of
									select="$KeyValuePairs/Carriers/Carrier[@Key=$marketingCarrier]" />
							</Name>
							<FlightNumber>
								<xsl:value-of select="FLI_NUM" />
							</FlightNumber>
						</MarketingCarrier>
						<OperatingCarrier>
							<xsl:variable name="operatingCarrier">
								<xsl:choose>
									<xsl:when test="COD_SHA_COD">
										<xsl:value-of select="COD_SHA_COD" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="ARL_COD" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<AirlineID>
								<xsl:value-of select="$operatingCarrier" />
							</AirlineID>
							<Name>
								<xsl:value-of
									select="$KeyValuePairs/Carriers/Carrier[@Key=$operatingCarrier]" />
							</Name>
							<FlightNumber>
								TODO It seems the Flighnumber of Marketing Carrier and Operating
								Carrier are same. Confirm
								<xsl:value-of select="FLI_NUM" />
							</FlightNumber>
						</OperatingCarrier>
						<Equipment>
							<xsl:variable name="equipmentType" select="EQP_TYP"></xsl:variable>
							<AircraftCode>
								<xsl:value-of select="$equipmentType" />
							</AircraftCode>
							<Name>
								<xsl:value-of
									select="$KeyValuePairs/Equipments/Equipment[@Key=$equipmentType]" />
							</Name>
						</Equipment>
						<FlightDetail>
							<FlightDistance>
								<Value>
									<xsl:value-of select="ADD_FLI_SVC/LEG_MIL" />
								</Value>
								<UOM>Miles</UOM>
							</FlightDistance>
							<FlightDuration>
								<FlightDurationInputted>
									<xsl:value-of select="ADD_FLI_SVC/ACU_FLI_TIM" />
								</FlightDurationInputted>
								<Value>
									<xsl:call-template name="parseDuration">
										<xsl:with-param name="duration" select="ADD_FLI_SVC/ACU_FLI_TIM" />
									</xsl:call-template>
								</Value>
							</FlightDuration>
						</FlightDetail>
					</FlightSegment>
				</xsl:for-each>
			</xsl:for-each>
		</FlightSegmentList>
	</xsl:template>

	<xsl:template name="parseDate">
		<xsl:param name="date" />
		<xsl:param name="interval" />
		<xsl:variable name="month">
			<xsl:value-of select="substring($date, 3)" />
		</xsl:variable>
		<xsl:variable name="day">
			<xsl:value-of select="substring($date, 1, 2)" />
		</xsl:variable>
		<xsl:variable name="monthInDigits">
			<xsl:call-template name="parseMonth">
				<xsl:with-param name="month" select="$month"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="$interval = ''">
			<xsl:text>2018-</xsl:text>
			<xsl:value-of select="$monthInDigits" />
			<xsl:text>-</xsl:text>
			<xsl:value-of select="$day" />
		</xsl:if>
		<xsl:if test="$interval != ''">
			<xsl:variable name="dayInNumber">
				<xsl:value-of select="$day + $interval" />
			</xsl:variable>
			<xsl:variable name="dayInNumberConcat0">
				<xsl:call-template name="parseDay">
					<xsl:with-param name="dayInNumber" select="$dayInNumber"></xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			<xsl:text>2018-</xsl:text>
			<xsl:value-of select="$monthInDigits" />
			<xsl:text>-</xsl:text>
			<xsl:value-of select="$dayInNumberConcat0" />
		</xsl:if>
	</xsl:template>

	<xsl:template name="parseMonth">
		<xsl:param name="month" select="1"></xsl:param>
		<xsl:value-of select="$KeyValuePairs/Months/Month[@Key=$month]" />
	</xsl:template>
	<xsl:template name="parseDay">
		<xsl:param name="dayInNumber" select="1"></xsl:param>
		<xsl:choose>
			<xsl:when test="string-length($dayInNumber) = 1">
				<xsl:value-of select="concat('0', $dayInNumber)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$dayInNumber" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="parseTime">
		<xsl:param name="time" />
		<xsl:value-of select="substring($time, 1, 2)" />
		:
		<xsl:value-of select="substring($time, 3, 2)" />
	</xsl:template>

	<xsl:template name="parseDuration">
		<xsl:param name="duration" />
		<xsl:if test="string-length($duration) = 3">
			<xsl:text>PT0</xsl:text>
			<xsl:value-of select="substring($duration, 1, 1)" />
			<xsl:text>H</xsl:text>
			<xsl:value-of select="substring($duration, 2, 2)" />
			<xsl:text>M</xsl:text>
		</xsl:if>
		<xsl:if test="string-length($duration) = 4">
			<xsl:text>PT</xsl:text>
			<xsl:value-of select="substring($duration, 1, 2)" />
			<xsl:text>H</xsl:text>
			<xsl:value-of select="substring($duration, 3, 2)" />
			<xsl:text>M</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template name="Datalist-FlightList">
		<FlightList>TODO</FlightList>
	</xsl:template>
	<xsl:template name="Datalist-OriginDestinationList">
		<OriginDestinationList>TODO</OriginDestinationList>
	</xsl:template>
	<xsl:template name="Datalist-PriceClassList">
		<PriceClassList>TODO</PriceClassList>
	</xsl:template>
</xsl:stylesheet>
