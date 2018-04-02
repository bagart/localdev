# Документация

mem
```
#force minikube remove
sudo minikube delete; rm -rf ~/.minikube/ ~/.kube ~/.localdev ~/.helm
echo nameserver 8.8.8.8 | sudo tee /etc/resolv.conf;echo nameserver 192.168.0.1 | sudo tee --append /etc/resolv.conf



dns
echo nameserver 10.96.0.10 | sudo tee /etc/resolv.conf;echo nameserver 8.8.8.8 | sudo tee --append /etc/resolv.conf

dig ext-api @10.96.0.10
curl http://ext-api.localdev.svc.dev.local/


маршрут
sudo ip r add 10.101.0.0/16 via $(minikube ip)


sudo ip r add 10.96.0.10 via $(minikube ip)
sudo ip r add 172.21.0.0/24 via $(minikube ip)
 ```
### config for proxy-nginx
```
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;

        index index.php index.html index.htm;

        server_name _;

        location / {
                resolver 10.96.0.10;
                proxy_pass http://$host$uri?$query_string;
                proxy_set_header Host $host;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Real-IP $remote_addr;
        }
}
```
 
## Содержание

+ [Быстрый запуск](#Quickstart);
+ [Требования](#Req);
+ [Переменные](#Vars);
+ [Определние сервисов для развертывания](#Def_services);
+ [Настройка openvpn-client](#OVPN);
+ [Монтирование](#Mount);

### <a name="Quickstart"></a> Быстрый запуск

Тестирование проводилось на ОС Ubuntu 16.04.4 LTS (Xenial Xerus) 

#### 1. Cклонировать репозиторий:
```sh
$ git clone git@github.com:bagart/localdev.git
```
#### 2. Перейти в склонированную папку:
```sh
$ cd localdev
```

#### 3. Установить конфиг для linux или windows
```bash
cp config.windows config
#cp config.linux config
```

#### 4. Настроить конфиг
Указать пользователя гитлаб репозитория, почту, пароль и private docker registry server (см .[Переменные](#Vars)).

#### 5. В файле `./services/ext-api` и отредактированть переменные (см. [Определние сервисов для развертывания](#Def_services)).

#### 6. Положить в директорию `secrets` файл настрйоки vpn в облачную среду
для openvpn-client `secrets/config.conf`:

#### 7. Установка `minikube`, `kubectl`, `helm`
```sh
$ ./install.sh
```

#### 8. Поднять кубернетес кластер на миникубе + инициация helm
```sh
$ ./deploy.sh
```

#### 9. прописать route о сетки minikube
```sh
sudo ip r add 10.96.0.10 via $(minikube ip)
```



На готовом кубернетес кластере можно отдельно запустить `install_service.sh`, в этом случае установка утилит будет пропущена, а развернутся только сервисы.

### <a name="Req"></a> Требования

Перед запуском скрипта необходимо установить гипервизор, если в качестве гипервизора используется kvm, то необходимо так же установить драйвера.

### <a name="Vars"></a> Переменные

В файле `config` необходимо определить переменные:

| Variable name              | Description                            | Required | Example |
| -------------------------- | -------------------------------------- | --------                              | ------- |
| LOCALDEV_REGISTRY_USERNAME | пользователь гитлаб репозитория        | Да       |user |
| LOCALDEV_REGISTRY_PASSWORD | пароль пользователя гитлаб репозитория | Да       | my_token |
| LOCALDEV_REGISTRY_SERVER   | private docker registry server, используется для создания секрета, и скачивания образов | Да | registry.gruzer.ru |
| GITLAB_EMAIL               | почта пользователя гитлаб репозитория  | Да       | @gmail.com |
| KUBECTL_VERSION            | желаямая версия kubectl                | Нет      | v1.9.3     |
| MINIKUBE_VERSION           | желаемая версия minikube               | Нет      | latest     |
| MINIKUBE_VM_DRIVER         | драйвер для виртуальной машины         | Нет      | virtualbox |

### <a name="Def_services"></a> Определние сервисов для развертывания
Для установки сервиса в локально развернутом кубернетесе, необходимо в директории `services` создать файл и определить в нем переменные:

| Variable name | Description | Required | Example |
| ------------- | ----------- | -------- | ------- |
| SERVICE_NAME | Имя сервиса, который будет установлен (скрипт будет искать директорию с именем сервиса и `helm` чартом в ней) | Да | ext-api |
| GIT_REPO_PROJECT_BASE | Если указано, сервис репозиторий будет склонирова по ссылке: <GIT_REPO_PROJECT_BASE>.<SERVICE_NAME>.git | Нет | git@gitlab.gruzer.ru:apps |
| LOCALDEV_BRANCH | Ветвь, которая будет использована при клонировании локального репозитория, так же будет использована как часть FQDN, пространства имен | Нет | stage |
| LOCALDEV_USERNAME | Имя пользователя, которое будет использовано в `helm` чарте, может быть необходимо какому-либо сервису | Да | yes |
| REMOTE_CLUSTER | Доменное имя, куда трафик должен быть перенаправлен | Нет | cluster.local |
| LOCALDEV_FAILOVER_BRANCH | То же самое что и LOCALDEV_BRANCH, но используется на удаленном кластере | Если REMOTE_CLUSTER опеределен | master |

### <a name="Mount"></a> Монтирование 

При запуске `minikube` содержимое папки `~/.localdev/services/` автоматически будет смонтировано на `minikube` в директорию `/home/services/`. Необходимые файлы приложений можно редактировать в папке `~/.localdev/services/`.


