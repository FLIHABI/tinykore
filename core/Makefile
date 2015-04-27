unpack: clean
	mkdir -p core-root
	cd ./core-root; zcat ../../iso/boot/core.gz | sudo cpio -i -H newc -d; cd ..
	sudo chown -R $(USER) ./core-root

pack:
	rm -rf core.gz
	cd ./core-root; sudo find | sudo cpio -o -H newc | \
	    gzip -2 > ../core.gz; cd ..
	advdef -z4 ./core.gz

clean:
	sudo rm -rf core-root/* core.gz
