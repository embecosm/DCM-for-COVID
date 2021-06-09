node('builder') {
  stage('Cleanup') {
    deleteDir()
  }

  stage('Checkout') {
    checkout scm
  }

  stage('Prepare Docker') {
    image = docker.build('build-env-ubuntu1804',
                         '--no-cache -f docker/linux-ubuntu1804.dockerfile docker')
  }

  stage('Build') {
  }

  stage('Test') {
    image.inside {
      sh script: 'octave DEM_COVID_tests.m > tests/DEM_COVID_tests_results.log'
    }
  }
}

