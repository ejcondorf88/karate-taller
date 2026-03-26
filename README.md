# Plantilla de Proyecto Karate Framework - API AutomationExercise

Plantilla educativa para pruebas de API REST con [Karate Framework](https://github.com/karatelabs/karate), configurada específicamente para la API pública de [AutomationExercise](https://automationexercise.com/api_list).

## API Objetivo

La API de AutomationExercise proporciona endpoints para práctica de pruebas API. Esta plantilla implementa pruebas completas con arquitectura modular y reutilizable.

### Endpoints Probados

1. **GET** - Obtener lista de productos
2. **POST** - Buscar productos, crear usuarios
3. **PUT** - Actualizar cuenta de usuario
4. **DELETE** - Eliminar cuenta de usuario

## Prerrequisitos

- **Java 17** o superior
- **Maven 3.x** o superior
- Un IDE (IntelliJ IDEA, Eclipse, VS Code) con soporte de Maven

## Estructura del Proyecto

```
karate-taller/
├── pom.xml                                 # Configuración Maven
├── src/
│   └── test/
│       ├── java/                           # Todos los archivos de prueba
│       │   ├── allure.properties           # Configuración de Allure
│       │   ├── karate-config.js            # Configuración mínima (entorno + baseUrl + carga de helpers)
│       │   ├── logback-test.xml            # Configuración de logs
│       │   ├── TestRunner.java             # Runner principal para ejecución paralela
│       │   │
│       │   ├── common/                     # Features reutilizables
│       │   │   ├── product/                # Reutilizables para productos
│       │   │   │   ├── list-products.feature
│       │   │   │   ├── search-product.feature
│       │   │   │   └── invalid-search.feature
│       │   │   └── user/                   # Reutilizables para usuarios
│       │   │       ├── create-user.feature
│       │   │       ├── update-user.feature
│       │   │       └── delete-user.feature
│       │   │
│       │   ├── data/                       # Datos de prueba centralizados
│       │   │   ├── user-data.json
│       │   │   └── product-data.json
│       │   │
│       │   ├── schemas/                    # Validación JSON
│       │   │   └── user-schema.json
│       │   │
│       │   ├── utils/                      # Helpers JavaScript
│       │   │   ├── generateEmail.js
│       │   │   ├── loadUserData.js
│       │   │   ├── loadProductData.js
│       │   │   └── deepCopy.js
│       │   │
│       │   ├── users/                      # Pruebas de usuarios
│       │   │   ├── users.feature           # Escenarios CRUD de usuarios
│       │   │   └── UsersRunner.java        # Runner individual
│       │   │
│       │   └── products/                   # Pruebas de productos
│       │       ├── products.feature        # Escenarios de listado y búsqueda
│       │       └── ProductsRunner.java     # Runner individual
│       │
│       └── resources/                      # (Vacío - config movida a java/)
│
└── target/                                 # Directorio de salida Maven
    ├── karate-reports/                     # Reportes HTML generados
    ├── allure-results/                     # Resultados Allure (generados automáticamente)
    └── allure-report/                      # Reporte Allure HTML (generado con mvn allure:report)
```

## Configuración de la API

La configuración está en `src/test/java/karate-config.js`:

```javascript
function fn() {
  var env = karate.env;
  karate.log('karate.env system property was:', env);
  if (!env) env = 'dev';
  
  var config = {
    env: env,
    baseUrl: 'https://automationexercise.com/api'
  };
  
  // Cargar helpers desde utils/
  config.generateEmail = read('classpath:utils/generateEmail.js')();
  config.loadUserData = read('classpath:utils/loadUserData.js')();
  config.loadProductData = read('classpath:utils/loadProductData.js')();
  config.deepCopy = read('classpath:utils/deepCopy.js')();
  
  return config;
}
```

## Arquitectura del Framework

### Separación de Responsabilidades
- **karate-config.js**: Solo configuración esencial (entorno, baseUrl, carga de helpers)
- **utils/**: Helpers JavaScript reutilizables
- **common/**: Features reutilizables por dominio
- **data/**: Datos de prueba centralizados
- **schemas/**: Validación JSON opcional

### Flujo de Ejecución
1. Karate carga `karate-config.js`
2. Config carga helpers desde `utils/`
3. Tests usan helpers y llaman features reutilizables
4. Features reutilizables interactúan con la API
5. Tests validan respuestas

## Features Reutilizables

### Patrón Utilizado
Cada feature reutilizable sigue este patrón:

```gherkin
Feature: [Nombre] reusable action

Scenario: [Descripción]
  Given url baseUrl
  And path '[endpoint]'
  And form field [campo] = [variable]  # Sin #() dentro del feature
  When method [verb]
  * def result = response
```

### Ejemplo: Create User Feature
```gherkin
# common/user/create-user.feature
Feature: Create user reusable action

Scenario: Create user account
  Given url baseUrl
  And path 'createAccount'
  And form field name = userData.name
  And form field email = userData.email
  And form field password = userData.password
  # ... más campos
  When method post
  * def result = response
```

### Llamada desde Tests
```gherkin
* def userData = deepCopy(userDataTemplate)
* set userData.email = generateEmail()
* def createRes = call read('classpath:common/user/create-user.feature') { userData: '#(userData)' }
* match createRes.result.responseCode == 201
```

## Utils (Helpers)

### generateEmail.js
Genera emails únicos con timestamp:
```javascript
function() {
  return function() {
    return 'user_' + new Date().getTime() + '@mail.com';
  }
}
```

### loadUserData.js
Carga datos de usuario desde JSON:
```javascript
function() {
  return function() {
    return read('classpath:data/user-data.json');
  }
}
```

### loadProductData.js
Carga datos de producto desde JSON:
```javascript
function() {
  return function() {
    return read('classpath:data/product-data.json');
  }
}
```

### deepCopy.js
Realiza copia profunda de objetos:
```javascript
function() {
  return function(obj) {
    return JSON.parse(JSON.stringify(obj));
  }
}
```

## Escenarios Implementados

### Products (3 escenarios)
1. **GET productos** - Listar todos los productos (200 OK)
2. **POST búsqueda válida** - Buscar con parámetro 'top' (200 OK)
3. **POST búsqueda inválida** - Buscar sin parámetro (400 en body)

### Users (3 escenarios)
1. **Crear usuario** - POST createAccount (201 Created)
2. **Actualizar usuario** - PUT updateAccount (200 OK)
3. **Eliminar usuario** - DELETE deleteAccount (200 OK)

**Total: 6 escenarios** - Todos pasando ✅

## Ejecución de Pruebas

### Ejecutar todas las pruebas (paralelo)
```bash
mvn test
```

### Ejecutar pruebas por dominio
```bash
# Solo productos
mvn test -Dtest=ProductsRunner

# Solo usuarios
mvn test -Dtest=UsersRunner

# Ejecutar runner principal (todos los dominios)
mvn test -Dtest=TestRunner
```

### Ejecutar desde IDE
Clic derecho en `TestRunner.java`, `ProductsRunner.java` o `UsersRunner.java` → Run/Debug

### Ejecutar pruebas con Tags
Las pruebas están organizadas con tags para ejecución selectiva:
```bash
# Ejecutar pruebas críticas (smoke)
mvn test -Dkarate.options="--tags @smoke"

# Ejecutar solo pruebas de un dominio
mvn test -Dkarate.options="--tags @users"
mvn test -Dkarate.options="--tags @products"

# Ejecutar pruebas por método HTTP
mvn test -Dkarate.options="--tags @get"
mvn test -Dkarate.options="--tags @post"

# Excluir pruebas en desarrollo
mvn test -Dkarate.options="--tags ~@wip"

# Combinar tags (OR lógico)
mvn test -Dkarate.options="--tags @smoke,@regresion"
```

## Archivos de Datos de Prueba

### Organización Centralizada
- **`data/user-data.json`**: Datos genéricos para creación de usuarios
- **`data/product-data.json`**: Datos de productos para búsqueda
- **`schemas/user-schema.json`**: JSON schema para validación

### Generación Dinámica
- Los emails se generan únicos usando `generateEmail()`
- Se usa `deepCopy()` para evitar mutaciones de datos base
- Los datos se cargan automáticamente con `loadUserData()` y `loadProductData()`

## Reportes

### Reportes HTML de Karate
Los reportes HTML se generan automáticamente en:
```
target/karate-reports/karate-summary.html
```

### Reportes Allure
El proyecto está configurado con integración de Allure Report para visualización mejorada:

1. **Generar resultados Allure** (se ejecuta automáticamente con `mvn test`):
   ```
   target/allure-results/
   ```

2. **Generar reporte HTML Allure**:
   ```
   mvn allure:report
   ```

3. **Abrir el reporte**:
   ```
   target/allure-report/index.html
   ```

4. **Alternativa: generar y abrir en un solo comando**:
   ```
   mvn allure:serve
   ```

Los reportes Allure incluyen detalles de pasos, attachments, tiempos de ejecución y gráficos interactivos.

## Personalización

### Agregar nuevo dominio
1. Crear carpeta en `src/test/java/common/nuevo-dominio/` para features reutilizables
2. Crear features siguiendo el patrón (Given url baseUrl, form fields, * def result = response)
3. Crear `nuevo-dominio.feature` en `src/test/java/nuevo-dominio/` con escenarios
4. Crear `NuevoDominioRunner.java` en el directorio del dominio
5. Actualizar `TestRunner.java` para incluir `classpath:nuevo-dominio`
6. Agregar datos de prueba en `data/` si es necesario
7. Agregar helpers en `utils/` si se necesitan nuevas funciones

### Modificar datos de prueba
- Editar archivos JSON en `data/`
- Los datos se cargan automáticamente con las funciones helpers
- Usar `deepCopy()` para crear variaciones de datos base

## Comandos Maven Útiles

```bash
mvn clean test        # Limpiar y ejecutar pruebas
mvn test-compile      # Solo compilar pruebas
mvn test -X           # Ejecutar con debug
mvn allure:report     # Generar reporte Allure
mvn surefire-report:report  # Generar reporte HTML de Surefire
```

## Recursos

- [API AutomationExercise](https://automationexercise.com/api_list)
- [Documentación Karate](https://karatelabs.github.io/karate/)
- [Sintaxis Gherkin](https://karatelabs.github.io/karate/#karate-language)
- [Karate DSL](https://github.com/karatelabs/karate)

## Notas para el Taller

- La estructura está diseñada para ser educativa y escalable
- Cada dominio es independiente pero comparte configuración global
- Los datos de prueba se generan dinámicamente para evitar conflictos
- La arquitectura modular permite fácil extensión con nuevos dominios
- Los features reutilizables promueven el principio DRY (Don't Repeat Yourself)