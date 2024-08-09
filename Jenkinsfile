pipeline {
    agent {
        label 'slave-node-1'
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        SONAR_URL = "https://sonarqube.swapnilahirekar.in"
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Checkout from Git') {
            steps {
                git branch: 'master', url: 'https://github.com/SwapnilDA-20/tedxntua2020.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonar-creds', variable: 'SONAR_AUTH_TOKEN')]) {
                    sh '''
                        $SCANNER_HOME/bin/sonar-scanner \
                        -Dsonar.login=$SONAR_AUTH_TOKEN \
                        -Dsonar.host.url=${SONAR_URL} \
                        -Dsonar.projectName=Tedxapp2020 \
                        -Dsonar.projectKey=Tedxapp2020
                    '''
                }
            }
        }
 stage('Build and Push Docker Image') {
      environment {
        DOCKER_IMAGE = "swapnil2026/tedxapp2020:${BUILD_NUMBER}"
        REGISTRY_CREDENTIALS = credentials('dockerhub-creds')
      }
      steps {
        script {
            sh 'whoami'
            sh 'docker build -t ${DOCKER_IMAGE} .'
            def dockerImage = docker.image("${DOCKER_IMAGE}")
            withDockerRegistry(credentialsId: "dockerhub-creds") {
            dockerImage.push()          
                }
            }
          }
 }
 stage('Update Deployment File') {
     environment {
            GIT_REPO_NAME = "tedxntua2020"
            GIT_USER_NAME = "SwapnilDA-20"
        }
      steps {
        withCredentials([string(credentialsId: 'github-creds', variable: 'GITHUB_TOKEN')]) {
            script {
                // Configure Git user
                sh 'git config user.email "swapnilahirekar20@gmail.com"'
                sh 'git config user.name "Swapnil Ahirekar"'
                
                // Get the build number
                def buildNumber = env.BUILD_NUMBER
                
                // Update the deployment file with the new image tag
                sh "sed -i 's/latest/${buildNumber}/g' k8s/deployment.yml"
                
                // Stage, commit, and push changes
                sh '''
                    git add .
                    git commit -m "Update deployment image to version ${buildNumber}"
                    git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:master
                '''
                        }
                    }
                }
        }
    }
}

