#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 15 14:07:26 2018

@author: tt434
"""

from BaseXClient import BaseXClient
import os
import sys
import re
import rdflib
from xml.sax import handler, make_parser
from xml.sax.saxutils import escape

MODULE_PATH = "[path to rwo.xqm]"
IN_PATH = "[source MARC/XML]"
OUT_PATH = "[output N-Triples]"

def rdfxml2nt(rdfxml):
    """
    Converts an RDF/XML document to N-Triples.
    
    PARAMS
    rdfxml: RDF/XML document 
    
    RETURNS
    N-Triples as a bytes literal
    """
    g = rdflib.Graph()        
    result = g.parse(data=rdfxml, format="application/rdf+xml")        
    return result.serialize(format="nt")

def xquery(module_path, record):
    """
    Converts a MARC/XML record to RDF/XML (using the MADS/RDF ontoloty)
    
    PARAMS
    module_path: Absolute path to the XQuery module used to convert from 
                 MARC to MADS
    record:      MARC/XML record
    
    RETURNS
    MARC/XML record (parses multiple records from a MARC collection)
    """
    xquery = """xquery version "3.1";
    
        import module namespace rwo = "http://id.loc.gov/rwo/" at "{0}";
            
        let $rec := {1}        
        let $lccn := $rec/*[@tag = "010"]/replace(., "\s+", "")
        return
            try {{
                rwo:create-rwoClass($rec, $lccn)        
            }} catch * {{
                "Error [" || $err:code || "]: " || $err:description
            }}""".format(module_path, record)
    return xquery

def return_query(query):
    """
    Iterate over the XQuery results 
    """
    for _, q in query.iter():
        return q

class MadsHandler(handler.ContentHandler):
    """
    Parses an XML stream. Reconstitutes the records in a MARC collection hands
    off one-by-one: 
        (1) to the XQuery function for conversion to MADS
        (2) to the RDFLib function for conversion to N-Triples
    """
    def __init__(self, session, out):
        self.record = ""
        self.session = session
        self.out = out
   
    def startElementNS(self, name, qname, attrs):
        (ns, localname) = name
        if localname == "record":               
            self.record += "<" + localname + ' xmlns="' + ns + '">'
        elif localname == "leader":
            self.record += "<" + localname + ">"
        elif localname == "collection":
            pass
        else:
            self.record += "<" + localname + " "
            num = 0
            total = len(attrs)
            for k, v in attrs.items():                
                num += 1                
                self.record += k[1] + "=" + '"' + v + '"'
                if num != total:
                    self.record += " "                
            self.record += ">"
    
    def endElementNS(self, name, qname):
        (ns, localname) = name
        if localname != "record" and localname != "collection":
            self.record += "</" + localname + ">"
        elif localname == "collection":
            pass
        else:
            self.record += "</" + localname + ">"
            
            # Execute XQuery against a record
            xqy = xquery(MODULE_PATH, self.record)
            query = self.session.query(xqy)
            
            # Return the result of XQuery execution
            result = return_query(query)
            
            # Convert from RDF/XML to N-Triples
            conversion = rdfxml2nt(result)
            
            # Append the result to the output file
            if conversion is not None:                      
                self.out.write(conversion.decode())
            
            # Reset the record
            self.record = ""

    def characters(self, data):
        escaped = escape(data)
        
        # Curly braces need to be doubled, or XQuery will try to evaluate them
        self.record += re.sub(r"\{(.*)\}", "{{" + r"\1" + "}}", escaped)

try:    
    # Connect to the BaseX Server
    session = BaseXClient.Session("127.0.0.1", 1984, "admin", "admin")   
    
    # Open the source file
    file = open(IN_PATH, "r")
    
    # Create a new output file and append once created
    if os.path.exists(OUT_PATH):
        append_write = "a" 
    else:   
        append_write = "w" # make a new file if not
    
    with open(OUT_PATH, append_write) as nt:                
        parser = make_parser()
        parser.setContentHandler(MadsHandler(session, nt))
        parser.setFeature(handler.feature_namespaces, True)        
        parser.parse(file)
    
    file.close()         
    session.close()
        
except:
    print("Unexpected error:", sys.exc_info()[0])
    raise
