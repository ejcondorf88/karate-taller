function fn() {
  var env = karate.env;
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    env: env,
    baseUrl: 'https://automationexercise.com/api'
  };
  
  // Cargar helpers desde utils
  config.generateEmail = read('classpath:utils/generateEmail.js')();
  config.loadUserData = read('classpath:utils/loadUserData.js')();
  config.loadProductData = read('classpath:utils/loadProductData.js')();
  config.deepCopy = read('classpath:utils/deepCopy.js')();
  
  if (env == 'dev') {
    // Personalizaciones por entorno dev
  } else if (env == 'e2e') {
    // Personalizaciones por entorno e2e
  }
  return config;
}