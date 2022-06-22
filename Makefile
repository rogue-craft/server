COMPOSE = docker-compose -p rogue-craft-server -f docker/docker-compose.yml

up:
	$(COMPOSE) up --build

stop:
	$(COMPOSE) stop

rebuild:
	$(COMPOSE) rm
	$(COMPOSE) up

# make enter redis
enter:
	$(COMPOSE) exec $(filter-out $@,$(MAKECMDGOALS)) /bin/bash

# This will create an Account that is able to login to the Admin
#
admin-user:
	$(COMPOSE) exec admin /bin/bash -c "cd admin && rake db:seed"

# Generate an Admin CRUD for the given model
#
# make admin-page Model::Player
#
admin-page:
	$(COMPOSE) exec admin /bin/bash -c "cd admin && bundle exec padrino g admin_page $(filter-out $@,$(MAKECMDGOALS))"
