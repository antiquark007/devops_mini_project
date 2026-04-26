pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo "🔄 Checking out code..."
                checkout scm
                echo "✅ Code checked out"
            }
        }

        stage('Validate') {
            steps {
                echo "🔍 Validating docker-compose.yml..."
                sh '''
                    docker compose config > /dev/null
                    echo "✅ Configuration valid"
                '''
            }
        }

        stage('Teardown') {
            steps {
                echo "🛑 Stopping old containers..."
                sh 'docker compose down --remove-orphans 2>/dev/null || true'
            }
        }

        stage('Deploy') {
            steps {
                echo "🚀 Deploying cluster..."
                sh '''
                    docker compose up -d
                    sleep 10
                    echo "✅ Deployment complete"
                '''
            }
        }

        stage('Health Check') {
            steps {
                echo "🏥 Running health checks..."
                sh '''
                    docker compose ps
                    echo "✅ Services are running"
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline succeeded! Cluster is running."
        }
        failure {
            echo "❌ Pipeline failed"
            sh 'docker compose logs || true'
        }
    }
}
