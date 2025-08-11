#!/bin/bash
set -e  # чтобы при ошибке всё останавливалось

# Установка пакетов
sudo apt update
sudo apt install -y \
    xserver-xorg-core xserver-xorg-video-vesa x11-xserver-utils xinit \
    x2goserver x2goserver-xsession openbox lxterminal pcmanfm mousepad \
    python3 python3-pip python3-venv python-is-python3 python3-tk python3-dev \
    libasound2t64 alsa-utils wmctrl libwebkit2gtk-4.1-0

# Настройка Xinit
echo -e "xrandr --output Virtual1 --mode 1280x720 --rate 60\nexec openbox-session" > ~/.xinitrc
chmod +x ~/.xinitrc

# Создание рабочей папки
mkdir -p bot
cd bot

# Виртуальное окружение
python3 -m venv venv
source venv/bin/activate
python3 -m pip install numpy opencv-python pyautogui pillow playwright
python3 -m playwright install firefox

# Telegram
wget -qO- https://telegram.org/dl/desktop/linux | tar -xJ
chmod +x Telegram/Telegram

# Папка с изображениями
mkdir -p images
git clone https://github.com/oosname/bot_images.git images

# Звуковой файл (через raw)
wget -O beep.wav https://raw.githubusercontent.com/oosname/bot/main/beep.wav

grep -qxF 'if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then startx; fi' ~/.profile || echo 'if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then startx; fi' >> ~/.profile

mkdir -p ~/bin && echo -e '#!/bin/bash\ncd ~/bot || exit 1\nsource venv/bin/activate\npython bot.py' > ~/bin/bot && chmod +x ~/bin/bot && grep -qxF 'export PATH="$HOME/bin:$PATH"' ~/.bashrc || echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

startx