import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import io.qameta.allure.karate.AllureKarate;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

class TestRunner {

    @Test
    void testParallel() {
        Results results = Runner.path("classpath:users", "classpath:products")
                .hook(new AllureKarate())
                .parallel(1);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }

}