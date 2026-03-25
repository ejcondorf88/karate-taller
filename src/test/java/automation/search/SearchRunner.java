package automation.search;

import com.intuit.karate.junit5.Karate;

class SearchRunner {

    @Karate.Test
    Karate testSearch() {
        return Karate.run("search").relativeTo(getClass());
    }

}