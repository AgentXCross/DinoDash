# Use gcc Version 16 C++ compiler
CXX := g++-16

# Compiler flags
CXXFLAGS := -std=c++20 -fmodules-ts -Wall -Wextra $(shell pkg-config --cflags raylib)
LDLIBS   := $(shell pkg-config --libs raylib)

# Headers precompiled as header units, use import <LIB>;
HEADER_UNITS := random array vector string cmath

# modules
MODULES := sprites game camera

# modules with separate implementation files
IMPLS   := game camera

# directory for compiled files
BUILD   := build
# The object files that will eventually be linked together
OBJS    := $(MODULES:%=$(BUILD)/%.o) $(IMPLS:%=$(BUILD)/%-impl.o) $(BUILD)/main.o

# name of the final executable
TARGET  := dinodash

# Phony targets
# all builds the entire program
# run builds and executes the program
# clean deletes the generated build files
.PHONY: all run clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $^ -o $@ $(LDLIBS)

# Precompile header units into gcm.cache/ once
$(BUILD)/headers.stamp:
	@mkdir -p $(BUILD)
	$(CXX) $(CXXFLAGS) -c -x c++-system-header $(HEADER_UNITS)
	@touch $@

# Interface unit
# GCC doesn't recognise .cppm, so force -x c++
$(BUILD)/%.o: src/%.cppm $(BUILD)/headers.stamp
	$(CXX) $(CXXFLAGS) -x c++ -c $< -o $@

# Implementation unit: build after its interface
$(BUILD)/%-impl.o: src/%-impl.cpp $(BUILD)/%.o
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Compiles main.cpp to main.o if all modules are up to date
$(BUILD)/main.o: src/main.cpp $(BUILD)/headers.stamp $(MODULES:%=$(BUILD)/%.o)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Module import dependencies: a module must be built after what it imports
$(BUILD)/game.o:   $(BUILD)/sprites.o
$(BUILD)/camera.o: $(BUILD)/game.o

run: $(TARGET)
	./$(TARGET)

clean:
	rm -rf $(BUILD) gcm.cache $(TARGET)
