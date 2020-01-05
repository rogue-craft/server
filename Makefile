test-docker-ruby-2.6:
	docker build -f test/unit/docker/ruby-2.6/Dockerfile -t rogue-craft-server-ruby-2.6 . \
	&& docker run --rm -v $(realpath ./coverage):/app/coverage rogue-craft-server-ruby-2.6 /bin/bash -c "bundle && GENERATE_COVERAGE=1 bundle exec rake test && source <\(curl -s https://codecov.io/bash\)"

test-docker-ruby-2.7:
	docker build -f test/unit/docker/ruby-2.7/Dockerfile -t rogue-craft-server-ruby-2.7 . \
	&& docker run --rm -v $(realpath ./coverage):/app/coverage rogue-craft-server-ruby-2.7 /bin/bash -c "bundle && GENERATE_COVERAGE=1 bundle exec rake test && source <\(curl -s https://codecov.io/bash\)"
