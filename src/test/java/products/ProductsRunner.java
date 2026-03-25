package products;

import com.intuit.karate.junit5.Karate;
import io.qameta.allure.karate.AllureKarate;

class ProductsRunner {

    @Karate.Test
    Karate testProducts() {
        return Karate.run("products").hook(new AllureKarate()).relativeTo(getClass());
    }

}