function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    env: env,
    baseUrl: 'https://automationexercise.com/api'
  };
  // Generate unique email for user creation tests
  config.generateEmail = function() {
    return 'test' + java.lang.System.currentTimeMillis() + '@example.com';
  };
  // Default user data for creation
  config.defaultUserData = function() {
    var email = config.generateEmail();
    return {
      name: 'Test User',
      email: email,
      password: 'password123',
      title: 'Mr',
      birth_date: '15',
      birth_month: '05',
      birth_year: '1990',
      firstname: 'Test',
      lastname: 'User',
      company: 'Test Company',
      address1: '123 Test Street',
      address2: 'Apt 456',
      country: 'United States',
      zipcode: '12345',
      state: 'California',
      city: 'Test City',
      mobile_number: '1234567890'
    };
  };
  if (env == 'dev') {
    // customize
    // e.g. config.foo = 'bar';
  } else if (env == 'e2e') {
    // customize
  }
  return config;
}