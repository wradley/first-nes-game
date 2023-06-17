OUT_DIR = build
LINK_FILES = main.o
CFG_FILE = mem_segments.cfg

link: $(LINK_FILES)
	ld65 -o $(OUT_DIR)/main.nes $(OUT_DIR)/*.o -C $(CFG_FILE)

%.o: %.s create_build_dir
	ca65 -o $(OUT_DIR)/$@ $<

create_build_dir:
	mkdir -p $(OUT_DIR)

clean:
	rm -rf $(OUT_DIR)