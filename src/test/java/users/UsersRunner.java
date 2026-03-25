package users;

import com.intuit.karate.junit5.Karate;
import io.qameta.allure.karate.AllureKarate;

class UsersRunner {

    @Karate.Test
    Karate testUsers() {
        return Karate.run("users").hook(new AllureKarate()).relativeTo(getClass());
    }

}