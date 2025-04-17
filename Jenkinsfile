pipeline {
    agent any

    parameters {
        string(name: 'PROJECT_KEY', description: 'Key of the project', defaultValue: '$PROJECT_KEY')
        string(name: 'TEST_EXECUTION_KEY', description: 'Key of the test execution', defaultValue: '$TEST_EXECUTION_KEY')
        string(name: 'milestoneId', description: 'Key of the test execution', defaultValue: '$milestoneId')
        string(name: 'testPlanKeys', description: 'Key of the test execution', defaultValue: '$testPlanKeys')
        string(name: 'testEnvironments', description: 'Key of the test execution', defaultValue: '$testEnvironments')
        string(name: 'revision', description: 'Key of the test execution', defaultValue: '$revision')
        string(name: 'fixVersions', description: 'Key of the test execution', defaultValue: '$fixVersions')
    }

    environment {
        AGILETEST_BASE_URL = 'https://jira4.demo.devsamurai.com'
        AGILETEST_CLIENT_TOKEN = 'NTA1ODY4NDIwMzk5OpOKPtGBhCJaGfe4gFkJQBFzNojX'
        PATH = "/usr/local/bin:${env.PATH}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'junit', url: 'https://github.com/Nanna-hehe/autodatacenter.git', credentialsId: '05f6d992-036c-42c7-ba6f-a91d89e425c9'
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "Running tests..."
                    dir('autodatacenter') {
                        sh 'npm ci'
                        sh 'npm run' // Replace with actual npm script name if different
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

                    def response = submitTestResults(token, params.PROJECT_KEY)
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

def authenticateApi() {
    return "${env.AGILETEST_CLIENT_TOKEN}" // Replace this with real auth logic if needed
}

def submitTestResults(token, projectKey) {
    return sh(script: """
        curl -X POST -H "Content-Type: application/xml" \\
        -H "Authorization: Bearer ${token}" \\
        --data @"./playwright-report/results.xml" \\
        "${env.AGILETEST_BASE_URL}/rest/agiletest/1.0/test-executions/automation/junit?projectKey=${params.PROJECT_KEY}&testExecutionKey=${params.TEST_EXECUTION_KEY}&milestoneId=${params.milestoneId}&testEnvironments=${params.testEnvironments}&testPlanKeys=${params.testPlanKeys}&revision=${params.revision}&fixVersions=${params.fixVersions}"
    """, returnStdout: true).trim()
}

def sendBuildStatus(token, status) {
    def response = sh(script: """
        curl -s -H "Content-Type:application/json" -H "Authorization:Bearer $token" \
        --data '{ "buildURL": "'"$env.BUILD_URL"'", "tool":"jenkins-multibranch", "result":"${status}" }' \
        "${env.AGILETEST_BASE_URL}/rest/agiletest/1.0/test-executions/${params.TEST_EXECUTION_KEY}/pipeline/history?projectKey=${params.PROJECT_KEY}"
    """, returnStdout: true).trim()


https://jira4.demo.devsamurai.com/rest/agiletest/1.0/test-executions/YOIC-7/pipeline/history?projectKey=YOIC
    echo "API Response for ${status} build: ${response}"
}
