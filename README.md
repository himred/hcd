# hcd : Health Care Daemon for docker
A lightweight process for managing unhealthy docker containers  

## Overview
Docker added recently support for health checks but unfortunatly the docker daemon cannot (yet?) restart containers in an unhealthy state.  
  
This is the purpose of this container.  
  
The image size is only 13MB and memory footprint is kept low (less than 1MB).

## Usage
By default, hcd monitor all your running containers and will restart any unhealthy container.  
  
Run the hcd container with the following command:
```
docker run -d --name hcd \
-v /var/run/docker.sock:/var/run/docker.sock \
himred/hcd
```
Or if you prefer to use a docker-compose file:
```
version: "2"
services:
  hcd:
    image: himred/hcd:latest
    restart: always
    container_name: hcd
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
```
## Configuration
By default, hcd run the checks every 60 seconds.  
If you want to change this interval, you must define the variable **INTERVAL**.  
For example, this will start hcd with an interval of 30 seconds:
```
docker run -d --name hcd -e INTERVAL=30 \
-v /var/run/docker.sock:/var/run/docker.sock \
himred/hcd
```
Of course, you can define this in your docker-compose.yml file as well.

## Labels
hcd use the **com.himred.hcd** label to customize the behavior container per container.  
By default, **any unhealthy container will be restarted**, unless it has the label com.himred.hcd  
If a container has the label com.himred.hcd, hcd behavior will be the following:  

|Label   |      value      |  behavior |
|----------|-------------|------|
| com.himred.hcd | ignore | When unhealthy, hcd will not restart the container |
| com.himred.hcd | stop   | When unhealthy, hcd will stop the container  |
| com.himred.hcd | start&nbsp;*file.yml* | When unhealthy, hcd will stop the container and run *docker-compose up -d* on the file provided (the file is searched in the /hcd directory).<br>Bind /hcd to your host and create yml files to use this feature.<br>This is useful to start a backup service when main service is unhealthy |

## Logs
hcd output all it's logs to stdout.
