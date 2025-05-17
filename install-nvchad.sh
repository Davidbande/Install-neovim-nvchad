#!/bin/bash

# Función para manejar errores
error_exit() {
    echo "❌ Error en la ejecución del script en la línea $1: $2"
    exit 1
}

# Activar manejo de errores
trap 'error_exit $LINENO "$BASH_COMMAND"' ERR

echo "🔧 Actualizando paquetes..."
sudo apt update

echo "📦 Instalando dependencias esenciales..."
sudo apt install -y git nodejs python3 perl curl wget ripgrep npm gcc make lua5.1 luarocks cargo python3-pip xclip

echo "📜 Instalando Tree-sitter CLI..."
sudo npm install -g tree-sitter-cli

echo "🛠️ Instalando Stylua para formateo de código..."
sudo cargo install stylua

echo "🔤 Agregando Cargo al PATH..."
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

echo "🛠️ Agregando el repositorio de Neovim e instalándolo..."
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt update && sudo apt install -y neovim

echo "🔠 Instalando Nerd Font si no está presente..."
FONT_DIR="$HOME/.local/share/fonts"
FONT_FILE="$FONT_DIR/JetBrainsMono.zip"

mkdir -p "$FONT_DIR"
cd "$FONT_DIR"

if [ ! -f "$FONT_FILE" ]; then
    wget -O "$FONT_FILE" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    unzip -o "$FONT_FILE" -d "$FONT_DIR"
    fc-cache -fv
else
    echo "✅ Nerd Fonts ya están instaladas, omitiendo descarga."
fi

cd

echo "Removing previous NvChad installation..."
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.cache/nvim
echo "Previous installation removed. Ready for fresh install!"

echo "🔽 Instalando NvChad si no está presente..."
if [ ! -d "$HOME/.config/nvim" ]; then
    git clone https://github.com/NvChad/starter ~/.config/nvim
else
    echo "✅ NvChad ya está instalado, omitiendo clonación."
fi

echo "🚀 Instalación completa. Abre Neovim con 'nvim' para empezar!"
