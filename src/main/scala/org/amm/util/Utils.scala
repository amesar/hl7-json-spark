package org.amm.util

object Utils {
  import com.fasterxml.jackson.databind.ObjectMapper
  import com.fasterxml.jackson.databind.SerializationFeature

  val mapper = new ObjectMapper()

  //import com.fasterxml.jackson.databind.MapperFeature
  //mapper.configure(MapperFeature.SORT_PROPERTIES_ALPHABETICALLY, true)
  //mapper.configure(SerializationFeature.ORDER_MAP_ENTRIES_BY_KEYS, true);

  val writer = mapper.writerWithDefaultPrettyPrinter()

  def toJson(map: java.util.Map[String,Any]) : String = {
    mapper.writeValueAsString(map)
  }

  def toJsonPretty(map: java.util.Map[String,Any]) : String = {
    writer.writeValueAsString(map)
  }

  def toJava(x: Any): Any = {
    import scala.collection.JavaConverters._
    x match {
      case y: scala.collection.MapLike[_, _, _] => y.map { case (d, v) => toJava(d) -> toJava(v) } asJava
      case y: scala.collection.SetLike[_,_] => y map { item: Any => toJava(item) } asJava
      case y: Iterable[_] => y.map { item: Any => toJava(item) } asJava
      case y: Iterator[_] => toJava(y.toIterable)
      case _ => x
    }
  }
}
