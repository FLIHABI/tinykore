ISONAME=kernel/flihabi-kernel.iso
MOUNTPOINT=/mnt

unpack:
	mkdir -p iso
	sudo mount $(ISONAME) $(MOUNTPOINT)
	sudo cp -r $(MOUNTPOINT)/* iso/
	sudo umount $(MOUNTPOINT)
	make -C ./core unpack

pack:
	mkdir newiso
	cp -r ./iso/boot newiso
	make -C ./core pack
	cp ./core/core.gz ./newiso/boot/
	mkisofs -l -J -r -V TC-custom -no-emul-boot \
	    -boot-load-size 4 \
	    -boot-info-table -b boot/isolinux/isolinux.bin \
	    -c boot/isolinux/boot.cat -o test.iso newiso
	rm -rf newiso

test:
	qemu-system-i386 -boot d -cdrom test.iso -m 512

boot:
	qemu-system-i386 -boot d -cdrom flihabi-kernel.iso -m 512

apply:
	cp ./test.iso ./kernel/flihabi-kernel.iso
	cd kernel; git add flihabi-kernel.iso; git commit; git push; cd ..

clean:
	sudo rm -rf ./core/core-root ./core/core.gz ./iso test.iso
