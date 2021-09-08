BLUE='\033[1;34m'
NC='\033[0m' # No Color
alias aliases="echo -e '${BLUE}extip${NC}\t\t\t- external IP address';\
               echo -e '${BLUE}ll${NC}\t\t\t- detailed list of all files';\
               echo -e '${BLUE}lld${NC}\t\t\t- detailed list of all directories';\
               echo -e '${BLUE}llg${NC} key\t\t\t- grep from detailed list of all files';\
               echo -e '${BLUE}nsg${NC} key\t\t\t- grep from netstat output';\
               echo -e '${BLUE}psg${NC} key\t\t\t- grep from process list';\
               echo -e '${BLUE}fg${NC} key\t\t\t- grep from (find /)';\
               echo -e '${BLUE}cya${NC}\t\t\t- shutdown now';\
               echo -e '${BLUE}h${NC}\t\t\t- history';\
               echo -e '${BLUE}hg${NC} key\t\t\t- grep from history';\
               echo -e '${BLUE}pyweb${NC}\t\t\t- python HTTP server';\
               echo -e '${BLUE}..${NC}\t\t\t- cd ..';\
               echo -e '${BLUE}...${NC}\t\t\t- cd ../..';\
               echo -e '${BLUE}ports${NC}\t\t\t- show used ports';\
               echo -e '${BLUE}p${NC}\t\t\t- ping';\
               echo -e '${BLUE}iptablemon${NC}\t\t- iptables output';\
               echo -e '${BLUE}ipcb${NC}\t\t\t- ip addresses';\
               echo -e '${BLUE}bwt${NC}\t\t\t- speed test';\
               echo -e '${BLUE}rpass${NC}\t\t\t- generate random pass';\
               "
alias a="aliases"

# Enable color output to standard commands
alias sudo='sudo '
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'

#Custom aliases
alias extip="echo -e -n '${BLUE}External IP${NC}: '; curl icanhazip.com;\
             echo -e -n '${BLUE}Reverse DNS record${NC}: '; curl icanhazptr.com;"
alias ll='ls -la'
alias lld='ls -ld */'
alias llg='ls -lta | grep -i $1'
alias nsg='netstat -nap | grep -i $1'
alias psg='ps -ef | grep -i $1'
alias fg='find / | egrep -i $1'
alias cya='shutdown -h now'
alias h='history'
alias hg='history | egrep -i $1'
alias pyweb='python3 -m http.server'
alias ..='cd ..'
alias ...='cd ../..'
alias ports='netstat -tulanp'
alias p='ping 8.8.8.8 -c 1; ping yahoo.com -c 1'
alias iptablemon='iptables -nvL | grep -v "0 0"'
alias ipcb='ip -c -brie a'
alias bwt='wget http://cachefly.cachefly.net/100mb.test -O /dev/null'
alias rpass='openssl rand -base64 24 | tr -d "\n" | xclip -selection clipboard' # install xclip
