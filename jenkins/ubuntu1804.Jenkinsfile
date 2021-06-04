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
    image.inside {
      dir('src') {
        sh script: 'make PLATFORM=octave'
        sh script: 'make PLATFORM=octave install'
      }
    }
  }

  stage('Test') {
    image.inside {
      sh script: 'octave DEM_COVID_tests.m > tests/DEM_COVID_tests_results.log'
    }
  }
}

