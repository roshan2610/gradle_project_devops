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

                }
            }
        }
    }
}