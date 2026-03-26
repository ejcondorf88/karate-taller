# AGENTS.md

Este archivo proporciona orientación para agentes de codificación IA que trabajan en este repositorio.

## Descripción del Proyecto
- **Framework**: Karate Framework 1.5.2 para pruebas de API
- **Sistema de Construcción**: Maven 3.x con Java 17
- **Estructura**: Organización modular con features reutilizables
- **API Bajo Prueba**: https://automationexercise.com/api_list

## Comandos de Construcción/Prueba

### Comandos Principales de Maven
```bash
# Limpiar y ejecutar todas las pruebas (recomendado para verificación completa)
mvn clean test

# Compilar sin ejecutar pruebas
mvn compile

# Ejecutar pruebas sin limpiar
mvn test

# Ejecutar el runner principal (todos los dominios)
mvn test -Dtest=TestRunner

# Ejecutar runners específicos por dominio
mvn test -Dtest=ProductsRunner
mvn test -Dtest=UsersRunner

# Ejecutar pruebas con salida detallada
mvn test -X

# Generar reportes Allure (después de que las pruebas hayan corrido)
mvn allure:report

# Abrir el reporte Allure automáticamente
mvn allure:serve

# Generar reporte HTML de Surefire (alternativo)
mvn surefire-report:report

# Ejecutar pruebas con Tags específicos
mvn test -Dkarate.options="--tags @smoke"              # Ejecutar solo pruebas smoke
mvn test -Dkarate.options="--tags @users"              # Ejecutar solo pruebas de usuarios
mvn test -Dkarate.options="--tags @products"           # Ejecutar solo pruebas de productos
mvn test -Dkarate.options="--tags @post"               # Ejecutar solo pruebas POST
mvn test -Dkarate.options="--tags @regresion"          # Ejecutar pruebas de regresión
mvn test -Dkarate.options="--tags ~@wip"               # Excluir pruebas en desarrollo (wip)
mvn test -Dkarate.options="--tags @smoke,@products"    # Combinar tags (OR lógico)
```

### Ejecución de Features Individuales
- Ejecutar desde IDE: Clic derecho en `ProductsRunner.java`, `UsersRunner.java` o `TestRunner.java` → Run/Debug
- Los features se ejecutan por dominio (products, users)
- Para ejecutar un solo escenario: usar tags específicos como `@createUser` o `@listProducts`

## Estructura del Proyecto Actualizada

```
src/test/java/
├── allure.properties                # Configuración de Allure
├── karate-config.js                 # Configuración mínima (entorno + baseUrl + carga de helpers)
├── logback-test.xml                 # Configuración de logs
├── TestRunner.java                  # Runner principal para ejecución paralela
│
├── common/                          # Features reutilizables
│   ├── product/                     # Reutilizables para productos
│   │   ├── list-products.feature
│   │   ├── search-product.feature
│   │   └── invalid-search.feature
│   └── user/                        # Reutilizables para usuarios
│       ├── create-user.feature
│       ├── update-user.feature
│       └── delete-user.feature
│
├── data/                            # Datos de prueba centralizados
│   ├── user-data.json
│   └── product-data.json
│
├── schemas/                         # Validación JSON
│   └── user-schema.json
│
├── utils/                           # Helpers JavaScript
│   ├── generateEmail.js             # Genera emails únicos con timestamp
│   ├── loadUserData.js              # Carga datos de usuario desde JSON
│   ├── loadProductData.js           # Carga datos de producto desde JSON
│   └── deepCopy.js                  # Copia profunda de objetos
│
├── users/                           # Pruebas de usuarios
│   ├── users.feature                # Escenarios CRUD de usuarios
│   └── UsersRunner.java             # Runner individual
│
└── products/                        # Pruebas de productos
    ├── products.feature             # Escenarios de listado y búsqueda
    └── ProductsRunner.java          # Runner individual
```

## Guías de Estilo de Código

### Archivos Java
- **Nomenclatura de paquetes**: Todo en minúsculas, basado en dominio (`users`, `products`)
- **Nomenclatura de clases**: PascalCase, descriptiva (`ProductsRunner`, `UsersRunner`, `TestRunner`)
- **Nomenclatura de métodos**: camelCase, basada en verbos (`testProducts`, `testUsers`, `testParallel`)
- **Importaciones**:
  - Usar importaciones explícitas, no comodines
  - Agrupar: Librería estándar de Java → terceros → importaciones del proyecto
  - Importaciones estáticas para aserciones (ej. `org.junit.jupiter.api.Assertions.*`)
- **Formato**:
  - Indentación de 4 espacios (sin tabulaciones)
  - Llave de apertura en la misma línea
  - Longitud de línea ≤ 120 caracteres
- **Manejo de errores**:
  - Usar el patrón `assertEquals(0, results.getFailCount(), results.getErrorMessages())`
  - Dejar que Karate maneje las fallas de aserción de forma natural

### Archivos Feature (.feature)
- **Idioma**: Español para descripciones, inglés para palabras clave de Gherkin
  - Usar `Feature:`, `Scenario:`, `Background:`, `Given`, `When`, `Then`, `And`
  - Descripciones en español: `Pruebas de API de productos (listado y búsqueda)`
- **Estructura**:
  - `Background:` para configuración compartida (URL, datos base)
  - Un feature por dominio o área de preocupación
  - Cada escenario debe ser independiente y autocontenido
- **Features Reutilizables (common/)**:
  - Siempre incluir `Given url baseUrl`
  - Usar `And form field campo = variable` (sin `#()` dentro del feature)
  - Terminar con `* def result = response`
  - NO incluir assertions (el caller las maneja)
- **Patrón de Llamada**:
  ```gherkin
  * def userData = deepCopy(userDataTemplate)
  * set userData.email = generateEmail()
  * def createRes = call read('classpath:common/user/create-user.feature') { userData: '#(userData)' }
  Then match createRes.result.responseCode == 201
  ```
- **Aserciones**:
  - Usar la sintaxis `match` de Karate para validación JSON
  - Validar tanto códigos de estado como contenido de respuesta
  - El resultado del `call` está en `variable.result.responseCode`
- **Gestión de datos**:
  - Cargar datos desde `data/` usando helpers (`loadUserData()`, `loadProductData()`)
  - Usar `deepCopy()` para crear copias sin mutar datos base
  - Generar datos únicos con `generateEmail()`
- **Uso de Tags**:
  - **Por Dominio**: `@users`, `@products`
  - **Por Método HTTP**: `@get`, `@post`, `@put`, `@delete`
  - **Por Tipo de Prueba**:
    - `@smoke`: Pruebas rápidas, críticas
    - `@regresion`: Pruebas exhaustivas
    - `@crud`: Ciclo completo CRUD
  - **Tags de Estado**:
    - `@wip`: Work In Progress (excluir de ejecuciones principales)
    - `@ignore`: Pruebas deshabilitadas temporalmente

### Archivos JavaScript (utils/)
- **Patrón**: Cada archivo exporta una función que devuelve la función helper
  ```javascript
  // generateEmail.js
  function() {
    return function() {
      return 'user_' + new Date().getTime() + '@mail.com';
    }
  }
  ```
- **Carga en karate-config.js**:
  ```javascript
  config.generateEmail = read('classpath:utils/generateEmail.js')();
  ```
- **Helpers disponibles**:
  - `generateEmail()`: Genera emails únicos
  - `loadUserData()`: Retorna datos de usuario desde JSON
  - `loadProductData()`: Retorna datos de producto desde JSON
  - `deepCopy(obj)`: Copia profunda de objetos

### Configuración karate-config.js
- **Ubicación**: `src/test/java/karate-config.js`
- **Responsabilidad mínima**:
  1. Detectar entorno (`karate.env`)
  2. Establecer `baseUrl`
  3. Cargar helpers desde `utils/`
  4. Personalizaciones por entorno (dev, e2e)
- **NO debe contener**:
  - Lógica de negocio
  - Datos de prueba (están en `data/`)
  - Helpers (están en `utils/`)

## Patrones Comunes

### Creación de Nuevos Escenarios de Prueba
1. Crear feature reutilizable en `common/[dominio]/` (ej. `common/product/search-product.feature`)
2. Crear feature de prueba en `[dominio]/[dominio].feature`
3. Crear Runner.java correspondiente con anotación `@Karate.Test`
4. Agregar a ejecución paralela en `TestRunner.java` si es necesario
5. Crear datos de prueba en `data/` (JSON/CSV)
6. Agregar helpers en `utils/` si se necesitan nuevas funciones

### Patrón para Features Reutilizables
```gherkin
# common/[domain]/[action]-[domain].feature
Feature: [Action] [domain] reusable action

Scenario: [Description]
  Given url baseUrl
  And path '[endpoint]'
  # Form fields sin #() - usar variable directamente
  And form field campo1 = variable1.campo1
  And form field campo2 = variable2.campo2
  When method [verb]
  * def result = response
```

### Validación de Respuestas de API
```gherkin
# Validación de código de estado
Then status 200

# Validación de estructura JSON
And match response.products == '#array'
And match response.products[0] contains { id: '#number', name: '#string' }

# Validación de código de respuesta (específico de la API)
And match response.responseCode == 201
And match response.message == 'User created!'

# Después de call a feature reutilizable
Then match createRes.result.responseCode == 201
And match createRes.result.message == 'User created!'
```

### Generación de Datos
- Usar `generateEmail()` para emails únicos con timestamp
- Usar `deepCopy(userDataTemplate)` para crear copias modificables
- Almacenar datos en `data/[domain]-data.json`
- Limpiar recursos creados cuando sea posible (DELETE tests)

## Configuración de Entorno
- **Entorno predeterminado**: `dev`
- **Configurar mediante**: `mvn test -Dkarate.env=e2e`
- **Personalizaciones**: En `karate-config.js` sección `if (env == 'dev')` / `else if (env == 'e2e')`
- **Variables de entorno**: `karate.env` (system property)

## Notas para Agentes
- **Esta es una plantilla de taller** — mantener los ejemplos simples y educativos
- **Arquitectura modular**: Permite escalar añadiendo nuevos dominios en `common/`, `[dominio]/`, `data/`
- **Idioma**: Mantener descripciones en español para participantes del taller
- **Calidad**: Todas las pruebas deben pasar antes de confirmar cambios
- **Verificación**: Ejecutar `mvn clean test` para verificar conjunto completo (debe ser 6/6 pruebas pasando)
- **Reportes**: HTML en `target/karate-reports/`, Allure en `target/allure-results/`
- **Evitar**: No usar `#()` dentro de features reutilizables - causa errores de interpolación
- **Parámetros**: Usar `'#(variable)'` al llamar features reutilizables, no `#(variable)` sin comillas

## Errores Comunes a Evitar
1. **Uso incorrecto de `#()`**:
   - ❌ Mal: `And form field name = '#(userData.name)'` dentro de feature reutilizable
   - ✅ Bien: `And form field name = userData.name` dentro de feature reutilizable
   - ✅ Bien: `call read(...) { userData: '#(userData)' }` al llamar

2. **Acceso incorrecto al resultado**:
   - ❌ Mal: `match createRes.responseCode == 201`
   - ✅ Bien: `match createRes.result.responseCode == 201`

3. **Mutación de datos base**:
   - ❌ Mal: `* userData.email = generateEmail()` (muta template)
   - ✅ Bien: `* def userData = deepCopy(userDataTemplate)` then `* set userData.email = generateEmail()`

4. **Falta de cleanup**:
   - ❌ Mal: Crear usuarios sin eliminarlos
   - ✅ Bien: Incluir DELETE tests o cleanup en escenarios