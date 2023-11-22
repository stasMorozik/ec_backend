build_core_tests:
	docker build -f Dockerfile.test.core ./  -t core_tests
core_tests:
	docker run --rm --name core_tests -v $(CURDIR)/Core:/tests core_tests
build_postgresql_adapters_tests:
	docker build -f Dockerfile.test.adapters.postgresql ./  -t postgresql_adapters_tests
postgresql_adapters_tests:
	docker run --rm --name postgresql_adapters_tests -v $(CURDIR)/PostgreSQLAdapters:/tests postgresql_adapters_tests
build_http_adapters_tests:
	docker build -f Dockerfile.test.adapters.http ./  -t http_adapters_tests
http_adapters_tests:
	docker run --rm --name http_adapters_tests -v $(CURDIR)/HttpAdapters:/tests http_adapters_tests
build_dev_application_http_api:
	docker build -f Dockerfile.app.http.api ./  -t dev_app_http_api
run_dev_application_http_api:
	docker run --network host --rm --name dev_app_http_api -v $(CURDIR)/Apps/Http/Api:/app dev_app_http_api

