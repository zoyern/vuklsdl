# Nom du projet
NAME = vulksdl
NAME_OUT = vulksdl
NAME_UPPER = $(shell echo $(NAME) | tr a-z A-Z)
NAME_CAMEL = $(shell echo $(NAME) | sed -r 's/(^|_)([a-z])/\U\2/g')
OS_NAME = $(shell uname -s)

# Dépendances spécifiques
ifeq ($(OS_NAME),Linux)  # Cas Linux
    DISTRO = $(shell cat /etc/os-release | grep '^ID=' | cut -d'=' -f2)
    ifeq ($(DISTRO),ubuntu)
   		DEPS = export DISPLAY=$(ip route | grep default | awk '{print $3}'):0.0 && sudo apt install -y build-essential cmake git vulkan-tools vulkan-utility-libraries-dev libvulkan-dev libsdl2-dev libsdl2-2.0-0
	ifeq ($(DISTRO),fedora)
   		DEPS = export DISPLAY=$(ip route | grep default | awk '{print $3}'):0.0 && sudo dnf install -y @development-tools cmake git vulkan-tools vulkan-loader-devel SDL2-devel
    else
        $(error "Système Linux non supporté")
    endif
else ifeq ($(OS_NAME),Darwin)  # Cas macOS
    DEPS = brew install cmake git vulkan-loader sdl2
else
    $(error "Système non supporté")
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