echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ======= Copiying My Files ======="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

# .config
sudo -u "$USER_NAME" cp -r "${FUIS_REPO}/config/." "${USER_HOME}/.config/"

sudo -u "$USER_NAME" cp -r "${FUIS_REPO}/zshrc" "${USER_HOME}/"
mv "${USER_HOME}/zshrc" "${USER_HOME}/.zshrc"

find "${USER_HOME}/.config/hypr/scripts/" -type f -name "*.sh" -exec chmod +x {} \;
