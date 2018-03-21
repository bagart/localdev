# Документация

### Содержание

+ [Быстрый запуск](#Quickstart);
+ [Требования](#Req);
+ [Переменные](#Vars);
+ [Определние сервисов для развертывания](#Def_services);
+ [Настройка openvpn-client](#OVPN);
+ [Монтирование](#Mount);

### <a name="Quickstart"></a> Быстрый запуск

Тестирование проводилось на ОС Ubuntu 16.04.4 LTS (Xenial Xerus) 

1. Cклонировать репозиторий:
```sh
$ git clone git@github.com:unicanova/localdev.git
```
2. Перейти в склонированную папку:
```sh
$ cd localdev
```
3. В файле `config` необходимо указать пользователя гитлаб репозитория, его почту, пароль и private docker registry server (см .[Переменные](#Vars)).

4. В файле `./services/ext-api` и отредактированть переменные (см. [Определние сервисов для развертывания](#Def_services)).

5. Создать папку с названием `secrets` и поместить в нее конфигурационный файл для openvpn-client `secrets/config.conf`:
```sh
$ mkdir secrets
```
6. 3апустить выполнение скрипта:
```sh
$ ./deploy.sh
```
Данный скрипт сначала устанавливает `minikube` и `kubectl`, а затем поднимает кубернетес кластер на миникубе. Так же выполняется установка утилиты для управления чартами кубернетеса - `helm`.
На готовом кубернетес кластере можно отдельно запустить `install_service.sh`, в этом случае установка утилит будет пропущена, а развернутся только сервисы.

### <a name="Req"></a> Требования

Перед запуском скрипта необходимо установить гипервизор, если в качестве гипервизора используется kvm, то необходимо так же установить драйвера.

### <a name="Vars"></a> Переменные

В файле `config` необходимо определить переменные:

| Variable name | Description | Required | Example |
| ------------- | ----------- | -------- | ------- |
| LOCALDEV_REGISTRY_USERNAME | пользователь гитлаб репозитория | Да |user |
| LOCALDEV_REGISTRY_PASSWORD | пароль пользователя гитлаб репозитория | Да | my_token |
| LOCALDEV_REGISTRY_SERVER | адрес private docker registry server, используется для создания секрета, и скачивания образов | Да | registry.gruzer.ru |
| GITLAB_EMAIL | почта пользователя гитлаб репозитория | Да | kkalynovskyi@gmail.com |
| KUBECTL_VERSION | желаямая версия kubectl | Нет | v1.9.3 |
| MINIKUBE_VERSION | желаемая версия minikube | Нет | latest |
| MINIKUBE_VM_DRIVER | драйвер для виртуальной машины | Нет | virtualbox |

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

### <a name="OVPN"></a> Настройка openvpn-client

Необходимо в папку `./secrets/` поместить конфигурационный файл для openvpn-client `secrets/config.conf`. 

### <a name="Mount"></a> Монтирование 

При запуске `minikube` содержимое папки `~/.localdev/services/` автоматически будет смонтировано на `minikube` в директорию `/home/services/`. Необходимые файлы приложений можно редактировать в папке `~/.localdev/services/`.
