pipeline {
    agent any // Use any available agent
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
        CLIENT_ID = 'ohuKO8VOiFh/OeeK+qyP6xz/l7z1nivhqrkAA9BvBnI71Lbv30ZrgYM5hf4a+6v+'
        CLIENT_SECRET = '4e5c99e4b1ac3147d14126967b07a161c1f2756ec27920ea4a9969e95a10acf1'
        PATH = "/usr/local/bin:${env.PATH}" // Add Node.js to PATH
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "Running tests..."
                    dir('/Users/thuydung/Desktop/github/agiletest') {
                        sh 'npm ci' // Install dependencies
                        sh 'npm run' // Run tests
                    }
                    echo "Tests completed."
                }
            }
        }

   post {
        success {
            script {
                echo 'This will run if the build is success.'
                def token = 'NTkxMDI1NDA5OTAzOvbClbbG1WuosRUr+kpfn/WJo3Q5'
                sendBuildStatus(token, "success")
            }
        }
        failure {
            script {
                echo 'This will run if the build is failed.'
                def token = 'NTkxMDI1NDA5OTAzOvbClbbG1WuosRUr+kpfn/WJo3Q5'
                sendBuildStatus(token, "failed")
            }
        }
    }
}


        stage('Finish') {
            steps {
                echo "Build process completed."
            }
        }
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
        curl -s -H "Content-Type:application/json" -H "Authorization:JWT $token" \
        --data '{ "buildURL": "'"$env.BUILD_URL"'", "tool":"jenkins", "result":"${status}" }' \
        "${env.AGILETEST_BASE_URL}/rest/agiletest/1.0/test-executions/testExecutionKey=${params.TEST_EXECUTION_KEY}/pipleine/history?/projectKey=${params.PROJECT_KEY}"
    """, returnStdout: true).trim()

    echo "API Response for ${status} build: ${response}"
}

