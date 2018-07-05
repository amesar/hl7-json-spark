# Converts HL7 v2.3 to JSON with SQL queries (Postgres, Spark)

Translates HL7 v2.3 data into JSON. 

The JSON can then be loaded into a SQL engine such as Spark or Postgres and analyzed with standard SQL queries.

## Overview

### Implementations
* Basic - converts a HL7 file to JSON
* Postgres - converts HL7 files to JSON and loads them into Postgres as [jsonb](https://www.postgresql.org/docs/current/static/datatype-json.html) column
* Spark - loads HL7 files into Spark as JSON

### Core logic
* Parse HL7 using [HAPI](https://hapifhir.github.io/hapi-hl7v2/) Java package.
* Create a nested Scala Map[String,Any] representation of HL7 data.
* Convert map to JSON with the venerable [Jackson](https://github.com/FasterXML/jackson) Java package. 

See [org.amm.hl7.HapiParser.scala](src/main/scala/org/amm/hl7/HapiParser.scala) for details.

## Requirements:
* Maven 3.5.0
* Scala 2.11.8
* Spark 2.3.0
* Postgres 

## Build
```
mvn package
```

## Run

### Convert HL7 file into JSON

[Driver.scala](src/main/scala/org/amm/hl7/Driver.scala) converts a HL7 files into JSON.

```
scala -cp target/amm-hl7-json-spark-1.0-SNAPSHOT.jar \
  org.amm.hl7.Driver \
  data/athena/siu/501.hl7
```

#### Data Sample
##### Input Hl7: 
[data/athena/siu/501.hl7](data/athena/siu/501.hl7)
```
MSH|^~\&|ATHENANET|235^TESTPRACTIVE|ATHENA||200403220359||SIU^S12|501|T|2.2||||||||
SCH|347606|347606||||office visit|office visit|ov^office visit|10|minutes|^^^200403221540|||||emorales|||||||||
PID||70690|70690||HALL^ROSCOE^||19971006|M|||5255 Skug^^NEW BRIT^CT^06051||(974)575-7194|(848)165-6315||S|||999144488|||||||||||
PV1|||^^^Brockton||||22^medickinson2||||||||||22^medickinson2|||||||||||||||||||||||||||||||||||
DG1||ICD9|49390|ASTHCT, UNSPECIFIED TYPE, WITHOUT MENTION OF STATUS ASTHCTTICUS  ASTHCT (BRONCHIAL) (ALLERGIC NOS); BRONCHITIS: ALLERGIC, ASTHCTTIC|||||||||||||||
RGS|||
AIG|||medickinson2|||||200403221540|||10|minutes||
AIL|||2^Brockton|||200403221540|||10|minutes||
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

### Run Postgres SQL queries on JSON data

#### Create the database and table

```
create database hl7;
create table siu (data jsonb not null) ;
```

#### Convert HL7 files to JSON

```
mkdir -p out
dir=data/athena/siu
files=`ls $dir/*.hl7`
for file in $files ; do
  scala -cp target/amm-hl7-json-spark-1.0-SNAPSHOT.jar \
    org.amm.hl7.Driver $dir/$file > out/$file.json
done
```

#### Load JSON files into Postgres

```
files=`ls out/*.json`
for file in $files ; do
  echo "insert into siu values ('" > _tmp.sql
  cat $file >> _tmp.sql
  echo "');" >> _tmp.sql
  psql -U MY_USER -f _tmp.sql hl7
  done
```

#### Run queries
For more queries, see the section Queries.

```
select data #>> '{DG1,Diagnosis_code}' as Diagnosis_code from siu;
```

### Run Spark SQL queries on JSON data

[SparkDriver.scala](src/main/scala/org/amm/hl7/SparkDriver.scala) converts a directory of HL7 files into JSON, and then executes some standard SQL queries on the JSON.

```
spark-submit --class org.amm.hl7.SparkDriver --master local[2] \
 target/amm-hl7-json-spark-1.0-SNAPSHOT.jar \
 data/athena/siu 
```

#### Input Hl7
[data/athena/siu](data/athena/siu)

### Output

#### Describe table siu
```
AIG	struct<UNKNOWN_11:string,UNKNOWN_12:string,UNKNOWN_3:string,UNKNOWN_8:string>	NULL
AIL	struct<UNKNOWN_10:string,UNKNOWN_12:string,UNKNOWN_3:struct<Comp1:string,Comp2:string>,UNKNOWN_6:string,UNKNOWN_9:string>	NULL
DG1	struct<Diagnosis_code:string,Diagnosis_coding_method:string,Diagnosis_description:string>	NULL
MSH	struct<Date_Time_of_message:string,Encoding_characters:string,Field_separator:string,Message_Control_ID:string,Message_type:struct<Comp1:string,Comp2:string>,Processing_ID:string,Receiving_application:string,Sending_application:string,Sending_facility:struct<Comp1:string,Comp2:string>,Version_ID:string>	NULL
PID	struct<Date_of_Birth:string,Marital_Status:string,Patient_Address:struct<City:string,Other_designation:string,State:string,Street_address:string,Zip:string>,Patient_ID_External_ID:string,Patient_ID_Internal_ID:string,Patient_Name:struct<Family_name:string,Given_name:string,Middle_initial:string>,Phone_Number_Business:string,Phone_Number_Home:string,Sex:string,Social_security_number_patient:string>	NULL
PV1	struct<Admitting_Doctor:struct<Comp1:string,Comp2:string>,Assigned_Patient_Location:struct<Comp1:string,Comp2:string,Comp3:string,Comp4:string>,Attending_Doctor:struct<Comp1:string,Comp2:string>>	NULL
SCH	struct<UNKNOWN_1:string,UNKNOWN_10:string,UNKNOWN_11:struct<Comp1:string,Comp2:string,Comp3:string,Comp4:string>,UNKNOWN_16:string,UNKNOWN_2:string,UNKNOWN_6:string,UNKNOWN_7:string,UNKNOWN_8:struct<Comp1:string,Comp2:string>,UNKNOWN_9:string>	NULL
```

#### DataFrame Schema

df.printSchema: [samples/spark_siu_schema.txt](samples/spark_siu_schema.txt)
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

#### Run queries
For more queries, see the section Queries.

```
select DG1.Diagnosis_code from siu;
```


## Queries

Queries:
  * Postgres queries: [samples/postgres_siu_queries.sql](samples/postgres_siu_queries.sql).
  * Spark queries: [samples/spark_siu_queries.sql](samples/spark_siu_queries.sql).

##### Count of diagnosis codes and descriptions
```
Spark

select count(*) as count,
  DG1.Diagnosis_code, 
  DG1.Diagnosis_description as Diagnosis_description 
from siu 
  group by Diagnosis_code, Diagnosis_description 
  order by count desc

Postgres

select count(*) as count,
  data #>> '{DG1,Diagnosis_code}' as Diagnosis_code,
  data #>> '{DG1,Diagnosis_description}' as Diagnosis_description
from siu 
  group by Diagnosis_code, Diagnosis_description 
  order by count desc;

Result

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
```

##### Count of diagnosis codes and descriptions by state

```
Spark

select 
  PID.Patient_Address.State, 
  count(*) as count,DG1.Diagnosis_code, 
  DG1.Diagnosis_description as Diagnosis_description 
from siu 
  group by PID.Patient_Address.State,Diagnosis_code, Diagnosis_description 
  order by state,count desc

Postgres

select
  data #>> '{PID,Patient_Name,Family_name}' as Family_name,
  data #>> '{PID,Patient_Name,Given_name}' as Given_name,
  data #>> '{PID,Patient_Address,Zip}' as Zip,
  data #>> '{PID,Patient_Address,State}' as State,
  data #>> '{PID,Patient_Address,City}' as City,
  data #>> '{PID,Patient_Address,Street_address}' as Street_address,
  data #>> '{DG1,Diagnosis_code}' as Diagnosis_code,
  data #>> '{DG1,Diagnosis_description}' as Diagnosis_description
from siu 
  order by State, City ;

select
  data #>> '{PID,Patient_Address,State}' as State,
  count(*) as count,
  data #>> '{DG1,Diagnosis_code}' as Diagnosis_code,
  data #>> '{DG1,Diagnosis_description}' as Diagnosis_description
from siu 
  group by State,Diagnosis_code, Diagnosis_description 
  order by State,count desc;

Result

+-----+-----+--------------+----------------------------------------------------------------------------------------------------+
|State|count|Diagnosis_code|Diagnosis_description                                                                               |
+-----+-----+--------------+----------------------------------------------------------------------------------------------------+
|CT   |3    |V202          |ROUTINE INFANT OR CHILD HEALTH CHECK                                                                |
|CT   |2    |8798          |OPEN WOUND OF OTHER AND UNSPECIFIED PARTS OF TRUNK, COMPLICATED                                     |
. . . 
|MA   |8    |3829          |UNSPECIFIED OTITIS MEDIA  OTITIS MEDIA: NOS, ACUTE NOS, CHRONIC NOS                                 |
|MA   |3    |37230         |CONJUNCTIVITIS, UNSPECIFIED                                                                         |
|MA   |3    |4659          |ACUTE UPPER RESPIRATORY INFECTIONS OF UNSPECIFIED SITE  ACUTE URI NOS; UPPER RESPIRATORY INFECTION (|
. . . 
|RI   |2    |4659          |ACUTE UPPER RESPIRATORY INFECTIONS OF UNSPECIFIED SITE  ACUTE URI NOS; UPPER RESPIRATORY INFECTION (|
|RI   |1    |490           |BRONCHITIS, NOT SPECIFIED AS ACUTE OR CHRONIC  BRONCHITIS NOS: CATARRHAL, WITH TRACHEITIS NOS; TRACH|
. . . 
```


##### Show patient diagnoses
```
Spark

select 
  PID.Patient_Name.Family_name, 
  PID.Patient_Name.Given_name, 
  PID.Patient_Address.Zip, 
  PID.Patient_Address.State, 
  PID.Patient_Address.City, 
  PID.Patient_Address.Street_address, 
  DG1.Diagnosis_code, 
  DG1.Diagnosis_description as Diagnosis_description 
from siu order by State, City

Postgres

select
  data #>> '{PID,Patient_Name,Family_name}' as Family_name,
  data #>> '{PID,Patient_Name,Given_name}' as Given_name,
  data #>> '{PID,Patient_Address,Zip}' as Zip,
  data #>> '{PID,Patient_Address,State}' as State,
  data #>> '{PID,Patient_Address,City}' as City,
  data #>> '{PID,Patient_Address,Street_address}' as Street_address,
  data #>> '{DG1,Diagnosis_code}' as Diagnosis_code,
  data #>> '{DG1,Diagnosis_description}' as Diagnosis_description
from siu 
  order by State, City ;

Result

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
