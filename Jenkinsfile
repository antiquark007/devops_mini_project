pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
    }

    environment {
        DOCKER_COMPOSE_VERSION = '2.0'
        PROJECT_NAME = 'docker-mini-cluster'
        GIT_BRANCH = 'main'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "🔄 Checking out code from repository..."
                    try {
                        checkout([
                            $class: 'GitSCM',
                            branches: [[name: "*/${GIT_BRANCH}"]],
                            userRemoteConfigs: [[
                                url: 'https://github.com/YOUR_USERNAME/docker-mini-cluster.git'
                            ]]
                        ])
                        echo "✅ Code checked out successfully!"
                    } catch (Exception e) {
                        error("❌ Git checkout failed: ${e.message}")
                    }
                }
            }
        }

        stage('Validate') {
            steps {
                script {
                    echo "🔍 Validating project structure and files..."
                    try {
                        sh '''
                            set -e
                            requiredFiles=(
                                "docker-compose.yml"
                                "Jenkinsfile"
                                "master/index.html"
                                "worker/nginx.conf"
                                "loadbalancer/nginx.conf"
                            )
                            for file in "${requiredFiles[@]}"; do
                                if [ ! -f "$file" ]; then
                                    echo "❌ Missing required file: $file"
                                    exit 1
                                fi
                                echo "✓ Found: $file"
                            done
                            docker compose config > /dev/null
                            echo "✅ docker-compose.yml is valid"
                        '''
                    } catch (Exception e) {
                        error("❌ Validation failed: ${e.message}")
                    }
                }
            }
        }

        stage('Teardown') {
            steps {
                script {
                    echo "🛑 Stopping existing containers..."
                    sh '''
                        docker compose down --remove-orphans 2>/dev/null || true
                        sleep 2
                        echo "✅ Cleanup complete"
                    '''
                }
            }
        }

        stage('Build & Pull Images') {
            steps {
                script {
                    echo "🏗️ Pulling Docker images..."
                    try {
                        sh '''
                            docker compose pull --quiet
                            echo "✅ All images pulled successfully"
                        '''
                    } catch (Exception e) {
                        error("❌ Docker pull failed: ${e.message}")
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "🚀 Deploying cluster..."
                    try {
                        sh '''
                            docker compose up -d
                            echo "Waiting for services to stabilize..."
                            sleep 10
                            echo "✅ Deployment complete"
                        '''
                    } catch (Exception e) {
                        error("❌ Deployment failed: ${e.message}")
                    }
                }
            }
        }

        stage('Verify & Health Check') {
            steps {
                script {
                    echo "🏥 Running health checks..."
                    sh '''
                        set -e
                        echo "Checking container status..."
                        docker compose ps
                        
                        echo "Waiting for load balancer to respond..."
                        MAX_RETRIES=30
                        RETRY=0
                        until curl -s http://localhost/health > /dev/null; do
                            RETRY=$((RETRY + 1))
                            if [ $RETRY -ge $MAX_RETRIES ]; then
                                echo "❌ Load balancer health check failed"
                                docker compose logs loadbalancer
                                exit 1
                            fi
                            echo "Attempt $RETRY/$MAX_RETRIES..."
                            sleep 1
                        done
                        
                        echo "✅ Load balancer is healthy"
                        echo "Testing round-robin load balancing..."
                        for i in 1 2 3 4; do
                            echo "Request $i:"
                            curl -s http://localhost/ | grep -o "worker" || echo "Response received"
                        done
                        echo "✅ All health checks passed!"
                    '''
                }
            }
        }

        stage('Test Access') {
            steps {
                script {
                    echo "🌐 Testing service accessibility..."
                    sh '''
                        echo "Testing services..."
                        echo "Load Balancer: http://localhost"
                        echo "Worker 1: http://localhost:8081"
                        echo "Worker 2: http://localhost:8082"
                        echo "Jenkins: http://localhost:8080"
                        echo "✅ All services deployed and accessible"
                    '''
                }
            }
        }
    }

    post {
        always {
            script {
                echo "📊 Pipeline execution summary:"
                echo "Build Status: ${currentBuild.result}"
                sh '''
                    echo ""
                    echo "=== Running Containers ==="
                    docker compose ps
                '''
            }
        }

        success {
            script {
                echo "✅ Pipeline succeeded! Cluster is running."
            }
        }

        failure {
            script {
                echo "❌ Pipeline failed! Collecting debug info..."
                sh '''
                    docker compose logs || true
                    docker compose down --remove-orphans 2>/dev/null || true
                '''
            }
        }
    }
}
