import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.skcorg.parser.XSLTTransformerService;
import org.skcorg.parser.impl.XSLTTransformerServiceImpl;

public class Main {
	private static final String PROVIDER = "travelport";
	private static final String API = "AirShoppingRQ";
	private static final String VERSION = "ALL";

	public static void main(String args[]) throws Exception {
		XSLTTransformerService transformerService = new XSLTTransformerServiceImpl(
				PROVIDER + "/" + API + "-" + VERSION + ".xsl");
		System.out.println(transformerService.transformXml("data.xml", prepareParameterMap()));
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
		options.add("18");
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