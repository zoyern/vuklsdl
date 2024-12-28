# Nom du projet
NAME = vulksdl
NAME_OUT = vulksdl

# Dépendances requises
DEPS = build-essential cmake git libvulkan-dev vulkan-tools libsdl2-dev
CMAKEVER = 3.10

# Répertoires
OUT_DIR = .
BUILD_DIR = build
INCLUDE_DIR = $(BUILD_DIR)/includes
CMAKE_DIR = $(BUILD_DIR)/cmake
SRC_DIR = src
SHADERS_DIR = shaders
MAIN_DIR = $(SRC_DIR)/main.cpp
HEADER_FILE = def.hpp
NAME_UPPER = $(shell echo $(NAME) | tr a-z A-Z)
NAME_CAMEL = $(shell echo $(NAME) | sed -r 's/(^|_)([a-z])/\U\2/g')

DEFAULT_HPP = template/hpp/default
DEFAULT_CPP = template/cpp/default
DEFAULT_MAIN = template/cpp/main
DEFAULT_DEF = template/hpp/def
# Fichiers
CMAKE_FILE = $(BUILD_DIR)/CMakeLists.txt

# Commandes
CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -Werror

UPDATEFILE	= sed -e 's/{{NAME_CAMEL}}/$(NAME_CAMEL)/g' \
				-e 's/{{NAME_UPPER}}/$(NAME_UPPER)/g' \
				-e 's/{{HEADER_FILE}}/$(HEADER_FILE)/g' \
				-e 's/{{NAME}}/$(NAME)/g' \

.PHONY: all clean fclean re install prepare cmake run headers

# Compilation complète
all: prepare headers cmake
	@$(MAKE) -C $(CMAKE_DIR)
	@echo "Compilation terminée ! Lancement : make run"

# Préparer les dossiers et fichiers nécessaires
prepare:
	@echo "Installation des dépendances..."
	@sudo apt install -y $(DEPS)
	@echo "Préparation des dossiers et fichiers..."
	@mkdir -p $(SRC_DIR)
	@mkdir -p $(SRC_DIR)/$(NAME_CAMEL)
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(INCLUDE_DIR)
	@mkdir -p $(SHADERS_DIR)
	@mkdir -p $(CMAKE_DIR)
	@if [ ! -f "$(CMAKE_FILE)" ]; then \
		echo "cmake_minimum_required(VERSION $(CMAKEVER))" > $(CMAKE_FILE); \
		echo "project($(NAME))" >> $(CMAKE_FILE); \
		echo "set(CMAKE_CXX_STANDARD 17)" >> $(CMAKE_FILE); \
		echo "find_package(Vulkan REQUIRED)" >> $(CMAKE_FILE); \
		echo "find_package(SDL2 REQUIRED)" >> $(CMAKE_FILE); \
		echo "include_directories(\$${Vulkan_INCLUDE_DIRS} \$${SDL2_INCLUDE_DIRS} ../$(INCLUDE_DIR))" >> $(CMAKE_FILE); \
		echo "file(GLOB_RECURSE SOURCES ../$(SRC_DIR)/*.cpp)" >> $(CMAKE_FILE); \
		echo "add_executable($(NAME) \$${SOURCES})" >> $(CMAKE_FILE); \
		echo "set_target_properties($(NAME) PROPERTIES OUTPUT_NAME ../../$(OUT_DIR)/$(NAME_OUT))" >> $(CMAKE_FILE); \
		echo "target_link_libraries($(NAME) Vulkan::Vulkan SDL2::SDL2)" >> $(CMAKE_FILE); \
	fi
	@if [ ! -f "$(SRC_DIR)/$(NAME_CAMEL)/$(NAME_CAMEL).cpp" ]; then \
		$(UPDATEFILE) $(DEFAULT_CPP) > $(SRC_DIR)/$(NAME_CAMEL)/$(NAME_CAMEL).cpp; \
	fi
	@if [ ! -f "$(SRC_DIR)/$(NAME_CAMEL)/$(NAME_CAMEL).hpp" ]; then \
		$(UPDATEFILE) $(DEFAULT_HPP) > $(SRC_DIR)/$(NAME_CAMEL)/$(NAME_CAMEL).hpp; \
	fi
	@if [ ! -f "$(MAIN_DIR)" ]; then \
		$(UPDATEFILE) $(DEFAULT_MAIN) > $(MAIN_DIR); \
	fi

headers:
	@echo "Organisation des fichiers d'en-tête..."
	@echo "" > $(SRC_DIR)/$(HEADER_FILE)
	@$(UPDATEFILE) $(DEFAULT_DEF) >> $(SRC_DIR)/$(HEADER_FILE)
	@echo "" >> $(SRC_DIR)/$(HEADER_FILE);

	@echo "#ifndef CLASS_HPP\n# define CLASS_HPP\n" > $(SRC_DIR)/class.hpp

	@find $(SRC_DIR) -type f -name "*.hpp" | while read file; do \
		dir=$$(dirname $$file); \
		base=$$(basename $$file); \
		rel_path=$$(realpath --relative-to=$(SRC_DIR) $$dir); \
		\
		if echo $$(basename $$dir) | grep -q '^[A-Z]'; then \
			target_dir="$(INCLUDE_DIR)/class"; \
			mkdir -p $$target_dir; \
			cp -u $$file $$target_dir/$$base; \
			echo "#include \"class/$$base\"" >> $(SRC_DIR)/class.hpp; \
		else \
			target_dir="$(INCLUDE_DIR)/$$rel_path"; \
			mkdir -p $$target_dir; \
			cp -u $$file $$target_dir/$$base; \
			if [ "$$base" != "class.hpp" ] && [ "$$base" != "$(HEADER_FILE)" ]; then \
				echo "#include \"$$rel_path/$$base\"" >> $(SRC_DIR)/class.hpp; \
			fi; \
		fi; \
	done
	@echo "#endif" >> $(SRC_DIR)/class.hpp
	@cat $(SRC_DIR)/class.hpp > $(INCLUDE_DIR)/class.hpp

# Installer les dépendances nécessaires
install:
	@echo "Installation des dépendances..."
	@sudo apt update && sudo apt install -y $(DEPS)

# Lancer cmake si nécessaire
cmake:
	@cd $(CMAKE_DIR) && cmake ..

# Nettoyer les fichiers générés
clean:
	@echo "Nettoyage des fichiers temporaires..."
	@rm -rf $(BUILD_DIR)/*

# Nettoyer et supprimer tout
fclean: clean
	@echo "Suppression de tous les fichiers inutiles..."
	@rm -rf $(BUILD_DIR)
	@rm -rf $(INCLUDE_DIR)
	@rm -rf $(OUT_DIR)/$(NAME_OUT)

ffclean: fclean
	@echo "Suppression de tous les fichiers et dossiers..."
	@rm -rf $(SHADERS_DIR)
	@rm -rf $(SRC_DIR)

# Recompiler proprement
re: fclean all

# Exécuter le programme compilé
run:
	@echo "Exécution du programme... ./$(OUT_DIR)/$(NAME_OUT)\n------------------------------\n"
	@./$(OUT_DIR)/$(NAME_OUT)
