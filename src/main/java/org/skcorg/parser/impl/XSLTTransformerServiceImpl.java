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
		StreamSource stylesource = new StreamSource(this.getClass().getResourceAsStream("/" + xsltSource));
		Transformer transformerTemp = null;
		try {
			transformerTemp = TransformerFactory.newInstance().newTransformer(stylesource);
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
		StreamSource source = new StreamSource(this.getClass().getResourceAsStream("/" + dataFileName));
		StringWriter sw = new StringWriter();
		transformer.transform(source, new StreamResult(sw));
		return sw.toString();
	}
}
