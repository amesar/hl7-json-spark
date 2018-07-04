package org.amm.hl7

import scala.collection._
import scala.collection.JavaConverters._
import ca.uhn.hl7v2.model.{Message,Structure,Segment,Group}
import ca.uhn.hl7v2.DefaultHapiContext
import ca.uhn.hl7v2.parser.Parser

class HapiParser(validate: Boolean, explodeFieldComponents: Boolean = true, replaceNames: Boolean = false) {
  //println(s"HapiParse: validate=$validate explodeFieldComponents=$explodeFieldComponents replaceNames=$replaceNames")
  val context = new DefaultHapiContext()
  val parser = context.getGenericParser()
  context.getParserConfiguration().setValidating(validate);

  def parse(content: String) : Map[String,Any] = {
    val version = parser.getVersion(content)
    //println(s"HL7 Version=$version")
    val msg = parser.parse(content)
    val map = mutable.LinkedHashMap.empty[String, Any]
    walkGroup(map, msg)
    map
  }

  def walkGroup(mapParent: mutable.Map[String,Any], group: Group) : Unit = {
    for (name <- group.getNames().toSeq) {
      val structs = group.getAll(name)
      if (structs.size > 0) {
        for (st <- structs) {
          val map = mutable.LinkedHashMap.empty[String, Any]
          mapParent += (name -> map)
          st match {
            case seg: Segment => walkSegment(map,seg)
            case group: Group => walkGroup(map,group)
            case _ => println(s"WARNING: TODO: STRUCTURE=${st.getName} CLASS=${st.getClass}")
          }
        }
      }
    }
  }

  def walkSegment(map: mutable.Map[String,Any], seg: Segment) = {
    val names = seg.getNames.toArray
    for (f <- 1 to seg.numFields) {
      val flds = seg.getField(f).toSeq
      if (flds.size == 1) {
        val name = names(f-1)
        val fld = flds(0)
        try {
          val v = fld.encode
          if (!explodeFieldComponents) {
            map += (createName(name,fld.getName,f) -> v)
          } else {
            val values = v.split("\\^").toSeq
            if (values.size == 1) {
              map += (createName(name,fld.getName,f) -> v)
            } else {
              val map2 = mutable.LinkedHashMap.empty[String, Any]
              map += (createName(name,fld.getName,f) -> map2)
              val nmap = NameMapping.segments.getOrElse(seg.getName+"_"+fld.getName,null)
              for ((v,c) <- values.zipWithIndex) {
                val c1 = c+1
                if (replaceNames && nmap != null) {
                  val name = nmap.getOrElse(c1,null)
                  if (name != null) {
                    map2 += (name -> v)
                  } else {
                    map2 += (s"Comp${c1}"  -> v)
                  } 
                } else {
                  map2 += (s"Comp${c1}"  -> v)
                } 
              }
            }
          }
       } catch {
         case e: Exception => {
           println(s"WARNING: Cannot encode field '$name' '$fld.Name' $f. Error: ${e.getMessage}")
        }
       }
      } else if (flds.size > 1) {
        for (fld <- flds) {
          println(s"WARNING: TODO Repeating fields: SEGMENT=${seg.getName} FIELD=${fld.getName}")
        }
      }
    }
  }

  // TODO: clean this up with proper regex magic
  def createName(name: String, fieldName: String, fieldIndex: Int) : String = {
      if (name==null) fieldName+"_"+fieldIndex  
      else name.replace(" ","_").replace("'","").replace("/","").replace("-","").replace("__","_").replace("(","").replace(")","")
  }
}
