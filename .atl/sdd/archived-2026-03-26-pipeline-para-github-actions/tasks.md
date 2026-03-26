# Tasks: GitHub Actions Pipeline para Pruebas Karate

## Phase 1: Infrastructure (Workflow Files)

- [x] 1.1 Create `.github/workflows/test.yml` - Main CI/CD workflow with push and pull_request triggers
- [x] 1.2 Configure Java 17 setup using actions/setup-java with temurin distribution
- [x] 1.3 Add Maven dependency caching using cache: 'maven'
- [x] 1.4 Create `.github/workflows/allure.yml` - Optional workflow for serving Allure report on demand

## Phase 2: Core Implementation (Pipeline Steps)

- [x] 2.1 Add step to execute `mvn clean test` command
- [x] 2.2 Add step to generate Allure report with `mvn allure:report`
- [x] 2.3 Configure artifact upload for allure-results (target/allure-results)
- [x] 2.4 Configure artifact upload for allure-report (target/allure-report)
- [x] 2.5 Add workflow_dispatch trigger to allure.yml for manual report serving

## Phase 3: Testing / Verification

- [x] 3.1 Validate workflow YAML syntax using GitHub UI or CLI
- [x] 3.2 Trigger manual workflow run to verify test execution
- [x] 3.3 Verify Allure artifacts are uploaded and downloadable
- [x] 3.4 Test failure scenario: verify workflow fails when tests fail

## Phase 4: Cleanup / Documentation

- [ ] 4.1 Document pipeline usage in project README (optional)
- [ ] 4.2 Add pipeline badge to README showing CI status (optional)
