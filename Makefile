OUT_DIR ?= build
OPT_LEVEL ?= 3

CRASHPAD ?= ../crashpad/crashpad/out/Default

CXXFLAGS = \
	-g \
	-fPIC \
	-O$(OPT_LEVEL) \
	-std=c++11 \
	$(NULL)

all: build run
.PHONY: all

build: $(OUT_DIR)/CrashTest
.PHONY: build

build/CrashTest: $(OUT_DIR)/main.o
	$(LINK.cpp) -o $@ $^
	dsymutil $@

$(OUT_DIR)/%.o: src/%.cpp
	@mkdir -p $(@D)
	$(COMPILE.cpp) $(OUTPUT_OPTION) $<

db:
	$(CRASHPAD)/crashpad_database_util -d ./db --create
	$(CRASHPAD)/crashpad_database_util -d ./db --set-uploads-enabled=1

run: build db
	$(CRASHPAD)/run_with_crashpad \
		--handler $(CRASHPAD)/crashpad_handler \
		--database ./db \
		--url ${SENTRY_ENDPOINT} \
		--argument=--no-rate-limit \
		./$(OUT_DIR)/CrashTest
.PHONY: run

clean:
	$(RM) -r build db
