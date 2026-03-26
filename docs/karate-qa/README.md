# KarateQA - Subagente Especializado en Karate Framework

## Descripción

KarateQA es un subagente especializado en pruebas API usando Karate Framework 1.5.2. Automatiza la creación, mantenimiento y debugging de pruebas API siguiendo los patrones modulares del proyecto.

## Características Principales

### 1. Creación de Features Reutilizables
- Genera features en `common/[dominio]/` siguiendo patrones establecidos
- Implementa manejo correcto de parámetros con `'#(variable)'`
- Crea datos de prueba en `data/` y helpers en `utils/`

### 2. Debugging Especializado
- Identifica errores comunes de interpolación Karate
- Analiza logs de ejecución con `mvn test -X`
- Proporciona correcciones específicas basadas en patrones conocidos

### 3. Gestión de Configuración
- Modifica `karate-config.js` solo para baseUrl y helpers
- Configura ejecución paralela en `TestRunner.java`
- Implementa tags para ejecución selectiva

### 4. Validación Automática
- Verifica que todas las pruebas pasen (6/6)
- Valida estructura JSON de respuestas
- Confirma patrones correctos de interpolación

## Instalación

### Requisitos Previos
1. Proyecto Karate Framework 1.5.2
2. Maven 3.x con Java 17
3. Estructura de proyecto modular:
   ```
   src/test/java/
   ├── common/      # Features reutilizables
   ├── data/        # Datos de prueba
   ├── utils/       # Helpers JavaScript
   ├── users/       # Tests de usuarios
   └── products/    # Tests de productos
   ```

### Configuración
1. Asegúrate de que el archivo `.opencode/agents/karate-qa.json` esté presente
2. Verifica que `AGENTS.md` esté actualizado con patrones del proyecto
3. Confirma que los helpers en `utils/` estén funcionando

## Uso

### Ejemplo 1: Crear Feature Reutilizable
```
Usuario: "Crea un feature reutilizable para autenticación de usuarios"

KarateQA:
1. Lee AGENTS.md para entender patrones
2. Verifica estructura del proyecto
3. Crea common/auth/login.feature
4. Actualiza users/users.feature
5. Verifica con mvn test -Dtest=UsersRunner
```

### Ejemplo 2: Debug de Error de Parámetros
```
Usuario: "Los parámetros no se están pasando correctamente a los features"

KarateQA:
1. Pide logs con mvn test -X
2. Identifica uso incorrecto de #()
3. Proporciona código corregido:
   ❌ Mal: And form field name = '#(userData.name)'
   ✅ Bien: And form field name = userData.name
4. Muestra patrón de llamada correcto:
   ✅ Bien: call read('...') { userData: '#(userData)' }
```

### Ejemplo 3: Optimización de Rendimiento
```
Usuario: "Las pruebas están tardando mucho"

KarateQA:
1. Verifica parallel() en TestRunner.java
2. Recomienda parallel(1) para evitar ConcurrentModificationException
3. Sugiere tags para ejecución selectiva:
   mvn test -Dkarate.options="--tags @smoke"
```

## Comandos Disponibles

### Comandos de Ejecución
```bash
# Ejecutar todas las pruebas
mvn clean test

# Ejecutar dominio específico
mvn test -Dtest=ProductsRunner
mvn test -Dtest=UsersRunner

# Ejecutar con tags
mvn test -Dkarate.options="--tags @smoke"
mvn test -Dkarate.options="--tags @users"

# Ejecutar con debug
mvn test -X

# Generar reportes
mvn allure:report
```

### Comandos de Validación
```bash
# Verificar estructura del proyecto
ls -la src/test/java/common/
ls -la src/test/java/data/
ls -la src/test/java/utils/

# Verificar helpers JavaScript
node -e "console.log(require('./src/test/java/utils/generateEmail.js'))"

# Verificar datos JSON
jq . src/test/java/data/user-data.json
```

## Patrones Críticos

### 1. Interpolación de Parámetros
```gherkin
# ❌ INCORRECTO - Error común
And form field name = '#(userData.name)'  # Dentro de feature reutilizable

# ✅ CORRECTO
And form field name = userData.name  # Dentro de feature reutilizable

# ✅ AL LLAMAR
* def res = call read('...') { userData: '#(userData)' }
```

### 2. Acceso a Resultados
```gherkin
# ❌ INCORRECTO
* match response.responseCode == 201

# ✅ CORRECTO (para features reutilizables)
* match response.result.responseCode == 201
```

### 3. Copiado de Datos
```javascript
// ❌ INCORRECTO - karate.deepCopy() no existe en 1.5.2
* def userData = karate.deepCopy(userDataTemplate)

// ✅ CORRECTO - Usar helper personalizado
* def userData = deepCopy(userDataTemplate)
```

## Estructura del Proyecto Esperada

```
karate-taller/
├── .opencode/
│   └── agents/
│       └── karate-qa.json          # Configuración del agente
├── src/test/java/
│   ├── common/                     # Features reutilizables
│   │   ├── product/               # Reutilizables para productos
│   │   └── user/                  # Reutilizables para usuarios
│   ├── data/                      # Datos de prueba centralizados
│   ├── schemas/                   # Validación JSON
│   ├── utils/                     # Helpers JavaScript
│   ├── users/                     # Pruebas de usuarios
│   ├── products/                  # Pruebas de productos
│   ├── karate-config.js           # Configuración mínima
│   └── TestRunner.java            # Runner principal
├── docs/
│   └── karate-qa/                 # Documentación del agente
└── AGENTS.md                      # Guías para agentes IA
```

## Errores Comunes y Soluciones

### Error 1: Interpolación de Parámetros
**Síntoma**: `#(variable)` aparece como texto literal
**Solución**: Cambiar a `variable` dentro de features reutilizables

### Error 2: Resultado No Encontrado
**Síntoma**: `response.responseCode` no existe
**Solución**: Usar `response.result.responseCode`

### Error 3: ConcurrentModificationException
**Síntoma**: Error durante ejecución paralela
**Solución**: Reducir a `parallel(1)` en TestRunner.java

### Error 4: karate.deepCopy No Existe
**Síntoma**: `karate.deepCopy is not a function`
**Solución**: Usar helper `deepCopy()` personalizado

## Métricas de Éxito

El agente KarateQA es exitoso si:
- **95%+** de features creados funcionan sin errores
- **80%+** de problemas de debugging se resuelven en primera interacción
- **Sigue** consistentemente patrones de AGENTS.md
- **Reduce** tiempo de debugging en 50%+

## Soporte y Debugging

### Logs Detallados
```bash
# Ejecutar con debug completo
mvn test -X > karate-debug.log

# Buscar errores específicos
grep -i "error\|exception\|fail" karate-debug.log
```

### Reportes
- **HTML Karate**: `target/karate-reports/karate-summary.html`
- **Allure Report**: `target/allure-report/index.html`

### Comando de Verificación Rápida
```bash
# Verificar que todo funciona
mvn clean test && echo "✅ Todas las pruebas pasan" || echo "❌ Hay fallos"
```

## Contribuir al Agente

Para mejorar el agente KarateQA:

1. **Agregar nuevos patrones** a AGENTS.md
2. **Documentar errores comunes** en esta guía
3. **Actualizar ejemplos** basados en uso real
4. **Mejorar detección** de problemas específicos del proyecto

## Versión

- **KarateQA**: 1.0.0
- **Karate Framework**: 1.5.2
- **Última Actualización**: 2026-03-26