# CI/CD Pipeline Specification

## Purpose

This spec defines the GitHub Actions workflow for automating Karate API tests on every push and pull request. The pipeline ensures code quality through automated testing and provides detailed test reports via Allure.

## ADDED Requirements

### Requirement: Pipeline Triggers

The pipeline MUST trigger on push and pull request events to the main branch.

#### Scenario: Push to main branch

- GIVEN developer pushes code to main branch
- WHEN workflow file exists in `.github/workflows/test.yml`
- THEN pipeline executes automatically
- AND runs `mvn clean test` command

#### Scenario: Pull request to main branch

- GIVEN developer opens/updates a pull request targeting main branch
- WHEN workflow triggers on pull_request event
- THEN pipeline executes and reports results

### Requirement: Java Environment Setup

The workflow MUST set up Java 17 environment before executing tests.

#### Scenario: Java setup on Ubuntu runner

- GIVEN workflow runs on ubuntu-latest runner
- WHEN setup-java action executes with JDK 17
- THEN Java 17 is available for Maven build
- AND Maven can execute test commands

### Requirement: Test Execution

The pipeline MUST execute Karate tests using Maven and generate Allure reports.

#### Scenario: Maven clean test execution

- GIVEN Java environment is configured
- WHEN `mvn clean test` command runs
- THEN all Karate tests execute
- AND results are generated in target directory
- AND Allure results are available in target/allure-results

#### Scenario: Generate Allure report

- GIVEN test execution completes successfully
- WHEN Allure results exist in target/allure-results
- THEN Allure report is generated
- AND report can be served for review

### Requirement: Artifact Upload

The workflow MUST upload Allure test results as artifacts for later review.

#### Scenario: Upload Allure artifacts

- GIVEN test execution completes
- WHEN Allure results directory exists
- THEN upload Allure results as ZIP artifact
- AND artifact is available for download from workflow run

### Requirement: Test Failure Handling

The pipeline MUST fail the workflow if any Karate test fails.

#### Scenario: Test failure detection

- GIVEN one or more Karate tests fail
- WHEN Maven exits with non-zero exit code
- THEN workflow marks the run as failed
- AND GitHub PR shows failed status check

## Non-Functional Requirements

### Performance

- Pipeline execution time SHOULD NOT exceed 10 minutes for full test suite
- Artifact upload SHOULD use compression to reduce storage

### Reliability

- Pipeline MUST be idempotent — running multiple times produces same results
- Workflow MUST handle transient network failures with retry logic

### Reporting

- Test results MUST be accessible via GitHub Actions artifacts
- Allure report MUST provide visual HTML representation of test results

### Security

- Sensitive credentials MUST NOT be logged or exposed in workflow outputs
- Workflow SHOULD use GitHub secrets for any required API keys
