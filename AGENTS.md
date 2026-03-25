# AGENTS.md

Este archivo proporciona orientación para agentes de codificación IA que trabajan en este repositorio.

## Descripción del Proyecto
- **Framework**: Karate Framework 1.5.2 para pruebas de API
- **Sistema de Construcción**: Maven 3.x con Java 17
- **Estructura**: Organización modular por dominios (users, products, auth, common)
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

# Generar reportes solamente (después de que las pruebas hayan corrido)
mvn surefire-report:report
```

### Ejecución de Features Individuales
- Ejecutar desde IDE: Clic derecho en `ProductsRunner.java`, `UsersRunner.java` o `TestRunner.java` → Run/Debug
- Los features se ejecutan por dominio (products, users, auth, common)

## Guías de Estilo de Código

### Archivos Java
- **Nomenclatura de paquetes**: Todo en minúsculas, basado en dominio (`users`, `products`, `auth`, `common`)
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
- **Aserciones**:
  - Usar la sintaxis `match` de Karate para validación JSON
  - Validar tanto códigos de estado como contenido de respuesta
  - Manejar códigos de respuesta específicos de la API (ej. campo `responseCode`)
- **Gestión de datos**:
  - Usar `karate-config.js` para datos específicos del entorno
  - Generar datos únicos para pruebas que crean/eliminan recursos
  - Almacenar datos de prueba en archivos JSON/CSV dentro de cada directorio de dominio

### Archivos de Configuración
- **karate-config.js**: Ubicado en `src/test/java/`
  - Configuración central para la URL base de la API y datos de prueba
  - Funciones para generar identificadores únicos (correos, etc.)
  - Cambio de entorno mediante la propiedad `karate.env`
- **logback-test.xml**: Configuración de registro para la ejecución de pruebas

### Organización de Archivos
```
src/test/java/
├── karate-config.js              # Configuración global
├── logback-test.xml              # Configuración de logs
├── TestRunner.java               # Runner principal para ejecución paralela
│
├── users/                        # Dominio: Usuarios
│   ├── users.feature             # Escenarios CRUD de usuarios
│   ├── user-data.json            # Datos de prueba
│   └── UsersRunner.java          # Runner individual
│
├── products/                     # Dominio: Productos
│   ├── products.feature          # Escenarios de listado y búsqueda
│   ├── product-data.csv          # Datos de productos
│   └── ProductsRunner.java       # Runner individual
│
├── auth/                         # Dominio: Autenticación (placeholders)
│   ├── login.feature
│   └── oauth-flow.feature
│
└── common/                       # Utilidades compartidas
    ├── api-helpers.feature       # Funciones reutilizables
    ├── validators.js             # Validadores JavaScript
    └── test-data.json            # Datos comunes
```

## Patrones Comunes

### Creación de Nuevos Escenarios de Prueba
1. Crear el archivo feature en el directorio de dominio apropiado
2. Crear el Runner.java correspondiente con la anotación `@Karate.Test`
3. Agregar a la ejecución paralela en TestRunner.java si es necesario
4. Crear archivos de datos de prueba (JSON/CSV) en el mismo directorio
5. Actualizar AGENTS.md si se agregan nuevos patrones

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
- Usar archivos JSON/CSV para datos de prueba complejos
- Limpiar los recursos creados cuando sea posible (pruebas DELETE)

## Configuración de Entorno
- Entorno predeterminado: `dev`
- Configurar mediante: `mvn test -Dkarate.env=e2e`
- La configuración en `karate-config.js` maneja la URL y credenciales por entorno

## Notas para Agentes
- Esta es una plantilla de taller — mantener los ejemplos simples y educativos
- La estructura modular permite escalar añadiendo nuevos dominios
- Mantener las descripciones en español para los participantes del taller
- Todas las pruebas deben pasar antes de confirmar los cambios
- Ejecutar `mvn clean test` para verificar el conjunto completo de pruebas
- Los reportes HTML se generan en `target/karate-reports/` después de la ejecución de pruebas
- Los directorios `auth/` y `common/` son placeholders para extender funcionalidades