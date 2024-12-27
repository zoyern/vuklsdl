# Nom du projet
NAME = vulksdl
NAME_OUT = app

# Dépendances requises
DEPS = build-essential cmake git libvulkan-dev vulkan-tools libsdl2-dev
CMAKEVER = 3.10

# Répertoires
OUT_DIR = .
BUILD_DIR = build
INCLUDE_DIR = $(BUILD_DIR)/include
CMAKE_DIR = $(BUILD_DIR)/cmake
SRC_DIR = src
SHADERS_DIR = $(SRC_DIR)/shaders
MAIN_DIR = $(SRC_DIR)/main.cpp

# Fichiers
MAIN_SRC = $(SRC_DIR)/main.cpp
HEADER_FILE = $(INCLUDE_DIR)/$(NAME).hpp
CMAKE_FILE = $(BUILD_DIR)/CMakeLists.txt

# Commandes
CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -Werror

.PHONY: all clean fclean re install prepare cmake run

# Compilation complète
all: prepare cmake
	@$(MAKE) -C $(CMAKE_DIR)
	@echo "Compilation fini pour lancé : make run"

# Préparer les dossiers et fichiers nécessaires
prepare:
	@echo "Préparation des dossiers et fichiers..."
	@mkdir -p $(SRC_DIR)
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
		echo "include_directories(\$${Vulkan_INCLUDE_DIRS} \$${SDL2_INCLUDE_DIRS} include)" >> $(CMAKE_FILE); \
		echo "file(GLOB SOURCES ../$(SRC_DIR)/*.cpp)" >> $(CMAKE_FILE); \
		echo "add_executable($(NAME) \$${SOURCES})" >> $(CMAKE_FILE); \
		echo "set_target_properties($(NAME) PROPERTIES OUTPUT_NAME ../../$(OUT_DIR)/$(NAME_OUT))" >> $(CMAKE_FILE); \
		echo "target_link_libraries($(NAME) Vulkan::Vulkan SDL2::SDL2)" >> $(CMAKE_FILE); \
	fi
	@if [ ! -f "$(MAIN_DIR)" ]; then \
		echo "#include <iostream>\n\n" > $(MAIN_DIR); \
		echo "int main(int argc, char *argv[], char *envp[])\n{\n	std::cout << \"prog start : $(NAME)\" << std::endl;\n \
		return ((void)argc, (void)argv, (void)envp, 0);\n}\n" >> $(MAIN_DIR); \
	fi

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
	@echo "Suppression de tous les non important a l'export..."
	@rm -rf $(BUILD_DIR)
	@rm -rf $(INCLUDE_DIR)
	@rm -rf $(OUT_DIR)/$(NAME_OUT)

ffclean: fclean
	@echo "Suppression de tous..."
	@rm -rf $(SHADERS_DIR)
	@rm -rf $(SRC_DIR)

# Recompiler proprement
re: fclean all

# Exécuter le programme compilé
run:
	@echo "Exécution du programme... ./$(OUT_DIR)/$(NAME_OUT)\n------------------------------\n"
	@./$(OUT_DIR)/$(NAME_OUT)
