test-docker-ruby-2.6:
	docker build -f test/unit/docker/ruby-2.6/Dockerfile -t rogue-craft-server-2.6  . \
	&& docker run -e GENERATE_COVERAGE=1 -v $(realpath ./test_reports):/app/test_reports --rm rogue-craft-server-2.6 \
	ruby -I . -e "require 'minitest/autorun'; Dir.glob('tests/**/*test.rb') { |f| require(f) }"
