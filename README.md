# Plantilla de Proyecto Karate Framework - API AutomationExercise

Plantilla base para pruebas de API REST con [Karate Framework](https://github.com/karatelabs/karate), configurada específicamente para la API pública de [AutomationExercise](https://automationexercise.com/api_list).

## API Objetivo

La API de AutomationExercise提供了 endpoints para práctica de pruebas API. Esta plantilla implementa 4 escenarios clave:

1. **GET** - Obtener lista de productos
2. **POST** - Buscar producto por término
3. **PUT** - Actualizar cuenta de usuario
4. **DELETE** - Eliminar cuenta de usuario

## Prerrequisitos

- **Java 17** o superior
- **Maven 3.x** o superior
- Un IDE (IntelliJ IDEA, Eclipse, VS Code) con soporte de Maven

## Estructura del Proyecto

```
karate-taller/
├── pom.xml                          # Configuración Maven
├── src/
│   └── test/
│       ├── java/                    # Código Java de pruebas
│       │   ├── automation/          # Paquete principal de pruebas
│       │   │   ├── AutomationTest.java     # Runner paralelo para todos los features
│       │   │   ├── products/        # Pruebas de productos (GET)
│       │   │   │   ├── ProductsRunner.java
│       │   │   │   └── products.feature
│       │   │   ├── search/          # Pruebas de búsqueda (POST)
│       │   │   │   ├── SearchRunner.java
│       │   │   │   └── search.feature
│       │   │   └── users/           # Pruebas de usuarios (PUT, DELETE)
│       │   │       ├── UsersRunner.java
│       │   │       └── user-crud.feature
│       │   └── examples/            # Ejemplo original (puedes eliminar)
│       └── resources/               # Recursos de configuración
│           ├── karate-config.js     # Configuración de API y datos de prueba
│           └── logback-test.xml     # Configuración de logs
└── target/                          # Directorio de salida Maven
    └── karate-reports/              # Reportes HTML generados
```

## Configuración de la API

La configuración específica para AutomationExercise está en `karate-config.js`:

```javascript
// URL base de la API
baseUrl: 'https://automationexercise.com/api'

// Función para generar emails únicos
generateEmail: function() { ... }

// Datos por defecto para creación de usuarios
defaultUserData: function() { ... }
```

## Ejecución de Pruebas

### Ejecutar todas las pruebas (GET, POST, PUT, DELETE)
```bash
mvn test
```

### Ejecutar pruebas por tipo de método HTTP
```bash
# Solo GET (productos)
mvn test -Dtest=ProductsRunner

# Solo POST (búsqueda)
mvn test -Dtest=SearchRunner

# Solo PUT y DELETE (usuarios)
mvn test -Dtest=UsersRunner
```

### Ejecutar desde IDE
Clic derecho en cualquier archivo `*Runner.java` o `AutomationTest.java` → Run/Debug

## Escenarios Implementados

### 1. GET - Obtener lista de productos
- **Endpoint**: `/productsList`
- **Método**: GET
- **Valida**: Status 200, array de productos con estructura esperada

### 2. POST - Buscar producto
- **Endpoint**: `/searchProduct`
- **Método**: POST
- **Parámetros**: `search_product` (ej: "top")
- **Valida**: Status 200 para búsqueda exitosa, Status 400 para parámetro faltante

### 3. PUT - Actualizar usuario
- **Endpoint**: `/updateAccount`
- **Método**: PUT
- **Flujo**: 
  1. Crear usuario con email único
  2. Actualizar campos del usuario
  3. Validar respuesta "User updated!"

### 4. DELETE - Eliminar usuario
- **Endpoint**: `/deleteAccount`
- **Método**: DELETE
- **Flujo**:
  1. Crear usuario con email único
  2. Eliminar usuario
  3. Validar respuesta "Account deleted!"

## Reportes

Los reportes HTML se generan automáticamente en:
```
target/karate-reports/
├── automation.products.products.html
├── automation.search.search.html
├── automation.users.user-crud.html
└── karate-summary.html  # Resumen general
```

## Personalización para Otros APIs

Para adaptar esta plantilla a otra API:

1. **Modificar `karate-config.js`**:
   - Cambiar `baseUrl` a tu nueva API
   - Ajustar `defaultUserData()` si es necesario

2. **Crear nuevos features**:
   - Copiar estructura de los existentes
   - Modificar endpoints, parámetros y validaciones

3. **Actualizar runners**:
   - Crear nuevos `*Runner.java` para cada feature
   - O modificar `AutomationTest.java` para incluir nuevos paquetes

## Comandos Maven Útiles

```bash
mvn clean test        # Limpiar y ejecutar todas las pruebas
mvn test-compile      # Solo compilar pruebas
mvn test -X           # Ejecutar con debug
```

## Solución de Problemas

- **Error 405 (Method Not Allowed)**: Algunos endpoints solo soportan métodos específicos
- **Error 400 (Bad Request)**: Parámetros requeridos faltantes
- **Datos de usuario**: Los tests de PUT/DELETE crean usuarios temporales con emails únicos

## Recursos

- [API AutomationExercise](https://automationexercise.com/api_list)
- [Documentación Karate](https://karatelabs.github.io/karate/)
- [Sintaxis Gherkin](https://karatelabs.github.io/karate/#karate-language)