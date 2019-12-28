test-docker-ruby-2.6:
	docker build -f test/unit/docker/ruby-2.6/Dockerfile -t rogue-craft-server-ruby-2.6  . \
	&& docker run --rm rogue-craft-server-ruby-2.6 bundle && GENERATE_COVERAGE=1 bundle exec rake test

test-docker-ruby-2.7:
	docker build -f test/unit/docker/ruby-2.7/Dockerfile -t rogue-craft-server-ruby-2.7  . \
	&& docker run --rm rogue-craft-server-ruby-2.7 bundle --version && bundle && GENERATE_COVERAGE=1 bundle exec rake test
