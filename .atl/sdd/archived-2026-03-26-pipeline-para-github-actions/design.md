# Design: GitHub Actions Pipeline para Pruebas Karate

## Technical Approach

El pipeline automatiza la ejecución de pruebas Karate en cada push y pull request mediante GitHub Actions. El flujo es: trigger → setup Java 17 → install dependencies → run tests → generate Allure report → upload artifacts. Esta aproximación sigue el patrón estándar de CI/CD para proyectos Maven con integración de reportes de prueba.

## Architecture Decisions

### Decision: Job Structure

**Choice**: Single job con pasos secuenciales
**Alternatives considered**: Multiple jobs (setup, test, report) con artifact sharing
**Rationale**: Simplifica la configuración y reduce overhead de transferencia de artifacts entre jobs. El tiempo de ejecución no justifica la complejidad de jobs distribuidos para este proyecto.

### Decision: Java Version

**Choice**: Java 17 (temurin)
**Alternatives considered**: Java 11, Java 21
**Rationale**: Coincide exactamente con `<java.version>17</java.version>` en pom.xml. Garantiza compatibilidad completa con Karate 1.5.2 y las dependencias del proyecto.

### Decision: Allure Report Handling

**Choice**: Generate report en el pipeline + upload results como artifact
**Alternatives considered**: Solo upload results, generar después localmente
**Rationale**: Permite acceso inmediato al reporte desde GitHub Actions sin necesidad de recrear el ambiente local. Results comprimidos ocupan poco espacio.

### Decision: Maven Cache Strategy

**Choice**: GitHub Actions cache para Maven dependencies
**Alternatives considered**: No cache, cache manual
**Rationale**: Acelera ejecuciones subsecuentes significativamente. GitHub Actions provee acción oficial `actions/cache` optimizada para Maven.

## Data Flow

```
GitHub Push/PR
     │
     ▼
┌─────────────────────────────┐
│  Checkout Code              │
│  Setup Java 17              │
│  Cache Maven Dependencies   │
│  Run mvn clean test          │
│  Generate Allure Report      │
│  Upload Artifacts            │
└─────────────────────────────┘
     │
     ▼
   GitHub Actions UI
   (Test Results + Allure)
```

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `.github/workflows/test.yml` | Create | Workflow principal de CI/CD |
| `.github/workflows/allure.yml` | Create | Workflow para servir Allure report |

## Implementation Details

### test.yml Structure

```yaml
name: Karate Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'
          cache: 'maven'
      - run: mvn clean test
      - name: Generate Allure Report
        run: mvn allure:report
      - uses: actions/upload-artifact@v4
        with:
          name: allure-results
          path: target/allure-results
      - uses: actions/upload-artifact@v4
        with:
          name: allure-report
          path: target/allure-report
```

### allure.yml Structure (Optional for PR comments)

```yaml
name: Allure Report
on: workflow_dispatch
jobs:
  report:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/download-artifact@v4
        with:
          name: allure-results
      - run: mvn allure:serve
```

## Artifacts Generated

| Artifact | Location | Description |
|----------|----------|-------------|
| `allure-results` | GitHub Actions | XML results para Allure history |
| `allure-report` | GitHub Actions | HTML report visual |
| Test Summary | GitHub Actions UI | Fail count, pass count |

## Testing Strategy

| Layer | What to Test | Approach |
|-------|-------------|----------|
| Integration | Pipeline completo | Validar que workflow syntax es válido |
| E2E | Ejecución real | Tests corriendo en ubuntu-latest |

## Migration / Rollout

No migration required. Este es un componente nuevo que no afecta funcionalidad existente.

## Open Questions

- [ ] ¿Se desea habilitar Allure History en cada ejecución o mantener solo el último reporte?
- [ ] ¿Necesita configuración adicional de notificaciones (Slack, Discord) al fallar tests?

---

**Status**: success
**Summary**: Diseño técnico creado para pipeline GitHub Actions con Java 17, Maven, y Allure reports.
**Artifacts**: Engram `sdd/pipeline para github actions/design` | `.github/workflows/test.yml` (pendiente creación)
**Next**: sdd-tasks
**Risks**: None
**Skill Resolution**: none — no registry found
