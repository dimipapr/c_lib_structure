include envvars.env

LIB_TARGET_NAME:=$(addsuffix .a,$(addprefix lib,$(LIB_NAME)))
LIB_DEBUG_TARGET_DIR:=$(DEBUG_DIR)/$(BIN_DIR)
LIB_DEBUG_TARGET:=$(LIB_DEBUG_TARGET_DIR)/$(LIB_TARGET_NAME)
LIB_DEBUG_BUILD_DIR:=$(DEBUG_DIR)/$(BUILD_DIR)
LIB_SOURCES_DIR:=$(SOURCE_DIR)

LIB_SOURCES:= $(wildcard $(SOURCE_DIR)/*.c)
LIB_DEBUG_OBJECTS:=$(patsubst $(LIB_SOURCES_DIR)/%.c, $(LIB_DEBUG_BUILD_DIR)/%.o,$(LIB_SOURCES))

CC:=gcc
CFLAGS:=-Wall -Wextra -I./$(LIB_SOURCES_DIR)
DEBUG_CFLAGS:=-g -Og -DDEBUG


build_debug: $(LIB_DEBUG_TARGET)

$(LIB_DEBUG_TARGET):$(LIB_DEBUG_OBJECTS)
	@mkdir -p $(dir $@)
	ar rcs $(LIB_DEBUG_TARGET) $(LIB_DEBUG_OBJECTS)
	ranlib $(LIB_DEBUG_TARGET)

$(LIB_DEBUG_BUILD_DIR)/%.o:$(LIB_SOURCES_DIR)/%.c $(LIB_SOURCES_DIR)/%.h
	@mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $(DEBUG_CFLAGS) $< -o $@

print:
	@echo $(LIB_DEBUG_BUILD_DIR)
	@echo $(LIB_SOURCES)
	@echo $(LIB_DEBUG_OBJECTS)

clean:
	@rm -rf $(DEBUG_DIR)

.PHONY:build_debug print clean