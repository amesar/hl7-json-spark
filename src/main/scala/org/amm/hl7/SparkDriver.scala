package org.amm.hl7

import org.apache.spark.sql.SparkSession
import org.amm.util.Utils

object SparkDriver {
  def main(args: Array[String]) {
    if (args.length < 1) {
      println("ERROR: Missing HL7_data_directory validate (optional) replaceNames (optional) ")
      System.exit(1)
    }
    val spark = SparkSession.builder().enableHiveSupport().appName("SparkHl7Driver").getOrCreate()
    val validate = if (args.length > 1) args(1).toBoolean else false
    val replaceNames = if (args.length > 2) args(2).toBoolean else false
    process(spark, args(0), validate, replaceNames)
  }

  def process(spark: SparkSession, dataDir: String, validate: Boolean, replaceNames: Boolean) = {
    import spark.implicits._
    println(s"dataDir=$dataDir")
    println(s"validate=$validate replaceNames=$replaceNames")

    val dfData = spark.sparkContext.wholeTextFiles(s"$dataDir/*.hl7").toDF("path","data").select("data")
    val rddHL7String = dfData.rdd.map(_.getAs[String](0))
    val rddJsonString = rddHL7String.map(hl7Data => {
      val hapiParser = new HapiParser(validate,true,replaceNames)
      val map = hapiParser.parse(hl7Data)
      val jmap = Utils.toJava(map).asInstanceOf[java.util.Map[String,Any]]
      Utils.toJsonPretty(jmap)
    })
    val dfJson = spark.read.json(rddJsonString.toDF.select("*").rdd.map(_.getAs[String](0)))
    println(s"\ndf.count=${dfJson.count}")

    println("\nSCHEMA:\n")
    dfJson.printSchema

    val table = "tbl"
    dfJson.createOrReplaceTempView(table)
    doQueries(spark,table)
  }

  def doQueries(spark: SparkSession, table: String) {
    println("\nTABLE SCHEMA:\n")
    doQuery(spark,"describe formatted tbl")

    println("\nQUERIES:\n")

    doQuery(spark,s"select count(*) as count,DG1.Diagnosis_code, substr(DG1.Diagnosis_description,0,100) as Diagnosis_description from $table group by Diagnosis_code, Diagnosis_description order by count desc")

    doQuery(spark,s"select PID.Patient_Address.State, count(*) as count,DG1.Diagnosis_code, substr(DG1.Diagnosis_description,0,100) as Diagnosis_description from $table group by PID.Patient_Address.State,Diagnosis_code, Diagnosis_description order by state,count desc")

    doQuery(spark,s"select PID.Patient_Name.Family_name, PID.Patient_Name.Given_name, PID.Patient_Address.Zip, PID.Patient_Address.State, PID.Patient_Address.City, PID.Patient_Address.Street_address, DG1.Diagnosis_code, substr(DG1.Diagnosis_description,0,70) as Diagnosis_description from $table order by State, City")
  }

  def doQuery(spark: SparkSession, query: String) {
    println(s"$query")
    spark.sql(query).show(1000,false)
  }
}
