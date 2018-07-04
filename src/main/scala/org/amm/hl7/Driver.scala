package org.amm.hl7

import scala.io.Source
import org.amm.util.Utils

object Driver {
  //val logger = org.slf4j.LoggerFactory.getLogger(getClass.getName)
  val logger = org.apache.log4j.Logger.getLogger(this.getClass())

  val replaceNames = true
  def main(args: Array[String]) {
    println(">> main: class="+getClass.getName)
    logger.info(">> log.info")
    logger.debug(">> log.debug")
    logger.error(">> log.error")
    if (args.length < 1) {
      println("ERROR: Missing HL7_file validate replaceNames")
      System.exit(1)
    }
    val ifname = args(0)
    val validate = if (args.length > 1) args(1).toBoolean else false
    val replaceNames = if (args.length > 2) args(2).toBoolean else true
    println(s"File=$ifname")
    println(s"Validate=$validate ReplaceNames=$replaceNames")

    val parser = new HapiParser(validate,true,replaceNames)
    val hl7 = Source.fromFile(ifname).mkString
    val map = parser.parse(hl7)

    val jmap = Utils.toJava(map).asInstanceOf[java.util.Map[String,Any]]
    val json = Utils.toJsonPretty(jmap)
    println(json)
  }
}
