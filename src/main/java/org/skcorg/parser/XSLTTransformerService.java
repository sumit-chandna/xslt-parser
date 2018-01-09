package org.skcorg.parser;

import java.util.Map;

public interface XSLTTransformerService {

	public String transformXml(String dataFileName, Map<String, Object> parameterMap) throws Exception;
}
