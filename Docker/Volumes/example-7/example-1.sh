#!/bin/bash

# Удаляем все не используемые volume
docker volume prune -f

# Создаём Volume
docker volume create --name storage --label maintainer='Lectrum LLC' --label used_for='mongo db storage'