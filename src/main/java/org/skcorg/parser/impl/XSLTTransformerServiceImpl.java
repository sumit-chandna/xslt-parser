package org.skcorg.parser.impl;

import java.io.StringWriter;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.skcorg.parser.XSLTTransformerService;

public class XSLTTransformerServiceImpl implements XSLTTransformerService {

	private final Transformer transformer;

	public XSLTTransformerServiceImpl(String xsltSource) {
		super();
		Transformer transformerTemp = null;
		try {
			transformerTemp = TransformerFactory.newInstance()
					.newTransformer(new StreamSource(this.getClass().getResourceAsStream("/" + xsltSource)));
		} catch (TransformerConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (TransformerFactoryConfigurationError e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		this.transformer = transformerTemp;
	}

	public String transformXml(String dataFileName) throws TransformerException {
		StringWriter sw = new StringWriter();
		transformer.transform(new StreamSource(this.getClass().getResourceAsStream("/" + dataFileName)),
				new StreamResult(sw));
		return sw.toString();
	}
}
