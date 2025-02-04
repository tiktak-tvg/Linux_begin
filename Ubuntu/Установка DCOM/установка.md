##### Установка и удаление программы в операционных системах семейства Ubuntu

Для установки распакуйте архив с программой в нужную папку.

Для работы программы необходимы библиотеки, часть из которых должна быть установлена в системе, другая часть поставляется в архиве. Чтобы установить необходимые библиотеки, выполните следующие команды (на примере Ubuntu):
```bash
sudo apt install libqt5opengl5
sudo apt install libqt5xml5
sudo apt install libqt5xmlpatterns5
sudo apt install qt5-image-formats-plugins
sudo apt install libqt5printsupport5
sudo apt install libqt5help5
sudo apt install libqt5webkit5
sudo apt install ffmpeg
```

#Для сборок, поддерживающих запись видео, необходимо установить библиотеку "ffmpeg" (команда для Ubuntu: sudo apt install ffmpeg).

###### Далее перейти по пути 
```bash
cd /home/user/'Рабочий стол'/Проводник/public/DCOM/InobitecDICOMViewer 
root@ub3-12:/home/user/public/DCOM/InobitecDICOMViewer# 
```

###### Дать разрешение на выполнение скрипта 
```bash
chmod +x DicomViewerLauncher.sh 
root@ub3-12:/home/user/public/DCOM/InobitecDICOMViewer#
```

###### И запустить программу
```bash
sh DicomViewerLauncher.sh 
или так
./DicomViewerLauncher.sh
или так
sudo sh ~/public/DCOM/InobitecDICOMViewer/DicomViewerLauncher.sh
```

###### Для того чтобы работал ярлык на DCOM, который находится в папке DCOM требуется дать разрешение на папку DICOMViewerWorkspace по пути /home/user/DICOMViewerWorkspace
открываем терминал и прописываем две команды
```bash
user@ub3-12:~$sudo chown 777 DICOMViewerWorkspace
user@ub3-12:~$sudo chown user:user DICOMViewerWorkspace 
```

###### Далее переходим cd DICOMViewerWorkspace
```bash
user@ub3-12:~/DICOMViewerWorkspace$ ls
ImageStorage  Thumbnails

# Тут еще две папки, даем разрешение на них
user@ub3-12:~/DICOMViewerWorkspace$ sudo chown user:user ImageStorage
user@ub3-12:~/DICOMViewerWorkspace$ sudo chown user:user Thumbnails
user@ub3-12:~/DICOMViewerWorkspace$ cd ImageStorage
user@ub3-12:~/DICOMViewerWorkspace/ImageStorage$ sudo chown user:user *
```
###### Теперь при запуске с ярлыка, который находится в папке DCOM и который можно скопировать на рабочий стол, пароль запрашивать не будет


