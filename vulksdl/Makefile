include settings/build.mk

.PHONY: all clean fclean re install prepare cmake run headers

# Compilation complète
all: display-info prepare headers cmake
	@$(MAKE) -C $(CMAKE_DIR)
	@echo "Compilation terminée ! Lancement : make run"

# Préparer les dossiers et fichiers nécessaires
prepare:
	@echo "Installation des dépendances..."
	@$(DEPS)
	@echo "Préparation des dossiers et fichiers..."
	@mkdir -p $(SRC_DIR)
	@mkdir -p $(SRC_DIR)/$(NAME_CAMEL)
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(INCLUDE_DIR)
	@mkdir -p $(SHADERS_DIR)
	@mkdir -p $(CMAKE_DIR)
	@if [ ! -f "$(BUILD_DIR)/$(CMAKE_FILE)" ]; then \
		$(UPDATEFILE2) $(DEFAULT_CMAKE) > $(BUILD_DIR)/$(CMAKE_FILE); \
	fi
	@if [ ! -f "$(SRC_DIR)/$(NAME_CAMEL)/$(NAME_CAMEL).cpp" ]; then \
		$(UPDATEFILE2) $(DEFAULT_CPP) > $(SRC_DIR)/$(NAME_CAMEL)/$(NAME_CAMEL).cpp; \
	fi
	@if [ ! -f "$(SRC_DIR)/$(NAME_CAMEL)/$(NAME_CAMEL).hpp" ]; then \
		$(UPDATEFILE2) $(DEFAULT_HPP) > $(SRC_DIR)/$(NAME_CAMEL)/$(NAME_CAMEL).hpp; \
	fi
	@if [ ! -f "$(MAIN_DIR)" ]; then \
		$(UPDATEFILE2) $(DEFAULT_MAIN) > $(MAIN_DIR)/$(MAIN_FILE); \
	fi

headers:
	@echo "Organisation des fichiers d'en-tête..."
	@echo "" > $(HEADER_DIR)/$(HEADER_FILE)
	@$(UPDATEFILE2) $(DEFAULT_DEF) >> $(HEADER_DIR)/$(HEADER_FILE)
	@echo "" >> $(HEADER_DIR)/$(HEADER_FILE);

	@echo "#ifndef CLASS_HPP" > $(SRC_DIR)/class.hpp
	@echo "# define CLASS_HPP" >> $(SRC_DIR)/class.hpp
	@echo "" >> $(SRC_DIR)/class.hpp

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

display-info:
	@echo "Mode d'affichage sélectionné : $(DISPLAY_MODE)"
	@echo "WAYLAND_DISPLAY=$(WAYLAND_DISPLAY)"
	@echo "DISPLAY=$(DISPLAY)"
	@echo "SDL_VIDEODRIVER=$(DISPLAY_MODE)"

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
	@rm -rf $(NAME_OUT)

ffclean: fclean
	@echo "Suppression de tous les fichiers et dossiers..."
	@rm -rf $(SHADERS_DIR)
	@rm -rf $(SRC_DIR)

# Recompiler proprement
re: fclean all

# Exécuter le programme compilé
run:
	@echo "Mode graphique utilisé : $(DISPLAY_MODE)"
	@echo "Exécution du programme... ./$(NAME_OUT)\n------------------------------\n"
	@./$(NAME_OUT)