# Converts HL7 v2 to JSON with Spark usage

Converts HL7 v2 to JSON with Spark usage example.

## Requirements:
* Maven 3.5.0
* Scala 2.11.8
* Spark 2.3.0

## Build
```
mvn package
```

## Run

### Run stand-alone HL7 to JSON converter
```
scala -cp target/amm-hl7-json-spark-1.0-SNAPSHOT.jar \
  org.amm.hl7.Driver \
  data/athena/siu/501.hl7
```

#### Data Sample
##### Input Hl7: 
[data/athena/siu/501.hl7](data/athena/siu/501.hl7)
```
MSH|^~\&|ATHENANET|235^TESTPRACTIVE|ATHENA||200403220359||SIU^S12|501|T|2.2||||||||^MSCH|347606|347606||||office visit|office visit|ov^office visit|10|minutes|^^^200403221540|||||emorales|||||||||^MPID||70690|70690||HALL^ROSCOE^||19971006|M|||5255 Skug^^NEW BRIT^CT^06051||(974)575-7194|(848)165-6315||S|||999144488|||||||||||^MPV1|||^^^Brockton||||22^medickinson2||||||||||22^medickinson2|||||||||||||||||||||||||||||||||||^MDG1||ICD9|49390|ASTHCT, UNSPECIFIED TYPE, WITHOUT MENTION OF STATUS ASTHCTTICUS  ASTHCT (BRONCHIAL) (ALLERGIC NOS); BRONCHITIS: ALLERGIC, ASTHCTTIC|||||||||||||||^MRGS|||^MAIG|||medickinson2|||||200403221540|||10|minutes||^MAIL|||2^Brockton|||200403221540|||10|minutes||^\^M
```
#### Output JSON
[samples/501.json](samples/501.json)
```
{
  "AIL" : {
    "UNKNOWN_3" : {
      "Comp1" : "2",
      "Comp2" : "Brockton"
    },
    "UNKNOWN_9" : "10",
    "UNKNOWN_10" : "minutes",
    "UNKNOWN_6" : "200403221540",
    "UNKNOWN_12" : "\u001C"
  },
  "MSH" : {
    "Sending_facility" : {
      "Comp1" : "235",
      "Comp2" : "TESTPRACTIVE"
    },
    "Encoding_characters" : "\\S\\\\R\\\\E\\\\T\\",
    "Processing_ID" : "T",
. . .
```

### Run Spark HL7 to JSON converter
```
spark-submit --class org.amm.hl7.SparkDriver --master local[2] \
 target/amm-hl7-json-spark-1.0-SNAPSHOT.jar \
 data/athena/siu 
```

#### Input Hl7
[data/athena/siu](data/athena/siu)

### Output

#### Schema
[samples/siu_schema.txt](samples/siu_schema.txt)
```
root
 |-- AIG: struct (nullable = true)
 |    |-- UNKNOWN_11: string (nullable = true)
 |    |-- UNKNOWN_12: string (nullable = true)
 |    |-- UNKNOWN_3: string (nullable = true)
 |    |-- UNKNOWN_8: string (nullable = true)
 |-- AIL: struct (nullable = true)
 |    |-- UNKNOWN_10: string (nullable = true)
 |    |-- UNKNOWN_12: string (nullable = true)
 |    |-- UNKNOWN_3: struct (nullable = true)
 |    |    |-- Comp1: string (nullable = true)
 |    |    |-- Comp2: string (nullable = true)
 |    |-- UNKNOWN_6: string (nullable = true)
 |    |-- UNKNOWN_9: string (nullable = true)
 |-- DG1: struct (nullable = true)
 |    |-- Diagnosis_code: string (nullable = true)
 |    |-- Diagnosis_coding_method: string (nullable = true)
 |    |-- Diagnosis_description: string (nullable = true)
 |-- MSH: struct (nullable = true)
 |    |-- Date_Time_of_message: string (nullable = true)
 |    |-- Encoding_characters: string (nullable = true)
 |    |-- Field_separator: string (nullable = true)
 |    |-- Message_Control_ID: string (nullable = true)
 |    |-- Message_type: struct (nullable = true)
 |    |    |-- Comp1: string (nullable = true)
 |    |    |-- Comp2: string (nullable = true)
 |    |-- Processing_ID: string (nullable = true)
 |    |-- Receiving_application: string (nullable = true)
 |    |-- Sending_application: string (nullable = true)
 |    |-- Sending_facility: struct (nullable = true)
 |    |    |-- Comp1: string (nullable = true)
 |    |    |-- Comp2: string (nullable = true)
 |    |-- Version_ID: string (nullable = true)
 |-- PID: struct (nullable = true)
 |    |-- Date_of_Birth: string (nullable = true)
 |    |-- Marital_Status: string (nullable = true)
 |    |-- Patient_Address: struct (nullable = true)
 |    |    |-- City: string (nullable = true)
 |    |    |-- Other_designation: string (nullable = true)
 |    |    |-- State: string (nullable = true)
 |    |    |-- Street_address: string (nullable = true)
 |    |    |-- Zip: string (nullable = true)
 |    |-- Patient_ID_External_ID: string (nullable = true)
 |    |-- Patient_ID_Internal_ID: string (nullable = true)
 |    |-- Patient_Name: struct (nullable = true)
 |    |    |-- Family_name: string (nullable = true)
 |    |    |-- Given_name: string (nullable = true)
 |    |    |-- Middle_initial: string (nullable = true)
 |    |-- Phone_Number_Business: string (nullable = true)
 |    |-- Phone_Number_Home: string (nullable = true)
 |    |-- Sex: string (nullable = true)
 |    |-- Social_security_number_patient: string (nullable = true)
 |-- PV1: struct (nullable = true)
 |    |-- Admitting_Doctor: struct (nullable = true)
 |    |    |-- Comp1: string (nullable = true)
 |    |    |-- Comp2: string (nullable = true)
 |    |-- Assigned_Patient_Location: struct (nullable = true)
 |    |    |-- Comp1: string (nullable = true)
 |    |    |-- Comp2: string (nullable = true)
 |    |    |-- Comp3: string (nullable = true)
 |    |    |-- Comp4: string (nullable = true)
 |    |-- Attending_Doctor: struct (nullable = true)
 |    |    |-- Comp1: string (nullable = true)
 |    |    |-- Comp2: string (nullable = true)
 |-- SCH: struct (nullable = true)
 |    |-- UNKNOWN_1: string (nullable = true)
 |    |-- UNKNOWN_10: string (nullable = true)
 |    |-- UNKNOWN_11: struct (nullable = true)
 |    |    |-- Comp1: string (nullable = true)
 |    |    |-- Comp2: string (nullable = true)
 |    |    |-- Comp3: string (nullable = true)
 |    |    |-- Comp4: string (nullable = true)
 |    |-- UNKNOWN_16: string (nullable = true)
 |    |-- UNKNOWN_2: string (nullable = true)
 |    |-- UNKNOWN_6: string (nullable = true)
 |    |-- UNKNOWN_7: string (nullable = true)
 |    |-- UNKNOWN_8: struct (nullable = true)
 |    |    |-- Comp1: string (nullable = true)
 |    |    |-- Comp2: string (nullable = true)
 |    |-- UNKNOWN_9: string (nullable = true)
```

#### Queries
[samples/siu_queries.sql](samples/siu_queries.sql)
```
select count(*) as count,DG1.Diagnosis_code, substr(DG1.Diagnosis_description,0,100) as Diagnosis_description 
from siu group by Diagnosis_code, Diagnosis_description order by count desc

+-----+--------------+----------------------------------------------------------------------------------------------------+
|count|Diagnosis_code|Diagnosis_description                                                                               |
+-----+--------------+----------------------------------------------------------------------------------------------------+
|9    |3829          |UNSPECIFIED OTITIS MEDIA  OTITIS MEDIA: NOS, ACUTE NOS, CHRONIC NOS                                 |
|5    |V202          |ROUTINE INFANT OR CHILD HEALTH CHECK                                                                |
|5    |4659          |ACUTE UPPER RESPIRATORY INFECTIONS OF UNSPECIFIED SITE  ACUTE URI NOS; UPPER RESPIRATORY INFECTION (|
|3    |37230         |CONJUNCTIVITIS, UNSPECIFIED                                                                         |
|3    |8798          |OPEN WOUND OF OTHER AND UNSPECIFIED PARTS OF TRUNK, COMPLICATED                                     |
|3    |46619         |ACUTE BRONCHIOLITIS DUE TO OTHER INFECTIOUS ORGANISMS  USE ADDITIONAL CODE TO IDENTIFY ORGANISM     |
. . . 


select PID.Patient_Address.State, count(*) as count,DG1.Diagnosis_code, 
  substr(DG1.Diagnosis_description,0,100) as Diagnosis_description 
from siu group by PID.Patient_Address.State,Diagnosis_code, Diagnosis_description order by state,count desc

+-----+-----+--------------+----------------------------------------------------------------------------------------------------+
|State|count|Diagnosis_code|Diagnosis_description                                                                               |
+-----+-----+--------------+----------------------------------------------------------------------------------------------------+
|CT   |3    |V202          |ROUTINE INFANT OR CHILD HEALTH CHECK                                                                |
|CT   |2    |8798          |OPEN WOUND OF OTHER AND UNSPECIFIED PARTS OF TRUNK, COMPLICATED                                     |
|CT   |1    |null          |no current diagnosis                                                                                |
|CT   |1    |07999         |UNSPECIFIED VIRAL INFECTION  VIRAL INFECTIONS NOS                                                   |
|CT   |1    |5589          |OTHER AND UNSPECIFIED NONINFECTIOUS GASTROENTERITIS AND COLITIS  {COLITIS} {ENTERITIS} {GASTROENTERI|
. . . 


select PID.Patient_Name.Family_name, PID.Patient_Name.Given_name, 
  PID.Patient_Address.Zip, 
  PID.Patient_Address.State, PID.Patient_Address.City, 
  PID.Patient_Address.Street_address, 
  DG1.Diagnosis_code, substr(DG1.Diagnosis_description,0,70) as Diagnosis_description 
from siu order by State, City

+-----------+----------+-----+-----+------------------------+---------------+--------------+----------------------------------------------------------------------+
|Family_name|Given_name|Zip  |State|City                    |Street_address |Diagnosis_code|Diagnosis_description                                                 |
+-----------+----------+-----+-----+------------------------+---------------+--------------+----------------------------------------------------------------------+
|THOMPSON   |SANG      |06605|CT   |BRIDGEPORT              |5297 Monatiquot|V202          |ROUTINE INFANT OR CHILD HEALTH CHECK                                  |
|GARCIA     |VANNESSA  |06605|CT   |BRIDGEPORT              |6455 Saugus    |V202          |ROUTINE INFANT OR CHILD HEALTH CHECK                                  |
|ANDERSON   |CLEMENTE  |06071|CT   |CONNECTICUT STATE PRISON|2275 Rowley    |8798          |OPEN WOUND OF OTHER AND UNSPECIFIED PARTS OF TRUNK, COMPLICATED       |
|JACKSON    |SHELLY    |06335|CT   |GALES FERRY             |5229 Stillwater|8798          |OPEN WOUND OF OTHER AND UNSPECIFIED PARTS OF TRUNK, COMPLICATED       |
|HALL       |ROSCOE    |06051|CT   |NEW BRIT                |5255 Skug      |49390         |ASTHCT, UNSPECIFIED TYPE, WITHOUT MENTION OF STATUS ASTHCTTICUS  ASTHC|
. . . 
```
