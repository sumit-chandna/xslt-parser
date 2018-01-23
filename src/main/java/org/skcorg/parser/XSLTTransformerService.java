package org.skcorg.parser;

import java.io.InputStream;
import java.util.Map;

import net.sf.saxon.s9api.SaxonApiException;

public interface XSLTTransformerService {

	public String transformXml(String dataFileName, Map<String, Object> parameterMap) throws Exception;

	public String transformXml(InputStream inputStream, Map<String, Object> prepareParameterMap)
			throws SaxonApiException;
}
