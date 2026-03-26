# Plantilla de Proyecto Karate Framework - API AutomationExercise

Plantilla base para pruebas de API REST con [Karate Framework](https://github.com/karatelabs/karate), configurada específicamente para la API pública de [AutomationExercise](https://automationexercise.com/api_list).

## API Objetivo

La API de AutomationExercise提供了 endpoints para práctica de pruebas API. Esta plantilla implementa 4 verbos HTTP clave:

1. **GET** - Obtener lista de productos
2. **POST** - Buscar producto y crear usuarios
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
│       ├── java/                    # Todos los archivos de prueba
│       │   ├── allure.properties    # Configuración de Allure
│       │   ├── karate-config.js     # Configuración global
│       │   ├── logback-test.xml     # Configuración de logs
│       │   ├── TestRunner.java      # Runner principal para ejecución paralela
│       │   │
│       │   ├── users/               # Pruebas de usuarios
│       │   │   ├── users.feature        # Escenarios CRUD de usuarios
│       │   │   ├── user-data.json       # Datos de prueba
│       │   │   └── UsersRunner.java     # Runner individual
│       │   │
│       │   └── products/            # Pruebas de productos
│       │       ├── products.feature     # Escenarios de listado y búsqueda
│       │       ├── product-data.csv     # Datos de productos
│       │       └── ProductsRunner.java  # Runner individual
│       │
│       └── resources/               # (Vacío - config movida a java/)
│
└── target/                          # Directorio de salida Maven
    ├── karate-reports/              # Reportes HTML generados
    ├── allure-results/              # Resultados Allure (generados automáticamente)
    └── allure-report/               # Reporte Allure HTML (generado con mvn allure:report)
```

## Configuración de la API

La configuración está en `src/test/java/karate-config.js`:

```javascript
// URL base de la API
baseUrl: 'https://automationexercise.com/api'

// Función para generar emails únicos
generateEmail: function() { ... }

// Datos por defecto para creación de usuarios
defaultUserData: function() { ... }
```

## Ejecución de Pruebas

### Ejecutar todas las pruebas (paralelo)
```bash
mvn test
```

### Ejecutar pruebas por dominio
```bash
# Solo productos (GET, POST búsqueda)
mvn test -Dtest=ProductsRunner

# Solo usuarios (POST creación, PUT actualización, DELETE eliminación)
mvn test -Dtest=UsersRunner

# Ejecutar solo un runner específico
mvn test -Dtest=TestRunner  # Todos los dominios
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

## Escenarios Implementados

### Products (3 escenarios)
- **GET** productos (listado completo)
- **POST** búsqueda con parámetro válido
- **POST** búsqueda sin parámetro (error 400)

### Users (2 escenarios)
- **POST + PUT**: Crear cuenta y actualizarla
- **POST + DELETE**: Crear cuenta y eliminarla

## Archivos de Datos de Prueba

- `users/user-data.json`: Datos genéricos para creación de usuarios
- `products/product-data.csv`: Ejemplo de productos
- `common/test-data.json`: Datos compartidos entre dominios

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
1. Crear carpeta en `src/test/java/nuevo-dominio/`
2. Crear `nuevo-dominio.feature` con escenarios
3. Crear `NuevoDominioRunner.java`
4. Actualizar `TestRunner.java` para incluir `classpath:nuevo-dominio`

### Modificar datos de prueba
- Editar archivos JSON/CSV en cada directorio de dominio
- Los datos se cargan automáticamente si se siguen las convenciones

## Comandos Maven Útiles

```bash
mvn clean test        # Limpiar y ejecutar pruebas
mvn test-compile      # Solo compilar pruebas
mvn test -X           # Ejecutar con debug
```

## Recursos

- [API AutomationExercise](https://automationexercise.com/api_list)
- [Documentación Karate](https://karatelabs.github.io/karate/)
- [Sintaxis Gherkin](https://karatelabs.github.io/karate/#karate-language)

## Notas para el Taller

- La estructura está diseñada para ser educativa y escalable
- Los componentes `auth/` y `common/` son placeholders para extender
- Cada dominio es independiente pero comparte configuración global
- Los datos de prueba se generan dinámicamente para evitar conflictos