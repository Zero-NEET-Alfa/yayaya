dpkg --add-architecture i386
rm -rf /usr/share/dotnet /etc/mysql /etc/php /etc/apt/sources.list.d
docker rmi `docker images -q`
apt-get remove account-plugin-facebook account-plugin-flickr account-plugin-jabber account-plugin-salut account-plugin-twitter account-plugin-windows-live account-plugin-yahoo aisleriot brltty duplicity empathy empathy-common example-content gnome-accessibility-themes gnome-contacts gnome-mahjongg gnome-mines gnome-orca gnome-screensaver gnome-sudoku gnome-video-effects gnomine landscape-common libreoffice-avmedia-backend-gstreamer libreoffice-base-core libreoffice-calc libreoffice-common libreoffice-core libreoffice-draw libreoffice-gnome libreoffice-gtk libreoffice-impress libreoffice-math libreoffice-ogltrans libreoffice-pdfimport libreoffice-style-galaxy libreoffice-style-human libreoffice-writer libsane libsane-common mcp-account-manager-uoa python3-uno rhythmbox rhythmbox-plugins rhythmbox-plugin-zeitgeist sane-utils shotwell shotwell-common telepathy-gabble telepathy-haze telepathy-idle telepathy-indicator telepathy-logger telepathy-mission-control-5 telepathy-salut totem totem-common totem-plugins printer-driver-brlaser printer-driver-foo2zjs printer-driver-foo2zjs-common printer-driver-m2300w printer-driver-ptouch printer-driver-splix
git config --global user.name "ZyCromerZ"
git config --global user.email "neetroid97@gmail.com"         
apt-get -y purge azure-cli ghc* zulu* hhvm llvm* firefox google* dotnet* powershell openjdk* mysql* php* 
apt-get clean 
apt-get -qq update
apt-get -qq install bc build-essential zip curl libstdc++6 git wget python gcc clang libssl-dev repo rsync flex curl  bison aria2

git config --global color.ui auto

mkdir -p $(pwd)/reep
PATH="$(pwd)/reep:${PATH}"
MAINPATH="$(pwd)"
curl https://storage.googleapis.com/git-repo-downloads/repo > $(pwd)/reep/repo
chmod a+rx $(pwd)/reep/repo

mkdir recovery && cd recovery

repo init git://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-11 --depth=1 --partial-clone --clone-filter=blob:limit=10M --groups=all,-notdefault,-device,-darwin,-x86,-mips

repo sync -j$(nproc --all)

git clone --depth=4 https://github.com/ZyCromerZ/twrp_redmi_begonia -b android-11.0 device/redmi/begonia

export ALLOW_MISSING_DEPENDENCIES=true
ALLOW_MISSING_DEPENDENCIES=true

. build/envsetup.sh

lunch twrp_begonia-eng

repo sync -j$(nproc --all)

mka recoveryimage -j$(nproc --all)

cd ..

cd recovery/out/target/product/begonia
ZipName="[$(date +"%Y%m%d")]TWRP-begonia-miui-12.5.zip"
zip -r9 $ZipName recovery.img
cd "$MAINPATH"

if [ -f recovery/out/target/product/begonia/recovery.img ];then
    git clone https://${GIT_SECRET}@github.com/ZyCromerZ/uploader-kernel-private
    cd uploader-kernel-private
    chmod +x ./run.sh
    . ./run.sh "$MAINPATH/recovery/out/target/product/begonia/recovery.img" "shared-file" "$(date +"%Y-%m-%d")"
    . ./run.sh "$MAINPATH/recovery/out/target/product/begonia/$ZipName" "shared-file" "$(date +"%Y-%m-%d")"
    rm -rf $MAINPATH/recovery/out/target/product/begonia/recovery.img $MAINPATH/recovery/out/target/product/begonia/$ZipName
fi

# cd "$MAINPATH/recovery/device/redmi/begonia"

# git reset --hard HEAD~1
# cd "$MAINPATH/recovery"

# export ALLOW_MISSING_DEPENDENCIES=true
# ALLOW_MISSING_DEPENDENCIES=true

# . build/envsetup.sh

# lunch twrp_begonia-eng

# repo sync -j$(nproc --all)

# mka recoveryimage -j$(nproc --all)

# cd ..

# cd recovery/out/target/product/begonia
# ZipName="[$(date +"%Y%m%d")][2]TWRP-begonia-miui-12.5.zip"
# zip -r9 $ZipName recovery.img
# cd "$MAINPATH"

# if [ -f recovery/out/target/product/begonia/recovery.img ];then
#     cp -af recovery/out/target/product/begonia/recovery.img recovery/out/target/product/begonia/recovery2.img
#     git clone https://${GIT_SECRET}@github.com/ZyCromerZ/uploader-kernel-private
#     cd uploader-kernel-private
#     chmod +x ./run.sh
#     . ./run.sh "$MAINPATH/recovery/out/target/product/begonia/recovery2.img" "shared-file" "$(date +"%Y-%m-%d")"
#     . ./run.sh "$MAINPATH/recovery/out/target/product/begonia/$ZipName" "shared-file" "$(date +"%Y-%m-%d")"
# fi
# cd "$MAINPATH/recovery/device/redmi/begonia"

# git reset --hard HEAD~1
# cd "$MAINPATH/recovery"

# export ALLOW_MISSING_DEPENDENCIES=true
# ALLOW_MISSING_DEPENDENCIES=true

# . build/envsetup.sh

# lunch twrp_begonia-eng

# repo sync -j$(nproc --all)

# mka recoveryimage -j$(nproc --all)

# cd ..

# cd recovery/out/target/product/begonia
# ZipName="[$(date +"%Y%m%d")][3]TWRP-begonia-miui-12.5.zip"
# zip -r9 $ZipName recovery.img
# cd "$MAINPATH"

# if [ -f recovery/out/target/product/begonia/recovery.img ];then
#     cp -af recovery/out/target/product/begonia/recovery.img recovery/out/target/product/begonia/recovery3.img
#     git clone https://${GIT_SECRET}@github.com/ZyCromerZ/uploader-kernel-private
#     cd uploader-kernel-private
#     chmod +x ./run.sh
#     . ./run.sh "$MAINPATH/recovery/out/target/product/begonia/recovery3.img" "shared-file" "$(date +"%Y-%m-%d")"
#     . ./run.sh "$MAINPATH/recovery/out/target/product/begonia/$ZipName" "shared-file" "$(date +"%Y-%m-%d")"
# fi
cd "$MAINPATH"
rm -rf *