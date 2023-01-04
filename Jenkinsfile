pipeline {
    agent any
    environment {
        APP_NAME = 'Skylight'
        APP_VERSION = '1.0.0'
        PACKAGE_NAME = 'Skylight'
    }
    stages {
        // 构建 jar
        stage('Build') {
            agent {
                docker {
                    image 'maven:3.8.3-slim'
                    // 挂载在宿主机上，复用依赖文件
                    args '-v /root/.m2:/root/.m2'
                }
            }
            steps {
                sh 'sh ./jenkins/scripts/build.sh'
                // 暂存 Jar 包，避免不同 agent 下取不到文件
                stash includes: '**/target/*.jar', name: 'jar'
            }
        }

        // 单元测试
        stage('Test') {
            steps {
                sh 'sh ./jenkins/scripts/test.sh'
            }
        }

        // 部署容器
        stage('Deploy') {
            environment {
                IMAGE_NAME = 'sky-light'
                IMAGE_VERSION = '1.0.0'
                SERVER_PORT = '7072'
            }
            steps {
                unstash 'jar'
                sh 'sh ./jenkins/scripts/deploy.sh'
            }
            post {
                failure {
                    echo "部署失败"
                }
            }
        }
    }
    //    全局post
    post {
        always {
            echo "Always"
        }
        success {
            echo "Success"
        }
        failure {
            echo "Failure"
        }
    }
}