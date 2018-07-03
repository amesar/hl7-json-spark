# Converts HL7 v2 to JSON with Spark usage

Converts HL7 v2 to JSON with Spark usage example.

## Build
```
mvn package
```

## Run
```
scala -cp target/amm-hl7-json-spark-1.0-SNAPSHOT.jar \
  org.amm.hl7.Driver \
  data/athena/siu/501.hl7
```

## Data Sample
### Input Hl7: 
[data/athena/siu/501.hl7](data/athena/siu/501.hl7)
```
MSH|^~\&|ATHENANET|235^TESTPRACTIVE|ATHENA||200403220359||SIU^S12|501|T|2.2||||||||^MSCH|347606|347606||||office visit|office visit|ov^office visit|10|minutes|^^^200403221540|||||emorales|||||||||^MPID||70690|70690||HALL^ROSCOE^||19971006|M|||5255 Skug^^NEW BRIT^CT^06051||(974)575-7194|(848)165-6315||S|||999144488|||||||||||^MPV1|||^^^Brockton||||22^medickinson2||||||||||22^medickinson2|||||||||||||||||||||||||||||||||||^MDG1||ICD9|49390|ASTHCT, UNSPECIFIED TYPE, WITHOUT MENTION OF STATUS ASTHCTTICUS  ASTHCT (BRONCHIAL) (ALLERGIC NOS); BRONCHITIS: ALLERGIC, ASTHCTTIC|||||||||||||||^MRGS|||^MAIG|||medickinson2|||||200403221540|||10|minutes||^MAIL|||2^Brockton|||200403221540|||10|minutes||^\^M
```
### Output JSON
[sample/501.json](sample/501.json)
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
