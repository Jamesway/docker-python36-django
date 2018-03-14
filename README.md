# Django with Docker.

## Usage
### Start a django project
```
docker run --rm -v $(pwd):/code jamesway/python36-django django-admin startproject [project_name]
```

### Clone this repo into your project
```
cd [project_name]
wget https://github.com/Jamesway/docker-django2-cheatsheet/archive/master.zip -O ./temp.zip \
&& unzip -j temp.zip \
&& rm temp.zip
```

### Docker-Sync (optional)
**NOTE: Docker compose expects a docker-sync volume by default. To use docker-compose without docker-sync, rename the docker-compose-override.yml to _docker-compose-override.yml (any name works as long as it's not docker-compose-override.yml).**
```
docker-sync start

# when not needed, eg after exiting runserver, stop and clean docker-sync
docker-sync stop
docker-sync clean
```
*Note: "docker-sync clean" may barf output. It doesn't seem to affect anything*

### Start an app
**NOTE: app_names can't have dashes (-), underscores only**
```
docker-compose run --rm django python startapp [app_name]

# or without compose
docker run --rm -v $(pwd):/code jamesway/python36-django python manage.py startapp [app_name]
```

### settings.py

- **ALLOWED_HOSTS** Before we runserver, we need to add the docker machine ip to ALLOWED_HOSTS
```
docker-machine ip

# eg: ALLOWED_HOSTS = ['192.168.99.100']
```
*Note: ALLOWED_HOSTS expects a string*

- **INSTALLED_APPS** add your app_name to the list


### runserver
```
# 0:8000 listen on all IPs - since the server is in the container, localhost/127.0.0.1 doesn't map
docker-compose run --rm django manage.py runserver 0:8000

#or without compose - note the -p and -itv flags
docker run --rm -p 8000:8000 -itv $(pwd):/code jamesway/python36-django python manage.py startapp [app_name]
```

Open a browser to your docker ip:8000, eg 192.168.99.100:8000
You should see the django page

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
...
# note: python 1 used url() method, django 2 uses path for string paths or re_path for regexes
path('index/', views.index, name='index1'),
re_path(r'^index$', views.index, name='index2'),
path('admin/', admin.site.urls),
...
```  
