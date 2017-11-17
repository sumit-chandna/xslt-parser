import org.skcorg.parser.XSLTTransformerService;
import org.skcorg.parser.impl.XSLTTransformerServiceImpl;

public class Main {

	public static void main(String args[]) throws Exception {
		XSLTTransformerService transformerService = new XSLTTransformerServiceImpl("data-xsl.xsl");
		System.out.println(transformerService.transformXml("data.xml"));
	}
}