import java.io.ByteArrayInputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

import org.skcorg.parser.XSLTTransformerService;
import org.skcorg.parser.impl.XSLTTransformerServiceImpl;

import net.sf.saxon.s9api.SaxonApiException;

public class Main {
	private static final String PROVIDER = "travelport/";
	XSLTTransformerService transformerServiceAirline, transformerServiceFLightList, transformerServiceOriginDest,
			transformerServicePriceList, transformerServiceFinal, transformerServiceRequest;

	public Main() throws SaxonApiException {
		transformerServiceAirline = new XSLTTransformerServiceImpl(PROVIDER + "response", "Airlines.xslt");
		transformerServiceFLightList = new XSLTTransformerServiceImpl(PROVIDER + "response", "FlightList.xslt");
		transformerServiceOriginDest = new XSLTTransformerServiceImpl(PROVIDER + "response",
				"OriginDestinationList.xslt");
		transformerServicePriceList = new XSLTTransformerServiceImpl(PROVIDER + "response", "PriceList.xslt");
		transformerServiceFinal = new XSLTTransformerServiceImpl(PROVIDER + "response", "Offer.xslt");
		transformerServiceRequest = new XSLTTransformerServiceImpl(PROVIDER + "request", "airshoppingRQ-ALL.xsl");
	}

	@SuppressWarnings("resource")
	public static void main(String args[]) throws Exception {
		Main main = new Main();
		String data1 = new Scanner(Main.class.getResourceAsStream("data.xml"), "UTF-8").useDelimiter("\\A").next();
		main.transformerServiceRequest.transformXml(data1, prepareParameterMap());
		String Tp_response = new Scanner(Main.class.getResourceAsStream("TP_Res.xml"), "UTF-8").useDelimiter("\\A")
				.next();
		main.execute(main, Tp_response);
		main.execute(main, Tp_response);
		main.execute(main, Tp_response);
		System.out.println(main.execute(main, Tp_response));
	}

	private String execute(Main main, String Tp_response) throws Exception {
		long startTime = System.currentTimeMillis();
		String airlinesXml = main.transformerServiceAirline.transformXml(Tp_response, prepareParameterMap());
		String FlightListXml = main.transformerServiceFLightList.transformXml(
				new ByteArrayInputStream(airlinesXml.getBytes(StandardCharsets.UTF_8.name())), prepareParameterMap());
		String OriginDestinationListXml = main.transformerServiceOriginDest.transformXml(
				new ByteArrayInputStream(FlightListXml.getBytes(StandardCharsets.UTF_8.name())), prepareParameterMap());
		String PriceListXml = main.transformerServicePriceList.transformXml(
				new ByteArrayInputStream(OriginDestinationListXml.getBytes(StandardCharsets.UTF_8.name())),
				prepareParameterMap());
		String OfferXml = main.transformerServiceFinal.transformXml(
				new ByteArrayInputStream(PriceListXml.getBytes(StandardCharsets.UTF_8.name())), prepareParameterMap());
		long endTime = System.currentTimeMillis();
		long difference = endTime - startTime;
		System.out.println("########################### Time Difference : " + difference);
		return OfferXml;
	}

	private static Map<String, Object> prepareParameterMap() {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tickettLoc", "MIA");
		map.put("dutCode", "WP");
		map.put("agentCurrency", "USD");
		map.put("agentCountry", "US");
		List<String> options = new ArrayList<String>();
		options.add("16");
		options.add("17");
		options.add("19");
		options.add("D");
		options.add("GF");
		options.add("O");
		options.add("U");
		map.put("options", options);
		map.put("originCityIndicator", "Y");
		map.put("airlineOption", "B");
		map.put("airline", "EK");
		return map;

	}
}