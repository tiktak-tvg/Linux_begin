#!/bin/bash

# Скачиваем образ на локальный компьютер
docker pull alpine

# Скачает все доступные образы alpine
docker pull -a alpine
