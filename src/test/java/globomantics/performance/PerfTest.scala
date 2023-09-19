package performance

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._

class PerfTest extends Simulation{


  // 1 - Define Protocol
  val protocol = karateProtocol(
    "api/product/{productId}" -> Nil
  )

  protocol.nameResolver = (req, ctx) => req.getHeader("karate-request")

  val csvFeeder = csv("products.csv").circular


  // 2 - Load Scenarios
  val listProducts = scenario("List all Products")
  .exec(karateFeature("classpath:globomantics/performance/listProducts.feature"))

  val createProduct = scenario("Create and delete products")
  .feed(csvFeeder)
  .exec(karateFeature("classpath:globomantics/performance/createProduct.feature"))

  // 3 - Load Simulation
  setUp(
    listProducts.inject(
      atOnceUsers(1), 
      nothingFor(5),
      rampUsers(10).during(10),
      rampUsersPerSec(1).to(5).during(10)
      ).protocols(protocol),

    createProduct.inject(rampUsers(20).during(20)).protocols(protocol)
  )
}