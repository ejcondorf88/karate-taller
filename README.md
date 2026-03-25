# Plantilla de Proyecto Karate Framework

Este proyecto es una plantilla base para pruebas de API con [Karate Framework](https://github.com/karatelabs/karate). Puedes adaptarla para probar cualquier API REST.

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
│       │   ├── examples/            # Paquete de ejemplos (puedes renombrar)
│       │   │   ├── ExamplesTest.java    # Runner paralelo para todos los features
│       │   │   └── users/           # Ejemplo de feature (puedes eliminar o modificar)
│       │   │       ├── UsersRunner.java 
│       │   │       └── users.feature    
│       │   └── ...                  # Agrega tus paquetes de pruebas aquí
│       └── resources/               # Recursos de configuración
│           ├── karate-config.js     # Configuración global de entornos
│           └── logback-test.xml     # Configuración de logs
└── target/                          # Directorio de salida Maven
    └── karate-reports/              # Reportes HTML generados
```

## Personalización para tu API

1. **Configurar URL base**: En `src/test/resources/karate-config.js` establece la URL de tu API.
2. **Crear tus features**: Copia la estructura de `users.feature` y adapta a tus endpoints.
3. **Crear runners**: Crea clases como `UsersRunner.java` para tus nuevos features.
4. **Actualizar ExamplesTest**: Asegúrate de que incluya tus nuevos paquetes.

## Ejecución de Pruebas

### Ejecutar todas las pruebas en paralelo
```bash
mvn test
```

### Ejecutar un feature específico
```bash
mvn test -Dtest=TuRunner
```

### Ejecutar desde IDE
Clic derecho en cualquier archivo `*Runner.java` o `*Test.java` → Run/Debug

## Reportes

Después de ejecutar las pruebas, abre:
```
target/karate-reports/karate-summary.html
```

## Configuración de Entornos

Edita `karate-config.js` para cambiar la URL base y otras variables:
```javascript
function fn() {
  var config = {
    baseUrl: 'https://tu-api.com',  // Cambia esto
    apiKey: 'tu-api-key'
  }
  return config;
}
```

## Estructura de un Feature

```gherkin
Feature: Descripción de tu funcionalidad

  Background:
    * url baseUrl  # Usa variable de configuración

  Scenario: Mi primer escenario
    Given path '/endpoint'
    When method get
    Then status 200
    And match response.field == 'valor esperado'
```

## Comandos Maven Útiles

```bash
mvn clean test        # Limpiar y ejecutar
mvn test-compile      # Solo compilar pruebas
mvn test -X           # Ejecutar con debug
```

## Solución de Problemas

- **Codificación**: Asegura UTF-8 en `pom.xml` (ya configurado)
- **Pruebas no ejecutan**: Verifica Java 17+ y Maven en PATH
- **Reportes no generan**: Permisos de escritura en `target/`

## Recursos

- [Documentación Karate](https://karatelabs.github.io/karate/)
- [GitHub Karate](https://github.com/karatelabs/karate)
- [Sintaxis Gherkin](https://karatelabs.github.io/karate/#karate-language)

## Notas para el Taller

- La estructura en `examples/users/` es solo ilustrativa
- Puedes eliminar o modificar esos archivos
- Copia y adapta la estructura para tu API específica
- La ejecución paralela está configurada en `ExamplesTest.java`