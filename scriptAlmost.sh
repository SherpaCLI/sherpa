readonly SDD="$HOME/.sherpa" # Sherpa Dot-Dir
readonly SCD="$HOME/sherpa"  # Sherpa Custom-Dir
readonly EDITOR="vim"        # Default Editor
readonly BIN="${SDD}/bin"    # Default Editor
set -eo pipefail
use() {
local file="$1" # ex std/fmt
local dotdir="${SDD}/lib"
local custom="${SCD}/lib"
if [ -f "${custom}/${file}.sh" ]; then
source "${custom}/${file}.sh"
elif [ -f "${dotdir}/${file}.sh" ]; then
source "${dotdir}/${file}.sh"
fi
}
import() {
local url=""
local repo=""
local branch="master"
local file=""
while getopts "u:r:b:f:" opt; do
case $opt in
u) url=$OPTARG ;;
r) repo=$OPTARG ;;
b) branch=$OPTARG ;;
f) file=$OPTARG ;;
*) echo "Invalid flag" ;;
esac
done
if [[ $url != "" ]]; then
. <(curl -s "$url")
elif [[ $repo != "" ]]; then
local fullUrl="https://raw.githubusercontent.com/${repo}/refs/heads/${branch}/${file}"
. <(curl -s "$fullUrl")
else
echo "Opps. Something went wrong."
exit 1
fi
}
confirm() {
br
read -r -p "$1 (y/n): " answer
if [[ ! $answer =~ ^[Yy]$ ]]; then
br
p "${btnWarning} Canceled ${x} Ok, got it."
br
exit 1
fi
}
add_yaml_parent() {
local key="$1"
local file="$2"
yq eval ".$key = {}" -i "$file"
}
add_yaml_item() {
local key="$1"
local value="$2"
local file="$3"
yq eval ".$key = \"$value\"" -i "$file"
}
get_yaml_item() {
local key="$1"
local file="$2"
yq e ".$key" "$file"
}
update_yaml_item() {
local key="$1"
local newValue="$2"
local file="$3"
yq -i ".$key = \"$newValue\"" "$file"
}
remove_yaml_item() {
local key="$1"
local file="$2"
yq -i "del(.$key)" "$file"
}
print_yaml_items() {
local file="$1"
yq eval "." "$file"
}
package() {
local key="$1"
get_yaml_item "package.${key}" "${ROOT}/Sherpa.yaml"
}
add_config() {
local key="$1"
local value="$2"
local file="$3"
yq -i ".$key = \"$value\"" "$file"
}
add_conf() {
local key="$1"
local value="$2"
yq -i ".$key = \"$value\"" ./Sherpa.yaml
}
get_config() {
local key="$1"
yq e ".$key" Sherpa.yaml
}
get_conf() {
local key="$1"
local file="$2"
yq e ".$key" "$file"
}
update_config() {
local key="$1"
local newValue="$2"
yq -i ".$key = \"$newValue\"" ./Sherpa.yaml
}
remove_config() {
local key="$1"
yq -i "del(.$key)" ./Sherpa.yaml
}
strong="\033[1m"   # Make it Bold
disabled="\033[2m" # Make it Dimmed
em="\033[3m"       # Make it Italic
u="\033[4m"        # Make it Underlined
x="\033[0m" # Make it </end> but shorter
txtBlack="\033[30m"   # .text-red
txtRed="\033[31m"     # .text-red
txtGreen="\033[32m"   # .text-green
txtYellow="\033[33m"  # .text-yellow
txtBlue="\033[34m"    # .text-blue
txtMagenta="\033[35m" # .text-magenta
txtCyan="\033[36m"    # .text-cyan
txtWhite="\033[37m"   # .text-white
bgBlack="\033[40m"     # .bg-black
bgRed="\033[41m"       # .bg-red
bgGreen="\033[42m"     # .bg-green
bgYellow="\033[43m"    # .bg-yellow
bgBlue="\033[44m"      # .bg-blue
bgMagenta="\033[45m"   # .bg-magenta
bgCyan="\033[46m"      # .bg-cyan
bgLightGray="\033[37m" # .bg-lightGray
icoLeaf="\ue22f"
primaryColor="Green"
case $primaryColor in
Black)
txtPrimary=${txtBlack}
;;
Red)
txtPrimary=${txtRed}
;;
Green)
txtPrimary=${txtGreen}
;;
Yellow)
txtPrimary=${txtYellow}
;;
Blue)
txtPrimary=${txtBlue}
;;
Magenta)
txtPrimary=${txtMagenta}
;;
Cyan)
txtPrimary=${txtCyan}
;;
White)
txtPrimary=${txtWhite}
;;
*)
txtPrimary=""
;;
esac
export btnSuccess="${bgGreen}${txtBlack}"
export btnWarning="${bgYellow}${txtBlack}"
export btnDanger="${bgRed}${txtWhite}"
export link="${u}${em}${txtBlue}"
text-center() {
local -i TERM_COLS
local -i str_len
local -i filler_len
local filler
TERM_COLS=$(tput cols)
str_len=${#1}
filler_len=$(((TERM_COLS - str_len) / 2))
filler=$(printf '%*s' "$filler_len" '' | tr ' ' ' ')
printf "%s%s\n" "$filler" "$1"
}
fetch() {
local endpoint="$1"
local response
response=$(curl -s -X GET "$endpoint")
echo "$response"
}
h1() {
printf "\n%b%b%s%b\n" "$strong" "$txtPrimary" "$1" "$x"
}
h2() {
printf "%b%s%b\n" "$txtPrimary" "$1" "$x"
}
h3() {
printf "%b%b%s%b\n" "$txtPrimary" "$em" "$1" "$x"
}
p() {
echo -e " $1"
}
span() {
printf "%s" "$1"
}
br() {
printf "\n"
}
em() {
printf "%b%s%b" "$em" "$1" "$x"
}
strong() {
printf "%b%s%b" "$strong" "$1" "$x"
}
hr() {
[[ $# == 0 ]] && return 1
declare -i TERM_COLS
declare -i str_len
TERM_COLS="$(tput cols)"
str_len="((${#1} + 2))"
[[ $str_len -ge $TERM_COLS ]] && {
echo "$1"
return 0
}
declare -i filler_len="$(((TERM_COLS - str_len) / 2))"
[[ $# -ge 2 ]] && ch="${2:0:1}" || ch=" "
filler=""
for ((i = 0; i < filler_len; i++)); do
filler="${filler}${ch}"
done
printf "%s %s %s" "$filler" "$1" "$filler"
[[ $(((TERM_COLS - str_len) % 2)) -ne 0 ]] && printf "%s" "${ch}"
printf "\n"
return 0
}
a() {
echo -e "${u}${em}${txtBlue}$1${x}"
}
flex-between() {
left_text=$1
right_text=$2
width=$(tput cols)
right_position=$((width - ${#right_text}))
printf "%s%*s\n" "$left_text" $((right_position - ${#left_text})) ""
printf "%s\n" "$right_text"
}
modify_value() {
local key="$1"
local new_value="$2"
local filename="$3"
sed -i -E "s/^(${key}\s*=\s*).*/\1${new_value}/" "$filename"
}
hello_link() {
echo
echo "Hello from tent/symlink.sh"
echo
}
_is_command() {
local link_name=$1
if command -v "$link_name" &> /dev/null; then
echo "Error: A command with the name '$link_name' already exists."
exit 1
fi
}
_sl_exists() {
local target_dir=$1
local link_name=$2
if [ -L "$target_dir/$link_name" ]; then
echo "Error: A symlink named '$link_name' already exists in $target_dir."
exit 1
fi
}
_sl_create() {
file_path=$1
target_dir=$2
link_name=$3
ln -s "$file_path" "$target_dir/$link_name"
}
symlink_add() {
local file_path=$1
local target_dir=$2
local link_name=$3
local link=${target_dir}/${link_name}
_sl_exists "$target_dir" "$link_name"
_sl_create "$file_path" "$target_dir" "$link_name"
if [[ $? == 0 ]]; then
p "Symlink created successfully."
else
p "Error creating symlink."
exit 1
fi
}
symlink_remove() {
link=$1
rm -i $link
[[ ! -L $link ]] && echo "'cause now I'm freeeee"
}
symlinks_list() {
local dir="${1:-$HOME/.sherpa/bin}"
while IFS= read -r -d '' file; do
if [ -L "$file" ]; then
echo "$(basename "$file") -> $(readlink -f "$file")"
fi
done < <(find "$dir" -type l -print0)
}
declare -g strong
declare -g txtBlue
declare -g txtGreen
declare -g x
color="" # String
usage() {
clear
h1 " Welcome, I'm your Sh:erpa 👋"
hr "sh:help" "-"
br
p "${strong}${txtBlue}Usage:${x}"" ${txtGreen}sherpa [option] <command> [arg]${x}"
br
p "${strong}${txtBlue}Options:${x}"
echo "  -h | --help       Display the usage message."
echo "  -v | --version    Display script Version."
echo "  -V | --verbose    Enable Verbose mode."
echo "  -q | --quiet      Continue force execution."
br
p "${strong}${txtBlue}Commands:${x}"
p "  ${txtGreen}build${x}, ${txtGreen}b${x}    Compile the curent package"
p "  ${txtGreen}doc${x}, ${txtGreen}d${x}      Build the package documentation"
p "  ${txtGreen}edit${x}, ${txtGreen}e${x}     Open files in default Editor"
p "  ${txtGreen}init${x}        Create package in existing dir"
p "  ${txtGreen}links${x}        Show symlinks from .sherpa/bin"
p "  ${txtGreen}new${x}         Create a new sherpa package"
p "  ${txtGreen}run${x}, ${txtGreen}r${x}      Build and run a binary or script"
p "  ${txtGreen}test${x}, ${txtGreen}t${x}     Run the tests from the tests dir"
br
p "Comming soon: the Docs website, and the link will be here."
br
}
while getopts ":hvc:Vq-:" opt; do
case $opt in
h)
usage
exit 0
;;
v)
printf "%s v%s\n" "Sh:erpa" "$(get_yaml_item "version" "${SDD}/Sherpa.yaml")"
exit 0
;;
c)
color=${OPTARG}
;;
V)
verb="on"
;;
q)
quiet="on"
;;
-)
case "${OPTARG}" in
help)
usage
exit 0
;;
version)
printf "%s v%s\n" "$SCRIPT_NAME" "$VERSION"
[[ -n "$REPO" ]] && printf "Repo: %s\n" "$REPO"
exit 0
;;
verbose)
verb="on"
;;
quiet)
quiet="on"
;;
*)
echo "Unknown option --${OPTARG}" >&2
exit 1
;;
esac
;;
\?)
echo "Invalid option: -$OPTARG" >&2
exit 1
;;
:)
echo "Option -$OPTARG requires an argument." >&2
exit 1
;;
esac
done
shift $((OPTIND - 1))
declare -g txtGreen
declare -g x
[[ ! -d "$SCD" ]] && cp -r "${SDD}/templates/SCD" "${SCD}"
localBoxes="${SCD}/registers/localBoxes.yaml"
bbrBin="${SCD}/registers/bbrBin.yaml"
if [[ "$#" == 0 ]]; then # Home Route
clear
h1 " Welcome to the Basecamp 👋"
hr "= + =" "-" # -----------= + =-----------
text-center "$(date +%T)"
br
h2 " Local BashBoxes"
if [[ -n "$localBoxes" ]]; then
p "$(yq 'keys | join(", ")' "$localBoxes")"
else
p "Create one with: sherpa create <myBashBox>"
fi
br
if [[ -n "$bbrBin" ]]; then
h2 " Installed Ones"
p "$(yq 'keys | join(", ")' "$bbrBin")"
else
p "Install something."
fi
cd "${SCD}/bbr/bin" || exit 1
dirs=(*/*)
dirs=("${dirs[@]%/}")
for dir in "${dirs[@]}"; do
p "* ${txtBlue}$dir${x}"
done
br
p "Docs: ${link}http://sherpa-basecamp.netlify.app${x}"
br
fi # End Home Route
if [[ "$1" == "bashdoc" ]]; then # Bashdoc
if [[ ! -f Sherpa.yaml ]]; then
p "Opps. Probably not in a project root."
exit 1
fi
SRC_DIR="src"
DOCS_DIR="docs"
HBS="${SDD}/templates/bashdoc.hbs"
[[ ! -d "$DOCS_DIR" ]] && mkdir -p "$DOCS_DIR"
for script in "$SRC_DIR"/*.sh; do
if [[ -f "$script" ]]; then
base_name=$(basename "$script" .sh)
bashdoc -c -j -l "${DOCS_DIR}" -t "${HBS}" $script
fi
done
fi # End Bashdoc
if [[ "$1" == "compile" ]]; then # Compile
executable="$(get_yaml_item "package.executable" Sherpa.yaml)"
script="target/local/${executable}"
scriptCopy="/tmp/${executable}-copy"
if [[ ! -f "target/local/${executable}" ]]; then # IsFile
p "Oops! Run first: ${em}sherpa make${x}"
exit 1
else
[[ ! -d "target/bin" ]] && mkdir target/bin
cp "$script" "$scriptCopy"
sed -i 's|#!/usr/bin/env bash|#!/bin/bash|g' "$scriptCopy"
echo "Compiling to Binary via SHC..."
export CC=gcc
shc -vrf "$scriptCopy" -o "target/bin/${executable}"
if [[ "$?" == 0 ]]; then
br
p "${btnSuccess} Done! ${x} The binary is stored in target/bin"
rm ${scriptCopy}
br
symlink="${SDD}/bin/${executable}"
target=$(readlink -f "$symlink")
if [[ "$target" != *"target/bin"* ]]; then
rm "$symlink"
ln -s "$(pwd)/target/bin/${executable}" "${SDD}/bin/${executable}"
echo "Symlink updated successfully."
else
echo "bin/${executable} still Symlinked to ${SDD}/bin"
fi
else
br
p "Ooops! Command failed, with the ${?} exit code."
br
fi
fi # End IsFile
fi   # End Compile
if [[ $1 == "edit" || $1 == "e" ]]; then # Edit
fileToEdit=$2
if [[ "$fileToEdit" == "bin" ]]; then # Options
if [[ -f "src/bin.sh" ]]; then
${EDITOR} src/bin.sh
else
br
p "Oops. No src/bin.sh file from here."
em "Make sure you are in a project root"
br
fi
elif [[ "$fileToEdit" == "opt" ]]; then
if [[ -f "src/_options.sh" ]]; then
${EDITOR} src/_options.sh
else
br
p "Oops. No src/_options.sh file from here."
em "Make sure you are in a project root"
br
fi
elif [[ "$fileToEdit" == "basecamp" ]]; then
if [[ -f "${SDD}/basecamp.sh" ]]; then
${EDITOR} "${SDD}/basecamp.sh"
else
br
p "Oops. Can't reach the basecamp."
em "Make sure Sherpa is corectly installed"
br
fi
elif [[ "$fileToEdit" == "yaml" ]]; then
if [[ -f "Sherpa.yaml" ]]; then
${EDITOR} "Sherpa.yaml"
else
br
p "Oops. Can't find the Sherpa.yaml file."
em "Make sure you are in a project root"
br
fi
fi # end Options
fi   # end Edit
if [[ "$1" == "box" ]]; then # Link
box_name="$2"
allPackages="${SCD}/registers/allPackages.yaml"
[[ ! -f "$allPackages" ]] && touch "$allPackages"
localBoxes="${SCD}/registers/localBoxes.yaml"
bbrBin="${SCD}/registers/bbrBin.yaml"
if [[ ! -f "$localBoxes" || ! -f "$bbrBin" ]]; then
echo "One or both input files do not exist."
exit 1
fi
yq ea -i 'select(fileIndex == 0) * select(fileIndex == 1)' "$localBoxes" "$bbrBin" >"$allPackages"
register="$allPackages"
root="$(get_yaml_item "${box_name}.root" "$register")"
boxType="$(get_yaml_item "${box_name}.type" "$register")"
exe="$(get_yaml_item "package.executable" "${root}/Sherpa.yaml")"
repo="$(get_yaml_item "${box_name}.repo" "$register")"
symLink="${SDD}/bin/${exe}"
if [[ -n "$2" && "$#" == 2 ]]; then # BoxInfos
if [[ "$root" != null ]]; then
h1 " -= ${box_name} =-"
hr "bash-box" "-"
p "Some infos about it."
if [[ -n "$boxType" && "$boxType" == "bbr" ]]; then
br
p "RootDir: ${em}${root}${x}"
p "Executable: ${em}${exe}${x}"
p "Repo: ${link}${repo}${x}"
br
p "Uninstall: ${em} sherpa uninstall ${box_name} ${x}"
else
br
p "RootDir: ${em}${root}${x}"
p "Executable: ${em}${exe}${x}"
br
p "To delete it: ${em}sherpa box ${box_name} delete${x}"
fi
hr "-" "-"
p "Other boxes: $(yq 'keys | join(", ")' "$register")"
fi
fi # End BoxInfos
if [[ "$3" == "delete" ]]; then # Delete
if [ "$#" -ne 3 ]; then
echo "Usage: $0 <boxName> delete"
exit 1
fi
confirm "Do you really want to delete ${box_name}?"
br
p " Allright, pal, let's clean a little..."
br
[[ -L "$symLink" ]] && rm "$HOME/.sherpa/bin/${exe}"
p "- Removed symlink: ${em}${exe}${x}"
rm -rf "$root"
p "- Removed directory: ${em}${root}${x}"
remove_yaml_item "$box_name" "$localBoxes"
p "- Removed register entry: ${em}${box_name}${x}"
br
p "${btnSuccess} Done! ${x} ${strong}${box_name}${x} just left the camp"
fi # End Delete
if [[ "$3" == "update" ]]; then # Update
confirm "Do you really want to update ${box_name}?"
if [[ "$boxType" == "bbr" ]]; then
cd "${root}" || return
git stash
git pull
git stash pop
sherpa build
p "${btnSuccess} Done! ${x} Latest version pulled."
fi
fi # End Update
fi # End link
if [[ "$1" == "rmBox" ]]; then # Link
boxName="$2"
if [[ ! -d "${SCD}/boxes/${boxName}" ]]; then
br
p "${btnWarning} Oops! ${x} There is no ${txtBlue}${boxName}${x} directory in boxes/"
br
exit 1
fi
root="${SCD}/boxes/${boxName}"
exe="$(get_yaml_item "package.executable" "${root}/Sherpa.yaml")"
link="${SDD}/bin/${exe}"
localBoxes="${SCD}/registers/localBoxes.yaml"
confirm "Do you really want to delete ${boxName}?"
br
p " Allright, pal, let's clean a little..."
br
[[ -L "$link" ]] && rm "$HOME/.sherpa/bin/${exe}"
p "- Removed symlink: ${em}${exe}${x}"
rm -rf "$root"
p "- Removed directory: ${em}${root}${x}"
remove_yaml_item "$boxName" "$localBoxes"
p "- Removed register entry: ${em}${boxName}${x}"
br
p "${btnSuccess} Done! ${x} ${strong}${boxName}${x} just left the camp"
br
fi # End link
if [[ "$1" == "links" ]]; then
br
p "Symlinks:"
symlinks_list
br
fi
quiet="off"
verb="off"
if [[ "$1" == "build" || "$1" == "b" ]]; then
shebang="src/_header.sh"
sourceOrder="src/__paths.txt"
combinedScript="scriptAlmost.sh"
finalScript="$(get_yaml_item "package.executable" "Sherpa.yaml")"
type="" # bin|lib|exe(executable .sh file)
while getopts "u:r:b:f:" opt; do
case $opt in
t) type=$OPTARG ;;
*) echo "Invalid flag" ;;
esac
done
[[ ! -d target ]] && mkdir target
[[ ! -d target/local ]] && mkdir target/local
[[ "$quiet" != "on" ]] && p "\nGenerating partials files paths..."
[[ "$quiet" != "on" ]] && br
use2path
[[ "$verb" == "on" ]] && echo "VB: Combining files listed in ${sourceOrder}..."
[[ "$verb" == "on" ]] && echo "VB: Some more lines"
mapfile -t files <"$sourceOrder"
cat "${files[@]}" >"$combinedScript"
if [[ -f "$combinedScript" ]]; then
echo
echo "Done. Combined into ${combinedScript}!"
echo
echo "Generating documentation from that file"
[[ ! -d docs ]] && mkdir docs
shdoc <"$combinedScript" >"docs/${finalScript}.md"
echo -e "--- Commands/Routes & nonFunctions ---\n" >>"docs/${finalScript}.md"
bashdoc "$combinedScript" >>"docs/${finalScript}.md"
if [[ -f "docs/${finalScript}.md" ]]; then
p "Check docs/${finalScript}.md"
br
fi
echo "- Removing comments and empty lines..."
sed -i '/^\s*#/d; /^\s*$/d' "$combinedScript"
echo "- Removing trailing spaces..."
sed -i 's/[[:space:]]*$//' "$combinedScript"
echo "- Removing the leading spaces..."
sed -i 's/^[[:space:]]*//' "$combinedScript"
echo "- Adding the /usr/bin/env bash Shebang..."
[[ ! -d target ]] && mkdir "target"
[[ ! -d target/local ]] && mkdir "target/local"
cat "$shebang" "$combinedScript" >"target/local/$finalScript"
rm "$combinedScript"
[[ "$verb" == "on" ]] && p "Making ${finalScript} it executable..."
chmod +x "target/local/$finalScript"
echo
p "${btnSuccess} Done! ${x} Execute it with ${txtGreen}${em}${finalScript}${x}"
br
executable=$(get_yaml_item "package.executable" "Sherpa.yaml")
symlink="${SDD}/bin/${executable}"
target=$(readlink -f "$symlink")
if [[ ! -L "$symlink" ]]; then
ln -s "$(pwd)/target/local/${executable}" "${SDD}/bin/${executable}"
fi
if [[ "$target" != *"target/local"* ]]; then
rm "$symlink"
ln -s "$(pwd)/target/local/${executable}" "${SDD}/bin/${executable}"
echo "Symlink updated successfully."
else
echo "local/${executable} still Symlinked to ${SDD}/bin"
fi
else
echo "Quelque chose à merdé!"
exit 1
fi
fi
if [[ "$1" == "new" ]]; then # Start Route
if [[ -z $2 ]]; then
br
p "${btnDanger} Oops! ${x} Second argument needed."
p "Usage: ${em}sherpa new [-t] <packageName>${x}"
br
p "It will be the directory's name, so no wild things."
exit 1
fi
if [[ -n $1 ]]; then # Creation
project=$2
regDir="${SCD}/registers"
localBoxes="${regDir}/localBoxes.yaml"
[[ ! -d "$regDir" ]] && mkdir "$regDir"
[[ ! -f "$localBoxes" ]] && touch "$localBoxes"
project_dir="${SCD}/boxes/$project"
template="binStarter"
custom_template="${SCD}/templates/${template}"
default_template="${SDD}/templates/${template}"
if [[ -d ${custom_template} ]]; then
template_files="${custom_template}"
else
template_files="${default_template}"
fi
cd "${SCD}/boxes" || return
mkdir "$project"
if [[ ! -d "$project" ]]; then
p "Couldn't create the ${project} directory"
exit 1
else
cd "$project" || return
fi
h1 " Welcome to the basecamp 👋 intrepid voyager."
hr "= + =" "-"
br
p "Unloading template's files from the truck..."
cp -r ~/.sherpa/templates/${template}/* .
git init
br
p "${btnSuccess} Done! ${x} Time to start climbing."
p "ProjectDir is $project_dir"
br
p "You can follow the trail with: ${em}cd ${project}${x}"
p "Then one of those signs:"
p "* sherpa run         # Build and Run your project"
p "* sherpa e bin       # Edit the main script content"
p "* sherpa e opt       # Edit the Flags & Options"
p "* sherpa e yaml      # Edit the Sherpa.yaml file"
p "* sherpa e basecamp  # Edit global data"
br
p "...more on ${link}https://github.com/AndiKod/sherpa${x}"
br
echo "readonly ROOT=\"$project_dir\"" >>"${project_dir}/src/_globals.sh"
add_yaml_item "package.root" "$project_dir" "${project_dir}/Sherpa.yaml"
add_yaml_item "package.type" "localBin" "${project_dir}/Sherpa.yaml"
update_yaml_item "package.name" "$project" "${project_dir}/Sherpa.yaml"
update_yaml_item "package.executable" "$project" "${project_dir}/Sherpa.yaml"
add_yaml_parent "$project" "$localBoxes"
add_yaml_item "${project}.root" "$project_dir" "$localBoxes"
fi #End Creation
fi   # End Route
if [[ "$1" == "init" ]]; then # Start Route
if [[ -n "$(ls -A)" ]]; then # Creation
p "It seems like this directory is not empty."
p "I hope you know about that."
else
project=$(basename "$PWD")
project_dir="$(pwd)"
template="binStarter"
custom_template="${SCD}/templates/${template}"
default_template="${SDD}/templates/${template}"
if [[ -d ${custom_template} ]]; then
template_files="${custom_template}"
else
template_files="${default_template}"
fi
h1 " Welcome to the basecamp 👋 intrepid voyager."
hr "= + =" "-"
br
p "Unloading template's files from the truck..."
cp -r ~/.sherpa/templates/${template}/* .
git init
br
p "${btnSuccess} Done! ${x} Time to start climbing."
p "ProjectDir is $project_dir"
br
p "You can follow the trail with some of those:"
p "* sherpa run         # Build and Run your project"
p "* sherpa e bin       # Edit the main script content"
p "* sherpa e opt       # Edit the Flags & Options"
p "* sherpa e yaml      # Edit the Sherpa.yaml file"
p "* sherpa e basecamp  # Edit global data"
br
p "...more on ${link}https://github.com/AndiKod/sherpa${x}"
br
echo "readonly ROOT=\"$project_dir\"" >>"${project_dir}/src/_globals.sh"
update_yaml_item "package.name" "$project" "${project_dir}/Sherpa.yaml"
update_yaml_item "package.executable" "$project" "${project_dir}/Sherpa.yaml"
key="readonly PKG_NAME"
new_value="${project}"
filename="./src/_globals.sh"
sed -i -E "s/^(${key}\s*=\s*)\"([^\"]*)\"/\1\"${new_value}\"/" "$filename"
fi #End Creation
fi   # End Route
if [[ "$1" == "run" || "$1" == "r" ]]; then
shebang="src/_header.sh"
sourceOrder="src/__paths.txt"
combinedScript="scriptAlmost.sh"
finalScript="$(get_yaml_item "package.executable" "Sherpa.yaml")"
[[ ! -d target ]] && mkdir target
[[ ! -d target/local ]] && mkdir target/local
use2path
mapfile -t files <"$sourceOrder"
cat "${files[@]}" >"$combinedScript"
if [[ -f "$combinedScript" ]]; then
[[ ! -d docs ]] && mkdir docs
shdoc <"$combinedScript" >"docs/${finalScript}.md"
echo -e "--- Commands/Routes & nonFunctions ---\n" >>"docs/${finalScript}.md"
bashdoc "$combinedScript" >>"docs/${finalScript}.md"
sed -i '/^\s*#/d; /^\s*$/d' "$combinedScript"
sed -i 's/[[:space:]]*$//' "$combinedScript"
sed -i 's/^[[:space:]]*//' "$combinedScript"
cat "$shebang" "$combinedScript" >"target/local/$finalScript"
rm "$combinedScript"
chmod +x "target/local/$finalScript"
executable=$(get_yaml_item "package.executable" "Sherpa.yaml")
symlink="${SDD}/bin/${executable}"
target=$(readlink -f "$symlink")
if [[ ! -L "$symlink" ]]; then
ln -s "$(pwd)/target/local/${executable}" "${SDD}/bin/${executable}"
fi
if [[ "$target" != *"target/local"* ]]; then
rm "$symlink"
ln -s "$(pwd)/target/local/${executable}" "${SDD}/bin/${executable}"
"$executable"
else
"$executable"
fi
else
echo "Quelque chose à merdé!"
exit 1
fi
fi
if [[ "$1" == "doc" || "$1" == "d" ]]; then # Shdoc
if [[ ! -f Sherpa.yaml ]]; then
p "Opps. Probably not in a project root."
exit 1
fi
SRC_DIR="src"
DOCS_DIR="docs"
[[ ! -d "$DOCS_DIR" ]] && mkdir -p "$DOCS_DIR"
for script in "$SRC_DIR"/*.sh; do
if [[ -f "$script" ]]; then
base_name=$(basename "$script" .sh)
shdoc <"$script" >"$DOCS_DIR/$base_name.md"
echo -e "--- Some more, via BashDoc ---\n" >>"$DOCS_DIR/$base_name.md"
bashdoc "$script" >>"$DOCS_DIR/$base_name.md"
if [[ -f "$DOCS_DIR/$base_name.md" ]]; then
br
p "${btnSuccess} Done! ${x} ... ${DOCS_DIR}/$base_name.md"
br
else
p "Can't generate doc."
exit 1
fi
fi
done
fi # End Shdoc
if [[
"$1" == "test" || "$1" == "t" ]]; then
if [[ ! -f Sherpa.yaml ]]; then
p "Ooops. You
are probably not in a Sherpa project root."
exit 1
fi
[[ ! -d "${SCD}/registers" ]] && mkdir "${SCD}/registers"
[[ ! -f "${SCD}/registers/" ]] && touch "${SCD}/registers/tests.yaml"
key=$(date "+%s")
value="$(pwd)/tests"
file="${SCD}/registers/tests.yaml"
add_yaml_item "$key" "$value" "$file"
bashunit tests
fi
use "tent/symlink"
regDir="${SCD}/registers"
bbrBin="${regDir}/bbrBin.yaml"
bbrLib="${regDir}/bbrLib.yaml"
if [[ "$1" == "install" ]]; then # Start Route
shift
name=""
url=""
type=""
while getopts "n:t:u:" opt; do
case $opt in
n) name=${OPTARG} ;;
t) type=${OPTARG} ;;
u) url=${OPTARG} ;;
*) echo "Invalid flag" ;;
esac
done
[[ ! -d "${SCD}/bbr" ]] && mkdir "${SCD}/bbr"
[[ ! -d "${SCD}/bbr/bin" ]] && mkdir "${SCD}/bbr/bin"
[[ ! -d "${SCD}/bbr/lib" ]] && mkdir "${SCD}/bbr/lib"
if [[ $# == 0 ]]; then
br
h1 "Install a BashBox from Git"
hr "+" "-"
p "Usage: ${em}sherpa install foobar${x} ...not yet implemented"
p "   or: ${em}sherpa install -n \"name\" -t \"bin\" -u \"url-to-repository\" ${x}"
br
p "If part of the BashBoxRegistry, the name is enough."
p "If not, a full url to the repository is expected, with following flags:"
p "-n name: Project's name... n=\"projName\""
p "-t type: Either bin or lib"
p "-u  url: Full url to the repository"
exit 1
fi
if [[ -n $url ]]; then # ifUrl
p "name: $name"
p "type: $type"
p "url: $url"
br
if [[ -z $type ]]; then # typeCheck
p "If the -u flag is used, -t must be also set."
p "The -t flag must be either -t='bin' or -t='lib'"
exit 1
elif [[ $type != "bin" && $type != "lib" ]]; then
p "The -t flag must be either -t='bin' or -t='lib'"
fi # End typeCheck
if [[ $type = "bin" ]]; then # installBin
if [[ -z "$name" ]]; then
p "The name can't be empty"
p "use: sherpa install -n \"name\" -t \"bin\" -u \"repoUrl\""
exit 1
fi
if [[ -d "${SCD}/bbr/bin/${name}" ]]; then # isDirAlready
br
p "Ooops! A ${name} directory already exists."
em "Pick another name."
br
exit 1
else
git clone "$url" "${SCD}/bbr/bin/${name}"
cd "${SCD}/bbr/bin/${name}" || return
fi # End isDirAlready
bbName="${name}"
bbRepo="${url}"
bbDir="${SCD}/bbr/bin/${name}"
bbExe="$(get_yaml_item "package.executable" "${bbDir}/Sherpa.yaml")"
binReg="${SCD}/registers/bbrBin.yaml"
if yq "any(* | select(.repo == ${bbRepo}))" "${binReg}"; then # isInstalled
br
p "Oops. That BashBox is already installed."
br
exit 1
else                                      # actual Install
if [[ -L "${SDD}/bin/${bbExe}" ]]; then # isLinkAlready
p "Ooops. A bin/${bbExe} symlink exists."
p "Change the value in Sherpa.yaml, then build the Script."
exit 1
else
if sherpa build; then # Log
add_yaml_parent "${bbName}" "${bbrBin}"
add_yaml_item "${bbName}.repo" "$bbRepo" "${bbrBin}"
add_yaml_item "${bbName}.root" "$bbDir" "${bbrBin}"
add_yaml_item "${bbName}.exe" "$bbExe" "${bbrBin}"
add_yaml_item "${bbName}.type" "bbr" "${bbrBin}"
add_yaml_item "${bbName}.origin" "git" "${bbrBin}" # bbr / git / local
fi                                                   # End Log
fi                                                     # End isLinkAlready
fi                                                       # End isInstalled
fi # End installBin
if [[ $type = "lib" ]]; then # installLib
git clone "$url" "${SCD}/bbr/lib/${name}"
target="${SCD}/bbr/lib/${name}"
symlink="${SCD}/lib/${name}"
p "Creating a symlink into ${SCD}/lib"
ln -s "${target}" "${symlink}"
if ln -s "$target" "${symlink}"; then # Log
bbName="${name}"
bbDir="${SCD}/bbr/lib/${name}"
libReg="${SCD}/registers/bbrLib.yaml"
add_yaml_item "name" "$bbName" "$libReg"
add_yaml_item "${bbName}.root" "$bbDir" "$libReg"
add_yaml_item "${bbName}.type" "bbr" "$libReg"
fi # End Log
fi #End installLib
fi # End ifUrl
fi # End Route
if [[ "$1" == "uninstall" ]]; then
box_name="$2"
register="${SCD}/registers/bbrBin.yaml"
root="$(get_yaml_item "${box_name}.root" "$register")"
boxType="$(get_yaml_item "${box_name}.type" "$register")"
exe="$(get_yaml_item "package.executable" "${root}/Sherpa.yaml")"
link="${SDD}/bin/${exe}"
if [ "$#" -ne 2 ]; then
echo "Usage: $0 uninstall <boxName>"
exit 1
fi
confirm "Do you really want to uninstall ${box_name}?"
br
p " Allright, pal, let's clean a little..."
br
[[ -L "$link" ]] && rm "$HOME/.sherpa/bin/${exe}"
p "- Removed symlink: ${em}${exe}${x}"
rm -rf "$root"
p "- Removed directory: ${em}${root}${x}"
remove_yaml_item "$box_name" "$register"
p "- Removed register entry: ${em}${box_name}${x}"
br
p "${btnSuccess} Done! ${x} ${strong}${box_name}${x} just left the camp"
fi
