pipeline{
    agent any
    environment{
        //taking this from jenkins env var
        VERSION = "${env.BUILD_ID}"
    }
    stages{
        stage("sonar quality check"){
            agent{
                docker {
                    // As java is required 
                    image 'openjdk:11'
                }
            }
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonar-token') 
                    {
                        sh 'chmod +x gradlew'  //execute perm to the file
                        sh './gradlew sonarqube'  //execute sq, pushes code to sq
                    }

                     timeout(time: 1, unit: 'HOURS') {
                      def qg = waitForQualityGate()  //it checks the json and stores at qg
                      if (qg.status != 'OK') { //if status is not ok, it will give error and stop the pipeline
                           error "Pipeline aborted due to quality gate failure: ${qg.status}"
                      }
                    }

                }
            }
        }
        stage("Docker build and docker push")
        {
            steps{
                script{
                    // tag the image
                    //remove image for disk space mngmnt
                    //nexus machine ip address with build version
                    //8083 is http port which allowed in nexus 

                    withCredentials([string(credentialsId: 'docker_pass', variable: 'docker_password')]) 
                    {
                        sh '''
                            docker build -t 52.91.251.90:8083/springapp:${VERSION} .
                            docker login -u admin -p $docker_password 52.91.251.90:8083
                            docker push 52.91.251.90:8083/springapp:${VERSION}
                            docker rmi 52.91.251.90:8083/springapp:${VERSION}
                        '''
                    }
                }
            }
        }
    }

    post {
		always {
			mail bcc: '', body: "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", to: "roshandpatil07@gmail.com";  
		}
	}
    stage('Identifying misconfigs using datree in help charts')
    {
        steps{
            script{
                dir('kubernetes/') {
                    //took this command from datree.io to trigger datree policy check via helm cli
                    sh 'helm datree test myapp/'
    
                }
            }
        }
    }
}