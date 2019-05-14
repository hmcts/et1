Dependencies
1. Docker
2. Gatling 


### Running Gatling tests locally

1. Start docker daemon 
2. Run below command from the application root folder to build your local docker container from where dockerfile exists.  If 'etgatling' image exists in your local you can skip this step

    ```
    > docker build -t etgatling:local -f performance-tests/Dockerfile .

    ```

3. Run command below locally to run gatling scripts against docker images
   ```
   > docker run --rm -it -v `pwd`/src/test/resources:/opt/gatling/conf -v `pwd`/src/test/scala/simulations:/opt/gatling/user-files/simulations -v `pwd`/results:/opt/gatling/results -v `pwd`/data:/opt/gatling/data etgatling:local -s simulations.EmploymentTribunalsPerformance
   ```

Note: if you are on os x you will need to include the following in the above command `--add-host localhost:<IP>`

    
4. Reports folder will be created once tests successfully ran


### Running Gatling tests using maven without container

1. Get latest from this repo.

2. Execute below command to run test

    ```
      > mvn gatling:execute

      or for single simulation execution

      > mvn gatling:execute -Dgatling.simulationClass=EmploymentTribunalsPerformance

    ```