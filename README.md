# Django with Docker
Good - use the docker image to run django commands  
Better - use the docker image to start a project and use docker-compose... as a replacement for python manage.py ...

## Why
You don't have to install python, django or worry about virtual environments.

## Usage
I'll include the docker commands and the docker-compose commands where appropriate.

### Start a django project
```
docker run --rm -v $(pwd):/code jamesway/python36-django django-admin startproject [project_name]
```

### Get the docker-compose files
Clone this repo into your project
```
cd [project_name]
wget https://github.com/Jamesway/docker-python36-django/archive/master.zip -O ./temp.zip \
&& unzip -j temp.zip \
&& rm temp.zip
```

### Docker-Sync (optional)
**NOTE: Docker compose expects a docker-sync volume by default. To use docker-compose without docker-sync, rename the docker-compose-override.yml to _docker-compose-override.yml (any name works as long as it's not docker-compose-override.yml).**
```
docker-sync start

# when not needed, eg after exiting runserver, stop and clean docker-sync
# docker-sync stop may barf output. It doesn't seem to affect anything
docker-sync stop
docker-sync clean
```

### Start an app
**NOTE: app_names can't have dashes (-), underscores only**
```
docker-compose run --rm django startapp [app_name]

# without compose
docker run --rm -v $(pwd):/code jamesway/python36-django python manage.py startapp [app_name]
```

### settings.py

- **ALLOWED_HOSTS**: before we runserver, we need to add the docker machine ip to ALLOWED_HOSTS
```
docker-machine ip

# ALLOWED_HOSTS expects a string*
# eg: ALLOWED_HOSTS = ['192.168.99.100']
```

- **INSTALLED_APPS**: add [app_name] to the list


### runserver
```
# 0:8000 -> listen on all IPs
# since the server is in the container, localhost/127.0.0.1 doesn't map
# also docker compose run DOES NOT enable ports by default - it sucks
docker-compose run --rm -p 8000:8000 django runserver 0:8000

# or using the --service-porst flag
docker-compose run --rm --service-ports django runserver 0:8000

# or without compose - note the -p and -itv flags
docker run --rm -p 8000:8000 -itv $(pwd):/code jamesway/python36-django python manage.py runserver 0:8000
```

Open a browser to your http://[docker ip]:8000, eg http://192.168.99.100:8000  
You should see the default django page

## Misc

### Installing Django with anaconda/miniconda
```
conda install django

# confirm django is installed
python -m django --version
```

### Anaconda Virtual Environments
```
conda create --name myENV django

# specific version
conda create --name myENV python=3.5

activate myENV
deactivate

# mac\linux
source activate myENV
```

### views.py
Add your first view
```
from django.shortcuts import render
from django.http import HttpResponse
# Create your views here.

def index(request):
    return HttpResponse('hello world')
```

### urls.py
Add the route for your view
```
# django 1 used the url() method, django 2 uses path() for string paths or re_path() for regexes
...
path('index/', views.index, name='index1'),
re_path(r'^index$', views.index, name='index2'),
path('admin/', admin.site.urls),
...
```  
