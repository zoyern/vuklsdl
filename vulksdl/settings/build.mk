# Nom du projet
NAME = vulksdl
NAME_OUT = vulksdl
NAME_UPPER = $(shell echo $(NAME) | tr a-z A-Z)
NAME_CAMEL = $(shell echo $(NAME) | sed -r 's/(^|_)([a-z])/\U\2/g')

# Dépendances spécifiques
OS_NAME = $(shell uname -s | tr -d '[:space:]')
DISTRO = $(shell cat /etc/os-release | grep '^ID=' | cut -d'=' -f2 | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')

# Détection de l'environnement graphique
ifeq ($(OS_NAME),Linux)
	ifdef WAYLAND_DISPLAY
		USE_WAYLAND := 1
	else
		USE_WAYLAND := 0
	endif
	ifeq ($(USE_WAYLAND),1)
		ifneq ($(DISPLAY),)
			DISPLAY_MODE=x11
			DISPLAY_CMD=export SDL_VIDEODRIVER=x11 && export DISPLAY=$(shell ip route | grep default | awk '{print $$3}'):0.0
		else
			DISPLAY_MODE=wayland
			DISPLAY_CMD=export SDL_VIDEODRIVER=wayland
		endif
	else
		DISPLAY_MODE=x11
		DISPLAY_CMD=export SDL_VIDEODRIVER=x11 && export DISPLAY=$(shell ip route | grep default | awk '{print $$3}'):0.0
	endif
endif

# Dépendances spécifiques
ifeq ($(OS_NAME),Linux)
	ifeq ($(DISTRO),ubuntu)
		DEPS = sudo apt update -y && sudo apt upgrade -y && sudo apt install -y build-essential cmake g++ git vulkan-tools libvulkan-dev libsdl2-dev libsdl2-2.0-0
    else ifeq ($(DISTRO),fedora)
		DEPS = sudo dnf update -y && sudo dnf upgrade -y && sudo dnf install -y @development-tools gcc-c++ cmake git vulkan-tools vulkan-loader-devel SDL2-devel
	else
		$(error "Système Linux non supporté OS_NAME='$(OS_NAME)' DISTRO='$(DISTRO)'")
	endif
else ifeq ($(OS_NAME),Darwin)
	DEPS = brew install cmake git vulkan-loader sdl2
else ifeq ($(OS_NAME),MINGW64_NT-10.0)
	DEPS = pacman -S --needed --noconfirm mingw-w64-x86_64-toolchain \
			mingw-w64-x86_64-cmake mingw-w64-x86_64-gcc mingw-w64-x86_64-gcc-libs \
			mingw-w64-x86_64-vulkan-loader mingw-w64-x86_64-SDL2
else ifeq ($(OS_NAME),Android)
	DEPS = sdkmanager "cmake;3.22.1" "ndk;21.4.7075529"
else
	$(error "Système non supporté OS_NAME='$(OS_NAME)'")
endif

CMAKEVER = 3.10

# Répertoires
SRC_DIR = src
SHADERS_DIR = shaders
BUILD_DIR = build
MAIN_DIR = $(SRC_DIR)
HEADER_DIR = $(SRC_DIR)
INCLUDE_DIR = $(BUILD_DIR)/includes
CMAKE_DIR = $(BUILD_DIR)/cmake

TEMPLATE_DIR = settings/template
DEFAULT_DEF = $(TEMPLATE_DIR)/hpp/def
DEFAULT_HPP = $(TEMPLATE_DIR)/hpp/default
DEFAULT_CPP = $(TEMPLATE_DIR)/cpp/default
DEFAULT_MAIN = $(TEMPLATE_DIR)/cpp/main
DEFAULT_CMAKE = $(TEMPLATE_DIR)/cmake/default

# Fichiers
CMAKE_FILE = CMakeLists.txt
MAIN_FILE = main.cpp
HEADER_FILE = def.hpp

UPDATEFILE2	= sed -e 's|{{NAME}}|$(NAME)|g' \
				-e 's|{{NAME_OUT}}|$(NAME_OUT)|g' \
				-e 's|{{NAME_UPPER}}|$(NAME_UPPER)|g' \
				-e 's|{{NAME_CAMEL}}|$(NAME_CAMEL)|g' \
				-e 's|{{OS_NAME}}|$(OS_NAME)|g' \
				-e 's|{{DEPS}}|$(DEPS)|g' \
				-e 's|{{CMAKEVER}}|$(CMAKEVER)|g' \
				-e 's|{{SRC_DIR}}|$(SRC_DIR)|g' \
				-e 's|{{SHADERS_DIR}}|$(SHADERS_DIR)|g' \
				-e 's|{{BUILD_DIR}}|$(BUILD_DIR)|g' \
				-e 's|{{MAIN_DIR}}|$(MAIN_DIR)|g' \
				-e 's|{{HEADER_DIR}}|$(HEADER_DIR)|g' \
				-e 's|{{INCLUDE_DIR}}|$(INCLUDE_DIR)|g' \
				-e 's|{{CMAKE_DIR}}|$(CMAKE_DIR)|g' \
				-e 's|{{TEMPLATE_DIR}}|$(TEMPLATE_DIR)|g' \
				-e 's|{{DEFAULT_DEF}}|$(DEFAULT_DEF)|g' \
				-e 's|{{DEFAULT_HPP}}|$(DEFAULT_HPP)|g' \
				-e 's|{{DEFAULT_CPP}}|$(DEFAULT_CPP)|g' \
				-e 's|{{DEFAULT_MAIN}}|$(DEFAULT_MAIN)|g' \
				-e 's|{{DEFAULT_CMAKE}}|$(DEFAULT_CMAKE)|g' \
				-e 's|{{CMAKE_FILE}}|$(CMAKE_FILE)|g' \
				-e 's|{{MAIN_FILE}}|$(MAIN_FILE)|g' \
				-e 's|{{HEADER_FILE}}|$(HEADER_FILE)|g'