package simulations
import io.gatling.core.Predef._
import io.gatling.http.Predef._

trait HttpConfiguration {

  val headers = Map(
    """Accept""" -> """text/html,application/xhtml+xml,application/xml,image/png,image/*;q=0.9,*/*;q=0.8""",
    """Cache-Control""" -> """no-cache""")

  val httpProtocol = http
    .acceptHeader("image/png,image/*;q=0.8,*/*;q=0.5")
    .userAgentHeader("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:25.0) Gecko/20100101 Firefox/31.0")
}
