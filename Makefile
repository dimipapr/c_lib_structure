include envvars.env

LIB_TARGET_NAME:=$(addsuffix .a,$(addprefix lib,$(LIB_NAME)))
LIB_DEBUG_TARGET_DIR:=$(DEBUG_DIR)/$(BIN_DIR)
LIB_DEBUG_TARGET:=$(LIB_DEBUG_TARGET_DIR)/$(LIB_TARGET_NAME)
LIB_DEBUG_BUILD_DIR:=$(DEBUG_DIR)/$(BUILD_DIR)
LIB_SOURCES_DIR:=$(SOURCE_DIR)

LIB_SOURCES:= $(wildcard $(SOURCE_DIR)/*.c)
LIB_DEBUG_OBJECTS:=$(patsubst $(LIB_SOURCES_DIR)/%.c, $(LIB_DEBUG_BUILD_DIR)/%.o,$(LIB_SOURCES))

TESTS_DEBUG_BINARIES_DIR:=$(TESTS_DIR)/$(DEBUG_DIR)/$(BIN_DIR)
TESTS_DEBUG_BUILD_DIR:=$(TESTS_DIR)/$(DEBUG_DIR)/$(BUILD_DIR)

TESTS_SOURCES_DIR=$(TESTS_DIR)/$(SOURCE_DIR)
TESTS_SOURCES:=$(wildcard $(TESTS_DIR)/$(SOURCE_DIR)/*.c)
TESTS_DEBUG_OBJECTS:=$(patsubst $(TESTS_SOURCES_DIR)/%.c,$(TESTS_DEBUG_BUILD_DIR)/%.o, $(TESTS_SOURCES))
TESTS_DEBUG_BINARIES:=$(patsubst $(TESTS_SOURCES_DIR)/%.c,$(TESTS_DEBUG_BINARIES_DIR)/%, $(TESTS_SOURCES))

CC:=gcc
CFLAGS:=-Wall -Wextra -I./$(LIB_SOURCES_DIR)
DEBUG_CFLAGS:=-g -Og -DDEBUG
DEBUG_LDFLAGS:=-L./$(LIB_DEBUG_TARGET_DIR) -l$(LIB_NAME)


build_lib_debug: $(LIB_DEBUG_TARGET)

build_tests_debug:$(LIB_DEBUG_TARGET) $(TESTS_DEBUG_BINARIES)

run_tests_debug:build_tests_debug
	bash run_tests.sh $(TESTS_DEBUG_BINARIES)

$(LIB_DEBUG_TARGET):$(LIB_DEBUG_OBJECTS)
	@mkdir -p $(dir $@)
	ar rcs $(LIB_DEBUG_TARGET) $(LIB_DEBUG_OBJECTS)
	ranlib $(LIB_DEBUG_TARGET)

$(LIB_DEBUG_BUILD_DIR)/%.o:$(LIB_SOURCES_DIR)/%.c $(LIB_SOURCES_DIR)/%.h
	@mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $(DEBUG_CFLAGS) $< -o $@


$(TESTS_DEBUG_BINARIES_DIR)/test_%:$(TESTS_DEBUG_BUILD_DIR)/test_%.o
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(DEBUG_CFLAGS) $< -o $@ $(DEBUG_LDFLAGS)

.PRECIOUS:$(TESTS_DEBUG_BUILD_DIR)/test_%.o
$(TESTS_DEBUG_BUILD_DIR)/test_%.o:$(TESTS_SOURCES_DIR)/test_%.c
	@mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $(DEBUG_CFLAGS) $< -o $@

print:
	@echo $(TESTS_DEBUG_BINARIES_DIR)
	@echo $(TESTS_DEBUG_OBJECTS)
	@echo $(TESTS_DEBUG_BINARIES)

clean:
	@rm -rf $(DEBUG_DIR)
	@rm -rf $(TESTS_DIR)/$(DEBUG_DIR)
	@rm -rf $(TESTS_DIR)/*.log

.PHONY:build_lib_debug build_tests_debug print clean