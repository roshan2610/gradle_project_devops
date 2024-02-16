pipeline{
    agent any
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
    }
}