package org.skcorg.parser;

import javax.xml.transform.TransformerException;

public interface XSLTTransformerService {

	public String transformXml(String dataFileName) throws TransformerException;
}
