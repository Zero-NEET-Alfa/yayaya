#!/usr/bin/env bash

# Function to show an informational message
msg() {
    echo -e "\e[1;32m$*\e[0m"
}

export GIT_SSL_NO_VERIFY=1
git config --global http.sslverify false

# Set a directory
DIR="$(pwd ...)"

if [ "${1}" == "13" ];then
    UseBranch="release/13.x"
    CloneTo="13"
elif [ "${1}" == "14" ];then
    UseBranch="main"
    CloneTo="14"
else
    msg "huh ???"
    exit
fi

if [[ -z "${GIT_SECRET}" ]] || [[ -z "${BOT_TOKEN}" ]];then
    msg "something is missing, aborting . . ."
    exit
fi

./build-llvm.py \
	--clang-vendor "ZyC" \
	--targets "ARM;AArch64" \
	--defines "LLVM_PARALLEL_COMPILE_JOBS=$(nproc) LLVM_PARALLEL_LINK_JOBS=$(nproc) CMAKE_C_FLAGS=-O3 CMAKE_CXX_FLAGS=-O3 LLVM_USE_LINKER=lld LLVM_ENABLE_LLD=ON" \
	--pgo kernel-defconfig \
	--lto thin \
	--shallow-clone \
    --branch "$UseBranch"


# Build binutils
msg "Building binutils..."
BIN_START=$(date +"%s")
./build-binutils.py --targets arm aarch64

# Remove unused products
rm -fr install/include
rm -f install/lib/*.a install/lib/*.la

# Strip remaining products
for f in $(find install -type f -exec file {} \; | grep 'not stripped' | awk '{print $1}'); do
	strip -s "${f: : -1}"
done

# Set executable rpaths so setting LD_LIBRARY_PATH isn't necessary
for bin in $(find install -mindepth 2 -maxdepth 3 -type f -exec file {} \; | grep 'ELF .* interpreter' | awk '{print $1}'); do
	# Remove last character from file output (':')
	bin="${bin: : -1}"

	echo "$bin"
	patchelf --set-rpath "$DIR/install/lib" "$bin"
done

# Release Info
pushd llvm-project || exit
llvm_commit="$(git rev-parse HEAD)"
short_llvm_commit="$(cut -c-8 <<< "$llvm_commit")"
popd || exit

llvm_commit_url="https://github.com/llvm/llvm-project/commit/$short_llvm_commit"
binutils_ver="$(ls | grep "^binutils-" | sed "s/binutils-//g")"
clang_version="$(install/bin/clang --version | head -n1 | cut -d' ' -f4)"

git clone https://${GIT_SECRET}@github.com/ZyCromerZ/Clang -b $CloneTo $(pwd)/FromGithub
pushd $(pwd)/FromGithub || exit
rm -fr ./*
cp -r ../install/* .
echo "# Quick Info
Clang Version : $clang_version
Build Date : $(date +"%Y-%m-%d")" > README.md
git add .
git commit -asm "Update to $llvm_commit_url

Clang VERSION: $clang_version
LLVM COMMIT URL: $llvm_commit_url"
git push -f
popd || exit

curl -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="-1001150624898" \
    -d "disable_web_page_preview=true" \
    -d "parse_mode=html" \
    -d text="New Toolchain Already Builded boy%0ADate : <code>$(date +"%Y-%m-%d")</code>%0A<code> --- Detail Info About it --- </code>%0AClang version : <code>${clang_version}</code>%0AClang Link : <code>https://github.com/ZyCromerZ/Clang/tree/${CloneTo}</code>%0A%0A-- uWu --"
