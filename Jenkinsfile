pipeline {
    agent any

    parameters {
        string(name: 'PROJECT_KEY', description: 'Key of the project', defaultValue: '')
        string(name: 'TEST_EXECUTION_KEY', description: 'Key of the test execution', defaultValue: '')
        string(name: 'milestoneId', description: 'Milestone ID', defaultValue: '')
        string(name: 'testPlanKeys', description: 'Test Plan Keys', defaultValue: '')
        string(name: 'testEnvironments', description: 'Test Environments', defaultValue: '')
        string(name: 'revision', description: 'Revision Identifier', defaultValue: '')
        string(name: 'fixVersions', description: 'Fix Versions', defaultValue: '')
    }

    environment {
        AGILETEST_BASE_URL = 'https://jira1.demo.devsamurai.com'
        AGILETEST_CLIENT_TOKEN = 'MzA5MzAzMDgwMDQyOqa1EXYvy1LxJXmivsFGGUMIqzzI'
        PATH = "/usr/local/bin:${env.PATH}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'cucumber', 
                    url: 'https://github.com/Nanna-hehe/autodatacenter.git', 
                    credentialsId: '05f6d992-036c-42c7-ba6f-a91d89e425c9'
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "Running tests..."
                    dir('autodatacenter') {
                        try {
                            sh 'yarn'
                        } catch (err) {
                            error "Yarn install failed: ${err}"
                        }

                        try {
                            sh 'yarn cucumber-test'
                        } catch (err) {
                            error "Test execution failed: ${err}"
                        }
                    }
                    echo "Tests completed."
                }
            }
        }

        stage('API Authentication & Test Result Submission') {
            steps {
                script {
                    def token = authenticateApi()
                    echo "API Token: ${token}"

                    echo "Project key: ${params.PROJECT_KEY}"
                    echo "Test execution key: ${params.TEST_EXECUTION_KEY}"

                    def response = submitTestResults(token)
                    echo "API Response: ${response}"
                }
            }
        }

        stage('Finish') {
            steps {
                echo "Build process completed."
            }
        }
    }

    post {
        success {
            script {
                echo 'Build succeeded.'
                def token = authenticateApi()
                sendBuildStatus(token, "success")
            }
        }
        failure {
            script {
                echo 'Build failed.'
                def token = authenticateApi()
                sendBuildStatus(token, "failed")
            }
        }
    }
}

// -----------------------------
// Utility Functions
// -----------------------------

def authenticateApi() {
    return "${env.AGILETEST_CLIENT_TOKEN}" // Optionally replace with real token logic
}

def submitTestResults(token) {
    return sh(script: """
        curl -s -X POST -H "Content-Type: application/xml" \\
            -H "Authorization: Bearer ${token}" \\
            --data @reports/cucumber-report.json \\
            "${env.AGILETEST_BASE_URL}/rest/agiletest/1.0/test-executions/automation/cucumber?projectKey=${params.PROJECT_KEY}&testExecutionKey=${params.TEST_EXECUTION_KEY}&milestoneId=${params.milestoneId}&testEnvironments=${params.testEnvironments}&testPlanKeys=${params.testPlanKeys}&revision=${params.revision}&fixVersions=${params.fixVersions}"
    """, returnStdout: true).trim()
}

def sendBuildStatus(token, status) {
    def response = sh(script: """
        curl -s -H "Content-Type: application/json" \\
            -H "Authorization: Bearer ${token}" \\
            --data '{ "buildURL": "${env.BUILD_URL}", "tool": "jenkins-multibranch", "result": "${status}" }' \\
            "${env.AGILETEST_BASE_URL}/rest/agiletest/1.0/test-executions/${params.TEST_EXECUTION_KEY}/pipeline/history?projectKey=${params.PROJECT_KEY}"
    """, returnStdout: true).trim()

    echo "API Response for ${status} build: ${response}"
}
