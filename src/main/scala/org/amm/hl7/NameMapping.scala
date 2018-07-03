package org.amm.hl7

object NameMapping {

  val PID_PN = Map(
    1 -> "Family_name",
    2 -> "Given_name",
    3 -> "Middle_initial",
    4 -> "Suffix",
    5 -> "Prefix",
    6 -> "Degree"
  )

  val PID_AD = Map(
    1 -> "Street_address",
    2 -> "Other_designation",
    3 -> "City",
    4 -> "State",
    5 -> "Zip",
    6 -> "Country",
    7 -> "Type"
  )

  val segments = Map(
    "PID_PN" -> PID_PN,
    "PID_AD" -> PID_AD
  )
  
}
