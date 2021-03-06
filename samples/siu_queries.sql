select count(*) as count,DG1.Diagnosis_code, substr(DG1.Diagnosis_description,0,100) as Diagnosis_description from siu group by Diagnosis_code, Diagnosis_description order by count desc
+-----+--------------+----------------------------------------------------------------------------------------------------+
|count|Diagnosis_code|Diagnosis_description                                                                               |
+-----+--------------+----------------------------------------------------------------------------------------------------+
|9    |3829          |UNSPECIFIED OTITIS MEDIA  OTITIS MEDIA: NOS, ACUTE NOS, CHRONIC NOS                                 |
|5    |V202          |ROUTINE INFANT OR CHILD HEALTH CHECK                                                                |
|5    |4659          |ACUTE UPPER RESPIRATORY INFECTIONS OF UNSPECIFIED SITE  ACUTE URI NOS; UPPER RESPIRATORY INFECTION (|
|3    |37230         |CONJUNCTIVITIS, UNSPECIFIED                                                                         |
|3    |8798          |OPEN WOUND OF OTHER AND UNSPECIFIED PARTS OF TRUNK, COMPLICATED                                     |
|3    |46619         |ACUTE BRONCHIOLITIS DUE TO OTHER INFECTIOUS ORGANISMS  USE ADDITIONAL CODE TO IDENTIFY ORGANISM     |
|2    |07999         |UNSPECIFIED VIRAL INFECTION  VIRAL INFECTIONS NOS                                                   |
|2    |null          |no current diagnosis                                                                                |
|2    |31401         |ATTENTION DEFICIT DISORDER OF CHILDHOOD WITH HYPERACTIVITY    COMBINED TYPE; OVERACTIVITY NOS; PREDO|
|2    |7746          |UNSPECIFIED FETAL AND NEONATAL JAUNDICE  ICTERUS NEONATORUM; NEONATAL HYPERBILIRUBINEMIA (TRANSIENT)|
|1    |07810         |VIRAL WARTS, UNSPECIFIED  CONDYLOMA NOS; VERRUCA NOS: VULGARIS; WARTS (INFECTIOUS)                  |
|1    |7862          |COUGH                                                                                               |
|1    |53550         |UNSPECIFIED GASTRITIS AND GASTRODUODENITIS (WITHOUT MENTION OF HEMORRHAGE)                          |
|1    |38010         |INFECTIVE OTITIS EXTERNA, UNSPECIFIED    OTITIS EXTERNA (ACUTE): NOS, CIRCUMSCRIBED, DIFFUSE, HEMORR|
|1    |5589          |OTHER AND UNSPECIFIED NONINFECTIOUS GASTROENTERITIS AND COLITIS  {COLITIS} {ENTERITIS} {GASTROENTERI|
|1    |78841         |URINARY FREQUENCY  FREQUENCY OF MICTURITION                                                         |
|1    |78079         |OTHER MALAISE AND FATIGUE  ASTHENIA NOS; LETHARGY; POSTVIRAL (ASTHENIC) SYNDROME; TIREDNESS         |
|1    |7242          |LUMBAGO    LOW BACK PAIN; LOW BACK SYNDROME; LUMBALGIA                                              |
|1    |49390         |ASTHCT, UNSPECIFIED TYPE, WITHOUT MENTION OF STATUS ASTHCTTICUS  ASTHCT (BRONCHIAL) (ALLERGIC NOS); |
|1    |7295          |PAIN IN LIMB                                                                                        |
|1    |490           |BRONCHITIS, NOT SPECIFIED AS ACUTE OR CHRONIC  BRONCHITIS NOS: CATARRHAL, WITH TRACHEITIS NOS; TRACH|
|1    |7821          |RASH AND OTHER NONSPECIFIC SKIN ERUPTION    EXANTHEM                                                |
|1    |4619          |ACUTE SINUSITIS, UNSPECIFIED    ACUTE SINUSITIS NOS                                                 |
|1    |7806          |FEVER    CHILLS WITH FEVER; FEVER NOS; HYPERPYREXIA NOS; PYREXIA NOS  PYREXIA OF UNKNWN ORIGIN; FEVE|
+-----+--------------+----------------------------------------------------------------------------------------------------+

select PID.Patient_Address.State, count(*) as count,DG1.Diagnosis_code, substr(DG1.Diagnosis_description,0,100) as Diagnosis_description from siu group by PID.Patient_Address.State,Diagnosis_code, Diagnosis_description order by state,count desc
+-----+-----+--------------+----------------------------------------------------------------------------------------------------+
|State|count|Diagnosis_code|Diagnosis_description                                                                               |
+-----+-----+--------------+----------------------------------------------------------------------------------------------------+
|CT   |3    |V202          |ROUTINE INFANT OR CHILD HEALTH CHECK                                                                |
|CT   |2    |8798          |OPEN WOUND OF OTHER AND UNSPECIFIED PARTS OF TRUNK, COMPLICATED                                     |
|CT   |1    |null          |no current diagnosis                                                                                |
|CT   |1    |07999         |UNSPECIFIED VIRAL INFECTION  VIRAL INFECTIONS NOS                                                   |
|CT   |1    |5589          |OTHER AND UNSPECIFIED NONINFECTIOUS GASTROENTERITIS AND COLITIS  {COLITIS} {ENTERITIS} {GASTROENTERI|
|CT   |1    |3829          |UNSPECIFIED OTITIS MEDIA  OTITIS MEDIA: NOS, ACUTE NOS, CHRONIC NOS                                 |
|CT   |1    |49390         |ASTHCT, UNSPECIFIED TYPE, WITHOUT MENTION OF STATUS ASTHCTTICUS  ASTHCT (BRONCHIAL) (ALLERGIC NOS); |
|CT   |1    |7746          |UNSPECIFIED FETAL AND NEONATAL JAUNDICE  ICTERUS NEONATORUM; NEONATAL HYPERBILIRUBINEMIA (TRANSIENT)|
|CT   |1    |46619         |ACUTE BRONCHIOLITIS DUE TO OTHER INFECTIOUS ORGANISMS  USE ADDITIONAL CODE TO IDENTIFY ORGANISM     |
|MA   |8    |3829          |UNSPECIFIED OTITIS MEDIA  OTITIS MEDIA: NOS, ACUTE NOS, CHRONIC NOS                                 |
|MA   |3    |37230         |CONJUNCTIVITIS, UNSPECIFIED                                                                         |
|MA   |3    |4659          |ACUTE UPPER RESPIRATORY INFECTIONS OF UNSPECIFIED SITE  ACUTE URI NOS; UPPER RESPIRATORY INFECTION (|
|MA   |2    |46619         |ACUTE BRONCHIOLITIS DUE TO OTHER INFECTIOUS ORGANISMS  USE ADDITIONAL CODE TO IDENTIFY ORGANISM     |
|MA   |2    |V202          |ROUTINE INFANT OR CHILD HEALTH CHECK                                                                |
|MA   |2    |31401         |ATTENTION DEFICIT DISORDER OF CHILDHOOD WITH HYPERACTIVITY    COMBINED TYPE; OVERACTIVITY NOS; PREDO|
|MA   |1    |7862          |COUGH                                                                                               |
|MA   |1    |7821          |RASH AND OTHER NONSPECIFIC SKIN ERUPTION    EXANTHEM                                                |
|MA   |1    |7806          |FEVER    CHILLS WITH FEVER; FEVER NOS; HYPERPYREXIA NOS; PYREXIA NOS  PYREXIA OF UNKNWN ORIGIN; FEVE|
|MA   |1    |38010         |INFECTIVE OTITIS EXTERNA, UNSPECIFIED    OTITIS EXTERNA (ACUTE): NOS, CIRCUMSCRIBED, DIFFUSE, HEMORR|
|MA   |1    |78841         |URINARY FREQUENCY  FREQUENCY OF MICTURITION                                                         |
|MA   |1    |8798          |OPEN WOUND OF OTHER AND UNSPECIFIED PARTS OF TRUNK, COMPLICATED                                     |
|MA   |1    |7242          |LUMBAGO    LOW BACK PAIN; LOW BACK SYNDROME; LUMBALGIA                                              |
|MA   |1    |4619          |ACUTE SINUSITIS, UNSPECIFIED    ACUTE SINUSITIS NOS                                                 |
|MA   |1    |78079         |OTHER MALAISE AND FATIGUE  ASTHENIA NOS; LETHARGY; POSTVIRAL (ASTHENIC) SYNDROME; TIREDNESS         |
|MA   |1    |null          |no current diagnosis                                                                                |
|MA   |1    |7746          |UNSPECIFIED FETAL AND NEONATAL JAUNDICE  ICTERUS NEONATORUM; NEONATAL HYPERBILIRUBINEMIA (TRANSIENT)|
|MA   |1    |07999         |UNSPECIFIED VIRAL INFECTION  VIRAL INFECTIONS NOS                                                   |
|MA   |1    |07810         |VIRAL WARTS, UNSPECIFIED  CONDYLOMA NOS; VERRUCA NOS: VULGARIS; WARTS (INFECTIOUS)                  |
|MA   |1    |7295          |PAIN IN LIMB                                                                                        |
|RI   |2    |4659          |ACUTE UPPER RESPIRATORY INFECTIONS OF UNSPECIFIED SITE  ACUTE URI NOS; UPPER RESPIRATORY INFECTION (|
|RI   |1    |490           |BRONCHITIS, NOT SPECIFIED AS ACUTE OR CHRONIC  BRONCHITIS NOS: CATARRHAL, WITH TRACHEITIS NOS; TRACH|
|RI   |1    |53550         |UNSPECIFIED GASTRITIS AND GASTRODUODENITIS (WITHOUT MENTION OF HEMORRHAGE)                          |
+-----+-----+--------------+----------------------------------------------------------------------------------------------------+

select PID.Patient_Name.Family_name, PID.Patient_Name.Given_name, PID.Patient_Address.Zip, PID.Patient_Address.State, PID.Patient_Address.City, PID.Patient_Address.Street_address, DG1.Diagnosis_code, substr(DG1.Diagnosis_description,0,70) as Diagnosis_description from siu order by State, City
+-----------+----------+-----+-----+------------------------+---------------+--------------+----------------------------------------------------------------------+
|Family_name|Given_name|Zip  |State|City                    |Street_address |Diagnosis_code|Diagnosis_description                                                 |
+-----------+----------+-----+-----+------------------------+---------------+--------------+----------------------------------------------------------------------+
|THOMPSON   |SANG      |06605|CT   |BRIDGEPORT              |5297 Monatiquot|V202          |ROUTINE INFANT OR CHILD HEALTH CHECK                                  |
|GARCIA     |VANNESSA  |06605|CT   |BRIDGEPORT              |6455 Saugus    |V202          |ROUTINE INFANT OR CHILD HEALTH CHECK                                  |
|ANDERSON   |CLEMENTE  |06071|CT   |CONNECTICUT STATE PRISON|2275 Rowley    |8798          |OPEN WOUND OF OTHER AND UNSPECIFIED PARTS OF TRUNK, COMPLICATED       |
|JACKSON    |SHELLY    |06335|CT   |GALES FERRY             |5229 Stillwater|8798          |OPEN WOUND OF OTHER AND UNSPECIFIED PARTS OF TRUNK, COMPLICATED       |
|HALL       |ROSCOE    |06051|CT   |NEW BRIT                |5255 Skug      |49390         |ASTHCT, UNSPECIFIED TYPE, WITHOUT MENTION OF STATUS ASTHCTTICUS  ASTHC|
|PARKER     |AUBREY    |06840|CT   |NEW CANAAN              |5773 Indian    |5589          |OTHER AND UNSPECIFIED NONINFECTIOUS GASTROENTERITIS AND COLITIS  {COLI|
|EDWARDS    |DEXTER    |06226|CT   |PERKINS CORNER          |8414 Forest    |3829          |UNSPECIFIED OTITIS MEDIA  OTITIS MEDIA: NOS, ACUTE NOS, CHRONIC NOS   |
|SCOTT      |ALDEN     |06782|CT   |PLYMOUTH                |7585 Little    |null          |no current diagnosis                                                  |
|RODRIGUEZ  |LOUIS     |06259|CT   |PONFRET CENTER          |1258 Island    |46619         |ACUTE BRONCHIOLITIS DUE TO OTHER INFECTIOUS ORGANISMS  USE ADDITIONAL |
|HERNANDEZ  |ROB       |06082|CT   |THOMPSONVILLE           |2037 Little    |V202          |ROUTINE INFANT OR CHILD HEALTH CHECK                                  |
|THOCTS     |CURT      |06820|CT   |TOKENEKE                |9741 Weir      |7746          |UNSPECIFIED FETAL AND NEONATAL JAUNDICE  ICTERUS NEONATORUM; NEONATAL |
|KING       |KAYLEIGH  |06098|CT   |WINCHESTER              |3525 Back      |07999         |UNSPECIFIED VIRAL INFECTION  VIRAL INFECTIONS NOS                     |
|WALKER     |DARYL     |01001|MA   |AGAWAM                  |5017 Hill      |3829          |UNSPECIFIED OTITIS MEDIA  OTITIS MEDIA: NOS, ACUTE NOS, CHRONIC NOS   |
|TAYLOR     |MILISSA   |01008|MA   |BLANDFORD               |9756 Beaver    |8798          |OPEN WOUND OF OTHER AND UNSPECIFIED PARTS OF TRUNK, COMPLICATED       |
|COLLINS    |CLAY      |02360|MA   |CEDARVILLE              |6794 Pines     |38010         |INFECTIVE OTITIS EXTERNA, UNSPECIFIED    OTITIS EXTERNA (ACUTE): NOS, |
|MILLER     |GARNET    |02633|MA   |CHATHAM                 |8328 Indian    |4659          |ACUTE UPPER RESPIRATORY INFECTIONS OF UNSPECIFIED SITE  ACUTE URI NOS;|
|WILSON     |CAROLYNE  |01923|MA   |DANVERS                 |8704 Nashua    |4659          |ACUTE UPPER RESPIRATORY INFECTIONS OF UNSPECIFIED SITE  ACUTE URI NOS;|
|LEE        |LENNY     |02030|MA   |DOVER                   |7245 Concord   |7295          |PAIN IN LIMB                                                          |
|MITCHELL   |KORY      |02723|MA   |FALL RIVER              |3060 Aberjona  |37230         |CONJUNCTIVITIS, UNSPECIFIED                                           |
|GONZALEZ   |VENETTA   |02721|MA   |FALL RIVER              |8984 Neponset  |7806          |FEVER    CHILLS WITH FEVER; FEVER NOS; HYPERPYREXIA NOS; PYREXIA NOS  |
|PEREZ      |BELEN     |01702|MA   |FRAMINGHAM              |3530 Neck      |78079         |OTHER MALAISE AND FATIGUE  ASTHENIA NOS; LETHARGY; POSTVIRAL (ASTHENIC|
|JONES      |IRMA      |01450|MA   |GROTON                  |4610 Skug      |3829          |UNSPECIFIED OTITIS MEDIA  OTITIS MEDIA: NOS, ACUTE NOS, CHRONIC NOS   |
|ADAMS      |INDIA     |01982|MA   |HAMILTON                |1006 Nashua    |3829          |UNSPECIFIED OTITIS MEDIA  OTITIS MEDIA: NOS, ACUTE NOS, CHRONIC NOS   |
|BROWN      |JANEE     |01841|MA   |LAWRENCE                |4983 Meadow    |7821          |RASH AND OTHER NONSPECIFIC SKIN ERUPTION    EXANTHEM                  |
|JOHNSON    |SHELBY    |01850|MA   |LOWELL                  |5072 Alewife   |V202          |ROUTINE INFANT OR CHILD HEALTH CHECK                                  |
|MOORE      |GREGORY   |01056|MA   |LUDLOW                  |6812 Ipswich   |07810         |VIRAL WARTS, UNSPECIFIED  CONDYLOMA NOS; VERRUCA NOS: VULGARIS; WARTS |
|LOPEZ      |ALTA      |02764|MA   |N DIGHTON               |0763 Sudbury   |31401         |ATTENTION DEFICIT DISORDER OF CHILDHOOD WITH HYPERACTIVITY    COMBINED|
|PHILLIPS   |EMILEE    |01908|MA   |NAHANT                  |2257 Weir      |4619          |ACUTE SINUSITIS, UNSPECIFIED    ACUTE SINUSITIS NOS                   |
|ROBERTS    |CAROLINA  |02056|MA   |NORFOLK                 |0823 Skug      |7746          |UNSPECIFIED FETAL AND NEONATAL JAUNDICE  ICTERUS NEONATORUM; NEONATAL |
|DAVIS      |JASMINE   |01054|MA   |NORTH LEVERETT          |2439 Hill      |37230         |CONJUNCTIVITIS, UNSPECIFIED                                           |
|NELSON     |ENEDINA   |01537|MA   |NORTH OXFORD            |5397 Spicket   |46619         |ACUTE BRONCHIOLITIS DUE TO OTHER INFECTIOUS ORGANISMS  USE ADDITIONAL |
|YOUNG      |BRICE     |01354|MA   |NORTHFIELD MT HERMON    |6338 Concord   |4659          |ACUTE UPPER RESPIRATORY INFECTIONS OF UNSPECIFIED SITE  ACUTE URI NOS;|
|CAMPBELL   |KASI      |01436|MA   |OTTER RIVER             |2111 Swamp     |07999         |UNSPECIFIED VIRAL INFECTION  VIRAL INFECTIONS NOS                     |
|BAKER      |CHESTER   |02140|MA   |PORTER SQUARE           |4732 Charles   |3829          |UNSPECIFIED OTITIS MEDIA  OTITIS MEDIA: NOS, ACUTE NOS, CHRONIC NOS   |
|WILLIAMS   |ELIDA     |01969|MA   |ROWLEY                  |2403 Skug      |7862          |COUGH                                                                 |
|EVANS      |WESTON    |01560|MA   |SAUNDERSVILLE           |6954 Mystic    |3829          |UNSPECIFIED OTITIS MEDIA  OTITIS MEDIA: NOS, ACUTE NOS, CHRONIC NOS   |
|TURNER     |TYESHA    |02703|MA   |SOUTH ATTLEBORO         |0178 Malden    |78841         |URINARY FREQUENCY  FREQUENCY OF MICTURITION                           |
|LEWIS      |HERMINIA  |01772|MA   |SOUTHBORO               |1371 Monatiquot|46619         |ACUTE BRONCHIOLITIS DUE TO OTHER INFECTIOUS ORGANISMS  USE ADDITIONAL |
|ROBINSON   |MONTY     |01775|MA   |STOW                    |1972 Indian    |V202          |ROUTINE INFANT OR CHILD HEALTH CHECK                                  |
|MARTINEZ   |BURTON    |02780|MA   |TAUNTON                 |3617 Assabet   |3829          |UNSPECIFIED OTITIS MEDIA  OTITIS MEDIA: NOS, ACUTE NOS, CHRONIC NOS   |
|CARTER     |SYNTHIA   |02071|MA   |WALPOLE                 |7776 Hill      |37230         |CONJUNCTIVITIS, UNSPECIFIED                                           |
|MARTIN     |CLIFFORD  |02339|MA   |WEST HANOVER            |4514 Pines     |3829          |UNSPECIFIED OTITIS MEDIA  OTITIS MEDIA: NOS, ACUTE NOS, CHRONIC NOS   |
|ALLEN      |EVALYN    |01089|MA   |WEST SPRINGFLD          |3819 Nashua    |3829          |UNSPECIFIED OTITIS MEDIA  OTITIS MEDIA: NOS, ACUTE NOS, CHRONIC NOS   |
|HARRIS     |DENISHA   |01089|MA   |WEST SPRINGFLD          |0130 Beaver    |null          |no current diagnosis                                                  |
|SMITH      |HERMAN    |01267|MA   |WMSTOWN                 |0291 Saugus    |31401         |ATTENTION DEFICIT DISORDER OF CHILDHOOD WITH HYPERACTIVITY    COMBINED|
|GREEN      |NEELY     |01367|MA   |ZOAR                    |6380 Essex     |7242          |LUMBAGO    LOW BACK PAIN; LOW BACK SYNDROME; LUMBALGIA                |
|WRIGHT     |THERON    |02809|RI   |BRISTOL                 |5493 Meadow    |490           |BRONCHITIS, NOT SPECIFIED AS ACUTE OR CHRONIC  BRONCHITIS NOS: CATARRH|
|HILL       |ASLEY     |02858|RI   |BURRILLVILLE            |4254 Neponset  |4659          |ACUTE UPPER RESPIRATORY INFECTIONS OF UNSPECIFIED SITE  ACUTE URI NOS;|
|WHITE      |GARFIELD  |02865|RI   |LINCOLN                 |2673 Farm      |4659          |ACUTE UPPER RESPIRATORY INFECTIONS OF UNSPECIFIED SITE  ACUTE URI NOS;|
|CLARK      |REUBEN    |02871|RI   |PORTSMOUTH              |3689 North     |53550         |UNSPECIFIED GASTRITIS AND GASTRODUODENITIS (WITHOUT MENTION OF HEMORRH|
+-----------+----------+-----+-----+------------------------+---------------+--------------+----------------------------------------------------------------------+
