xquery version "3.1";

(: NAMESPACES :)
module namespace rwo    = "http://id.loc.gov/rwo/";

declare namespace marcxml       = "http://www.loc.gov/MARC21/slim";
declare namespace madsrdf       = "http://www.loc.gov/mads/rdf/v1#";
declare namespace rdf           = "http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace rdfs          = "http://www.w3.org/2000/01/rdf-schema#";
declare namespace owl           = "http://www.w3.org/2002/07/owl#";
declare namespace identifiers   = "http://id.loc.gov/vocabulary/identifiers/";
declare namespace skos          = "http://www.w3.org/2004/02/skos/core#";

(:~
:   Creates MADS RWO Class
:
:   @param  $df        	element() the relevant marcxml:datafield 
:   @param  $identifier        string of the marc001 
:   @return relation as element()
:)
declare function rwo:create-rwoClass($record as element(), $identifier as xs:string) as element()* {
    let $df046 := $record/marcxml:datafield[@tag='046']
    let $df368 := $record/marcxml:datafield[@tag='368'] 
    let $df370 := $record/marcxml:datafield[@tag='370']    
    let $df371 := $record/marcxml:datafield[@tag='371'] 
    let $df372 := $record/marcxml:datafield[@tag='372'] 
    let $df373 := $record/marcxml:datafield[@tag='373'] 
    let $df374 := $record/marcxml:datafield[@tag='374'] 
    let $df375 := $record/marcxml:datafield[@tag='375']  
    let $df376 := $record/marcxml:datafield[@tag='376'] 
    let $df377 := $record/marcxml:datafield[@tag='377'] 
    let $df380 := $record/marcxml:datafield[@tag='380'] 
    
    let $types := (
            if ($record/marcxml:datafield[@tag='100'] and fn:string($record/marcxml:datafield[@tag='100']/@ind1)!="3" and 
                fn:not($record/marcxml:datafield[@tag='100']/marcxml:subfield[fn:matches(@code , '[efhklmnoprstvxyz]')])
                ) then
                (<rdf:type rdf:resource="http://id.loc.gov/ontologies/bibframe/Person"/>,
					<rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Person"/>)
           else if ($record/marcxml:datafield[@tag='100'] and fn:string($record/marcxml:datafield[@tag='100']/@ind1)="3"                 
                ) then
                (<rdf:type rdf:resource="http://id.loc.gov/ontologies/bibframe/Family"/>,
				<rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Group"/>)
					 
            else (),
            if ($record/marcxml:datafield[@tag='110'] and 
                fn:not($record/marcxml:datafield[@tag='110']/marcxml:subfield[fn:matches(@code , '[efhklmnoprstvxyz]')])
                ) then
                (<rdf:type rdf:resource="http://id.loc.gov/ontologies/bibframe/Organization"/>,
				<rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Organization"/>)
				
            else (),
            if ($record/marcxml:datafield[@tag='151']) then
                <rdf:type rdf:resource="http://www.loc.gov/standards/mads/rdf/v1#Geographic"/>
            else ()
            )
    let $properties := 
        ( 	<rdfs:label>{string-join($record/marcxml:datafield[@tag='100' or @tag='110' or @tag='151'])}</rdfs:label>,
            for $df in $df046
                let $source:=if ($df/marcxml:subfield[@code='2']) then fn:concat("(", fn:string($df/marcxml:subfield[@code='2']),") ") else ("")
                return
                   (if ($df/marcxml:subfield[@code='f']) then
                         element madsrdf:birthDate{
                            element skos:Concept {
                                element rdfs:label{fn:concat($source, $df/marcxml:subfield[@code='f'][1]/text())},
                                for $sf in $df/marcxml:subfield[fn:matches(@code, '(u|v)')]
                                return 
                                    element madsrdf:hasSource {
                                        element madsrdf:Source{
                                            element rdfs:label {$sf/text()}
                                    }}
                            }}
                    else (), 
                    if ($df/marcxml:subfield[@code='g']) then
                        element madsrdf:deathDate{
                            element skos:Concept {
                                element rdfs:label{fn:concat($source, $df/marcxml:subfield[@code='g']/text())},
                                for $sf in $df/marcxml:subfield[fn:matches(@code, '(u|v)')]
                                return 
                                    element madsrdf:hasSource {
                                        element madsrdf:Source{
                                            element rdfs:label {$sf/text()}
                                    }}
                            }}
                    else (),
                    if ($df/marcxml:subfield[@code='s']) then
                        element madsrdf:activityStartDate {
                           element skos:Concept {
                                element rdfs:label{fn:concat($source, $df/marcxml:subfield[@code='s']/text())},
                                for $sf in $df/marcxml:subfield[fn:matches(@code, '(u|v)')]
                                return 
                                    element madsrdf:hasSource {
                                        element madsrdf:Source{
                                            element rdfs:label {$sf/text()}
                                    }}
                            }}
                    else (),
                    if ($df/marcxml:subfield[@code='t']) then
                        element madsrdf:activityEndDate {
                            element skos:Concept {
                                element rdfs:label{fn:concat($source, $df/marcxml:subfield[@code='t']/text())},
                                for $sf in $df/marcxml:subfield[fn:matches(@code, '(u|v)')]
                                return 
                                    element madsrdf:hasSource {
                                        element madsrdf:Source{
                                            element rdfs:label {$sf/text()}
                                    }}
                            }}
                    else (),
                    if ($df/marcxml:subfield[@code='q']) then
                        element madsrdf:establishDate {
                            element skos:Concept {
                                element rdfs:label{fn:concat($source, $df/marcxml:subfield[@code='q']/text())},
                                for $sf in $df/marcxml:subfield[fn:matches(@code, '(u|v)')]
                                return 
                                    element madsrdf:hasSource {
                                        element madsrdf:Source{
                                            element rdfs:label {$sf/text()}
                                    }}
                            }}
                    else (),
                    if ($df/marcxml:subfield[@code='r']) then
                        element madsrdf:terminateDate{
                            element skos:Concept {
                                element rdfs:label{fn:concat($source, $df/marcxml:subfield[@code='r']/text())},
                                for $sf in $df/marcxml:subfield[fn:matches(@code, '(u|v)')]
                                return 
                                    element madsrdf:hasSource {
                                        element madsrdf:Source{
                                            element rdfs:label {$sf/text()}
                                    }}
                            }}
                    else ()
                    ),
            for $df in $df368 
		   	  let $source:=if ($df/marcxml:subfield[@code='2']) then fn:concat("(", fn:string($df/marcxml:subfield[@code='2']),") ") else ("")
              return
                ( for $sf in $df/marcxml:subfield[fn:matches(@code,'(a|b|c)')]
                    return element madsrdf:entityDescriptor {
                             element skos:Concept {
                                element rdfs:label {fn:concat($source,$sf/text())},  
                                for $sf in $df/marcxml:subfield[fn:matches(@code, '(u|v|0)')]
                                return 
                                   element madsrdf:hasSource {
                                     element madsrdf:Source{
                                       element rdfs:label {$sf/text()}
                                   }}
                              }},                      
                  for $sf in $df/marcxml:subfield[@code='d']
                    return element madsrdf:honoraryTitle {
                             element skos:Concept {
                                element rdfs:label {fn:concat($source,$sf/text())},  
                                for $sf in $df/marcxml:subfield[fn:matches(@code, '(u|v|0)')]
                                return 
                                   element madsrdf:hasSource {
                                     element madsrdf:Source{
                                       element rdfs:label {$sf/text()}
                                   }}
                              }}
                ),
            for $df in $df370
            let $source:=if ($df/marcxml:subfield[@code='2'][1]) then fn:concat("(", fn:string($df/marcxml:subfield[@code='2'][1]),") ") else ("")
                return
    				(for $sf in $df/marcxml:subfield[@code='a']
                        return element madsrdf:birthPlace { 
                            element madsrdf:Geographic {
                                    element rdfs:label {fn:concat($source,$sf/text())},
                                    for $sf in $df/marcxml:subfield[fn:matches(@code, '(u|v|0)')]
                                    return 
                                        element madsrdf:hasSource {
                                            element madsrdf:Source{
                                                element rdfs:label {$sf/text()}
                                        }}
                            }},
                     for $sf in $df/marcxml:subfield[@code='b']
                        return element madsrdf:deathPlace { 
                            element madsrdf:Geographic {
                                    element rdfs:label {fn:concat($source,$sf/text())},
                                    for $sf in $df/marcxml:subfield[fn:matches(@code, '(u|v|0)')]
                                    return 
                                        element madsrdf:hasSource {
                                            element madsrdf:Source{
                                                element rdfs:label {$sf/text()}
                                        }}
                            }},
     				for $sf in $df/marcxml:subfield[fn:matches(@code,'(c|e|f)')]
                         return element madsrdf:associatedLocale { 
                            element madsrdf:Geographic {
                                    element rdfs:label {fn:concat($source,$sf/text())},
                                    for $sf in $df/marcxml:subfield[fn:matches(@code, '(u|v|0)')]
                                    return 
                                        element madsrdf:hasSource {
                                            element madsrdf:Source{
                                                element rdfs:label {$sf/text()}
                                        }}
                            }}
                    ),
            for $sf in $df371
             return
                   element madsrdf:hasAffiliation {
                   element madsrdf:Affiliation {
                   element madsrdf:hasAffiliationAddress {
                       element madsrdf:Address {
                         for $sfa at $i in $sf/marcxml:subfield[@code='a']
                            return
                                 ( if ($i =1)  then
                                           element madsrdf:streetAddress {$sfa[1]/text()}
                                   else element madsrdf:extendedAddress {$sfa/text()}
                                  ),
                         if ($sf/marcxml:subfield[@code='b']) then
                              element madsrdf:city {$sf/marcxml:subfield[@code='b']/text()}
                         else (),
                         if ($sf/marcxml:subfield[@code='c']) then
                              element madsrdf:state {$sf/marcxml:subfield[@code='c']/text()}
                         else (),
                         if ($sf/marcxml:subfield[@code='d']) then
                              element madsrdf:country {$sf/marcxml:subfield[@code='d']/text()}
                         else (),    
                         if ($sf/marcxml:subfield[@code='e']) then
                              element madsrdf:postcode{$sf/marcxml:subfield[@code='e']/text()}
                         else ()
                       }},
                       for $esf in $sf/marcxml:subfield[@code='m']
                         return
                             element madsrdf:email {$esf/text()},
                       for $so in $sf/marcxml:subfield[fn:matches(@code,'(v|u)')]
                         return 
                            element madsrdf:hasSource {
                              element madsrdf:Source{
                                element rdfs:label {$so/text()}
                            }}
                }},
            for $df in $df372
			 	let $source:=if ($df/marcxml:subfield[@code='2']) then fn:concat("(", fn:string($df/marcxml:subfield[@code='2']),") ") else ("")
                return 
                  (for $sf in $df/marcxml:subfield[fn:matches(@code, '(a|s|t)')]
                        return element madsrdf:fieldOfActivity {
                                   element skos:Concept {
                                    element rdfs:label {fn:concat($source, $sf/text())},
                                    for $sf in $df/marcxml:subfield[fn:matches(@code,'(v|u|0)')]
                                      return 
                                        element madsrdf:hasSource {
                                            element madsrdf:Source{
                                               element rdfs:label {$sf/text()}
                                        }}
                                  }}
                  ),
            for $df in $df373
             let $source:=if ($df/marcxml:subfield[@code='2']) then fn:concat("(", fn:string($df/marcxml:subfield[@code='2']),") ") else ("")
             return
                      element madsrdf:hasAffiliation {
                           element madsrdf:Affiliation {
                            for $a in $df/marcxml:subfield[@code='a']
                                return
                                   element madsrdf:organization {
                                    element madsrdf:Organization{
                                        element rdfs:label {fn:concat($source, $a/text())}
                                   }},
                             if ($df/marcxml:subfield[@code='s']) then
                                   element madsrdf:affiliationStart {
                                    $df/marcxml:subfield[@code='s']/text()}
                             else (),
                             if ($df/marcxml:subfield[@code='t']) then
                                   element madsrdf:affiliationEnd {
                                    $df/marcxml:subfield[@code='t']/text()}
                             else (),
                             for $sf in $df/marcxml:subfield[fn:matches(@code, '(u|v|0)')]
                                return 
                                   element madsrdf:hasSource {
                                     element madsrdf:Source{
                                       element rdfs:label {$sf/text()}
                                   }}
                           }}, 
            for $df in $df374
				let $source:=if ($df/marcxml:subfield[@code='2']) then fn:concat("(", fn:string($df/marcxml:subfield[@code='2']),") ") else ("")
                return 
                   ( for $sf in $df/marcxml:subfield[@code='a']
                        return element madsrdf:occupation {
                                element madsrdf:Occupation {
                                    element rdfs:label {fn:concat($source,$sf/text())},
                                    for $sf in $df/marcxml:subfield[fn:matches(@code, '(u|v|0)')]
                                        return 
                                           element madsrdf:hasSource {
                                             element madsrdf:Source{
                                               element rdfs:label {$sf/text()}
                                           }}
                                    
                                }}
                    ),	
            for $df in $df375
				let $source:=if ($df/marcxml:subfield[@code='2']) then fn:concat("(", fn:string($df/marcxml:subfield[@code='2']),") ") else ("")
                return 
                   ( for $sf in $df/marcxml:subfield[@code='a']
                        return element madsrdf:gender {
                                 element skos:Concept {
                                    element rdfs:label {fn:concat($source,$sf/text())},  
                                    for $sf in $df/marcxml:subfield[fn:matches(@code, '(u|v|0)')]
                                    return 
                                       element madsrdf:hasSource {
                                         element madsrdf:Source{
                                           element rdfs:label {$sf/text()}
                                       }}
                              }}
                    ),	
            for $df in $df376
				let $source:=if ($df/marcxml:subfield[@code='2']) then fn:concat("(", fn:string($df/marcxml:subfield[@code='2']),") ") else ("")
                return 
                   ( for $sf in $df/marcxml:subfield[@code='a']
                        return element madsrdf:entityDescriptor {
                                 element skos:Concept {
                                    element rdfs:label {fn:concat($source,$sf/text())},  
                                    for $sf in $df/marcxml:subfield[fn:matches(@code, '(u|v|0)')]
                                    return 
                                       element madsrdf:hasSource {
                                         element madsrdf:Source{
                                           element rdfs:label {$sf/text()}
                                       }}
                              }},	
                    for $sf in $df/marcxml:subfield[@code='b']
                        return element madsrdf:prominentFamilyMember {
                                 element skos:Concept {
                                    element rdfs:label {fn:concat($source,$sf/text())},  
                                    for $sf in $df/marcxml:subfield[fn:matches(@code, '(u|v|0)')]
                                    return 
                                       element madsrdf:hasSource {
                                         element madsrdf:Source{
                                           element rdfs:label {$sf/text()}
                                       }}
                              }},	
                    for $sf in $df/marcxml:subfield[@code='c']
                        return element madsrdf:honoraryTitle {
                                 element skos:Concept {
                                    element rdfs:label {fn:concat($source,$sf/text())},  
                                    for $sf in $df/marcxml:subfield[fn:matches(@code, '(u|v|0)')]
                                    return 
                                       element madsrdf:hasSource {
                                         element madsrdf:Source{
                                           element rdfs:label {$sf/text()}
                                       }}
                              }}
                   ),
            for $df in $df377
			    let $source:=if ($df/marcxml:subfield[@code='2']) then fn:concat("(", fn:string($df/marcxml:subfield[@code='2']),") ") else ("")
                return 
                   ( for $sf in $df/marcxml:subfield[fn:matches(@code,'(a|l)')]
                        return 
                            element madsrdf:associatedLanguage {
                                element madsrdf:Language {
                                    element rdfs:label {fn:concat($source,$sf/text())}
                            }}
                   )
       )
	   (:<!-- if ($types/rdf:type/@rdf:resource!='http://www.loc.gov/standards/mads/rdf/v1.html#Geographic') then -->
					<!-- attribute rdf:resource {"http://id.loc.gov/rwo/agents/"}, -->
					           
				<!-- else () -->:)
				
    let $rwo := 
        (if ($types) then
            (:element madsrdf:identifiesRWO {  :)
                element madsrdf:RWO {attribute rdf:about {fn:concat("http://id.loc.gov/rwo/agents/",fn:normalize-space($identifier))},
					$types,$properties				
				}
            (:}:)
        else ()
		)
    return <rdf:RDF>{$rwo}</rdf:RDF>
};