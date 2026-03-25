# AGENTS.md

Este archivo proporciona orientación para agentes de codificación IA que trabajan en este repositorio.

## Descripción del Proyecto
- **Framework**: Karate Framework 1.5.2 para pruebas de API
- **Sistema de Construcción**: Maven 3.x con Java 17
- **Estructura**: Diseño estándar de Maven con `src/test/java` y `src/test/resources`
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

# Ejecutar una clase de prueba específica
mvn test -Dtest=AutomationTest

# Ejecutar un runner de feature específico
mvn test -Dtest=ProductsRunner
mvn test -Dtest=SearchRunner
mvn test -Dtest=UsersRunner

# Ejecutar pruebas con salida detallada
mvn test -X

# Generar reportes solamente (después de que las pruebas hayan corrido)
mvn surefire-report:report
```

### Ejecución de Features Individuales
- Usar `mvn test -Dtest=ProductsRunner` para products.feature
- Usar `mvn test -Dtest=SearchRunner` para search.feature
- Usar `mvn test -Dtest=UsersRunner` para user-crud.feature
- O ejecutar directamente desde el IDE haciendo clic derecho en el archivo *Runner.java

## Guías de Estilo de Código

### Archivos Java
- **Nomenclatura de paquetes**: Todo en minúsculas, basado en dominio (`automation.products`, `automation.search`, `automation.users`)
- **Nomenclatura de clases**: PascalCase, descriptiva (`ProductsRunner`, `AutomationTest`)
- **Nomenclatura de métodos**: camelCase, basada en verbos (`testProducts`, `testParallel`)
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
  - Descripciones en español: `Pruebas de API de listado de productos`
- **Estructura**:
  - `Background:` para configuración compartida (URL, datos base)
  - Un feature por preocupación de API (productos, búsqueda, usuarios)
  - Cada escenario debe ser independiente y autocontenido
- **Aserciones**:
  - Usar la sintaxis `match` de Karate para validación JSON
  - Validar tanto códigos de estado como contenido de respuesta
  - Manejar códigos de respuesta específicos de la API (ej. campo `responseCode`)
- **Gestión de datos**:
  - Usar `karate-config.js` para datos específicos del entorno
  - Generar datos únicos para pruebas que crean/eliminan recursos

### Archivos de Configuración
- **karate-config.js**:
  - Configuración central para la URL base de la API y datos de prueba
  - Funciones para generar identificadores únicos (correos, etc.)
  - Cambio de entorno mediante la propiedad `karate.env`
- **logback-test.xml**: Configuración de registro para la ejecución de pruebas

### Organización de Archivos
```
src/test/java/
├── automation/              # Paquete principal de pruebas
│   ├── AutomationTest.java  # Runner de pruebas en paralelo
│   ├── products/            # Pruebas de API de productos
│   │   ├── ProductsRunner.java
│   │   └── products.feature
│   ├── search/              # Pruebas de API de búsqueda
│   │   ├── SearchRunner.java
│   │   └── search.feature
│   └── users/               # Pruebas de cuentas de usuario
│       ├── UsersRunner.java
│       └── user-crud.feature
└── resources/               # Archivos de configuración
    ├── karate-config.js
    └── logback-test.xml
```

## Patrones Comunes

### Creación de Nuevos Escenarios de Prueba
1. Crear el archivo feature en el directorio de paquete apropiado
2. Crear el Runner.java correspondiente con la anotación `@Karate.Test`
3. Agregar a la ejecución paralela en AutomationTest.java si es necesario
4. Actualizar AGENTS.md si se agregan nuevos patrones

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
```

### Generación de Datos
- Usar `java.lang.System.currentTimeMillis()` para IDs únicos
- Almacenar datos generados en variables para escenarios de múltiples pasos
- Limpiar los recursos creados cuando sea posible (pruebas DELETE)

## Configuración de Entorno
- Entorno predeterminado: `dev`
- Configurar mediante: `mvn test -Dkarate.env=e2e`
- La configuración en `karate-config.js` maneja la URL y credenciales por entorno

## Notas para Agentes
- Esta es una plantilla de taller — mantener los ejemplos simples y educativos
- Mantener las descripciones en español para los participantes del taller
- Todas las pruebas deben pasar antes de confirmar los cambios
- Ejecutar `mvn clean test` para verificar el conjunto completo de pruebas
- Los reportes HTML se generan en `target/karate-reports/` después de la ejecución de pruebas