ISONAME=./kernel/flihabi-core.iso
MOUNTPOINT=/mnt
TESTISO=test.iso
QEMU=qemu-system-x86_64


unpack: clean
	mkdir -p iso
	sudo mount $(ISONAME) $(MOUNTPOINT)
	sudo cp -r $(MOUNTPOINT)/* iso/
	sudo umount $(MOUNTPOINT)
	make -C ./core unpack

pack:
	sudo rm -rf newiso
	mkdir newiso
	cp -r ./iso/* newiso
	make -C ./core pack
	sudo cp ./core/core.gz ./newiso/boot/
	sudo mkisofs -l -J -r -V TC-custom -no-emul-boot \
	    -boot-load-size 4 \
	    -boot-info-table -b boot/isolinux/isolinux.bin \
	    -c boot/isolinux/boot.cat -o test.iso newiso

test:
	$(QEMU) -boot d -cdrom $(TESTISO) -m 512

boot:
	$(QEMU) -boot d -cdrom $(TESTISO) -m 512

apply:
	cp ./test.iso ./kernel/flihabi-kernel.iso
	cd kernel; git add flihabi-kernel.iso; git commit; git push; cd ..

clean:
	sudo rm -rf ./core/core-root ./core/core.gz ./iso test.iso ./newiso

presentation:
	$(QEMU) -boot d -cdrom presentation2.iso -m 512
