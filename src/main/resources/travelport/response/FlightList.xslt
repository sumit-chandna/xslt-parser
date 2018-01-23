<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
	xmlns:exsl="http://exslt.org/common">
	<xsl:output method="xml" indent="yes" />

	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="FlightList">
		<FlightList>
			<xsl:for-each
				select="//FlightSegmentList/FlightSegment[not(@parentIdentifier=preceding::FlightSegment/@parentIdentifier)]">
				<xsl:variable name="flightNumber" select="@FlightNumber" />
				<xsl:variable name="parentIdentifier" select="@parentIdentifier" />
				<Flight>
					<xsl:attribute name="FlightKey">
            <xsl:text>FL</xsl:text>
            <xsl:number value="position()" />
          </xsl:attribute>
					<xsl:attribute name="AirlineRef">
            <xsl:value-of select="MarketingCarrier/AirlineID" />
          </xsl:attribute>
					<Journey>
						<xsl:variable name="totalTime">
							<xsl:value-of
								select="sum(//FlightSegmentList/FlightSegment[@parentIdentifier = $parentIdentifier]/FlightDetail/FlightDuration/FlightDurationInputted)"></xsl:value-of>
						</xsl:variable>
						<TotalTime>
							<xsl:value-of select="$totalTime" />
						</TotalTime>
						<Time>


							<xsl:variable name="minutes"
								select="xs:integer(substring($totalTime, string-length($totalTime) - 1, 2))"
								as="xs:integer"></xsl:variable>
							<xsl:variable name="hours"
								select="xs:integer(substring($totalTime, 1, string-length($totalTime) - 2))"
								as="xs:integer"></xsl:variable>
							<xsl:variable name="totalParsed">
								<xsl:choose>
									<xsl:when test="$minutes >= 60">
										<hours>
											<xsl:value-of select="$hours + 1"></xsl:value-of>
										</hours>
										<minutes>
											<xsl:value-of select="$minutes - 60"></xsl:value-of>
										</minutes>
									</xsl:when>
									<xsl:otherwise>
										<hours>
											<xsl:number value="$hours"></xsl:number>
										</hours>
										<minutes>
											<xsl:number value="$minutes"></xsl:number>
										</minutes>
									</xsl:otherwise>
								</xsl:choose>

							</xsl:variable>
							<xsl:variable name="parsedHours"
								select="exsl:node-set($totalParsed)/hours" />
							<xsl:variable name="parsedMinutes"
								select="exsl:node-set($totalParsed)/minutes" />
							<xsl:variable name="parsedMinutes2Chars">
								<xsl:choose>
									<xsl:when test="string-length($parsedMinutes) = 1">
										<xsl:value-of select="concat(0, $parsedMinutes)" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$parsedMinutes" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:call-template name="parseDuration">
								<xsl:with-param name="duration"
									select="concat($parsedHours,$parsedMinutes2Chars)"></xsl:with-param>
							</xsl:call-template>

						</Time>
					</Journey>
					<SegmentReferences>
						<xsl:variable name="minimumSelfIdentifier">
							<xsl:for-each
								select="//FlightSegmentList/FlightSegment[@parentIdentifier = $parentIdentifier]">
								<xsl:sort select="@selfIdentifier" data-type="number" />
								<xsl:if test="position()=1">
									<xsl:value-of select="@selfIdentifier" />
								</xsl:if>
							</xsl:for-each>
						</xsl:variable>
						<xsl:variable name="maximumSelfIdentifier">
							<xsl:for-each
								select="//FlightSegmentList/FlightSegment[@parentIdentifier = $parentIdentifier]">
								<xsl:sort select="@selfIdentifier" order="descending"
									data-type="number" />
								<xsl:if test="position()=1">
									<xsl:value-of select="@selfIdentifier" />
								</xsl:if>
							</xsl:for-each>
						</xsl:variable>
						<xsl:attribute name="OnPoint">
              <xsl:value-of
							select="//FlightSegmentList/FlightSegment[@parentIdentifier = $parentIdentifier and @selfIdentifier = $minimumSelfIdentifier]/Departure/AirportCode" />
            </xsl:attribute>
						<xsl:attribute name="OffPoint">
              <xsl:value-of
							select="//FlightSegmentList/FlightSegment[@parentIdentifier = $parentIdentifier and @selfIdentifier = $maximumSelfIdentifier]/Arrival/AirportCode" />
            </xsl:attribute>
						<xsl:for-each
							select="//FlightSegmentList/FlightSegment[@parentIdentifier = $parentIdentifier]">
							<xsl:value-of select="@SegmentKey" />
							<xsl:if test="position() != last()">
								<xsl:text> </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</SegmentReferences>
				</Flight>
			</xsl:for-each>
		</FlightList>
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

	<xsl:template match="*/text()[normalize-space()]">
		<xsl:value-of select="normalize-space()" />
	</xsl:template>

	<xsl:template match="*/text()[not(normalize-space())]" />
</xsl:stylesheet>
