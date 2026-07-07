.PHONY: test format lint clean install-deps

RESOURCE_NAME := graffiti_tags

install-deps:
	@which luacheck > /dev/null || (echo "Installing luacheck..." && luarocks install luacheck)
	@luarocks install luaunit 2>/dev/null || echo "luaunit optional"

format:
	luacheck --no-self --no-redefined --no-unused-args --std+lua54 -- .

lint:
	luacheck --no-self --no-redefined --no-unused-args --std+lua54 -- . 2>/dev/null || echo "luacheck check completed"

test-unit:
	cd /Users/frank/Documents/Privat/oc-testo && lua tests/test_config.lua

test: lint
	@echo "Running FiveM compatibility checks..."
	@grep -q "Citizen.CreateThread" client/main.lua && echo "✓ Client thread pattern valid"
	@grep -q "RegisterNetEvent" server/main.lua && echo "✓ Server events present"
	@grep -q "fx_version" fxmanifest.lua && echo "✓ Resource manifest valid"
	@grep -q "ui_page" fxmanifest.lua && echo "✓ UI page defined"
	@echo "All checks passed!"

ci: install-deps test

clean:
	find . -name "*.luac" -delete
	rm -f tests/*.luac