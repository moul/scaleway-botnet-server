BROKER_HOST ?= 127.0.0.1
BROKER_AUTH ?= guest:guest

run: run_rabbit run_redis run_flower run_registry

run_flower:
	docker run \
	-p 5555:5555 \
	-e CELERY_BROKER_URL=amqp://$(BROKER_AUTH)@$(BROKER_HOST):5672// \
	-d \
	armbuild/iserko-docker-celery-flower \
	    --broker_api=http://$(BROKER_AUTH)@$(BROKER_HOST):15672/api/

run_redis:
	docker run \
	    -p 6379:6379 \
	    -d \
	    armbuild/dockerfile-redis

run_rabbit: /data/
	docker run \
	    -p 5672:5672 \
	    -p 15672:15672 \
	    -v /data/rabbitmq/log:/data/log \
	    -v /data/rabbitmq/mnesia:/data/mnesia \
	    -d \
	    armbuild/dockerfile-rabbitmq

run_registry: /data/
	docker run \
	    -p 5000:5000 \
	    -v /data/registry:/registry \
	    -e SETTINGS_FLAVOR=local \
	    -e STORAGE_PATH=/registry \
	    -d \
	    armbuild/registry

/data/:
	mkdir -p /data/rabbitmq/
