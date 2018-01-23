<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:jscript="http://www.transvision.dk" exclude-result-prefixes="msxsl jscript">
	<xsl:output method="xml" indent="yes" />
	<xsl:decimal-format name="IndianFormat"
		decimal-separator="." grouping-separator="," />

	<xsl:variable name="KeyValuePairs"
		select="document('KeyValuePair.xml')/KeyValuePairs" />

	<msxsl:script language="JScript" implements-prefix="jscript">
		function getOfferExpirationDate(){
		var currentDate = new Date();
		currentDate.setMinutes(currentDate.getMinutes() + 10);

		var year =
		currentDate.getFullYear();
		var month = ((currentDate.getMonth() +
		1).toString().length === 1 ? ('0'
		+ (currentDate.getMonth() + 1)) :
		(currentDate.getMonth() + 1));
		var day =
		(currentDate.getDate()).toString().length === 1 ? ('0' +
		currentDate.getDate()) : currentDate.getDate();
		var day =
		(currentDate.getDate()).toString().length === 1 ? ('0' +
		currentDate.getDate()) : currentDate.getDate();
		var hours =
		(currentDate.getHours()).toString().length === 1 ? ('0' +
		currentDate.getHours()) : currentDate.getHours();
		var minutes =
		(currentDate.getMinutes()).toString().length === 1 ? ('0' +
		currentDate.getMinutes()) : currentDate.getMinutes();
		var seconds =
		(currentDate.getSeconds()).toString().length === 1 ? ('0' +
		currentDate.getSeconds()) : currentDate.getSeconds();
		var datetime =
		currentDate.getFullYear() + '-' + month + "-" + day
		+ "T" + hours + ":"
		+ minutes + ":"
		+ seconds;
		return datetime;
		}
	</msxsl:script>
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" />
		</xsl:copy>
	</xsl:template>
	<xsl:template match="OffersGroup/AirlineOffers">
		<AirlineOffers>
			<xsl:call-template name="AirlineOffers-AirlineOfferSnapshot"></xsl:call-template>
			<xsl:call-template name="AirlineOffers-Offer"></xsl:call-template>
		</AirlineOffers>
	</xsl:template>
	<xsl:template match="*/text()[normalize-space()]">
		<xsl:value-of select="normalize-space()" />
	</xsl:template>

	<xsl:template match="*/text()[not(normalize-space())]" />
	<xsl:template name="AirlineOffers-AirlineOfferSnapshot">
		<AirlineOfferSnapshot>

			<PassengerQuantity>
				<xsl:value-of select="sum(//RSP/PSW5A/ALT_INF[1]/PTC_FAR_INF/NUM_PAX)" />
			</PassengerQuantity>
			<Highest>
				<EncodedCurrencyPrice>
					<xsl:attribute name="Code">
            <xsl:value-of select="//RSP/PSW5A/ALT_INF/ISO_CUR_COD" />
          </xsl:attribute>
					<xsl:value-of select="//RSP/PSW5A/ALT_INF/TTL_FAR" />
				</EncodedCurrencyPrice>
			</Highest>
			<Lowest>
				<EncodedCurrencyPrice>
					<xsl:attribute name="Code">
            <xsl:value-of select="//RSP/PSW5A/ALT_INF/ISO_CUR_COD" />
          </xsl:attribute>
					<xsl:value-of select="//RSP/PSW5A/ALT_INF/TTL_FAR" />
				</EncodedCurrencyPrice>
			</Lowest>
			<MatchedOfferQuantity>
				<xsl:value-of select="count(//RSP/PSW5A/ALT_INF)" />
			</MatchedOfferQuantity>

		</AirlineOfferSnapshot>
	</xsl:template>
	<xsl:template name="AirlineOffers-Offer">
		<xsl:for-each select="//RSP/PSW5A/ALT_INF">
			<Offer>
				<xsl:variable name="offerId" select="position()"></xsl:variable>
				<xsl:attribute name="OfferID">
          <xsl:text>OFFER</xsl:text>
          <xsl:number value="$offerId" />
        </xsl:attribute>
				<xsl:attribute name="Owner">
          <xsl:value-of select="FLI_GRP/FLI_INF[1]/ARL_COD" />
        </xsl:attribute>
				<xsl:call-template name="AirlineOffers-Parameters"></xsl:call-template>
				<ValidatingCarrier>
					<xsl:value-of select="FLI_GRP/FLI_INF[1]/ARL_COD" />
				</ValidatingCarrier>
				<TimeLimits>
					<OfferExpiration>
						<xsl:attribute name="DateTime">
             <!--  <xsl:value-of select="jscript:getOfferExpirationDate()" /> -->
            </xsl:attribute>
					</OfferExpiration>
					<OtherLimits>
						<OtherLimit>
							<PriceGuaranteeTimeLimit />
							<TicketByTimeLimit>
								<TicketBy>
									<xsl:call-template name="parseLastTicketDate">
										<xsl:with-param name="lastTicket" select="LAS_TIC_DAT"></xsl:with-param>
									</xsl:call-template>
								</TicketBy>
							</TicketByTimeLimit>
						</OtherLimit>
					</OtherLimits>
				</TimeLimits>
				<TotalPrice>
					<DetailCurrencyPrice>
						<Total>
							<xsl:attribute name="Code">
                <xsl:value-of select="ISO_CUR_COD" />
              </xsl:attribute>
							<xsl:value-of select="TTL_FAR" />
						</Total>
					</DetailCurrencyPrice>
				</TotalPrice>
				<Match>
					<Application>Journey</Application>
					<MatchResult>Partial</MatchResult>
				</Match>
				<xsl:for-each select="FLI_GRP">
					<xsl:variable name="onBoard" select="FLI_INF[1]/DEP_ARP" />
					<xsl:variable name="offBoard" select="FLI_INF[last()]/ARR_ARP" />
					<xsl:variable name="totalTime"
						select="sum(FLI_INF/ADD_FLI_SVC[1]/ACU_FLI_TIM)"></xsl:variable>
					<FlightsOverview>
						<FlightRef>
							<xsl:attribute name="ODRef">
                <xsl:for-each
								select="//OriginDestinationList/OriginDestination">
                  <xsl:if
								test="DepartureCode = $onBoard and ArrivalCode=$offBoard">
                    <xsl:value-of select="@OriginDestinationKey" />
                  </xsl:if>
                </xsl:for-each>
              </xsl:attribute>
							<xsl:attribute name="PriceClassRef">
                <xsl:text>Economy</xsl:text>
              </xsl:attribute>
							<xsl:for-each select="//FlightList/Flight">
								<xsl:if
									test="SegmentReferences/@OnPoint = $onBoard and SegmentReferences/@OffPoint=$offBoard and Journey/TotalTime = $totalTime">
									<xsl:value-of select="@FlightKey" />
								</xsl:if>
							</xsl:for-each>
						</FlightRef>
					</FlightsOverview>
				</xsl:for-each>
				<xsl:for-each select="PTC_FAR_INF">
					<xsl:call-template name="Airline-OfferItem">
						<xsl:with-param name="parentId" select="$offerId"></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>

			</Offer>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="AirlineOffers-Parameters">
		<Parameters>
			<TotalItemQuantity>
				<xsl:value-of select="count(PTC_FAR_INF)" />
			</TotalItemQuantity>
			<xsl:for-each select="PTC_FAR_INF">
				<xsl:sort select="PTC" />
				<PTC_Priced>
					<xsl:variable name="requestedQuantity">
						<xsl:number value="NUM_PAX" />
					</xsl:variable>
					<xsl:variable name="requestedType" select="PTC" />
					<Requested>
						<xsl:attribute name="Quantity">
              <xsl:value-of select="$requestedQuantity"></xsl:value-of>
            </xsl:attribute>
						<xsl:value-of select="$requestedType"></xsl:value-of>
					</Requested>
					<Priced>
						<xsl:attribute name="Quantity">
              <xsl:value-of select="$requestedQuantity"></xsl:value-of>
            </xsl:attribute>
						<xsl:choose>
							<xsl:when test="$requestedType = 'INF'">
								<xsl:value-of select="$requestedType" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>ADT</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</Priced>
				</PTC_Priced>
			</xsl:for-each>
		</Parameters>
	</xsl:template>

	<xsl:template name="parseLastTicketDate">
		<xsl:param name="lastTicket" select="1" />
		<xsl:variable name="dateFromLastTicket"
			select="substring-before(substring-after($lastTicket, '/ '), ' ')"></xsl:variable>
		<xsl:variable name="year"
			select="substring($dateFromLastTicket, string-length($dateFromLastTicket) - 3)">
		</xsl:variable>
		<xsl:variable name="month">
			<xsl:call-template name="parseMonth">
				<xsl:with-param name="month"
					select="substring($dateFromLastTicket, string-length($dateFromLastTicket) - 6, 3)"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="day">
			<xsl:call-template name="parseDay">
				<xsl:with-param name="dayInNumber"
					select="substring($dateFromLastTicket, 1, string-length($dateFromLastTicket) - 7)"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="concat($year, '-', $month, '-', $day, 'T23:59:00') " />
	</xsl:template>

	<xsl:template name="Airline-OfferItem">
		<xsl:param name="parentId" select="1"></xsl:param>
		<OfferItem MandatoryInd="true">
			<xsl:attribute name="OfferItemID">
        <xsl:text>OFFER</xsl:text>
        <xsl:number value="$parentId" />
        <xsl:text>-</xsl:text>
        <xsl:number value="position()" />
      </xsl:attribute>
			<TotalPriceDetail>
				<TotalAmount>
					<DetailCurrencyPrice>
						<Total>
							<xsl:attribute name="Code">
                <xsl:value-of select="../ISO_CUR_COD" />
              </xsl:attribute>
							<!--<xsl:value-of select="format-number(TTL_FAR, '##,##,###.00', 'IndianFormat')"/> -->
							<xsl:value-of select="TTL_FAR" />
						</Total>
					</DetailCurrencyPrice>
				</TotalAmount>
			</TotalPriceDetail>
			<FareDetail>
				<Price>
					<BaseAmount>
						<xsl:attribute name="Code">
              <xsl:value-of select="../ISO_CUR_COD" />
            </xsl:attribute>
						<xsl:value-of select="BAS_FAR" />
					</BaseAmount>
					<Taxes>
						<Total>
							<xsl:attribute name="Code">
                <xsl:value-of select="../ISO_CUR_COD" />
              </xsl:attribute>
							<!--<xsl:value-of select="format-number(TTL_FAR - BAS_FAR,'##,##,###.00', 
								'IndianFormat')"/> -->
							<xsl:value-of select="TTL_FAR - BAS_FAR" />
						</Total>
					</Taxes>
				</Price>
				<Comment>TODO Add For Each</Comment>

				<FareComponent>
					<FareBasis>
						<FareBasisCode refs="TODO">
							<Code>TODO</Code>
						</FareBasisCode>
						<RBD>
							<xsl:value-of select="../FLI_GRP[1]/FLI_INF[1]/FAR_CLA" />
						</RBD>
						<CabinType>
							<CabinTypeCode>
								<xsl:text>Y</xsl:text>
							</CabinTypeCode>
							<CabinTypeName>
								<xsl:text>COACH</xsl:text>
							</CabinTypeName>
						</CabinType>
					</FareBasis>
					<FareRules>
						<Ticketing>
							<Endorsements>
								<Endorsement>
									<xsl:call-template name="parseLastTicketDate">
										<xsl:with-param name="lastTicket" select="../LAS_TIC_DAT"></xsl:with-param>
									</xsl:call-template>
								</Endorsement>
							</Endorsements>
						</Ticketing>
					</FareRules>
					<PriceClassRef>Economy</PriceClassRef>
					<SegmentRefs ON_Point="TODO" OFF_Point="SYD">TODO TODO</SegmentRefs>
				</FareComponent>
				<xsl:call-template name="Remarks"></xsl:call-template>

			</FareDetail>
		</OfferItem>
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
	<xsl:template name="Remarks">
		<Remarks>
			<xsl:variable name="passengarType" select="PTC"></xsl:variable>
			<xsl:for-each select="../TRI_INF">
				<xsl:if test="PTC_DTL_INF/PTC = $passengarType">
					<Remark>
						<xsl:variable name="remarkCode">
							<xsl:value-of select="PTC_DTL_INF/FAR_RST" />
						</xsl:variable>
						<xsl:value-of select="$KeyValuePairs/Remarks/Remark[@Key=$remarkCode]" />
					</Remark>
				</xsl:if>
			</xsl:for-each>
		</Remarks>
	</xsl:template>
</xsl:stylesheet>
