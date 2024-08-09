docker images

docker ps -a

docker exec -it 6e0794eaac42  bash

hostname -i

docker container inspect 6e0794eaac42 

docker container inspect 6e0794eaac42 | grep IPAddress

docker container prune



Running Docker Commands

In the articles introducing Docker, you installed and managed a Docker container on an Ubuntu server. By default, the docker command can only be run by the root user, by prepending sudo power, or by a user in the docker group.

You used the docker command to pass options, subcommands, and arguments to your Docker container:

docker exec для запуска команд в активном контейнере, используя --workdir флаг для указания каталога, 

в котором должна быть запущена команда, --user флаг для запуска команды от имени другого пользователя 

и -e флаг для передачи переменной среды в контейнер или --env-file флаг для указания файл .env.

docker images для просмотра изображений, загруженных в вашу систему.

docker info для доступа к общесистемной информации.

docker ps для просмотра активных контейнеров, работающих в вашей системе, с помощью -aпереключателя для просмотра всех контейнеров, как активных, так и неактивных, и -lпереключателя для просмотра последнего созданного вами контейнера.
docker rename чтобы переименовать ваш контейнер.

docker rm с идентификатором или именем контейнера, чтобы удалить контейнер.

docker run для запуска контейнера из указанного образа, используя комбинированные -itпереключатели для интерактивного доступа к оболочке.

docker search для поиска образов, доступных на Docker Hub, и docker pull для загрузки указанного образа из реестра (например,  sudo docker search ubuntu).

docker start с идентификатором или именем контейнера, чтобы запустить остановленный контейнер.

docker stop с идентификатором или именем контейнера, чтобы остановить работающий контейнер.

docker tag переименовать созданный образ.

docker volume для управления объемами данных.

 docker docker-subcommand --help
 
 sudo systemctl status docker --no-pager -l
 
 docker login -u tvglamba
