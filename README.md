# healthcare
A lightweight process for managing unhealthy docker containers  

## Overview
Docker added recently support for health checks but unfortunatly the docker daemon cannot (yet?) restart containers in an unhealthy state.  
  
This is the purpose of this container.  
  
The image size is only 6MB and memory footprint is kept low (less than 1MB).

## Usage
By default, healthcare monitor all your running containers and will restart any unhealthy container.  
  
Run the healthcare container with the following command:
```
docker run -d --name healthcare \
-v /var/run/docker.sock:/var/run/docker.sock \
himred/healthcare
```
Or if you prefer to use a docker-compose file:
```
version: "2"
services:
  healthcare:
    image: himred/healthcare:latest
    restart: always
    container_name: healthcare
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
```
## Configuration
By default, healthcare run the checks every 60 seconds.  
If you want to change this interval, you must define the variable **INTERVAL**.  
For example, this will start healthcare with an interval of 30 seconds:
```
docker run -d --name healthcare -e INTERVAL=30 \
-v /var/run/docker.sock:/var/run/docker.sock \
himred/healthcare
```
Of course, you can define this in your docker-compose.yml file as well.

## Labels
Healthcare use the **com.himred.hcd** label to customize the behavior container per container.  
By default, **any unhealthy container will be restarted**, unless it has the label com.himred.hcd  
If a container has the label com.himred.hcd, healthcare behavior will be the following:  

|Label   |      value      |  behavior |
|----------|-------------|------|
| com.himred.hcd | ignore | When unhealthy, healthcare will not restart the container |
| com.himred.hcd | stop   | When unhealthy, healthcare will stop the container  |
| com.himred.hcd | start&nbsp;*file.yml* | When unhealthy, healthcare will stop the container and run *docker-compose up -d* on the file provided (the file is searched in the /hcd directory).<br>Bind /hcd to your host and create yml files to use this feature.<br>This is useful to start a backup service when main service is unhealthy |

## Logs
Healthcare output all it's logs to stdout.
