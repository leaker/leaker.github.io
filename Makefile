.PHONY: update update-force
update:
	git submodule update --remote

update-force:
	git submodule foreach --recursive 'git reset --hard && git clean -fd'
	git submodule update --remote --force