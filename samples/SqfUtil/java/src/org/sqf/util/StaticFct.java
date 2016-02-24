package org.sqf.util;

import java.net.URI;

import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;

import org.apache.log4j.Logger;

import net.sf.saxon.Configuration;
import net.sf.saxon.expr.XPathContext;
import net.sf.saxon.om.NodeInfo;
//import net.sf.saxon.query.QueryResult;
import net.sf.saxon.s9api.DocumentBuilder;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XdmNode;

public class StaticFct {


	private static final Logger logger = Logger.getLogger(StaticFct.class.getName());
	
	
	public static NodeInfo loadDocRaw(XPathContext context, URI uri) {
		
		// create new, compatible configuration
		final Configuration baseConfig	= context.getConfiguration(); 
		final Configuration newConfig	= new Configuration();
		newConfig.setNamePool(baseConfig.getNamePool());
		newConfig.setDocumentNumberAllocator(baseConfig.getDocumentNumberAllocator());

		// don't resolve attribute defaults and XIncludes!
		newConfig.setExpandAttributeDefaults(false);
		newConfig.setXIncludeAware(false);

		try {
			
			final Source 			source 		= baseConfig.getURIResolver().resolve(uri.getPath(), null);
			final Processor 		processor 	= new Processor(newConfig);
			final DocumentBuilder 	builder 	= processor.newDocumentBuilder();
			final XdmNode 			doc 		= builder.build(source);
			
			//logger.info("loadDocRaw: " + QueryResult.serialize(doc.getUnderlyingNode()));
			
			return doc.getUnderlyingNode();
			
		} catch (TransformerException | SaxonApiException e) {
			logger.error(e, e);
			return null;
		}
		
	}
}
