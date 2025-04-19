# Для этого Makefile требуется GNU Make
MAKEFLAGS += --silent

# =================================================================================================
#  Инициализация
# =================================================================================================
# Загрузка переменных окружения из .env файла
ENV_FILE := .env
DOCKER_DIR := .docker

# Проверка существования .env файла
ifneq (,$(wildcard $(ENV_FILE)))
    include $(ENV_FILE)
endif

# =================================================================================================
#  Конфигурация
# =================================================================================================
# Значения по умолчанию для переменных окружения
DOCKER_TITLE			?= $(PROJECT_TITLE)
DOCKER_ABBR				?= $(PROJECT_ABBR)
DOCKER_HOST				?= $(PROJECT_HOST)
DOCKER_PORT				?= $(PROJECT_PORT)
DOCKER_CAAS				?= $(PROJECT_CAAS)
DOCKER_PATH				?= $(PROJECT_PATH)
SYMFONY_VERSION			?= 7.2.x

# Вычисляемые переменные
CURRENT_DIR				:= $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))
DOCKER_COMPOSE			:= $(DOCKER_USER) docker compose
DOCKER_EXEC				:= $(DOCKER_USER) docker exec -it $(DOCKER_CAAS) sh -c

# Цвета для терминала
C_HEAD					:= \033[1;36m
C_BLU					:= \033[0;34m
C_GRN					:= \033[0;32m
C_RED					:= \033[0;31m
C_YEL					:= \033[0;33m
C_END					:= \033[0m

# =================================================================================================
#  Справочная система
# =================================================================================================
.PHONY: help
help: ## Показать справку по командам
	echo "$(C_HEAD)Доступные команды:$(C_END)"
	echo "$(C_BLU)Использование: make [цель]$(C_END)"
	awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "$(C_YEL)%-25s$(C_END) %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# =================================================================================================
#  Управление окружающей средой
# =================================================================================================
.PHONY: env env-set

env: ## Отображение текущей конфигурации среды
	echo "$(C_HEAD)Текущая конфигурация среды:$(C_END)"
	awk '!/^#/ && !/^$$/ {printf "	$(C_BLU)%-20s$(C_END) %s\n", $$1, $$2}' FS='=' $(ENV_FILE)

env-set: ## Создание шаблона среды
	printf "\
	# =======================================================\n\
	# Конфигурация средства настройки\n\
	# =======================================================\n\
	# Пользователь Docker (sudo, если требуется)\n\
	DOCKER_USER=\"sudo\"\n\n\
	# =======================================================\n\
	# Метаданные сервиса\n\
	# =======================================================\n\
	# Отображаемое название проекта\n\
	PROJECT_TITLE=\"Symfony App\"\n\
	# Краткий идентификатор проекта (3-5 букв)\n\
	PROJECT_ABBR=\"app\"\n\n\
	# =======================================================\n\
	# Краткий идентификатор проекта\n\
	# =======================================================\n\
	# Привязка к хосту (127.0.0.1 или localhost)\n\
	PROJECT_HOST=\"127.0.0.1\"\n\
	# Сопоставление портов (80-8888)\n\
	PROJECT_PORT=\"8888\"\n\
	# Имя сервиса (строчные буквы со знаками подчеркивания)\n\
	PROJECT_CAAS=\"symfony_app\"\n\
	# Путь к приложению в контейнере (относительно корня проекта)\n\
	PROJECT_PATH=\"app\"\n\n\
	" | sed 's/^\t\t//' > $(ENV_FILE)
	echo "$(C_GRN)✔ Создан шаблон среды$(C_END)"
	echo "$(C_YEL)⚠ Пожалуйста, просмотрите и отредактируйте env-файлы$(C_END)"

# =================================================================================================
#  Валидаторы
# =================================================================================================
.PHONY: validate
validate: ## Проверка конфигурации среды и генерация docker-конфига
	test -s $(DOCKER_DIR) || (echo "$(C_RED)✗ Отсутствует директория $(DOCKER_DIR)$(C_END)\n Создайте её или проверьте конфигурацию"; exit 1;)
	test -s $(ENV_FILE) || (echo "$(C_RED)✗ Отсутствует файл .env$(C_END)\n Выполните: $(C_YEL)make env-set$(C_END)"; exit 1;)
	printf "\
	COMPOSE_PROJECT_ABBR=\"%s\"\n\
	COMPOSE_PROJECT_HOST=\"%s\"\n\
	COMPOSE_PROJECT_PORT=\"%s\"\n\
	COMPOSE_PROJECT_NAME=\"%s\"\n\
	COMPOSE_PROJECT_PATH=\"%s\"\
	" \
		"$(DOCKER_ABBR)" \
		"$(DOCKER_HOST)" \
		"$(DOCKER_PORT)" \
		"$(DOCKER_CAAS)" \
		"$(DOCKER_PATH)" \
	 > $(DOCKER_DIR)/$(ENV_FILE)
	echo "$(C_GRN)✔ Конфигурация валидна$(C_END)"
	echo "• Сгенерирован файл: $(C_BLU)$(DOCKER_DIR)/$(ENV_FILE)$(C_END)"

# =================================================================================================
#  Управление docker
# =================================================================================================
.PHONY: build up start stop restart clean

build: validate ## Формирование сервисов
	cd $(DOCKER_DIR) && $(DOCKER_COMPOSE) up --build --no-recreate -d
	echo "$(C_GRN)✔ Контейнеры успешно построены$(C_END)"

up: validate ## Запуск всех сервисов
	cd $(DOCKER_DIR) && $(DOCKER_COMPOSE) up -d
	echo "$(C_GRN)✔ Контейнеры запущены$(C_END)"

start: ## Запуск существующих сервисов
	cd $(DOCKER_DIR) && $(DOCKER_COMPOSE) start
	echo "$(C_GRN)✔ Контейнеры перезапущены$(C_END)"

stop: ## Остановка запущенных сервисов
	cd $(DOCKER_DIR) && $(DOCKER_COMPOSE) stop
	echo "$(C_YEL)⚠ Контейнеры остановлены$(C_END)"

restart: stop start ## Перезапуск сервисов

clean: ## Удаление всех сервисов и зависимостей
	cd $(DOCKER_DIR) && $(DOCKER_COMPOSE) down -v --rmi local
	echo "$(C_YEL)⚠ Удаленны контейнеры и объемы$(C_END)"

# =================================================================================================
#  Управление приложением
# =================================================================================================
.PHONY: app-install app-update app-clean

app-install: ## Установка приложения Symfony с помощью пакета webapp bundle
	echo "$(C_YEL)▶ Установка каркаса Symfony...$(C_END)"
	$(DOCKER_EXEC) ' \
		git clone https://github.com/csitrovsky/symfony-tailwind-starter.git skeleton && \
		cd skeleton && \
		rm -rf .git && \
		[ -f .env ] || cp .env.example .env && \
		composer install && \
		npm install && \
		(mv -n * /var/www/html/ || true) && \
		(mv -n .[!.]* /var/www/html/ || true) && \
		cd .. && \
		rm -rf skeleton \
	'
	echo "$(C_GRN)✔ Приложение Symfony успешно установлено с помощью пакета webapp$(C_END)"

app-update: ## Обновление зависимостей
	$(DOCKER_EXEC) "composer update --with-dependencies"
	echo "$(C_GRN)✔ Зависимости обновлены$(C_END)"

app-clean: ## Очистка кэша приложения
	$(DOCKER_EXEC) "rm -rf var/cache/*"
	echo "$(C_YEL)⚠ Application cache cleaned$(C_END)"

# =================================================================================================
#  Управление услугами
# =================================================================================================
.PHONY: ssh

ssh: ## Войти в контейнер
	$(DOCKER_USER) docker exec -it $(DOCKER_CAAS) sh