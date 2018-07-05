package org.amm.hl7

import scala.io.Source
import org.amm.util.Utils

object Driver {
  val replaceNames = true
  def main(args: Array[String]) {
    if (args.length < 1) {
      println("ERROR: Missing HL7_file validate replaceNames")
      System.exit(1)
    }
    val ifname = args(0)
    val validate = if (args.length > 1) args(1).toBoolean else false
    val replaceNames = if (args.length > 2) args(2).toBoolean else true
    //println(s"File=$ifname")
    //println(s"Validate=$validate ReplaceNames=$replaceNames")

    val parser = new HapiParser(validate,true,replaceNames)
    val hl7 = Source.fromFile(ifname).mkString
    val map = parser.parse(hl7)

    val jmap = Utils.toJava(map).asInstanceOf[java.util.Map[String,Any]]
    val json = Utils.toJsonPretty(jmap)
    println(json)
  }
}
