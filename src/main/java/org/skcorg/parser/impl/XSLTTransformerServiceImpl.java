package org.skcorg.parser.impl;

import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.xml.transform.stream.StreamSource;

import org.skcorg.parser.XSLTTransformerService;

import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XdmAtomicValue;
import net.sf.saxon.s9api.XdmItem;
import net.sf.saxon.s9api.XdmValue;
import net.sf.saxon.s9api.XsltExecutable;
import net.sf.saxon.s9api.XsltTransformer;

public class XSLTTransformerServiceImpl implements XSLTTransformerService {

	private final XsltTransformer xsltTransformer;
	private final Processor processor;
	private final XsltExecutable xsltExecutable;

	public XSLTTransformerServiceImpl(final String xsltSource) throws SaxonApiException {
		processor = new Processor(false);
		xsltExecutable = processor.newXsltCompiler()
				.compile(new StreamSource(this.getClass().getResourceAsStream("/" + xsltSource)));
		xsltTransformer = xsltExecutable.load();
	}

	public String transformXml(String dataFileName, Map<String, Object> parameterMap) throws Exception {
		xsltTransformer.setSource(new StreamSource(this.getClass().getResourceAsStream("/" + dataFileName)));
		for (Map.Entry<String, Object> entry : parameterMap.entrySet()) {
			if (entry.getValue() instanceof String) {
				xsltTransformer.setParameter(new QName(entry.getKey()), new XdmAtomicValue((String) entry.getValue()));
			} else if (entry.getValue() instanceof Iterable) {
				List<XdmItem> itemList = new ArrayList<XdmItem>();
				for (Object data : (Iterable<?>) entry.getValue()) {
					itemList.add(new XdmAtomicValue((String) data));
				}
				xsltTransformer.setParameter(new QName(entry.getKey()), new XdmValue(itemList));
			}
		}
		final StringWriter writer = new StringWriter();
		xsltTransformer.setDestination(processor.newSerializer(writer));
		xsltTransformer.transform();
		return writer.toString();
	}

}
