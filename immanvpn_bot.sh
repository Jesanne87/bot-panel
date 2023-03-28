#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################


clear
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }


[[ ! -f "/etc/IP" ]] && wget -qO- ipv4.icanhazip.com > /etc/IP
cekray=`cat /root/log-install.txt | grep -ow "XRAY" | sort | uniq`
if [ "$cekray" = "XRAY" ]; then
domen=`cat /etc/xray/domain`
raycheck='xray'
else
domen=`cat /etc/v2ray/domain`
raycheck='v2ray'
fi

PID=`ps -ef |grep -v grep | grep sshws |awk '{print $2}'`
if [[ ! -z ${PID} ]]; then
IPs="$domen"
else
IPs=$(cat /etc/IP)
fi
[[ ! -d /var/lib/scrz-prem ]] && exit 0
[[ ! -f /etc/.maAsiss/res_token ]] && touch /etc/.maAsiss/res_token
[[ ! -f /etc/.maAsiss/user_flood ]] && touch /etc/.maAsiss/user_flood
[[ ! -f /etc/.maAsiss/log_res ]] && touch /etc/.maAsiss/log_res
[[ ! -f /etc/.maAsiss/User_Generate_Token ]] && touch /etc/.maAsiss/User_Generate_Token
[[ ! -d /etc/.maAsiss/.cache ]] && mkdir /etc/.maAsiss/.cache
[[ ! -f /etc/.maAsiss/.cache/StatusDisable ]] && {
touch /etc/.maAsiss/.cache/StatusDisable
cat <<-EOF >/etc/.maAsiss/.cache/StatusDisable
SSH : [ON]
VMESS : [ON]
VLESS : [ON]
TROJAN : [ON]
TROJAN-GO : [ON]
WIREGUARD : [ON]
SHADOWSOCK: [ON]
SHADOWSOCKS-R : [ON]
EOF
}

source /root/ResBotAuth
source /etc/.maAsiss/.Shellbtsss
User_Active=/etc/.maAsiss/list_user
User_Token=/etc/.maAsiss/User_Generate_Token
Res_Token=/etc/.maAsiss/res_token
User_Flood=/etc/.maAsiss/user_flood

ShellBot.init --token $Toket --monitor --return map --flush
ShellBot.username
echo "Admin ID = $Admin_ID"
admin_bot_panel=$(grep -w "admin_panel" /etc/.maAsiss/bot.conf | awk '{print $NF}')
_limTotal=$(grep -w "limite_trial" /etc/.maAsiss/bot.conf | awk '{print $NF}')
nameStore=$(grep -w "store_name" /etc/.maAsiss/bot.conf | awk '{print $NF}')
rm -f /tmp/authToken 
rm -f /tmp/authAdmin

AUTOBLOCK() {
[[ "$(grep -wc ${message_chat_id[$id]} $User_Flood)" != '1' ]] && {
   Max=9
   [[ "${message_from_id[$id]}" = "$Admin_ID" ]] && {
   return 0
   } || [[ "$(grep -w "${message_from_id}" $User_Active | grep -wc 'reseller')" != '1' ]] && {
   echo $message_date + $Max | bc >> /etc/.maAsiss/.cache/$message_chat_id
   [[ "$(grep -wc "$message_date" "/etc/.maAsiss/.cache/$message_chat_id")" = '1' ]] && {
         echo "$message_chat_id" >> /etc/.maAsiss/user_flood
         rm -f /etc/.maAsiss/.cache/$message_chat_id
         ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
             --text "Youre flooding im sorry to block you\nThis ur ID: <code>${message_chat_id[$id]}</code>\n\nContact $admin_bot_panel to unblock" \
             --parse_mode html
         ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
         return 0
      }
    }
  }
}

Disable_Order() {
   [[ "${message_from_id[$id]}" == "$Admin_ID" ]] && {
     ShellBot.deleteMessage	--chat_id ${message_chat_id[$id]} \
              --message_id ${message_message_id[$id]}
              
     [[ "$(grep -wc "ssh" "/tmp/order")" = '1' ]] && {
         touch /etc/.maAsiss/.cache/DisableOrderSSH
         sed -i "/SSH/c\SSH : [OFF]" /etc/.maAsiss/.cache/StatusDisable
         ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
             --text "âœ… Success Disabled SSH" \
             --parse_mode html
         [[ -f /tmp/msgid ]] && {
             dx=$(cat /tmp/msgid | tail -1)
             echo $dx + 1 | bc >> /tmp/msgid
         } || {
         echo ${message_message_id[$id]} + 1 | bc >> /tmp/msgid
         }
     }
     [[ "$(grep -wc "vmess" "/tmp/order")" = '1' ]] && {
         touch /etc/.maAsiss/.cache/DisableOrderVMESS
         sed -i "/VMESS/c\VMESS : [OFF]" /etc/.maAsiss/.cache/StatusDisable
         ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
             --text "âœ… Success Disabled VMess" \
             --parse_mode html
         [[ -f /tmp/msgid ]] && {
             dx=$(cat /tmp/msgid | tail -1)
             echo $dx + 1 | bc >> /tmp/msgid
         } || {
         echo ${message_message_id[$id]} + 1 | bc >> /tmp/msgid
         }
     }
     [[ "$(grep -wc "vless" "/tmp/order")" = '1' ]] && {
         touch /etc/.maAsiss/.cache/DisableOrderVLESS
         sed -i "/VLESS/c\VLESS : [OFF]" /etc/.maAsiss/.cache/StatusDisable
         ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
             --text "âœ… Success Disabled VLess" \
             --parse_mode html
         [[ -f /tmp/msgid ]] && {
             dx=$(cat /tmp/msgid | tail -1)
             echo $dx + 1 | bc >> /tmp/msgid
         } || {
         echo ${message_message_id[$id]} + 1 | bc >> /tmp/msgid
         }
     }
     [[ "$(grep -wc "trojan" "/tmp/order")" = '1' ]] && {
         touch /etc/.maAsiss/.cache/DisableOrderTROJAN
         sed -i "/TROJAN :/c\TROJAN : [OFF]" /etc/.maAsiss/.cache/StatusDisable
         ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
             --text "âœ… Success Disabled Trojan" \
             --parse_mode html
         [[ -f /tmp/msgid ]] && {
             dx=$(cat /tmp/msgid | tail -1)
             echo $dx + 1 | bc >> /tmp/msgid
         } || {
         echo ${message_message_id[$id]} + 1 | bc >> /tmp/msgid
         }
     }
     [[ "$(grep -wc "trgo" "/tmp/order")" = '1' ]] && {
         touch /etc/.maAsiss/.cache/DisableOrderTROJANGO
         sed -i "/TROJAN-GO/c\TROJAN-GO : [OFF]" /etc/.maAsiss/.cache/StatusDisable
         ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
             --text "âœ… Success Disabled Trojan-GO" \
             --parse_mode html
         [[ -f /tmp/msgid ]] && {
             dx=$(cat /tmp/msgid | tail -1)
             echo $dx + 1 | bc >> /tmp/msgid
         } || {
         echo ${message_message_id[$id]} + 1 | bc >> /tmp/msgid
         }
     }
     [[ "$(grep -wc "wg" "/tmp/order")" = '1' ]] && {
         touch /etc/.maAsiss/.cache/DisableOrderWG
         sed -i "/WIREGUARD/c\WIREGUARD : [OFF]" /etc/.maAsiss/.cache/StatusDisable
         ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
             --text "âœ… Success Disabled Wireguard" \
             --parse_mode html
         [[ -f /tmp/msgid ]] && {
             dx=$(cat /tmp/msgid | tail -1)
             echo $dx + 1 | bc >> /tmp/msgid
         } || {
         echo ${message_message_id[$id]} + 1 | bc >> /tmp/msgid
         }
     }
     [[ "$(grep -wc "ss" "/tmp/order")" = '1' ]] && {
         touch /etc/.maAsiss/.cache/DisableOrderSS
         sed -i "/^SHADOWSOCK:/c\SHADOWSOCK: [OFF]" /etc/.maAsiss/.cache/StatusDisable
         ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
             --text "âœ… Success Disabled Shadowsocks" \
             --parse_mode html
         [[ -f /tmp/msgid ]] && {
             dx=$(cat /tmp/msgid | tail -1)
             echo $dx + 1 | bc >> /tmp/msgid
         } || {
         echo ${message_message_id[$id]} + 1 | bc >> /tmp/msgid
         }
     }
     [[ "$(grep -wc "ssr" "/tmp/order")" = '1' ]] && {
         touch /etc/.maAsiss/.cache/DisableOrderSSR
         sed -i "/SHADOWSOCKS-R/c\SHADOWSOCKS-R : [OFF]" /etc/.maAsiss/.cache/StatusDisable
         ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
             --text "âœ… Success Disabled Shadowsocks-R" \
             --parse_mode html
         [[ -f /tmp/msgid ]] && {
             dx=$(cat /tmp/msgid | tail -1)
             echo $dx + 1 | bc >> /tmp/msgid
         } || {
         echo ${message_message_id[$id]} + 1 | bc >> /tmp/msgid
         }
     }
     [[ -f /tmp/msgid ]] && {
     while read msg_id; do
         ShellBot.deleteMessage	--chat_id ${message_chat_id[$id]} \
              --message_id $msg_id
     done <<<"$(cat /tmp/msgid)"
     rm -f /tmp/msgid
     }
     [[ "$(grep -wc "off" "/tmp/order")" = '1' ]] && {
         rm -f /etc/.maAsiss/.cache/DisableOrderWG
         rm -f /etc/.maAsiss/.cache/DisableOrderSSH
         rm -f /etc/.maAsiss/.cache/DisableOrderVMESS
         rm -f /etc/.maAsiss/.cache/DisableOrderVLESS
         rm -f /etc/.maAsiss/.cache/DisableOrderTROJAN
         rm -f /etc/.maAsiss/.cache/DisableOrderTROJANGO
         rm -f /etc/.maAsiss/.cache/DisableOrderSS
         rm -f /etc/.maAsiss/.cache/DisableOrderSSR
         sed -i "s/\[OFF\]/\[ON\]/g" /etc/.maAsiss/.cache/StatusDisable
         bdx=$(echo ${message_message_id[$id]} + 1 | bc)
         ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
             --text "â˜‘ï¸ Successfully Enabled Order â˜‘ï¸" \
             --parse_mode html
         sleep 1
         ShellBot.deleteMessage	--chat_id ${message_chat_id[$id]} \
              --message_id $bdx
     } 
  }
}

about_server() {
[[ "$(grep -wc ${message_chat_id[$id]} $User_Flood)" = '1' ]] && return 0 || AUTOBLOCK
ISP=`curl -sS ip-api.com | grep -w "isp" | awk '{print $3,$4,$5,$6,$7,$8,$9}' | cut -d'"' -f2 | cut -d',' -f1 | tee -a /etc/afak.conf`
CITY=`curl -sS ip-api.com | grep -w "city" | awk '{print $3}' | cut -d'"' -f2 | tee -a /etc/afak.conf`
WKT=`curl -sS ip-api.com | grep -w "timezone" | awk '{print $3}' | cut -d'"' -f2 | tee -a /etc/afak.conf`
IPVPS=`curl -sS ip-api.com | grep -w "query" | awk '{print $3}' | cut -d'"' -f2 | tee -a /etc/afak.conf`

    local msg
    msg="<b>Server Information</b>\n\n"
    msg+="<code>ISP  : $ISP\n"
    msg+="CITY : $CITY\n"
    msg+="TIME : $WKT\n"
    msg+="IP.  : $IPVPS</code>\n"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
        --text "$msg" \
        --parse_mode html
    return 0
}

msg_welcome() {
[[ "$(grep -wc ${message_chat_id[$id]} $User_Flood)" = '1' ]] && return 0 || AUTOBLOCK
[[ "$(grep -wc ${message_chat_id[$id]} $User_Token)" = '0' ]] && {
r1=$(tr -dc A-Za-z </dev/urandom | head -c 4)
r2=$(tr -dc A-Za-z </dev/urandom | head -c 2)
r3=$(tr -dc A-Za-z </dev/urandom | head -c 3)
r4=$(tr -dc A-Za-z </dev/urandom | head -c 1)
r5=$(tr -dc A-Za-z </dev/urandom | head -c 5)
r6=$(tr -dc A-Za-z </dev/urandom | head -c 2)
r7=$(tr -dc A-Za-z </dev/urandom | head -c 4)
r8=$(tr -dc A-Za-z </dev/urandom | head -c 2)
r9=$(tr -dc A-Za-z </dev/urandom | head -c 4)
fcm=$(echo ${message_from_id[$id]} | sed 's/\([0-9]\{2,\}\)\([0-9]\)\([0-9]\)\([0-9]\)\([0-9]\)\([0-9]\)\([0-9]\)\([0-9]\)/\1'$r1'\2'$r2'\3'$r3'\4'$r4'\5'$r5'\6'$r6'\7'$r7'\8'$r8'/ig' | rev)
echo "ID_User : ${message_chat_id[$id]} Token : $fcm" >> /etc/.maAsiss/User_Generate_Token
} || {
fcm=$(grep -w ${message_chat_id[$id]} $User_Token | awk '{print $NF}')
}

local msg
msg="===========================\n"
msg+="Welcome <b>${message_from_first_name[$id]}</b>\n\n"
msg+="To access the menu [ /menu ]\n"
msg+="To see server information [ /info ]\n"
msg+="for free account [ /free ]\n\n"
msg+="===========================\n"
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
msg+="<b>Acces Token:</b>\n"
msg+="<code>$fcm</code>\n"
msg+="===========================\n"
} 
ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
     --text "$(echo -e $msg)" \
     --parse_mode html
return 0
}

menu_func() {
[[ "$(grep -wc ${message_chat_id[$id]} $User_Flood)" = '1' ]] && return 0 || AUTOBLOCK
hargassh=$(grep -w "Price SSH" /etc/.maAsiss/price | awk '{print $NF}')
hargavmess=$(grep -w "Price VMess" /etc/.maAsiss/price | awk '{print $NF}')
hargavless=$(grep -w "Price VLess" /etc/.maAsiss/price | awk '{print $NF}')
hargatrojan=$(grep -w "Price Trojan :" /etc/.maAsiss/price | awk '{print $NF}')
hargatrgo=$(grep -w "Price Trojan-GO" /etc/.maAsiss/price | awk '{print $NF}')
hargawg=$(grep -w "Price Wireguard" /etc/.maAsiss/price | awk '{print $NF}')
hargass=$(grep -w "Price Shadowsocks :" /etc/.maAsiss/price | awk '{print $NF}')
hargassr=$(grep -w "Price Shadowsocks-R" /etc/.maAsiss/price | awk '{print $NF}')
hargasstp=$(grep -w "Price SSTP" /etc/.maAsiss/price | awk '{print $NF}')
hargal2tp=$(grep -w "Price L2TP" /etc/.maAsiss/price | awk '{print $NF}')
hargapptp=$(grep -w "Price PPTP" /etc/.maAsiss/price | awk '{print $NF}')
hargaxray=$(grep -w "Price Xray" /etc/.maAsiss/price | awk '{print $NF}')

    [[ "${message_from_id[$id]}" == "$Admin_ID" ]] && {
        local env_msg
        env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="<b> WELCOME TO BOT $nameStore</b>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n\n"
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$env_msg" \
            --reply_markup "$keyboard1" \
            --parse_mode html
        return 0
    }
    if [[ "$(grep -w "${message_from_id}" $User_Active | grep -wc 'reseller')" != '0' ]]; then
        _SaldoTotal=$(grep -w 'Saldo_Reseller' /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id} | awk '{print $NF}')
        local env_msg
        env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="<b> WELCOME TO BOT $nameStore</b>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="ðŸ’²Price List :ðŸ’²\n"
        env_msg+="<code>SSH            : $hargassh\n"
        env_msg+="VMess          : $hargavmess\n"
        env_msg+="VLess          : $hargavless\n"
        env_msg+="Trojan         : $hargatrojan\n"
        env_msg+="Trojan-Go      : $hargatrgo\n"
        env_msg+="Wireguard      : $hargawg\n"
        env_msg+="Shadowsocks    : $hargass\n"
        env_msg+="Shadowsocks-R  : $hargassr\n"
        env_msg+="SSTP           : $hargasstp\n"
        env_msg+="PPTP           : $hargapptp\n"
        env_msg+="L2TP           : $hargal2tp\n"
        env_msg+="XRAY           : $hargaxray</code>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="ðŸ¤µ Admin Panel : $admin_bot_panel ðŸ¤µ\n"
        env_msg+="ðŸ’¡ Limit Trial : $_limTotal users ðŸ’¡\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="ðŸ’° Current Balance : $_SaldoTotal ðŸ’°\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n\n"
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$env_msg" \
            --reply_markup "$menu_re_main_updater1" \
            --parse_mode html
        return 0
    else
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
            --text "===========================\nâ›” ACCESS DENIED â›”\n===========================\n\nfor register to be a reseller contact : $admin_bot_panel\n\n===========================\nBot Panel By : @KennXV\n===========================\n"
        return 0
    fi
}

menu_func_cb() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] && {
        local env_msg
        env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="<b> WELCOME TO BOT $nameStore</b>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n\n"
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "$env_msg" \
            --parse_mode html \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'menu')"
        return 0
    }
    if [[ "$(grep -w "${message_from_id}" $User_Active | grep -wc 'reseller')" != '0' ]]; then
        _SaldoTotal=$(grep -w 'Saldo_Reseller' /etc/.maAsiss/db_reseller/${callback_query_from_id}/${callback_query_from_id} | awk '{print $NF}')       

[[ ! -f "/etc/.maAsiss/update-info" ]] && {
   local env_msg
   env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
   env_msg+="<b> WELCOME TO BOT $nameStore</b>\n"
   env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n\n"
} || {
   inf=$(cat /etc/.maAsiss/update-info)
   local env_msg
   env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
   env_msg+="ðŸ· Information for reseller :\n\n"
   env_msg+="$inf\n\n"
   env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
}
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "$env_msg" \
            --parse_mode html \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'menu_re_main')"
        return 0
    else
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    fi
}

info_port() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        portssh=$(grep -w "OpenSSH" /root/log-install.txt | awk '{print $NF}')
        portsshws=$(grep -w "SSH Websocket" /root/log-install.txt | awk '{print $5,$6}')
        portovpn=$(grep -w " OpenVPN" /root/log-install.txt | awk '{print $4,$5,$6,$7,$8,$9,$10}')
        portssl=$(grep -w "Stunnel4" /root/log-install.txt | awk '{print $4,$5,$6,$7}')
        portdb=$(grep -w "Dropbear" /root/log-install.txt | awk '{print $4,$5,$6,$7}')
        portsqd=$(grep -w "Squid Proxy" /root/log-install.txt | awk '{print $5,$6}')
        portudpgw=$(grep -w "Badvpn" /root/log-install.txt | awk '{print $4}')
        portnginx=$(grep -w "Nginx" /root/log-install.txt | awk '{print $NF}')
        portwstls=$(grep -w "Vmess TLS" /root/log-install.txt | awk '{print $NF}')
        portws=$(grep -w "Vmess None TLS" /root/log-install.txt | awk '{print $NF}')
        portvlesstls=$(grep -w "Vless TLS" /root/log-install.txt | awk '{print $NF}')
        portvless=$(grep -w "Vless None TLS" /root/log-install.txt | awk '{print $NF}')
        porttr=$(grep -w "Trojan " /root/log-install.txt | awk '{print $NF}')
        porttrgo=$(grep -w "Trojan Go" /root/log-install.txt | awk '{print $NF}')
        portwg=$(grep -w "Wireguard" /root/log-install.txt | awk '{print $NF}')
        portsstp=$(grep -w "SSTP VPN" /root/log-install.txt | awk '{print $NF}')
        portl2tp=$(grep -w "L2TP/IPSEC VPN" /root/log-install.txt | awk '{print $NF}')
        portpptp=$(grep -w "PPTP VPN" /root/log-install.txt | awk '{print $NF}')
        portsstls=$(grep -w "SS-OBFS TLS" /root/log-install.txt | awk '{print $NF}')
        portss=$(grep -w "SS-OBFS HTTP" /root/log-install.txt | awk '{print $NF}')
        portssR=$(grep -w "Shadowsocks-R" /root/log-install.txt | awk '{print $NF}')
        OhpSSH=`cat /root/log-install.txt | grep -w "OHP SSH" | cut -d: -f2 | awk '{print $1}'`
        OhpDB=`cat /root/log-install.txt | grep -w "OHP DBear" | cut -d: -f2 | awk '{print $1}'`
        OhpOVPN=`cat /root/log-install.txt | grep -w "OHP OpenVPN" | cut -d: -f2 | awk '{print $1}'`
        wsssl=`cat /root/log-install.txt | grep -w "SSH SSL Websocket" | cut -d: -f2 | awk '{print $1}'`
                        
        local env_msg
        env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="OpenSSH : $portssh\n"
        env_msg+="SSH-WS : $portsshws\n"
        env_msg+="SSH-WS-SSL : $wsssl\n"
        env_msg+="OHP SSH : $OhpSSH\n"
        env_msg+="OHP Dropbear : $OhpDB\n"
        env_msg+="OHP OpenVPN : $OhpOVPN\n"
        env_msg+="OpenVPN : $portovpn\n"
        env_msg+="Stunnel : $portssl\n"
        env_msg+="Dropbear : $portdb\n"
        env_msg+="Squid Proxy : $portsqd\n"
        env_msg+="Badvpn : $portudpgw\n"
        env_msg+="Nginx : $portnginx\n"
        env_msg+="Vmess TLS : $portwstls\n"
        env_msg+="Vmess HTTP : $portws\n"
        env_msg+="Vless TLS : $portvlesstls\n"
        env_msg+="Vless HTTP : $portvless\n"
        env_msg+="Trojan : $porttr\n"
        env_msg+="Trojan-GO : $porttrgo\n"
        env_msg+="Wireguard : $portwg\n"
        env_msg+="SSTP VPN: $portsstp\n"
        env_msg+="L2TP VPN : $portl2tp\n"
        env_msg+="PPTP VPN : $portpptp\n"
        env_msg+="SS-OBFS TLS : $portsstls\n"
        env_msg+="SS-OBFS HTTP : $portss\n"
        env_msg+="Shadowsocks-R : $portssR\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "$env_msg" \
            --parse_mode html \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'back_menu')"
        return 0
    } || {
  ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
         --text "â›” ACCESS DENIED â›”"
         return 0
  }
}

admin_price_see() {
hargassh=$(grep -w "Price SSH" /etc/.maAsiss/price | awk '{print $NF}')
hargavmess=$(grep -w "Price VMess" /etc/.maAsiss/price | awk '{print $NF}')
hargavless=$(grep -w "Price VLess" /etc/.maAsiss/price | awk '{print $NF}')
hargatrojan=$(grep -w "Price Trojan :" /etc/.maAsiss/price | awk '{print $NF}')
hargatrgo=$(grep -w "Price Trojan-GO" /etc/.maAsiss/price | awk '{print $NF}')
hargawg=$(grep -w "Price Wireguard" /etc/.maAsiss/price | awk '{print $NF}')
hargass=$(grep -w "Price Shadowsocks :" /etc/.maAsiss/price | awk '{print $NF}')
hargassr=$(grep -w "Price Shadowsocks-R" /etc/.maAsiss/price | awk '{print $NF}')
hargasstp=$(grep -w "Price SSTP" /etc/.maAsiss/price | awk '{print $NF}')
hargal2tp=$(grep -w "Price L2TP" /etc/.maAsiss/price | awk '{print $NF}')
hargapptp=$(grep -w "Price PPTP" /etc/.maAsiss/price | awk '{print $NF}')
hargaxray=$(grep -w "Price Xray" /etc/.maAsiss/price | awk '{print $NF}')

[[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        local env_msg
        env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="ðŸ’²Price List :ðŸ’²\n"
        env_msg+="<code>SSH            : $hargassh\n"
        env_msg+="VMess          : $hargavmess\n"
        env_msg+="VLess          : $hargavless\n"
        env_msg+="Trojan         : $hargatrojan\n"
        env_msg+="Trojan-Go      : $hargatrgo\n"
        env_msg+="Wireguard      : $hargawg\n"
        env_msg+="Shadowsocks    : $hargass\n"
        env_msg+="Shadowsocks-R  : $hargassr\n"
        env_msg+="SSTP           : $hargasstp\n"
        env_msg+="PPTP           : $hargapptp\n"
        env_msg+="L2TP           : $hargal2tp\n"
        env_msg+="XRAY           : $hargal2tp</code>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "$env_msg" \
            --parse_mode html \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'back_menu_admin')"
        return 0
    } || {
  ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
         --text "â›” ACCESS DENIED â›”"
         return 0
  }
}

admin_service_see() {
[[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        local env_msg
        env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="<b> WELCOME TO BOT $nameStore</b>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "$env_msg" \
            --parse_mode html \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'menu_adm_ser')"
        return 0
    } || {
  ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
         --text "â›” ACCESS DENIED â›”"
         return 0
  }
}

menu_reserv() {
        stsSSH=$(grep -w "SSH" /etc/.maAsiss/.cache/StatusDisable | awk '{print $NF}')
        stsVMESS=$(grep -w "VMESS" /etc/.maAsiss/.cache/StatusDisable | awk '{print $NF}')
        stsVLESS=$(grep -w "VLESS" /etc/.maAsiss/.cache/StatusDisable | awk '{print $NF}')
        stsTROJAN=$(grep -w "TROJAN :" /etc/.maAsiss/.cache/StatusDisable | awk '{print $NF}')
        stsTROJANGO=$(grep -w "TROJAN-GO" /etc/.maAsiss/.cache/StatusDisable | awk '{print $NF}')
        stsWG=$(grep -w "WIREGUARD" /etc/.maAsiss/.cache/StatusDisable | awk '{print $NF}')
        stsSS=$(grep -w "SHADOWSOCK:" /etc/.maAsiss/.cache/StatusDisable | awk '{print $NF}')
        stsSSR=$(grep -w "SHADOWSOCKS-R" /etc/.maAsiss/.cache/StatusDisable | awk '{print $NF}')
        local env_msg
        env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="<b> WELCOME TO BOT $nameStore</b>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="ðŸŸ¢ Status Order : \n\n"
        env_msg+="<code>SSH            : $stsSSH\n"
        env_msg+="VMess          : $stsVMESS\n"
        env_msg+="VLess          : $stsVLESS\n"
        env_msg+="Trojan         : $stsTROJAN\n"
        env_msg+="Trojan-Go      : $stsTROJANGO\n"
        env_msg+="Wireguard      : $stsWG\n"
        env_msg+="Shadowsocks    : $stsSS\n"
        env_msg+="Shadowsocks-R  : $stsSSR</code>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

[[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "$env_msg" \
            --parse_mode html \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'menu_re_ser')"
        return 0
    } || {
  ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
         --text "â›” ACCESS DENIED â›”"
         return 0
  }
}

status_order() {
        stsSSH=$(grep -w "SSH" /etc/.maAsiss/.cache/StatusDisable | awk '{print $NF}')
        stsVMESS=$(grep -w "VMESS" /etc/.maAsiss/.cache/StatusDisable | awk '{print $NF}')
        stsVLESS=$(grep -w "VLESS" /etc/.maAsiss/.cache/StatusDisable | awk '{print $NF}')
        stsTROJAN=$(grep -w "TROJAN :" /etc/.maAsiss/.cache/StatusDisable | awk '{print $NF}')
        stsTROJANGO=$(grep -w "TROJAN-GO" /etc/.maAsiss/.cache/StatusDisable | awk '{print $NF}')
        stsWG=$(grep -w "WIREGUARD" /etc/.maAsiss/.cache/StatusDisable | awk '{print $NF}')
        stsSS=$(grep -w "SHADOWSOCK:" /etc/.maAsiss/.cache/StatusDisable | awk '{print $NF}')
        stsSSR=$(grep -w "SHADOWSOCKS-R" /etc/.maAsiss/.cache/StatusDisable | awk '{print $NF}')
        local env_msg
        env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="<b> WELCOME TO BOT $nameStore</b>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="ðŸŸ¢ Status Order : \n\n"
        env_msg+="<code>SSH            : $stsSSH\n"
        env_msg+="VMess          : $stsVMESS\n"
        env_msg+="VLess          : $stsVLESS\n"
        env_msg+="Trojan         : $stsTROJAN\n"
        env_msg+="Trojan-Go      : $stsTROJANGO\n"
        env_msg+="Wireguard      : $stsWG\n"
        env_msg+="Shadowsocks    : $stsSS\n"
        env_msg+="Shadowsocks-R  : $stsSSR</code>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "$env_msg" \
            --parse_mode html \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'status_disable')" \
        return 0
    } || {
  ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
         --text "â›” ACCESS DENIED â›”"
         return 0
  }
}

how_to_order() {
        local env_msg
        env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="<b> WELCOME TO BOT $nameStore</b>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="ðŸ’¡ How to use : [code] \n\n"
        env_msg+="<code>SSH            : ssh\n"
        env_msg+="VMess          : vmess\n"
        env_msg+="VLess          : vless\n"
        env_msg+="Trojan         : trojan\n"
        env_msg+="Trojan-Go      : trgo\n"
        env_msg+="Wireguard      : wg\n"
        env_msg+="Shadowsocks    : ss\n"
        env_msg+="Shadowsocks-R  : ssr</code>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="usage: /disable[space][code]\n"
        env_msg+="example: <code>/disable ssh</code>\n\n"
        env_msg+="note: you can use multiple args\n"
        env_msg+="example: <code>/disable ssh ssr trojan trgo</code>\n\n"
        env_msg+="usage: /disable[space][off] to turn off\n"
        env_msg+="example: <code>/disable off</code>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "$env_msg" \
            --parse_mode html \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'status_how_to')" \
        return 0
    } || {
  ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
         --text "â›” ACCESS DENIED â›”"
         return 0
  }
}

see_log() {
    beha=$(cat /etc/.maAsiss/log_res)
        local env_msg
        env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="<code>$beha</code>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
    [[ "$(cat /etc/.maAsiss/log_res | wc -l)" = '0' ]] && {
    ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
         --text "â›” No Information Available â›”"
         return 0
    } || {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "$env_msg" \
            --parse_mode html \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'back_menu_admin')" \
        return 0
    }
  } || {
  ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
         --text "â›” ACCESS DENIED â›”"
         return 0
  }
}

res_opener() {
[[ ! -f "/etc/.maAsiss/update-info" ]] && {
   local env_msg
   env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
   env_msg+="<b> WELCOME TO BOT $nameStore</b>\n"
   env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n\n"
} || {
   inf=$(cat /etc/.maAsiss/update-info)
   local env_msg
   env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
   env_msg+="ðŸ· Information for reseller :\n\n"
   env_msg+="$inf\n\n"
   env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
}

    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "$env_msg" \
            --parse_mode html \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'menu_re_main')"
        return 0
    } || {
    ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
         --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

res_closer() {
hargassh=$(grep -w "Price SSH" /etc/.maAsiss/price | awk '{print $NF}')
hargavmess=$(grep -w "Price VMess" /etc/.maAsiss/price | awk '{print $NF}')
hargavless=$(grep -w "Price VLess" /etc/.maAsiss/price | awk '{print $NF}')
hargatrojan=$(grep -w "Price Trojan :" /etc/.maAsiss/price | awk '{print $NF}')
hargatrgo=$(grep -w "Price Trojan-GO" /etc/.maAsiss/price | awk '{print $NF}')
hargawg=$(grep -w "Price Wireguard" /etc/.maAsiss/price | awk '{print $NF}')
hargass=$(grep -w "Price Shadowsocks :" /etc/.maAsiss/price | awk '{print $NF}')
hargassr=$(grep -w "Price Shadowsocks-R" /etc/.maAsiss/price | awk '{print $NF}')
hargasstp=$(grep -w "Price SSTP" /etc/.maAsiss/price | awk '{print $NF}')
hargal2tp=$(grep -w "Price L2TP" /etc/.maAsiss/price | awk '{print $NF}')
hargapptp=$(grep -w "Price PPTP" /etc/.maAsiss/price | awk '{print $NF}')
hargaxray=$(grep -w "Price Xray" /etc/.maAsiss/price | awk '{print $NF}')

    if [[ "$(grep -w "${message_from_id}" $User_Active | grep -wc 'reseller')" != '0' ]]; then
        _SaldoTotal=$(grep -w 'Saldo_Reseller' /etc/.maAsiss/db_reseller/${callback_query_from_id}/${callback_query_from_id} | awk '{print $NF}')       
        local env_msg
        env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="<b> WELCOME TO BOT $nameStore</b>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="ðŸ’²Price List :ðŸ’²\n"
        env_msg+="<code>SSH            : $hargassh\n"
        env_msg+="VMess          : $hargavmess\n"
        env_msg+="VLess          : $hargavless\n"
        env_msg+="Trojan         : $hargatrojan\n"
        env_msg+="XRAY           : $hargaxray</code>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="ðŸ¤µ Admin Panel : $admin_bot_panel ðŸ¤µ\n"
        env_msg+="ðŸ’¡ Limit Trial : $_limTotal usersðŸ’¡\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="ðŸ’° Current Balance : $_SaldoTotal ðŸ’°\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n\n"
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "$env_msg" \
            --parse_mode html \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'menu_re_main_updater')"
        return 0
    else
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
         --text "â›” ACCESS DENIED â›”"
        return 0
    fi
}

user_already_exist() {
    userna=$1
   if [[ "${message_from_id[$id]}" = "$Admin_ID" ]]; then
        datata=$(find /etc/.maAsiss/ -name $userna | sort | uniq | wc -l)
        for accc in "${datata[@]}"
        do
             _resl=$accc
        done  
        _results=$(echo $_resl)
    elif [[ "${message_from_id[$id]}" != "$Admin_ID" ]]; then
        datata=$(find /etc/.maAsiss/ -name $userna | sort | uniq | wc -l)
        for accc in "${datata[@]}"
        do
             _resl=$accc
        done  
        _results=$(echo $_resl)
      fi
      [[ "$_results" != "0" ]] && {
         ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "â›” User $userna already exist , try other username " \
                --parse_mode html
         ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                --text "Func Error Do Nothing" \
                --reply_markup "$(ShellBot.ForceReply)"
         return 0
      }   
}

adduser_ssh() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ‘¤ CREATE USER ðŸ‘¤\n\nUsername:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

cret_user() {
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    [[ -f /etc/.maAsiss/.cache/DisableOrderSSH ]] && {
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "â›” Disable Order SSH" \
                --parse_mode html
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
               --text "Func Error Do Nothing" \
               --reply_markup "$(ShellBot.ForceReply)"
        return 0
    }
}
    file_user=$1
    userna=$(sed -n '1 p' $file_user | cut -d' ' -f2)
    passw=$(sed -n '2 p' $file_user | cut -d' ' -f2)
    data=$(sed -n '3 p' $file_user | cut -d' ' -f2)
    exp=$(echo "$data" | awk -F'/' '{print $2FS$1FS$3}' | xargs -i date -d'{}' +%Y-%m-%d)

    if /usr/sbin/useradd -M -N -s /bin/false $userna -e $exp; then
        (echo "${passw}";echo "${passw}") | passwd "${userna}"
    else
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "â›” ERROR CREATING USER" \
                --parse_mode html
        return 0
    fi
    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
        pricessh=$(grep -w "Price SSH" /etc/.maAsiss/price | awk '{print $NF}')
        saldores=$(grep -w "Saldo_Reseller" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id} | awk '{print $NF}')
        if [ "$saldores" -lt "$pricessh" ]; then
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "â›” Your Balance Not Enough" \
                --parse_mode html
            return 0
        else
            echo "$userna:$passw:$info_data" >/etc/.maAsiss/db_reseller/${message_from_id}/user_by_res/$userna
            echo "$userna:$passw:$info_data" >/etc/.maAsiss/info-users/$userna
            _CurrSal=$(echo $saldores - $pricessh | bc)
            sed -i "/Saldo_Reseller/c\Saldo_Reseller: $_CurrSal" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id}
            sed -i "/${message_from_id}/c\USER: ${message_from_id} SALDO: $_CurrSal TYPE: reseller" $User_Active
            echo "$userna:$passw 30Days SSH | ${message_from_username}" >> /etc/.maAsiss/log_res
        fi
    }
}

2month_user() {
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    [[ -f /etc/.maAsiss/.cache/DisableOrderSSH ]] && {
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "â›” Disable Order SSH" \
                --parse_mode html
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
               --text "Func Error Do Nothing" \
               --reply_markup "$(ShellBot.ForceReply)"
        return 0
    }
}
    file_user=$1
    userna=$(sed -n '1 p' $file_user | cut -d' ' -f2)
    passw=$(sed -n '2 p' $file_user | cut -d' ' -f2)
    data=$(sed -n '3 p' $file_user | cut -d' ' -f2)
    exp=$(echo "$data" | awk -F'/' '{print $2FS$1FS$3}' | xargs -i date -d'{}' +%Y-%m-%d)
   
     if /usr/sbin/useradd -M -N -s /bin/false $userna -e $exp; then
        (echo "${passw}";echo "${passw}") | passwd "${userna}"
    else
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "$(echo -e "â›” ERROR CREATING USER")" \
                --parse_mode html
        return 0
    fi

    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
        pricessh=$(grep -w "Price SSH" /etc/.maAsiss/price | awk '{print $NF}')
        saldores=$(grep -w "Saldo_Reseller" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id} | awk '{print $NF}')
        urday=$(echo $pricessh * 2 | bc)
        if [ "$saldores" -lt "$urday" ]; then
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "â›” Your Balance Not Enough " \
                --parse_mode html
            return 0
        else
            echo "$userna:$passw:$info_data" >/etc/.maAsiss/db_reseller/${message_from_id}/user_by_res/$userna
            echo "$userna:$passw:$info_data" >/etc/.maAsiss/info-users/$userna
            _CurrSal=$(echo $saldores - $urday | bc)
            sed -i "/Saldo_Reseller/c\Saldo_Reseller: $_CurrSal" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id}
            sed -i "/${message_from_id}/c\USER: ${message_from_id} SALDO: $_CurrSal TYPE: reseller" $User_Active
            echo "$userna:$passw 60Days SSH | ${message_from_username}" >> /etc/.maAsiss/log_res
        fi
    }
}

del_ssh() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ—‘ REMOVE USER ðŸ—‘\n\nUsername:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

func_del_ssh() {
    userna=$1
    [[ "${message_from_id[$id]}" = "$Admin_ID" ]] && {
        userdel --force "$userna" 2>/dev/null
        kill-by-user $userna
rm /root/login-db.txt > /dev/null 2>&1
rm /root/login-db-pid.txt > /dev/null 2>&1
    } || {
        [[ ! -e /etc/.maAsiss/db_reseller/${message_from_id}/user_by_res/$userna ]] && {
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "$(echo -e "â›” THE USER DOES NOT EXIST â›”")" \
                --parse_mode html
            _erro='1'
            return 0
        }
        userdel --force "$userna" 2>/dev/null
        rm /etc/.maAsiss/db_reseller/${message_from_id}/user_by_res/$userna
        rm /etc/.maAsiss/info-users/$userna
        kill-by-user $userna
        
rm /root/login-db.txt > /dev/null 2>&1
rm /root/login-db-pid.txt > /dev/null 2>&1
    }
}

info_users_ssh() {
    if [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]]; then
        arq_info=/tmp/$(echo $RANDOM)
        fun_infu() {
            local info
            for user in $(cat /etc/passwd | awk -F : '$3 >= 1000 {print $1}' | grep -v nobody); do
                info='â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n'
                datauser=$(chage -l $user | grep -i co | awk -F : '{print $2}')
                [[ $datauser = ' never' ]] && {
                    data="Never"
                } || {
                    databr="$(date -d "$datauser" +"%Y%m%d")"
                    hoje="$(date -d today +"%Y%m%d")"
                    [[ $hoje -ge $databr ]] && {
                        data="Expired"
                    } || {
                        dat="$(date -d"$datauser" '+%Y-%m-%d')"
                        data=$(echo -e "$((($(date -ud $dat +%s) - $(date -ud $(date +%Y-%m-%d) +%s)) / 86400)) Days")
                    }
                }
                info+="$user â€¢ $data"
                echo -e "$info"
            done
        }
        fun_infu >$arq_info
        while :; do
            ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
            ShellBot.sendMessage --chat_id $Admin_ID \
                --text "$(while read line; do echo $line; done < <(sed '1,30!d' $arq_info))" \
                --parse_mode html
            sed -i 1,30d $arq_info
            [[ $(cat $arq_info | wc -l) = '0' ]] && rm $arq_info && break
        done
    elif [[ "$(grep -wc "${callback_query_from_id}" $User_Active)" != '0' ]]; then
        [[ $(ls /etc/.maAsiss/db_reseller/${callback_query_from_id}/user_by_res | wc -l) == '0' ]] && {
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "YOU HAVE NOT CREATED A USER YET!"
            return 0
        }
        arq_info=/tmp/$(echo $RANDOM)
        fun_infu() {
            local info
            for user in $(ls /etc/.maAsiss/db_reseller/${callback_query_from_id}/user_by_res); do
                info='â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n'
                datauser=$(chage -l $user | grep -i co | awk -F : '{print $2}')
                [[ $datauser = ' never' ]] && {
                    data="Never"
                } || {
                    databr="$(date -d "$datauser" +"%Y%m%d")"
                    hoje="$(date -d today +"%Y%m%d")"
                    [[ $hoje -ge $databr ]] && {
                        data="Expired"
                    } || {
                        dat="$(date -d"$datauser" '+%Y-%m-%d')"
                        data=$(echo -e "$((($(date -ud $dat +%s) - $(date -ud $(date +%Y-%m-%d) +%s)) / 86400)) Days")
                    }
                }
                info+="$user â€¢ $data"
                echo -e "$info"
            done
        }
        fun_infu >$arq_info
        while :; do
            ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                --text "$(while read line; do echo $line; done < <(sed '1,30!d' $arq_info))" \
                --parse_mode html
            sed -i 1,30d $arq_info
            [[ $(cat $arq_info | wc -l) = '0' ]] && rm $arq_info && break
        done
    else
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    fi
}

renew_ssh() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "â³ Renew SSH â³\n\nUsername:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

func_renew_ssh() {
    userna=$1
    inputdate=$2
    if [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]]; then
        [[ "$(echo -e "$inputdate" | sed -e 's/[^/]//ig')" != '//' ]] && {
            udata=$(date "+%d/%m/%Y" -d "+$inputdate days")
            sysdate="$(echo "$udata" | awk -v FS=/ -v OFS=- '{print $3,$2,$1}')"
        } || {
            udata=$(echo -e "$inputdate")
            sysdate="$(echo -e "$inputdate" | awk -v FS=/ -v OFS=- '{print $3,$2,$1}')"
            today="$(date -d today +"%Y%m%d")"
            timemachine="$(date -d "$sysdate" +"%Y%m%d")"
            [ $today -ge $timemachine ] && {
                verify='1'
                ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                    --text "â›” Date Invalid" \
                    --parse_mode html
                _erro='1'
                return 0
            }
        }
        chage -E $sysdate $userna
        [[ -e /etc/.maAsiss/db_reseller/${message_from_id}/user_by_res/$userna ]] && {
            data2=$(cat /etc/.maAsiss/info-users/$userna | awk -F : {'print $3'})
            sed -i "s;$data2;$udata;" /etc/.maAsiss/info-users/$userna
            echo $userna $udata ${message_from_id}
            sed -i "s;$data2;$udata;" /etc/.maAsiss/db_reseller/${message_from_id}/user_by_res/$userna
        }
    elif [[ "$(grep -wc "${callback_query_from_id}" $User_Active)" != '0' ]]; then
        [[ "$(echo -e "$inputdate" | sed -e 's/[^/]//ig')" != '//' ]] && {
            udata=$(date "+%d/%m/%Y" -d "+$inputdate days")
            sysdate="$(echo "$udata" | awk -v FS=/ -v OFS=- '{print $3,$2,$1}')"
         } || {
            udata=$(echo -e "$inputdate")
            sysdate="$(echo -e "$inputdate" | awk -v FS=/ -v OFS=- '{print $3,$2,$1}')"
            today="$(date -d today +"%Y%m%d")"
            timemachine="$(date -d "$sysdate" +"%Y%m%d")"
            [ $today -ge $timemachine ] && {
                verify='1'
                ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                    --text "â›” Date Invalid" \
                    --parse_mode html
                _erro='1'
                return 0
            }
         }
         chage -E $sysdate $userna
         [[ -e /etc/.maAsiss/db_reseller/${message_from_id}/user_by_res/$userna ]] && {
            pricessh=$(grep -w "Price SSH" /etc/.maAsiss/price | awk '{print $NF}')
            saldores=$(grep -w "Saldo_Reseller" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id} | awk '{print $NF}')
            if [ "$saldores" -lt "$pricessh" ]; then
                ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                    --text "â›” Your Balance Not Enough â›”" \
                    --parse_mode html
                return 0
            else
                data2=$(cat /etc/bot/info-users/$userna | awk -F : {'print $3'})
                sed -i "s;$data2;$udata;" /etc/.maAsiss/info-users/$userna
                echo $userna $udata ${message_from_id}
                sed -i "s;$data2;$udata;" /etc/.maAsiss/db_reseller/${message_from_id}/user_by_res/$userna
                _CurrSal=$(echo $saldores - $pricessh | bc)
                sed -i "/Saldo_Reseller/c\Saldo_Reseller: $_CurrSal" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id}
                sed -i "/${message_from_id}/c\USER: ${message_from_id} SALDO: $_CurrSal TYPE: reseller" $User_Active
            fi
         }
    else
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    fi
}

add_ssh_trial() {
    if [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]]; then
        ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ‘¤ CREATE TRIAL SSH ðŸ‘¤\n\nHow many hours should it last ? EX: 1:" \
            --reply_markup "$(ShellBot.ForceReply)"
    elif [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]]; then
            ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                --text "ðŸ‘¤ CREATE TRIAL SSH ðŸ‘¤\n\nHow many hours should it last ? EX: 1:" \
                --reply_markup "$(ShellBot.ForceReply)"       
    else
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    fi
}

func_add_ssh_trial() {
    mkdir -p /etc/.maAsiss/info-users
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    [[ -f /etc/.maAsiss/.cache/DisableOrderSSH ]] && {
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "â›” Disable Order SSH" \
                --parse_mode html
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
               --text "Func Error Do Nothing" \
               --reply_markup "$(ShellBot.ForceReply)"
        return 0
    }
}
    userna=$(echo Trial`</dev/urandom tr -dc A-Z0-9 | head -c4`)
    password='1'
    t_time=$1
    ex_date=$(date '+%d/%m/%C%y' -d " +2 days")
    tuserdate=$(date '+%C%y/%m/%d' -d " +2 days")
    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    mkdir -p /etc/.maAsiss/db_reseller/${message_from_id}/trial-fold
    }
    [[ -z $t_time ]] && {
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
            --text "$(echo -e "â›” error try again")" \
            --parse_mode html
        return 0
        _erro='1'
    }
    /usr/sbin/useradd -M -N -s /bin/false $userna -e $tuserdate >/dev/null 2>&1
    (
        echo "$password"
        echo "$password"
    ) | passwd $userna >/dev/null 2>&1
    echo "$password" >/etc/.maAsiss/$userna
    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
        echo "$userna:$password:$ex_date" >/etc/.maAsiss/db_reseller/${message_from_id}/user_by_res/$userna
        echo "$userna:$password:$ex_date" >/etc/.maAsiss/db_reseller/${message_from_id}/trial-fold/$userna
    }
dir_teste="/etc/.maAsiss/db_reseller/${message_from_id}/user_by_res/$userna"
dir_teste2="/etc/.maAsiss/db_reseller/${message_from_id}/trial-fold/$userna"
dates=`date`
cat <<-EOF >/etc/.maAsiss/$userna.sh
#!/bin/bash
# USER TRIAL SSH by ${message_from_id} $dates
kill-by-user $userna
userdel --force $userna
[[ -e $dir_teste ]] && rm $dir_teste
[[ -e $dir_teste2 ]] && rm $dir_teste2

rm /root/login-db.txt > /dev/null 2>&1
rm /root/login-db-pid.txt > /dev/null 2>&1
rm -f /etc/.maAsiss/$userna
rm -f /etc/.maAsiss/$userna.sh
EOF
    chmod +x /etc/.maAsiss/$userna.sh
    echo "/etc/.maAsiss/$userna.sh" | at now + $t_time hour >/dev/null 2>&1
    [[ "$t_time" == '1' ]] && hrs="hour" || hrs="hours"
        ossl=`cat /root/log-install.txt | grep -w " OpenVPN" | cut -f2 -d: | awk '{print $6}'`
        opensh=`cat /root/log-install.txt | grep -w "OpenSSH" | cut -f2 -d: | awk '{print $1}'`
        db=`cat /root/log-install.txt | grep -w "Dropbear" | cut -f2 -d: | awk '{print $1,$2}'`
        ssl="$(cat /root/log-install.txt | grep -w "Stunnel4" | cut -d: -f2)"
        sqd="$(cat /root/log-install.txt | grep -w "Squid" | cut -d: -f2)"
        ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
        ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
        portsshws=`cat /root/log-install.txt | grep -w "SSH Websocket" | cut -d: -f2 | awk '{print $1}'`
        wsssl=`cat /root/log-install.txt | grep -w "SSH SSL Websocket" | cut -d: -f2 | awk '{print $1}'`
        OhpSSH=`cat /root/log-install.txt | grep -w "OHP SSH" | cut -d: -f2 | awk '{print $1}'`
        OhpDB=`cat /root/log-install.txt | grep -w "OHP DBear" | cut -d: -f2 | awk '{print $1}'`
        OhpOVPN=`cat /root/log-install.txt | grep -w "OHP OpenVPN" | cut -d: -f2 | awk '{print $1}'`

        local env_msg
        env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>    ðŸ”¸ TRIAL SSH ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="Host : $IPs \n"
        env_msg+="Username: <code>$userna</code>\n"
        env_msg+="Password: 1\n"
        env_msg+="Expired On: $t_time $hrs â³\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="OpenSSH : $opensh\n"
        env_msg+="Dropbear : $db\n"
        env_msg+="SSH-WS : 80\n"
        env_msg+="SSH-WS-SSL : 443\n"
        env_msg+="SSL/TLS : $ssl\n"
        env_msg+="UDPGW : 7100-7300 \n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="OpenVPN Config : http://$IPs:81/\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="Payload WS : \n\n"
        env_msg+="<code>GET / HTTP/1.1[crlf]Host: $IPs [crlf]Upgrade: websocket[crlf][crlf]</code>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
            --text "$env_msg" \
            --parse_mode html
        return 0
}

fun_drop() {
    port_dropbear=$(ps aux | grep dropbear | awk NR==1 | awk '{print $17;}')
    log=/var/log/auth.log
    loginsukses='Password auth succeeded'
    pids=$(ps ax | grep dropbear | grep " $port_dropbear" | awk -F" " '{print $1}')
    for pid in $pids; do
        pidlogs=$(grep $pid $log | grep "$loginsukses" | awk -F" " '{print $3}')
        i=0
        for pidend in $pidlogs; do
            let i=i+1
        done
        if [ $pidend ]; then
            login=$(grep $pid $log | grep "$pidend" | grep "$loginsukses")
            PID=$pid
            user=$(echo $login | awk -F" " '{print $10}' | sed -r "s/'/ /g")
            waktu=$(echo $login | awk -F" " '{print $2"-"$1,$3}')
            while [ ${#waktu} -lt 13 ]; do
                waktu=$waktu" "
            done
            while [ ${#user} -lt 16 ]; do
                user=$user" "
            done
            while [ ${#PID} -lt 8 ]; do
                PID=$PID" "
            done
            echo "$user $PID $waktu"
        fi
    done
}

user_online_ssh() {
    if [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]]; then
        cad_onli=/tmp/$(echo $RANDOM)
        fun_online() {
            local info2
            for user in $(cat /etc/passwd | awk -F : '$3 >= 1000 {print $1}' | grep -v nobody); do
                [[ $(netstat -nltp | grep 'dropbear' | wc -l) != '0' ]] && drop="$(fun_drop | grep "$user" | wc -l)" || drop=0
                [[ -e /etc/openvpn/openvpn-status.log ]] && ovp="$(cat /etc/openvpn/openvpn-status.log | grep -E ,"$user", | wc -l)" || ovp=0
                sqd="$(ps -u $user | grep sshd | wc -l)"
                _cont=$(($drop + $ovp))
                conex=$(($_cont + $sqd))
                [[ $conex -gt '0' ]] && {
                    timerr="$(ps -o etime $(ps -u $user | grep sshd | awk 'NR==1 {print $1}') | awk 'NR==2 {print $1}')"
                    info2+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
                    info2+="<code>ðŸŸ¢ $user      âƒ£ $conex      â³ $timerr</code>\n"
                }
            done
            echo -e "$info2"
        }
        fun_online >$cad_onli
        [[ $(cat $cad_onli | wc -w) != '0' ]] && {
            while :; do
                ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
                     --message_id ${callback_query_message_message_id[$id]}
                ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                    --text "$(while read line; do echo $line; done < <(sed '1,30!d' $cad_onli))" \
                    --parse_mode html
                sed -i 1,30d $cad_onli
                [[ "$(cat $cad_onli | wc -l)" = '0' ]] && {
                    rm $cad_onli
                    break
                }
            done
        } || {
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "No users online" \
                --parse_mode html
            return 0
        }
    elif [[ "$(grep -wc "${callback_query_from_id}" $User_Active)" != '0' ]]; then
        [[ $(ls /etc/.maAsiss/db_reseller/${callback_query_from_id}/user_by_res | wc -l) == '0' ]] && {
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "YOU HAVE NOT CREATED A USER YET!"
            return 0
        }
        cad_onli=/tmp/$(echo $RANDOM)
        fun_online() {
            local info2
            for user in $(ls /etc/.maAsiss/db_reseller/${callback_query_from_id}/user_by_res); do
                [[ $(netstat -nltp | grep 'dropbear' | wc -l) != '0' ]] && drop="$(fun_drop | grep "$user" | wc -l)" || drop=0
                [[ -e /etc/openvpn/openvpn-status.log ]] && ovp="$(cat /etc/openvpn/openvpn-status.log | grep -E ,"$user", | wc -l)" || ovp=0
                sqd="$(ps -u $user | grep sshd | wc -l)"
                conex=$(($sqd + $ovp + $drop))
                [[ $conex -gt '0' ]] && {
                    timerr="$(ps -o etime $(ps -u $user | grep sshd | awk 'NR==1 {print $1}') | awk 'NR==2 {print $1}')"
                    info2+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
                    info2+="<code>ðŸ‘¤ $user      âƒ£ $conex      â³ $timerr</code>\n"
                }
            done
            echo -e "$info2"
        }
        fun_online >$cad_onli
        [[ $(cat $cad_onli | wc -w) != '0' ]] && {
            while :; do
                ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
                    --message_id ${callback_query_message_message_id[$id]}
                ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                    --text "<code>$(while read line; do echo $line; done < <(sed '1,30!d' $cad_onli))</code>" \
                    --parse_mode html
                sed -i 1,30d $cad_onli
                [[ "$(cat $cad_onli | wc -l)" = '0' ]] && {
                    rm $cad_onli
                    break
                }
            done
        } || {
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                --text "No users online" \
                --parse_mode html
            return 0
        }
    else
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    fi
}

Saldo_CheckerSSH() {
    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
        pricessh=$(grep -w "Price SSH" /etc/.maAsiss/price | awk '{print $NF}')
        saldores=$(grep -w "Saldo_Reseller" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id} | awk '{print $NF}')
        if [ "$saldores" -lt "$pricessh" ]; then
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "â›” Your Balance Not Enough â›”" \
                --parse_mode html
            _erro="1"
            return 0
        else
            echo
        fi
    }
}

Saldo_CheckerSSH2Month() {
    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
        pricessh=$(grep -w "Price SSH" /etc/.maAsiss/price | awk '{print $NF}')
        saldores=$(grep -w "Saldo_Reseller" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id} | awk '{print $NF}')
        urday=$(echo $pricessh * 2 | bc)
        if [ "$saldores" -lt "$urday" ]; then
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "â›” Your Balance Not Enough â›”" \
                --parse_mode html
            _erro="1"
            return 0
        else
            echo
        fi
    }
}

verifica_acesso() {
    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
        [[ "$(grep -wc ${message_from_id} $User_Active)" == '0' ]] && {
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "WTF !! Whooo Are You ???")" \
                            --parse_mode html
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
            return 0
        }
    }
}

ssh_menus() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "SELECT AN OPTION BELOW:" \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'menu1')"
        return 0
    }
}

add_res(){
        gg=$(cat $Res_Token | awk '{print $2}')
        local env_msg
        env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="<b> List name reseller</b>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="<code>$gg</code>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
                --message_id ${callback_query_message_message_id[$id]} \
                --text "$env_msg" \
                --parse_mode html 
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ‘¥ ADD Reseller ðŸ‘¥\n\nEnter the name:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

cret_res() {
    file_res=$1
    [[ -z "$file_res" ]] && {
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
            --text "$(echo -e Error)"
        _erro='1'
        break
    }
    name_res=$(sed -n '1 p' $file_res | cut -d' ' -f2)
    uname_res=$(sed -n '2 p' $file_res | cut -d' ' -f2)
    saldo_res=$(sed -n '3 p' $file_res | cut -d' ' -f2)
    [[ "${message_from_id[$id]}" = "$Admin_ID" ]] && {
        t_res='reseller'
    }
    Token=$(cat /tmp/scvpsss)
    mkdir -p /etc/.maAsiss/db_reseller/"$uname_res"
    mkdir -p /etc/.maAsiss/db_reseller/"$uname_res"/user_by_res
    mkdir -p /etc/.maAsiss/db_reseller/"$uname_res"/trial-fold
    mkdir -p /etc/.maAsiss/db_reseller/"$uname_res"/user_ray
    mkdir -p /etc/.maAsiss/db_reseller/"$uname_res"/user_vless
    mkdir -p /etc/.maAsiss/db_reseller/"$uname_res"/user_trojan
    mkdir -p /etc/.maAsiss/db_reseller/"$uname_res"/user_wg
    mkdir -p /etc/.maAsiss/db_reseller/"$uname_res"/user_ss
    mkdir -p /etc/.maAsiss/db_reseller/"$uname_res"/user_ssr
    mkdir -p /etc/.maAsiss/db_reseller/"$uname_res"/user_sstp
    mkdir -p /etc/.maAsiss/db_reseller/"$uname_res"/user_l2tp
    mkdir -p /etc/.maAsiss/db_reseller/"$uname_res"/user_pptp
    mkdir -p /etc/.maAsiss/db_reseller/"$uname_res"/user_trgo
    mkdir -p /etc/.maAsiss/db_reseller/"$uname_res"/user_xray
    touch /etc/.maAsiss/db_reseller/"$uname_res"/$uname_res
    echo -e "USER: $uname_res SALDO: $saldo_res TYPE: $t_res" >>$User_Active
    echo -e "Name: $name_res TOKEN: $Token" >> $Res_Token
    echo -e "=========================\nSaldo_Reseller: $saldo_res\n=========================\n" >/etc/.maAsiss/db_reseller/"$uname_res"/$uname_res
    sed -i '$d' $file_res
    
    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
           --text "âœ… Successfully Added Reseller. âœ…\n\n<b>Name </b>: $name_res\n<b>Token </b>: $Token\n<b>Saldo </b>: $saldo_res\n\n<b>BOT </b>: @${message_reply_to_message_from_username}" \
           --parse_mode html
    return 0
}

del_res() {
    gg=$(cat $Res_Token | awk '{print $2}')
        local env_msg
        env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="<b> List name reseller</b>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="<code>$gg</code>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
                --message_id ${callback_query_message_message_id[$id]} \
                --text "$env_msg" \
                --parse_mode html 
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ—‘ REMOVE Reseller ðŸ—‘\n\nInput Name of Reseller:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

func_del_res() {
    _cli_rev=$1
    [[ -z "$_cli_rev" ]] && {
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
            --text "$(echo -e "Error")"
        return 0
    }
    cek_res_token=$(grep -w "$_cli_rev" "$Res_Token" | awk '{print $NF}' | sed -e 's/[^0-9]//ig'| rev)
    [[ "${message_from_id[$id]}" == "$Admin_ID" ]] && {
        [[ "$(grep -wc "$cek_res_token" $User_Active)" != '0' ]] && {
            [[ -e "/etc/.maAsiss/db_reseller/$cek_res_token/$cek_res_token" ]] && _dirsts='db_reseller' || _dirsts='suspensos'
            [[ "$(ls /etc/.maAsiss/$_dirsts/$cek_res_token/user_by_res | wc -l)" != '0' ]] && {
                for _user in $(ls /etc/.maAsiss/$_dirsts/$cek_res_token/user_by_res); do
                    userdel --force "$_user" 2>/dev/null
                    kill-by-user $_user
                done
            }
            
            rm /root/login-db.txt > /dev/null 2>&1
            rm /root/login-db-pid.txt > /dev/null 2>&1
            sed -i "/\b$_cli_rev\b/d" $Res_Token
            [[ -d /etc/.maAsiss/$_dirsts/$cek_res_token ]] && rm -rf /etc/.maAsiss/$_dirsts/$cek_res_token >/dev/null 2>&1
            sed -i "/\b$cek_res_token\b/d" $User_Active
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "$(echo -e "âœ… SUCCESSFULLY REMOVED âœ…")" \
                --parse_mode html
            return 0
        } || {
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "$(echo -e â›” Reseller DOES NOT EXIST â›”)"
            return 0
        }
    }
}

reset_saldo_res() {
    gg=$(cat $Res_Token | awk '{print $2}')
        local env_msg
        env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="<b> List </b>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="<code>$gg</code>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
                --message_id ${callback_query_message_message_id[$id]} \
                --text "$env_msg" \
                --parse_mode html 
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸŒ€ Reset Saldo Reseller ðŸŒ€\n\nInput Name of Reseller:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

func_reset_saldo_res() {
    _cli_rev=$(cat /tmp/resSaldo | awk '{print $NF}' | sed -e 's/[^0-9]//ig'| rev)
    [[ -z "$_cli_rev" ]] && {
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
            --text "$(echo -e "Error")"
        return 0
    }
    cek_res_token=$(grep -ow "$_cli_rev" "$User_Active")
    [[ "${message_from_id[$id]}" == "$Admin_ID" ]] && {
       [[ "$(grep -wc "$cek_res_token" $User_Active)" != '0' ]] && {
            sed -i "/Saldo_Reseller/c\Saldo_Reseller: 0" /etc/.maAsiss/db_reseller/"$cek_res_token"/$cek_res_token
            sed -i "/$cek_res_token/c\USER: $cek_res_token SALDO: 0 TYPE: reseller" $User_Active
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "$(echo -e "âœ… Succesfully Reset Saldo 0 âœ…")" \
                --parse_mode html
            rm -f /tmp/resSaldo
            return 0
    
    } || {
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
            --text "$(echo -e â›” Reseller DOES NOT EXIST â›”)"
        return 0
    }
  }
}

# {name0}](tg://user?id={uid})
func_list_res() {
    if [[ "${callback_query_from_id[$id]}" = "$Admin_ID" ]]; then
        local msg1
        msg1="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\nðŸ“ƒ List Reseller !\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        cek_res_token=$(cat $Res_Token | awk '{print $NF}' | sed -e 's/[^0-9]//ig'| rev)
        gg=$(cat $Res_Token | awk '{print $NF}')
        [[ "$(cat /etc/.maAsiss/res_token | wc -l)" != '0' ]] && {
            while read _atvs; do
                _uativ="$(echo $_atvs | awk '{print $2}')"
                _cursald="$(echo $_atvs | awk '{print $4}')"
                msg1+="â€¢ [Reseller](tg://user?id=$_uativ) | â€¢ $_cursald \n"
            done <<<"$(grep -w "$cek_res_token" "$User_Active")"
            ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
                --message_id ${callback_query_message_message_id[$id]} \
                --text "$(echo -e "$msg1")" \
                --parse_mode markdown \
                --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'list_bck_adm')" \
            return 0
        } || {
            ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "YOU DO NOT HAVE RESELLERS"
            return 0
        }
    else
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    fi
}

topup_res() {
        gg=$(cat $Res_Token | awk '{print $2}')
        local env_msg
        env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="<b> List name reseller</b>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="<code>$gg</code>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
                --message_id ${callback_query_message_message_id[$id]} \
                --text "$env_msg" \
                --parse_mode html 
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ’¸ Topup Saldo ðŸ’¸\n\nName reseller:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

func_topup_res() {
    userna=$1
    saldo=$2
    _SaldoTotal=$(grep -w 'Saldo_Reseller' /etc/.maAsiss/db_reseller/$userna/$userna | awk '{print $NF}')
    _TopUpSal=$(echo $_SaldoTotal + $saldo | bc)
    sed -i "/Saldo_Reseller/c\Saldo_Reseller: $_TopUpSal" /etc/.maAsiss/db_reseller/$userna/$userna
    sed -i "/$userna/c\USER: $userna SALDO: $_TopUpSal TYPE: reseller" $User_Active
}

func_verif_limite_res() {
    userna=$1
    [[ "$(grep -w "$userna" $User_Active | awk '{print $NF}')" == 'reseller' ]] && {
        echo $_userrev
        _result=$(ls /etc/.maAsiss/db_reseller/$userna/trial-fold | wc -l)       
    }
}

func_limit_publik() {
   getMes=$1
   getLimits=$(grep -w "MAX_USERS" "/etc/.maAsiss/public_mode/settings" | awk '{print $NF}')
   _result=$(ls /etc/.maAsiss/public_mode/$getMes | wc -l)
   [[ ! -d /etc/.maAsiss/public_mode ]] && {
       ShellBot.sendMessage --chat_id ${callback_query_from_id[$id]} \
                    --text "â›” Public mode is off" \
                    --parse_mode html
                ShellBot.sendMessage --chat_id
                return 0
   }
   _result2=$(ls /etc/.maAsiss/public_mode --ignore='settings' | wc -l)
   [[ "${callback_query_from_id[$id]}" != "$Admin_ID" ]] && {
       [[ "$_result2" -ge "$getLimits" ]] && {
            ShellBot.sendMessage --chat_id ${callback_query_from_id[$id]} \
                    --text "â›” Max $getLimits Users" \
                    --parse_mode html
                ShellBot.sendMessage --chat_id
                return 0
       }
       [[ "$_result" -ge "1" ]] && {
            ShellBot.sendMessage --chat_id ${callback_query_from_id[$id]} \
                    --text "â›” Max Limit Create only 1 Users" \
                    --parse_mode html
                ShellBot.sendMessage --chat_id
                return 0
       }
   }
}

res_ssh_menu() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "SELECT AN OPTION BELOW:" \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'menu_re')"
        return 0
    }
}

unset menu_re
menu_re=''
ShellBot.InlineKeyboardButton --button 'menu_re' --line 1 --text 'âž• Add SSH âž•' --callback_data '_add_res_ssh'
ShellBot.InlineKeyboardButton --button 'menu_re' --line 2 --text 'ðŸŸ¢ List Member SSH ðŸŸ¢' --callback_data '_member_res_ssh'
ShellBot.InlineKeyboardButton --button 'menu_re' --line 3 --text 'â³ Create Trial SSH â³' --callback_data '_trial_res_ssh'
ShellBot.InlineKeyboardButton --button 'menu_re' --line 4 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_goback'
ShellBot.regHandleFunction --function adduser_ssh --callback_data _add_res_ssh
ShellBot.regHandleFunction --function info_users_ssh --callback_data _member_res_ssh
ShellBot.regHandleFunction --function add_ssh_trial --callback_data _trial_res_ssh
ShellBot.regHandleFunction --function menu_reserv --callback_data _goback
unset menu_re1
menu_re1="$(ShellBot.InlineKeyboardMarkup -b 'menu_re')"

unset menu1
menu1=''
ShellBot.InlineKeyboardButton --button 'menu1' --line 1 --text 'Add SSH' --callback_data '_add_ssh'
ShellBot.InlineKeyboardButton --button 'menu1' --line 1 --text 'Del SSH' --callback_data '_del_ssh'
ShellBot.InlineKeyboardButton --button 'menu1' --line 2 --text 'Renew SSH' --callback_data '_renew_ssh'
ShellBot.InlineKeyboardButton --button 'menu1' --line 3 --text 'Member SSH' --callback_data '_member_ssh'
ShellBot.InlineKeyboardButton --button 'menu1' --line 3 --text 'User Online' --callback_data '_online_ssh'
ShellBot.InlineKeyboardButton --button 'menu1' --line 4 --text 'Create Trial SSH' --callback_data '_trial_ssh'
ShellBot.InlineKeyboardButton --button 'menu1' --line 5 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_goback1'
ShellBot.regHandleFunction --function adduser_ssh --callback_data _add_ssh
ShellBot.regHandleFunction --function del_ssh --callback_data _del_ssh
ShellBot.regHandleFunction --function renew_ssh --callback_data _renew_ssh
ShellBot.regHandleFunction --function info_users_ssh --callback_data _member_ssh
ShellBot.regHandleFunction --function user_online_ssh --callback_data _online_ssh
ShellBot.regHandleFunction --function add_ssh_trial --callback_data _trial_ssh
ShellBot.regHandleFunction --function admin_service_see --callback_data _goback1
unset keyboard2
keyboard2="$(ShellBot.InlineKeyboardMarkup -b 'menu1')"


#====== ALL ABOUT V2RAY =======#

res_v2ray_menus() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "SELECT AN OPTION BELOW:" \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'res_menu_vray')"
        return 0
    }
}
v2ray_menus() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "SELECT AN OPTION BELOW:" \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'menu_vray')"
        return 0
    }
}

add_ray() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ‘¤ CREATE USER VMess ðŸ‘¤\n\nUsername:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

func_add_ray() {
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    [[ -f /etc/.maAsiss/.cache/DisableOrderVMESS ]] && {
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                    --text "â›” Disable Order VMESS" \
                    --parse_mode html
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                   --text "Func Error Do Nothing" \
                   --reply_markup "$(ShellBot.ForceReply)"
            return 0
    }
}

file_user=$1
userna=$(sed -n '1 p' $file_user | cut -d' ' -f2)
data=$(sed -n '2 p' $file_user | cut -d' ' -f2)
exp=$(echo "$data" | awk -F'/' '{print $2FS$1FS$3}' | xargs -i date -d'{}' +%Y-%m-%d)
        
domain=$(cat /etc/$raycheck/domain)
tls="$(cat /root/log-install.txt | grep -w "Vmess TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat /root/log-install.txt | grep -w "Vmess None TLS" | cut -d: -f2|sed 's/ //g')"

[[ "${message_from_id[$id]}" = "$Admin_ID" ]] && {
mkdir -p /etc/.maAsiss/info-user-v2ray
echo "$userna:$data" >/etc/.maAsiss/info-user-v2ray/$userna
uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#vmess$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$userna""'"' /etc/xray/config.json
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmessgrpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$userna""'"' /etc/xray/config.json
            
asu=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmess",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF`
ask=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "80",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmess",
      "type": "none",
      "host": "",
      "tls": "none"
}
EOF`
grpc=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "grpc",
      "path": "vmess-grpc",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF`
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmess_base643=$( base64 -w 0 <<< $vmess_json3)
vmesslink1="vmess://$(echo $asu | base64 -w 0)"
vmesslink2="vmess://$(echo $ask | base64 -w 0)"
vmesslink3="vmess://$(echo $grpc | base64 -w 0)"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>      ðŸ”¸ VMESS ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Domain : $domain\n"
env_msg+="Remarks : $userna\n"
env_msg+="Expired On : $data ðŸ“†\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port TLS : 443\n"
env_msg+="Port None TLS : 80\n"
env_msg+="ID : $uuid\n"
env_msg+="AlterID : 0\n"
env_msg+="Security : auto\n"
env_msg+="Network : websocket/ws\n"
env_msg+="Path : /vmess\n"
env_msg+="ServiceName : vmess-grpc\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link TLS : \n<code>$vmesslink1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link None TLS : \n<code>$vmesslink2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link GRPC : \n<code>$vmesslink3</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"


ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
systemctl restart xray > /dev/null 2>&1
return 0
}

pricevmess=$(grep -w "Price VMess" /etc/.maAsiss/price | awk '{print $NF}')
saldores=$(grep -w "Saldo_Reseller" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id} | awk '{print $NF}')
if [ "$saldores" -lt "$pricevmess" ]; then
ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "â›” Your Balance Not Enough â›”" \
    --parse_mode html
return 0
else
mkdir -p /etc/.maAsiss/info-user-v2ray
mkdir -p /etc/.maAsiss/db_reseller/${message_from_id}/user_ray
echo "$userna:$data" >/etc/.maAsiss/db_reseller/${message_from_id}/user_ray/$userna
echo "$userna:$data" >/etc/.maAsiss/info-user-v2ray/$userna
_CurrSal=$(echo $saldores - $pricevmess | bc)
sed -i "/Saldo_Reseller/c\Saldo_Reseller: $_CurrSal" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id}
sed -i "/${message_from_id}/c\USER: ${message_from_id} SALDO: $_CurrSal TYPE: reseller" $User_Active
            
uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#vmess$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$userna""'"' /etc/xray/config.json
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmessgrpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$userna""'"' /etc/xray/config.json
            
asu=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmess",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF`
ask=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "80",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmess",
      "type": "none",
      "host": "",
      "tls": "none"
}
EOF`
grpc=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "grpc",
      "path": "vmess-grpc",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF`
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmess_base643=$( base64 -w 0 <<< $vmess_json3)
vmesslink1="vmess://$(echo $asu | base64 -w 0)"
vmesslink2="vmess://$(echo $ask | base64 -w 0)"
vmesslink3="vmess://$(echo $grpc | base64 -w 0)"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>      ðŸ”¸ VMESS ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Domain : $domain\n"
env_msg+="Remarks : $userna\n"
env_msg+="Expired On : $data ðŸ“†\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port TLS : 443\n"
env_msg+="Port None TLS : 80\n"
env_msg+="ID : $uuid\n"
env_msg+="AlterID : 0\n"
env_msg+="Security : auto\n"
env_msg+="Network : websocket/ws\n"
env_msg+="Path : /vmess\n"
env_msg+="ServiceName : vmess-grpc\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link TLS : \n<code>$vmesslink1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link None TLS : \n<code>$vmesslink2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link GRPC : \n<code>$vmesslink3</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
echo "$userna 30Days VMESS | ${message_from_username}" >> /etc/.maAsiss/log_res

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
systemctl restart $raycheck > /dev/null 2>&1
return 0
fi
}

func_add_ray2() {
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    [[ -f /etc/.maAsiss/.cache/DisableOrderVMESS ]] && {
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                    --text "â›” Disable Order VMESS" \
                    --parse_mode html
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                   --text "Func Error Do Nothing" \
                   --reply_markup "$(ShellBot.ForceReply)"
            return 0
    }
}
file_user=$1
userna=$(sed -n '1 p' $file_user | cut -d' ' -f2)
data=$(sed -n '2 p' $file_user | cut -d' ' -f2)
exp=$(echo "$data" | awk -F'/' '{print $2FS$1FS$3}' | xargs -i date -d'{}' +%Y-%m-%d)
        
domain=$(cat /etc/$raycheck/domain)
tls="$(cat /root/log-install.txt | grep -w "Vmess TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat /root/log-install.txt | grep -w "Vmess None TLS" | cut -d: -f2|sed 's/ //g')"

[[ "${message_from_id[$id]}" = "$Admin_ID" ]] && {
mkdir -p /etc/.maAsiss/info-user-v2ray
echo "$userna:$data" >/etc/.maAsiss/info-user-v2ray/$userna
uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#vmess$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$userna""'"' /etc/xray/config.json
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmessgrpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$userna""'"' /etc/xray/config.json
            
asu=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmess",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF`
ask=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "80",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmess",
      "type": "none",
      "host": "",
      "tls": "none"
}
EOF`
grpc=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "grpc",
      "path": "vmess-grpc",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF`
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmess_base643=$( base64 -w 0 <<< $vmess_json3)
vmesslink1="vmess://$(echo $asu | base64 -w 0)"
vmesslink2="vmess://$(echo $ask | base64 -w 0)"
vmesslink3="vmess://$(echo $grpc | base64 -w 0)"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>      ðŸ”¸ VMESS ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Domain : $domain\n"
env_msg+="Remarks : $userna\n"
env_msg+="Expired On : $data ðŸ“†\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port TLS : 443\n"
env_msg+="Port None TLS : 80\n"
env_msg+="ID : $uuid\n"
env_msg+="AlterID : 0\n"
env_msg+="Security : auto\n"
env_msg+="Network : websocket/ws\n"
env_msg+="Path : /vmess\n"
env_msg+="ServiceName : vmess-grpc\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link TLS : \n<code>$vmesslink1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link None TLS : \n<code>$vmesslink2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link GRPC : \n<code>$vmesslink3</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
systemctl restart xray > /dev/null 2>&1
return 0
}

pricevmess=$(grep -w "Price VMess" /etc/.maAsiss/price | awk '{print $NF}')
saldores=$(grep -w "Saldo_Reseller" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id} | awk '{print $NF}')
urday=$(echo $pricevmess * 2 | bc)
if [ "$saldores" -lt "$urday" ]; then
ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "â›” Your Balance Not Enough â›”" \
    --parse_mode html
return 0
else
mkdir -p /etc/.maAsiss/info-user-v2ray
mkdir -p /etc/.maAsiss/db_reseller/${message_from_id}/user_ray
echo "$userna:$data" >/etc/.maAsiss/db_reseller/${message_from_id}/user_ray/$userna
echo "$userna:$data" >/etc/.maAsiss/info-user-v2ray/$userna
_CurrSal=$(echo $saldores - $urday | bc)
sed -i "/Saldo_Reseller/c\Saldo_Reseller: $_CurrSal" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id}
sed -i "/${message_from_id}/c\USER: ${message_from_id} SALDO: $_CurrSal TYPE: reseller" $User_Active
            
uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#vmess$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$userna""'"' /etc/xray/config.json
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmessgrpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$userna""'"' /etc/xray/config.json
            
asu=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmess",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF`
ask=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "80",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmess",
      "type": "none",
      "host": "",
      "tls": "none"
}
EOF`
grpc=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "grpc",
      "path": "vmess-grpc",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF`
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmess_base643=$( base64 -w 0 <<< $vmess_json3)
vmesslink1="vmess://$(echo $asu | base64 -w 0)"
vmesslink2="vmess://$(echo $ask | base64 -w 0)"
vmesslink3="vmess://$(echo $grpc | base64 -w 0)"
systemctl restart xray > /dev/null 2>&1

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>      ðŸ”¸ VMESS ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Domain : $domain\n"
env_msg+="Remarks : $userna\n"
env_msg+="Expired On : $data ðŸ“†\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port TLS : 443\n"
env_msg+="Port None TLS : 80\n"
env_msg+="ID : $uuid\n"
env_msg+="AlterID : 0\n"
env_msg+="Security : auto\n"
env_msg+="Network : websocket/ws\n"
env_msg+="Path : /vmess\n"
env_msg+="ServiceName : vmess-grpc\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link TLS : \n<code>$vmesslink1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link None TLS : \n<code>$vmesslink2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link GRPC : \n<code>$vmesslink3</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
echo "$userna 60Days VMESS | ${message_from_username}" >> /etc/.maAsiss/log_res

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
return 0
fi
}

del_ray() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ—‘ REMOVE USER V2RAY ðŸ—‘\n\nUsername:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

func_del_ray() {
    userna=$1
    [[ "${message_from_id[$id]}" = "$Admin_ID" ]] && {
        exp=$(grep -wE "^### $userna" "/etc/$raycheck/config.json" | cut -d ' ' -f 3 | sort | uniq)
        sed -i "/^### $userna $exp/,/^},{/d" /etc/$raycheck/config.json
        datata=$(find /etc/.maAsiss/ -name $userna)
        for accc in "${datata[@]}"
        do
        rm $accc
        done
        systemctl restart $raycheck > /dev/null 2>&1
    } || {
        [[ ! -e /etc/.maAsiss/db_reseller/${message_from_id}/user_ray/$userna ]] && {
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "$(echo -e "â›” THE USER DOES NOT EXIST â›”")" \
                --parse_mode html
            _erro='1'      
            ShellBot.sendMessage --chat_id ${callack_query_message_chat_id[$id]} \
                 --text "Func Error Do Nothing" \
                 --reply_markup "$(ShellBot.ForceReply)"
            return 0
        }
        exp=$(grep -wE "^### $userna" "/etc/$raycheck/config.json" | cut -d ' ' -f 3 | sort | uniq)
        sed -i "/^### $userna $exp/,/^},{/d" /etc/$raycheck/config.json
        rm /etc/.maAsiss/db_reseller/${message_from_id}/user_ray/$userna
        rm /etc/.maAsiss/info-user-v2ray/$userna
        systemctl restart $raycheck > /dev/null 2>&1
    }
}

add_ray_trial() {
    if [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]]; then
        ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ‘¤ CREATE TRIAL VMess ðŸ‘¤\n\nHow many hours should it last ? EX: 1:" \
            --reply_markup "$(ShellBot.ForceReply)"
    elif [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]]; then
            ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                --text "ðŸ‘¤ CREATE TRIAL VMess ðŸ‘¤\n\nHow many hours should it last ? EX: 1:" \
                --reply_markup "$(ShellBot.ForceReply)"       
    else
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    fi
}

func_add_ray_trial() {
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    [[ -f /etc/.maAsiss/.cache/DisableOrderVMESS ]] && {
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                    --text "â›” Disable Order VMESS" \
                    --parse_mode html
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                   --text "Func Error Do Nothing" \
                   --reply_markup "$(ShellBot.ForceReply)"
            return 0
    }
}
    mkdir -p /etc/.maAsiss/info-user-v2ray
    userna=$(echo Trial`</dev/urandom tr -dc A-Z0-9 | head -c4`)
    t_time=$1
    domain=$(cat /etc/$raycheck/domain)
    tls="$(cat /root/log-install.txt | grep -w "Vmess TLS" | cut -d: -f2|sed 's/ //g')"
    none="$(cat /root/log-install.txt | grep -w "Vmess None TLS" | cut -d: -f2|sed 's/ //g')"

    exp=`date -d "2 days" +"%Y-%m-%d"`
    tuserdate=$(date '+%C%y/%m/%d' -d " +2 days")
    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
       mkdir -p /etc/.maAsiss/db_reseller/${message_from_id}/trial-fold
    }
    [[ -z $t_time ]] && {
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
            --text "$(echo -e "â›” error try again")" \
            --parse_mode html
        return 0
        _erro='1'
    }

echo "$userna:$exp" >/etc/.maAsiss/info-user-v2ray/$userna
uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#vmess$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$userna""'"' /etc/xray/config.json
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmessgrpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$userna""'"' /etc/xray/config.json
            
asu=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmess",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF`
ask=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "80",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmess",
      "type": "none",
      "host": "",
      "tls": "none"
}
EOF`
grpc=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "grpc",
      "path": "vmess-grpc",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF`
  
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    echo "$userna:$exp" >/etc/.maAsiss/db_reseller/${message_from_id}/user_ray/$userna
    echo "$userna:$exp" >/etc/.maAsiss/db_reseller/${message_from_id}/trial-fold/$userna
}
dir_teste="/etc/.maAsiss/db_reseller/${message_from_id}/user_ray/$userna"
dir_teste2="/etc/.maAsiss/db_reseller/${message_from_id}/trial-fold/$userna"
dates=`date`
cat <<-EOF >/etc/.maAsiss/$userna.sh
#!/bin/bash
# USER TRIAL VMESS by ${message_from_id} $dates
exp=\$(grep -wE "^### $userna" "/etc/$raycheck/config.json" | cut -d ' ' -f 3 | sort | uniq)
sed -i "/^### $userna $exp/,/^},{/d" /etc/$raycheck/config.json
systemctl restart $raycheck > /dev/null 2>&1
rm /etc/.maAsiss/db_reseller/${message_from_id}/user_ray/$userna
rm /etc/.maAsiss/info-user-v2ray/$userna
[[ -e $dir_teste ]] && rm $dir_teste
[[ -e $dir_teste2 ]] && rm $dir_teste2
rm -f /etc/.maAsiss/$userna
rm -f /etc/.maAsiss/$userna.sh
EOF
chmod +x /etc/.maAsiss/$userna.sh
echo "/etc/.maAsiss/$userna.sh" | at now + $t_time hour >/dev/null 2>&1
[[ "$t_time" == '1' ]] && hrs="hour" || hrs="hours"          
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmess_base643=$( base64 -w 0 <<< $vmess_json3)
vmesslink1="vmess://$(echo $asu | base64 -w 0)"
vmesslink2="vmess://$(echo $ask | base64 -w 0)"
vmesslink3="vmess://$(echo $grpc | base64 -w 0)"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>      ðŸ”¸ VMESS ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Domain : $domain\n"
env_msg+="Remarks : $userna\n"
env_msg+="Expired On : $data ðŸ“†\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port TLS : 443\n"
env_msg+="Port None TLS : 80\n"
env_msg+="ID : $uuid\n"
env_msg+="AlterID : 0\n"
env_msg+="Security : auto\n"
env_msg+="Network : websocket/ws\n"
env_msg+="Path : /vmess\n"
env_msg+="ServiceName : vmess-grpc\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link TLS : \n<code>$vmesslink1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link None TLS : \n<code>$vmesslink2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link GRPC : \n<code>$vmesslink3</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
systemctl restart xray > /dev/null 2>&1
return 0

}

list_member_ray() {
   if [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]]; then
      _result=$(grep -E "^### " "/etc/$raycheck/config.json" | cut -d ' ' -f 2 | column -t | sort | uniq | wc -l)
      _results=$(grep -E "^### " "/etc/$raycheck/config.json" | cut -d ' ' -f 2 | column -t | sort | uniq )
   elif [[ "${callback_query_from_id[$id]}" != "$Admin_ID" ]]; then
      _result=$(ls /etc/.maAsiss/db_reseller/${callback_query_from_id}/user_ray | wc -l)
      _results=$(ls /etc/.maAsiss/db_reseller/${callback_query_from_id}/user_ray )
   else
      ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "â›” ACCESS DENIED â›”" \
                --parse_mode html
      return 0
   fi
   if [ "$_result" = "0" ]; then
      ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "â›” YOU DONT HAVE ANY USER YET â›”" \
                --parse_mode html
      return 0
   else
      ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
      ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
         --text "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n ðŸ VMESS MEMBER LIST ðŸ \nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n\n$_results\n\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n" \
         --parse_mode html
      return 0
   fi
}

check_login_ray(){
if [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]]; then
echo -n > /tmp/other.txt
data=( `cat /etc/xray/config.json | grep '^###' | cut -d ' ' -f 2 | sort | uniq`);

echo -e "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”" > /tmp/vmess-login
echo -e "         ðŸŸ¢ Vmess User Login ðŸŸ¢  " >> /tmp/vmess-login
echo -e "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”" >> /tmp/vmess-login

for akun in "${data[@]}"
do
if [[ -z "$akun" ]]; then
akun="tidakada"
fi

echo -n > /tmp/ipvmess.txt
data2=( `netstat -anp | grep ESTABLISHED | grep tcp6 | grep $raycheck | awk '{print $5}' | cut -d: -f1 | sort | uniq`);
for ip in "${data2[@]}"
do

jum=$(cat /var/log/$raycheck/access.log | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip | sort | uniq)
if [[ "$jum" = "$ip" ]]; then
echo "$jum" >> /tmp/ipvmess.txt
else
echo "$ip" >> /tmp/other.txt
fi
jum2=$(cat /tmp/ipvmess.txt)
sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
done

jum=$(cat /tmp/ipvmess.txt)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
jum2=$(cat /tmp/ipvmess.txt | nl)
echo "user : $akun" >> /tmp/vmess-login
echo "$jum2" >> /tmp/vmess-login
echo -e "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”" >> /tmp/vmess-login
fi
rm -rf /tmp/ipvmess.txt
done

oth=$(cat /tmp/other.txt | sort | uniq | nl)
echo "other" >> /tmp/vmess-login
echo "$oth" >> /tmp/vmess-login
echo -e "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”" >> /tmp/vmess-login
rm -rf /tmp/other.txt
msg=$(cat /tmp/vmess-login)
cekk=$(cat /tmp/vmess-login | wc -l)
if [ "$cekk" = "0" ] || [ "$cekk" = "6" ]; then
ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "â›” NO USERS ONLINE â›”" \
                --parse_mode html
rm /tmp/vmess-login
return 0
else
ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
         --text "$msg" \
         --parse_mode html
rm /tmp/vmess-login
return 0
fi
else
ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "â›” ACCESS DENIED â›”" \
                --parse_mode html
return 0
fi
}

unset menu_vray
menu_vray=''
ShellBot.InlineKeyboardButton --button 'menu_vray' --line 1 --text 'Add VMess' --callback_data '_add_ray'
ShellBot.InlineKeyboardButton --button 'menu_vray' --line 2 --text 'Delete VMess' --callback_data '_del_ray'
ShellBot.InlineKeyboardButton --button 'menu_vray' --line 3 --text 'Create Trial VMess' --callback_data '_trial_ray'
ShellBot.InlineKeyboardButton --button 'menu_vray' --line 4 --text 'List Member VMess' --callback_data '_list_ray'
ShellBot.InlineKeyboardButton --button 'menu_vray' --line 5 --text 'Check User Login VMess' --callback_data '_login_ray'
ShellBot.InlineKeyboardButton --button 'menu_vray' --line 6 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_gobackray'
ShellBot.regHandleFunction --function add_ray --callback_data _add_ray
ShellBot.regHandleFunction --function del_ray --callback_data _del_ray
ShellBot.regHandleFunction --function add_ray_trial --callback_data _trial_ray
ShellBot.regHandleFunction --function list_member_ray --callback_data _list_ray
ShellBot.regHandleFunction --function check_login_ray --callback_data _login_ray
ShellBot.regHandleFunction --function admin_service_see --callback_data _gobackray
unset keyboardray
keyboardray="$(ShellBot.InlineKeyboardMarkup -b 'menu_vray')"

unset res_menu_vray
res_menu_vray=''
ShellBot.InlineKeyboardButton --button 'res_menu_vray' --line 1 --text 'âž• Add VMess âž•' --callback_data '_res_add_ray'
ShellBot.InlineKeyboardButton --button 'res_menu_vray' --line 2 --text 'â³ Create Trial VMess â³' --callback_data '_res_trial_ray'
ShellBot.InlineKeyboardButton --button 'res_menu_vray' --line 3 --text 'ðŸŸ¢ List Member VMess ðŸŸ¢' --callback_data '_res_list_ray'
ShellBot.InlineKeyboardButton --button 'res_menu_vray' --line 4 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_res_gobackray'
ShellBot.regHandleFunction --function add_ray --callback_data _res_add_ray
ShellBot.regHandleFunction --function add_ray_trial --callback_data _res_trial_ray
ShellBot.regHandleFunction --function list_member_ray --callback_data _res_list_ray
ShellBot.regHandleFunction --function menu_reserv --callback_data _res_gobackray
unset keyboardrayres
keyboardrayres="$(ShellBot.InlineKeyboardMarkup -b 'res_menu_vray')"

#======= TROJAN MENU =========

res_trojan_menus() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "SELECT AN OPTION BELOW:" \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'res_menu_trojan')"
        return 0
    }
}
trojan_menus() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "SELECT AN OPTION BELOW:" \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'menu_trojan')"
        return 0
    }
}

add_trojan() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ‘¤ CREATE USER Trojan ðŸ‘¤\n\nUsername:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

func_add_trojan() {
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    [[ -f /etc/.maAsiss/.cache/DisableOrderTROJAN ]] && {
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "â›” Disable Order TROJAN" \
                --parse_mode html
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
               --text "Func Error Do Nothing" \
               --reply_markup "$(ShellBot.ForceReply)"
        return 0
    }
}

file_user=$1
userna=$(sed -n '1 p' $file_user | cut -d' ' -f2)
data=$(sed -n '2 p' $file_user | cut -d' ' -f2)
exp=$(echo "$data" | awk -F'/' '{print $2FS$1FS$3}' | xargs -i date -d'{}' +%Y-%m-%d)
        
domain=$(cat /etc/$raycheck/domain)
tr="$(cat /root/log-install.txt | grep -w "Trojan " | cut -d: -f2|sed 's/ //g')"

[[ "${message_from_id[$id]}" = "$Admin_ID" ]] && {
mkdir -p /etc/.maAsiss/info-user-trojan
echo "$userna:$data" >/etc/.maAsiss/info-user-trojan/$userna
uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#trojanws$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#trojangrpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#trojantcp$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#trojanxtls$/a\#&# '"$user $exp"'\
},{"password": "'""$uuid""'","flow": "'""xtls-rprx-direct""'","email": "'""$userna""'"' /etc/xray/config.json
trojanlink3="trojan://${uuid}@${domain}:${tr}?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=bug.com#${userna}"
trojanlink2="trojan://${uuid}@${domain}:${tr}?path=%2Ftrojan-ws&security=tls&host=bug.com&type=ws&sni=bug.com#${userna}"
trojanlink="trojan://${uuid}@${domain}:443#${userna}"
trojanlink1="trojan://${uuid}@${doman}:443?security=xtls&headerType=none&type=tcp&flow=xtls-rprx-direct&sni=bug.com#${userna}"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>     ðŸ”¸ TROJAN ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Domain : $domain\n"
env_msg+="Remarks : $userna\n"
env_msg+="Expired On : $data â³ \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port  : $tr\n"
env_msg+="Key : $uuid\n"
env_msg+="Path : /trojan-ws\n"
env_msg+="Flow : xtls-rprx-direct\n"
env_msg+="ServiceName : trojan-grpc\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link TCP: \n<code>$trojanlink</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link XTLS: \n<code>$trojanlink1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link WS: \n<code>$trojanlink2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link GRPC: \n<code>$trojanlink3</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
systemctl restart $raycheck > /dev/null 2>&1
return 0
}

pricetrojan=$(grep -w "Price Trojan :" /etc/.maAsiss/price | awk '{print $NF}')
saldores=$(grep -w "Saldo_Reseller" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id} | awk '{print $NF}')
if [ "$saldores" -lt "$pricetrojan" ]; then
ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "â›” Your Balance Not Enough â›”" \
    --parse_mode html
return 0
else
mkdir -p /etc/.maAsiss/info-user-trojan
mkdir -p /etc/.maAsiss/db_reseller/${message_from_id}/user_trojan
echo "$userna:$data" >/etc/.maAsiss/db_reseller/${message_from_id}/user_trojan/$userna
echo "$userna:$data" >/etc/.maAsiss/info-user-trojan/$userna
_CurrSal=$(echo $saldores - $pricetrojan | bc)
sed -i "/Saldo_Reseller/c\Saldo_Reseller: $_CurrSal" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id}
sed -i "/${message_from_id}/c\USER: ${message_from_id} SALDO: $_CurrSal TYPE: reseller" $User_Active

uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#trojanws$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#trojangrpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#trojantcp$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#trojanxtls$/a\#&# '"$user $exp"'\
},{"password": "'""$uuid""'","flow": "'""xtls-rprx-direct""'","email": "'""$userna""'"' /etc/xray/config.json
trojanlink3="trojan://${uuid}@${domain}:${tr}?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=bug.com#${userna}"
trojanlink2="trojan://${uuid}@${domain}:${tr}?path=%2Ftrojan-ws&security=tls&host=bug.com&type=ws&sni=bug.com#${userna}"
trojanlink="trojan://${uuid}@${domain}:443#${userna}"
trojanlink1="trojan://${uuid}@${doman}:443?security=xtls&headerType=none&type=tcp&flow=xtls-rprx-direct&sni=bug.com#${userna}"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>     ðŸ”¸ TROJAN ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Domain : $domain\n"
env_msg+="Remarks : $userna\n"
env_msg+="Expired On : $data â³ \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port  : $tr\n"
env_msg+="Key : $uuid\n"
env_msg+="Path : /trojan-ws\n"
env_msg+="Flow : xtls-rprx-direct\n"
env_msg+="ServiceName : trojan-grpc\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link TCP: \n<code>$trojanlink</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link XTLS: \n<code>$trojanlink1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link WS: \n<code>$trojanlink2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link GRPC: \n<code>$trojanlink3</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
echo "$userna 30Days TROJAN | ${message_from_username}" >> /etc/.maAsiss/log_res

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
systemctl restart $raycheck > /dev/null 2>&1
return 0
fi
}

func_add_trojan2() {
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    [[ -f /etc/.maAsiss/.cache/DisableOrderTROJAN ]] && {
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "â›” Disable Order TROJAN" \
                --parse_mode html
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
               --text "Func Error Do Nothing" \
               --reply_markup "$(ShellBot.ForceReply)"
        return 0
    }
}
file_user=$1
userna=$(sed -n '1 p' $file_user | cut -d' ' -f2)
data=$(sed -n '2 p' $file_user | cut -d' ' -f2)
exp=$(echo "$data" | awk -F'/' '{print $2FS$1FS$3}' | xargs -i date -d'{}' +%Y-%m-%d)
        
domain=$(cat /etc/$raycheck/domain)
tr="$(cat /root/log-install.txt | grep -w "Trojan " | cut -d: -f2|sed 's/ //g')"

[[ "${message_from_id[$id]}" = "$Admin_ID" ]] && {
mkdir -p /etc/.maAsiss/info-user-trojan
echo "$userna:$data" >/etc/.maAsiss/info-user-trojan/$userna

uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#trojanws$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#trojangrpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#trojantcp$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#trojanxtls$/a\#&# '"$user $exp"'\
},{"password": "'""$uuid""'","flow": "'""xtls-rprx-direct""'","email": "'""$userna""'"' /etc/xray/config.json
trojanlink3="trojan://${uuid}@${domain}:${tr}?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=bug.com#${userna}"
trojanlink2="trojan://${uuid}@${domain}:${tr}?path=%2Ftrojan-ws&security=tls&host=bug.com&type=ws&sni=bug.com#${userna}"
trojanlink="trojan://${uuid}@${domain}:443#${userna}"
trojanlink1="trojan://${uuid}@${doman}:443?security=xtls&headerType=none&type=tcp&flow=xtls-rprx-direct&sni=bug.com#${userna}"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>     ðŸ”¸ TROJAN ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Domain : $domain\n"
env_msg+="Remarks : $userna\n"
env_msg+="Expired On : $data â³ \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port  : $tr\n"
env_msg+="Key : $uuid\n"
env_msg+="Path : /trojan-ws\n"
env_msg+="Flow : xtls-rprx-direct\n"
env_msg+="ServiceName : trojan-grpc\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link TCP: \n<code>$trojanlink</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link XTLS: \n<code>$trojanlink1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link WS: \n<code>$trojanlink2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link GRPC: \n<code>$trojanlink3</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
systemctl restart $raycheck > /dev/null 2>&1
return 0
}

pricetrojan=$(grep -w "Price Trojan :" /etc/.maAsiss/price | awk '{print $NF}')
saldores=$(grep -w "Saldo_Reseller" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id} | awk '{print $NF}')
urday=$(echo $pricetrojan * 2 | bc)
if [ "$saldores" -lt "$urday" ]; then
ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "â›” Your Balance Not Enough â›”" \
    --parse_mode html
return 0
else
mkdir -p /etc/.maAsiss/info-user-trojan
mkdir -p /etc/.maAsiss/db_reseller/${message_from_id}/user_trojan
echo "$userna:$data" >/etc/.maAsiss/db_reseller/${message_from_id}/user_trojan/$userna
echo "$userna:$data" >/etc/.maAsiss/info-user-trojan/$userna
_CurrSal=$(echo $saldores - $urday | bc)
sed -i "/Saldo_Reseller/c\Saldo_Reseller: $_CurrSal" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id}
sed -i "/${message_from_id}/c\USER: ${message_from_id} SALDO: $_CurrSal TYPE: reseller" $User_Active
uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#trojanws$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#trojangrpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#trojantcp$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#trojanxtls$/a\#&# '"$user $exp"'\
},{"password": "'""$uuid""'","flow": "'""xtls-rprx-direct""'","email": "'""$userna""'"' /etc/xray/config.json
trojanlink3="trojan://${uuid}@${domain}:${tr}?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=bug.com#${userna}"
trojanlink2="trojan://${uuid}@${domain}:${tr}?path=%2Ftrojan-ws&security=tls&host=bug.com&type=ws&sni=bug.com#${userna}"
trojanlink="trojan://${uuid}@${domain}:443#${userna}"
trojanlink1="trojan://${uuid}@${doman}:443?security=xtls&headerType=none&type=tcp&flow=xtls-rprx-direct&sni=bug.com#${userna}"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>     ðŸ”¸ TROJAN ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Domain : $domain\n"
env_msg+="Remarks : $userna\n"
env_msg+="Expired On : $data â³ \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port  : $tr\n"
env_msg+="Key : $uuid\n"
env_msg+="Path : /trojan-ws\n"
env_msg+="Flow : xtls-rprx-direct\n"
env_msg+="ServiceName : trojan-grpc\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link TCP: \n<code>$trojanlink</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link XTLS: \n<code>$trojanlink1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link WS: \n<code>$trojanlink2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link GRPC: \n<code>$trojanlink3</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
echo "$userna 60Days TROJAN | ${message_from_username}" >> /etc/.maAsiss/log_res

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html

systemctl restart $raycheck > /dev/null 2>&1
return 0
fi
}

del_trojan() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ—‘ REMOVE USER TROJAN ðŸ—‘\n\nUsername:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

func_del_trojan() {
    userna=$1
    [[ "${message_from_id[$id]}" = "$Admin_ID" ]] && {
        exp=$(grep -wE "^#! $userna" "/etc/$raycheck/config.json" | cut -d ' ' -f 3 | sort | uniq)
        sed -i "/^#! $userna $exp/,/^},{/d" /etc/$raycheck/config.json
        datata=$(find /etc/.maAsiss/ -name $userna)
        for accc in "${datata[@]}"
        do
        rm $accc
        done
        systemctl restart $raycheck > /dev/null 2>&1
    } || {
        [[ ! -e /etc/.maAsiss/db_reseller/${message_from_id}/user_trojan/$userna ]] && {
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "$(echo -e "â›” THE USER DOES NOT EXIST â›”")" \
                --parse_mode html
            _erro='1'      
            ShellBot.sendMessage --chat_id ${callack_query_message_chat_id[$id]} \
                 --text "Func Error Do Nothing" \
                 --reply_markup "$(ShellBot.ForceReply)"
            return 0
        }
        exp=$(grep -wE "^#! $userna" "/etc/$raycheck/config.json" | cut -d ' ' -f 3 | sort | uniq)
        sed -i "/^#! $userna $exp/,/^},{/d" /etc/$raycheck/config.json
        rm /etc/.maAsiss/db_reseller/${message_from_id}/user_trojan/$userna
        rm /etc/.maAsiss/info-user-trojan/$userna
        systemctl restart $raycheck > /dev/null 2>&1
    }
}

add_trojan_trial() {
    if [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]]; then
        ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ‘¤ CREATE TRIAL Trojan ðŸ‘¤\n\nHow many hours should it last ? EX: 1:" \
            --reply_markup "$(ShellBot.ForceReply)"
    elif [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]]; then
            ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                --text "ðŸ‘¤ CREATE TRIAL Trojan ðŸ‘¤\n\nHow many hours should it last ? EX: 1:" \
                --reply_markup "$(ShellBot.ForceReply)"       
    else
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    fi
}

func_add_trojan_trial() {
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    [[ -f /etc/.maAsiss/.cache/DisableOrderTROJAN ]] && {
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "â›” Disable Order TROJAN" \
                --parse_mode html
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
               --text "Func Error Do Nothing" \
               --reply_markup "$(ShellBot.ForceReply)"
        return 0
    }
}
    mkdir -p /etc/.maAsiss/info-user-trojan
    userna=$(echo Trial`</dev/urandom tr -dc A-Z0-9 | head -c4`)
    t_time=$1
    domain=$(cat /etc/$raycheck/domain)
    tr="$(cat /root/log-install.txt | grep -w "Trojan " | cut -d: -f2|sed 's/ //g')"

    exp=`date -d "2 days" +"%Y-%m-%d"`
    tuserdate=$(date '+%C%y/%m/%d' -d " +2 days")
    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
       mkdir -p /etc/.maAsiss/db_reseller/${message_from_id}/trial-fold
    }
    [[ -z $t_time ]] && {
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
            --text "$(echo -e "â›” error try again")" \
            --parse_mode html
        return 0
        _erro='1'
    }
    
echo "$userna:$exp" >/etc/.maAsiss/info-user-trojan/$userna
uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#trojanws$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#trojangrpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#trojantcp$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#trojanxtls$/a\#&# '"$user $exp"'\
},{"password": "'""$uuid""'","flow": "'""xtls-rprx-direct""'","email": "'""$userna""'"' /etc/xray/config.json
  
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    echo "$userna:$exp" >/etc/.maAsiss/db_reseller/${message_from_id}/user_trojan/$userna
    echo "$userna:$exp" >/etc/.maAsiss/db_reseller/${message_from_id}/trial-fold/$userna
}
dir_teste="/etc/.maAsiss/db_reseller/${message_from_id}/user_trojan/$userna"
dir_teste2="/etc/.maAsiss/db_reseller/${message_from_id}/trial-fold/$userna"
dates=`date`
cat <<-EOF >/etc/.maAsiss/$userna.sh
#!/bin/bash
# USER TRIAL TROJAN by ${message_from_id} $dates
exp=\$(grep -wE "^#! $userna" "/etc/$raycheck/config.json" | cut -d ' ' -f 3 | sort | uniq)
sed -i "/^#! $userna $exp/,/^},{/d" /etc/$raycheck/config.json
systemctl restart $raycheck > /dev/null 2>&1
rm /etc/.maAsiss/db_reseller/${message_from_id}/user_trojan/$userna
rm /etc/.maAsiss/info-user-trojan/$userna
[[ -e $dir_teste ]] && rm $dir_teste
[[ -e $dir_teste2 ]] && rm $dir_teste2
rm -f /etc/.maAsiss/$userna
rm -f /etc/.maAsiss/$userna.sh
EOF
chmod +x /etc/.maAsiss/$userna.sh
echo "/etc/.maAsiss/$userna.sh" | at now + $t_time hour >/dev/null 2>&1
[[ "$t_time" == '1' ]] && hrs="hour" || hrs="hours"          

trojanlink3="trojan://${uuid}@${domain}:${tr}?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=bug.com#${userna}"
trojanlink2="trojan://${uuid}@${domain}:${tr}?path=%2Ftrojan-ws&security=tls&host=bug.com&type=ws&sni=bug.com#${userna}"
trojanlink="trojan://${uuid}@${domain}:443#${userna}"
trojanlink1="trojan://${uuid}@${doman}:443?security=xtls&headerType=none&type=tcp&flow=xtls-rprx-direct&sni=bug.com#${userna}"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>     ðŸ”¸ TROJAN ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Domain : $domain\n"
env_msg+="Remarks : $userna\n"
env_msg+="Expired On : $data â³ \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port  : $tr\n"
env_msg+="Key : $uuid\n"
env_msg+="Path : /trojan-ws\n"
env_msg+="Flow : xtls-rprx-direct\n"
env_msg+="ServiceName : trojan-grpc\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link TCP: \n<code>$trojanlink</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link XTLS: \n<code>$trojanlink1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link WS: \n<code>$trojanlink2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link GRPC: \n<code>$trojanlink3</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
systemctl restart $raycheck > /dev/null 2>&1
return 0

}

list_member_trojan() {
   if [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]]; then
      _result=$(grep -E "^#! " "/etc/$raycheck/config.json" | cut -d ' ' -f 2 | column -t | sort | uniq | wc -l)
      _results=$(grep -E "^#! " "/etc/$raycheck/config.json" | cut -d ' ' -f 2 | column -t | sort | uniq )
   elif [[ "${callback_query_from_id[$id]}" != "$Admin_ID" ]]; then
      _result=$(ls /etc/.maAsiss/db_reseller/${callback_query_from_id}/user_trojan | wc -l)
      _results=$(ls /etc/.maAsiss/db_reseller/${callback_query_from_id}/user_trojan )
   else
      ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "â›” ACCESS DENIED â›”" \
                --parse_mode html
      return 0
   fi
   if [ "$_result" = "0" ]; then
      ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "â›” YOU DONT HAVE ANY USER YET â›”" \
                --parse_mode html
      return 0
   else
      ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
      ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
         --text "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n ðŸŸ¢ TROJAN MEMBER LIST ðŸŸ¢ \nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n\n$_results\n\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n" \
         --parse_mode html
      return 0
   fi
}

check_login_trojan(){
if [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]]; then
echo -n > /tmp/other.txt
data=( `cat /etc/$raycheck/config.json | grep '^#!' | cut -d ' ' -f 2 | sort | uniq`);

echo -e "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”" > /tmp/vmess-login
echo -e "         ðŸŸ¢ Trojan User Login ðŸŸ¢  " >> /tmp/vmess-login
echo -e "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”" >> /tmp/vmess-login

for akun in "${data[@]}"
do
if [[ -z "$akun" ]]; then
akun="tidakada"
fi

echo -n > /tmp/ipvmess.txt
data2=( `netstat -anp | grep ESTABLISHED | grep tcp6 | grep $raycheck | awk '{print $5}' | cut -d: -f1 | sort | uniq`);
for ip in "${data2[@]}"
do

jum=$(cat /var/log/$raycheck/access.log | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip | sort | uniq)
if [[ "$jum" = "$ip" ]]; then
echo "$jum" >> /tmp/ipvmess.txt
else
echo "$ip" >> /tmp/other.txt
fi
jum2=$(cat /tmp/ipvmess.txt)
sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
done

jum=$(cat /tmp/ipvmess.txt)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
jum2=$(cat /tmp/ipvmess.txt | nl)
echo "user : $akun" >> /tmp/vmess-login
echo "$jum2" >> /tmp/vmess-login
echo -e "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”" >> /tmp/vmess-login
fi
rm -rf /tmp/ipvmess.txt
done

oth=$(cat /tmp/other.txt | sort | uniq | nl)
echo "other" >> /tmp/vmess-login
echo "$oth" >> /tmp/vmess-login
echo -e "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”" >> /tmp/vmess-login
rm -rf /tmp/other.txt
msg=$(cat /tmp/vmess-login)
cekk=$(cat /tmp/vmess-login | wc -l)
if [ "$cekk" = "0" ] || [ "$cekk" = "6" ]; then
ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "â›” NO USERS ONLINE â›”" \
                --parse_mode html
rm /tmp/vmess-login
return 0
else
ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
         --text "$msg" \
         --parse_mode html
rm /tmp/vmess-login
return 0
fi
else
ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "â›” ACCES DENIED â›”" \
                --parse_mode html
return 0
fi
}

unset menu_trojan
menu_trojan=''
ShellBot.InlineKeyboardButton --button 'menu_trojan' --line 1 --text 'Add Trojan' --callback_data '_add_trojan'
ShellBot.InlineKeyboardButton --button 'menu_trojan' --line 2 --text 'Delete Trojan' --callback_data '_delete_trojan'
ShellBot.InlineKeyboardButton --button 'menu_trojan' --line 3 --text 'Create Trial Trojan' --callback_data '_trial_trojan'
ShellBot.InlineKeyboardButton --button 'menu_trojan' --line 4 --text 'List Member Trojan' --callback_data '_member_trojan'
ShellBot.InlineKeyboardButton --button 'menu_trojan' --line 5 --text 'Check User Login Trojan' --callback_data '_login_trojan'
ShellBot.InlineKeyboardButton --button 'menu_trojan' --line 6 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_gobacktro'
ShellBot.regHandleFunction --function add_trojan --callback_data _add_trojan
ShellBot.regHandleFunction --function del_trojan --callback_data _delete_trojan
ShellBot.regHandleFunction --function add_trojan_trial --callback_data _trial_trojan
ShellBot.regHandleFunction --function list_member_trojan --callback_data _member_trojan
ShellBot.regHandleFunction --function check_login_trojan --callback_data _login_trojan
ShellBot.regHandleFunction --function admin_service_see --callback_data _gobacktro
unset keyboardtro
keyboardtro="$(ShellBot.InlineKeyboardMarkup -b 'menu_trojan')"

unset res_menu_trojan
res_menu_trojan=''
ShellBot.InlineKeyboardButton --button 'res_menu_trojan' --line 1 --text 'âž• Add Trojan âž•' --callback_data '_res_add_trojan'
ShellBot.InlineKeyboardButton --button 'res_menu_trojan' --line 3 --text 'â³ Create Trial Trojan â³' --callback_data '_res_trial_trojan'
ShellBot.InlineKeyboardButton --button 'res_menu_trojan' --line 4 --text 'ðŸŸ¢ List Member Trojan ðŸŸ¢' --callback_data '_res_member_trojan'
ShellBot.InlineKeyboardButton --button 'res_menu_trojan' --line 5 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_res_gobacktro'
ShellBot.regHandleFunction --function add_trojan --callback_data _res_add_trojan
ShellBot.regHandleFunction --function add_trojan_trial --callback_data _res_trial_trojan
ShellBot.regHandleFunction --function list_member_trojan --callback_data _res_member_trojan
ShellBot.regHandleFunction --function menu_reserv --callback_data _res_gobacktro
unset keyboardtrores
keyboardtrores="$(ShellBot.InlineKeyboardMarkup -b 'res_menu_trojan')"

#======= VLESS MENU =========
res_vless_menus() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "SELECT AN OPTION BELOW:" \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'res_menu_vless')"
        return 0
    }
}

vless_menus() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "SELECT AN OPTION BELOW:" \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'menu_vless')"
        return 0
    }
}

add_vless() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ‘¤ CREATE USER VLess ðŸ‘¤\n\nUsername:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

func_add_vless() {
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    [[ -f /etc/.maAsiss/.cache/DisableOrderVLESS ]] && {
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                    --text "â›” Disable Order VLESS" \
                    --parse_mode html
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                   --text "Func Error Do Nothing" \
                   --reply_markup "$(ShellBot.ForceReply)"
            return 0
    }
}

file_user=$1
userna=$(sed -n '1 p' $file_user | cut -d' ' -f2)
data=$(sed -n '2 p' $file_user | cut -d' ' -f2)
exp=$(echo "$data" | awk -F'/' '{print $2FS$1FS$3}' | xargs -i date -d'{}' +%Y-%m-%d)
        
domain=$(cat /etc/$raycheck/domain)
tls="$(cat /root/log-install.txt | grep -w "Vless TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat /root/log-install.txt | grep -w "Vless None TLS" | cut -d: -f2|sed 's/ //g')"

[[ "${message_from_id[$id]}" = "$Admin_ID" ]] && {
mkdir -p /etc/.maAsiss/info-user-vless
echo "$userna:$data" >/etc/.maAsiss/info-user-vless/$userna

uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#vless$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#vlessgrpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
vlesslink1="vless://${uuid}@${domain}:$tls?path=/vless&security=tls&encryption=none&type=ws#${userna}"
vlesslink2="vless://${uuid}@${domain}:$none?path=/vless&encryption=none&type=ws#${userna}"
vlesslink3="vless://${uuid}@${domain}:$tls?mode=gun&security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=bug.com#${userna}"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>        ðŸ”¸ VLESS ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Address : $domain\n"
env_msg+="Remarks : $userna\n"
env_msg+="Expired On : $data \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port TLS : $tls\n"
env_msg+="Port None TLS : $none\n"
env_msg+="ID : <code>$uuid</code>\n"
env_msg+="Encryption : none\n"
env_msg+="Network : websocket/ws\n"
env_msg+="Path : /vless\n"
env_msg+="ServiceName : vless-grpc\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link TLS : \n"
env_msg+="<code>$vlesslink1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link None TLS : \n"
env_msg+="<code>$vlesslink2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link GRPC : \n"
env_msg+="<code>$vlesslink3</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html 
systemctl restart $raycheck > /dev/null 2>&1
return 0
}

pricevless=$(grep -w "Price VLess" /etc/.maAsiss/price | awk '{print $NF}')
saldores=$(grep -w "Saldo_Reseller" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id} | awk '{print $NF}')
if [ "$saldores" -lt "$pricevless" ]; then
ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "â›” Your Balance Not Enough â›”" \
    --parse_mode html
return 0
else
mkdir -p /etc/.maAsiss/info-user-vless
mkdir -p /etc/.maAsiss/db_reseller/${message_from_id}/user_vless
echo "$userna:$data" >/etc/.maAsiss/db_reseller/${message_from_id}/user_vless/$userna
echo "$userna:$data" >/etc/.maAsiss/info-user-vless/$userna
_CurrSal=$(echo $saldores - $pricevless | bc)
sed -i "/Saldo_Reseller/c\Saldo_Reseller: $_CurrSal" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id}
sed -i "/${message_from_id}/c\USER: ${message_from_id} SALDO: $_CurrSal TYPE: reseller" $User_Active


uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#vless$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#vlessgrpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
vlesslink1="vless://${uuid}@${domain}:$tls?path=/vless&security=tls&encryption=none&type=ws#${userna}"
vlesslink2="vless://${uuid}@${domain}:$none?path=/vless&encryption=none&type=ws#${userna}"
vlesslink3="vless://${uuid}@${domain}:$tls?mode=gun&security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=bug.com#${userna}"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>        ðŸ”¸ VLESS ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Address : $domain\n"
env_msg+="Remarks : $userna\n"
env_msg+="Expired On : $data \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port TLS : $tls\n"
env_msg+="Port None TLS : $none\n"
env_msg+="ID : <code>$uuid</code>\n"
env_msg+="Encryption : none\n"
env_msg+="Network : websocket/ws\n"
env_msg+="Path : /vless\n"
env_msg+="ServiceName : vless-grpc\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link TLS : \n"
env_msg+="<code>$vlesslink1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link None TLS : \n"
env_msg+="<code>$vlesslink2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link GRPC : \n"
env_msg+="<code>$vlesslink3</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
echo "$userna 30Days VLESS | ${message_from_username}" >> /etc/.maAsiss/log_res

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
systemctl restart $raycheck > /dev/null 2>&1
return 0
fi
}

func_add_vless2() {
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    [[ -f /etc/.maAsiss/.cache/DisableOrderVLESS ]] && {
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                    --text "â›” Disable Order VLESS" \
                    --parse_mode html
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                   --text "Func Error Do Nothing" \
                   --reply_markup "$(ShellBot.ForceReply)"
            return 0
    }
}
file_user=$1
userna=$(sed -n '1 p' $file_user | cut -d' ' -f2)
data=$(sed -n '2 p' $file_user | cut -d' ' -f2)
exp=$(echo "$data" | awk -F'/' '{print $2FS$1FS$3}' | xargs -i date -d'{}' +%Y-%m-%d)
        
domain=$(cat /etc/$raycheck/domain)
tls="$(cat /root/log-install.txt | grep -w "Vless TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat /root/log-install.txt | grep -w "Vless None TLS" | cut -d: -f2|sed 's/ //g')"

[[ "${message_from_id[$id]}" = "$Admin_ID" ]] && {
mkdir -p /etc/.maAsiss/info-user-vless
echo "$userna:$data" >/etc/.maAsiss/info-user-vless/$userna

uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#vless$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#vlessgrpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
vlesslink1="vless://${uuid}@${domain}:$tls?path=/vless&security=tls&encryption=none&type=ws#${userna}"
vlesslink2="vless://${uuid}@${domain}:$none?path=/vless&encryption=none&type=ws#${userna}"
vlesslink3="vless://${uuid}@${domain}:$tls?mode=gun&security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=bug.com#${userna}"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>        ðŸ”¸ VLESS ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Address : $domain\n"
env_msg+="Remarks : $userna\n"
env_msg+="Expired On : $data \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port TLS : $tls\n"
env_msg+="Port None TLS : $none\n"
env_msg+="ID : <code>$uuid</code>\n"
env_msg+="Encryption : none\n"
env_msg+="Network : websocket/ws\n"
env_msg+="Path : /vless\n"
env_msg+="ServiceName : vless-grpc\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link TLS : \n"
env_msg+="<code>$vlesslink1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link None TLS : \n"
env_msg+="<code>$vlesslink2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link GRPC : \n"
env_msg+="<code>$vlesslink3</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html 
systemctl restart $raycheck > /dev/null 2>&1
return 0
}

pricevless=$(grep -w "Price VLess" /etc/.maAsiss/price | awk '{print $NF}')
saldores=$(grep -w "Saldo_Reseller" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id} | awk '{print $NF}')
urday=$(echo $pricevless * 2 | bc)
if [ "$saldores" -lt "$urday" ]; then
ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "â›” Your Balance Not Enough â›”" \
    --parse_mode html
return 0
else
mkdir -p /etc/.maAsiss/info-user-vless
mkdir -p /etc/.maAsiss/db_reseller/${message_from_id}/user_vless
echo "$userna:$data" >/etc/.maAsiss/db_reseller/${message_from_id}/user_vless/$userna
echo "$userna:$data" >/etc/.maAsiss/info-user-vless/$userna
_CurrSal=$(echo $saldores - $urday | bc)
sed -i "/Saldo_Reseller/c\Saldo_Reseller: $_CurrSal" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id}
sed -i "/${message_from_id}/c\USER: ${message_from_id} SALDO: $_CurrSal TYPE: reseller" $User_Active

uuid=$(cat /proc/sys/kernel/random/uuid)
uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#vless$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#vlessgrpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
vlesslink1="vless://${uuid}@${domain}:$tls?path=/vless&security=tls&encryption=none&type=ws#${userna}"
vlesslink2="vless://${uuid}@${domain}:$none?path=/vless&encryption=none&type=ws#${userna}"
vlesslink3="vless://${uuid}@${domain}:$tls?mode=gun&security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=bug.com#${userna}"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>        ðŸ”¸ VLESS ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Address : $domain\n"
env_msg+="Remarks : $userna\n"
env_msg+="Expired On : $data \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port TLS : $tls\n"
env_msg+="Port None TLS : $none\n"
env_msg+="ID : <code>$uuid</code>\n"
env_msg+="Encryption : none\n"
env_msg+="Network : websocket/ws\n"
env_msg+="Path : /vless\n"
env_msg+="ServiceName : vless-grpc\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link TLS : \n"
env_msg+="<code>$vlesslink1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link None TLS : \n"
env_msg+="<code>$vlesslink2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link GRPC : \n"
env_msg+="<code>$vlesslink3</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
echo "$userna 60Days VLESS | ${message_from_username}" >> /etc/.maAsiss/log_res

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
systemctl restart $raycheck > /dev/null 2>&1
return 0
fi
}

add_vless_trial() {
    if [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]]; then
        ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ‘¤ CREATE TRIAL VLess ðŸ‘¤\n\nHow many hours should it last ? EX: 1:" \
            --reply_markup "$(ShellBot.ForceReply)"
    elif [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]]; then
            ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                --text "ðŸ‘¤ CREATE TRIAL VLess ðŸ‘¤\n\nHow many hours should it last ? EX: 1:" \
                --reply_markup "$(ShellBot.ForceReply)"       
    else
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    fi
}

func_add_vless_trial() {
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    [[ -f /etc/.maAsiss/.cache/DisableOrderVLESS ]] && {
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                    --text "â›” Disable Order VLESS" \
                    --parse_mode html
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                   --text "Func Error Do Nothing" \
                   --reply_markup "$(ShellBot.ForceReply)"
            return 0
    }
}
mkdir -p /etc/.maAsiss/info-user-vless
    userna=$(echo Trial`</dev/urandom tr -dc A-Z0-9 | head -c4`)
    t_time=$1
    domain=$(cat /etc/$raycheck/domain)
    tls="$(cat /root/log-install.txt | grep -w "Vless TLS" | cut -d: -f2|sed 's/ //g')"
    none="$(cat /root/log-install.txt | grep -w "Vless None TLS" | cut -d: -f2|sed 's/ //g')"

    exp=`date -d "2 days" +"%Y-%m-%d"`
    tuserdate=$(date '+%C%y/%m/%d' -d " +2 days")
    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
       mkdir -p /etc/.maAsiss/db_reseller/${message_from_id}/trial-fold
    }
    [[ -z $t_time ]] && {
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
            --text "$(echo -e "â›” error try again")" \
            --parse_mode html
        return 0
        _erro='1'
    }
    
echo "$userna:$exp" >/etc/.maAsiss/info-user-vless/$userna
uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#vless$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#vlessgrpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
  
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    echo "$userna:$exp" >/etc/.maAsiss/db_reseller/${message_from_id}/user_vless/$userna
    echo "$userna:$exp" >/etc/.maAsiss/db_reseller/${message_from_id}/trial-fold/$userna
}
dir_teste="/etc/.maAsiss/db_reseller/${message_from_id}/user_vless/$userna"
dir_teste2="/etc/.maAsiss/db_reseller/${message_from_id}/trial-fold/$userna"
dates=`date`
cat <<-EOF >/etc/.maAsiss/$userna.sh
#!/bin/bash
# USER TRIAL VLESS by ${message_from_id} $dates
exp=\$(grep -wE "^#& $userna" "/etc/$raycheck/config.json" | cut -d ' ' -f 3 | sort | uniq)
sed -i "/^#& $userna $exp/,/^},{/d" /etc/$raycheck/config.json
systemctl restart $raycheck > /dev/null 2>&1
rm /etc/.maAsiss/db_reseller/${message_from_id}/user_vless/$userna
rm /etc/.maAsiss/info-user-vless/$userna
[[ -e $dir_teste ]] && rm $dir_teste
[[ -e $dir_teste2 ]] && rm $dir_teste2
rm -f /etc/.maAsiss/$userna
rm -f /etc/.maAsiss/$userna.sh
EOF
chmod +x /etc/.maAsiss/$userna.sh
echo "/etc/.maAsiss/$userna.sh" | at now + $t_time hour >/dev/null 2>&1
[[ "$t_time" == '1' ]] && hrs="hour" || hrs="hours"          

vlesslink1="vless://${uuid}@${domain}:$tls?path=/vless&security=tls&encryption=none&type=ws#${userna}"
vlesslink2="vless://${uuid}@${domain}:$none?path=/vless&encryption=none&type=ws#${userna}"
vlesslink3="vless://${uuid}@${domain}:$tls?mode=gun&security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=bug.com#${userna}"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>        ðŸ”¸ VLESS ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Address : $domain\n"
env_msg+="Remarks : $userna\n"
env_msg+="Expired On : $data \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port TLS : $tls\n"
env_msg+="Port None TLS : $none\n"
env_msg+="ID : <code>$uuid</code>\n"
env_msg+="Encryption : none\n"
env_msg+="Network : websocket/ws\n"
env_msg+="Path : /vless\n"
env_msg+="ServiceName : vless-grpc\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link TLS : \n"
env_msg+="<code>$vlesslink1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link None TLS : \n"
env_msg+="<code>$vlesslink2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link GRPC : \n"
env_msg+="<code>$vlesslink3</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
systemctl restart $raycheck > /dev/null 2>&1
return 0

}

list_member_vless() {
   if [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]]; then
      _result=$(grep -E "^#& " "/etc/$raycheck/config.json" | cut -d ' ' -f 2 | column -t | sort | uniq | wc -l)
      _results=$(grep -E "^#& " "/etc/$raycheck/config.json" | cut -d ' ' -f 2 | column -t | sort | uniq )
   elif [[ "${callback_query_from_id[$id]}" != "$Admin_ID" ]]; then
      _result=$(ls /etc/.maAsiss/db_reseller/${callback_query_from_id}/user_vless | wc -l)
      _results=$(ls /etc/.maAsiss/db_reseller/${callback_query_from_id}/user_vless )
   else
      ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "â›” ACCESS DENIED â›”" \
                --parse_mode html
      return 0
   fi
   if [ "$_result" = "0" ]; then
      ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "â›” YOU DONT HAVE ANY USER YET â›”" \
                --parse_mode html
      return 0
   else
      ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
      ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
         --text "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n ðŸŸ¢ VLESS MEMBER LIST ðŸŸ¢ \nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n\n$_results\n\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n" \
         --parse_mode html
      return 0
   fi
}

del_vless() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ—‘ REMOVE USER VLess ðŸ—‘\n\nUsername:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

func_del_vless() {
    userna=$1
    [[ "${message_from_id[$id]}" = "$Admin_ID" ]] && {
        exp=$(grep -wE "^#& $userna" "/etc/$raycheck/config.json" | cut -d ' ' -f 3 | sort | uniq)
        sed -i "/^#& $userna $exp/,/^},{/d" /etc/$raycheck/config.json
        datata=$(find /etc/.maAsiss/ -name $userna)
        for accc in "${datata[@]}"
        do
        rm $accc
        done
        systemctl restart $raycheck > /dev/null 2>&1
    } || {
        [[ ! -e /etc/.maAsiss/db_reseller/${message_from_id}/user_vless/$userna ]] && {
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "$(echo -e "â›” THE USER DOES NOT EXIST â›”")" \
                --parse_mode html
            _erro='1'      
            ShellBot.sendMessage --chat_id ${callack_query_message_chat_id[$id]} \
                 --text "Func Error Do Nothing" \
                 --reply_markup "$(ShellBot.ForceReply)"
            return 0
        }
        exp=$(grep -wE "^#& $userna" "/etc/$raycheck/config.json" | cut -d ' ' -f 3 | sort | uniq)
        sed -i "/^#& $userna $exp/,/^},{/d" /etc/$raycheck/config.json
        rm /etc/.maAsiss/db_reseller/${message_from_id}/user_vless/$userna
        rm /etc/.maAsiss/info-user-vless/$userna
        systemctl restart $raycheck > /dev/null 2>&1
    }
}

check_login_vless(){
if [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]]; then
echo -n > /tmp/other.txt
data=( `cat /etc/$raycheck/config.json | grep '^#&' | cut -d ' ' -f 2 | sort | uniq`);

echo -e "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”" > /tmp/vmess-login
echo -e "         ðŸŸ¢ VLess User Login ðŸŸ¢  " >> /tmp/vmess-login
echo -e "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”" >> /tmp/vmess-login

for akun in "${data[@]}"
do
if [[ -z "$akun" ]]; then
akun="tidakada"
fi

echo -n > /tmp/ipvmess.txt
data2=( `netstat -anp | grep ESTABLISHED | grep tcp6 | grep $raycheck | awk '{print $5}' | cut -d: -f1 | sort | uniq`);
for ip in "${data2[@]}"
do

jum=$(cat /var/log/$raycheck/access.log | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip | sort | uniq)
if [[ "$jum" = "$ip" ]]; then
echo "$jum" >> /tmp/ipvmess.txt
else
echo "$ip" >> /tmp/other.txt
fi
jum2=$(cat /tmp/ipvmess.txt)
sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
done

jum=$(cat /tmp/ipvmess.txt)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
jum2=$(cat /tmp/ipvmess.txt | nl)
echo "user : $akun" >> /tmp/vmess-login
echo "$jum2" >> /tmp/vmess-login
echo -e "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”" >> /tmp/vmess-login
fi
rm -rf /tmp/ipvmess.txt
done

oth=$(cat /tmp/other.txt | sort | uniq | nl)
echo "other" >> /tmp/vmess-login
echo "$oth" >> /tmp/vmess-login
echo -e "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”" >> /tmp/vmess-login
rm -rf /tmp/other.txt
msg=$(cat /tmp/vmess-login)
cekk=$(cat /tmp/vmess-login | wc -l)
if [ "$cekk" = "0" ] || [ "$cekk" = "6" ]; then
ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "â›” NO USERS ONLINE â›”" \
                --parse_mode html
rm /tmp/vmess-login
return 0
else
ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
         --text "$msg" \
         --parse_mode html
rm /tmp/vmess-login
return 0
fi
else
ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "â›” ACCESS DENIED â›”" \
                --parse_mode html
return 0
fi
}

res_menus() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "SELECT AN OPTION BELOW:" \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'menuzzz')" \
        return 0
    }
}

unset menu_vless
menu_vless=''
ShellBot.InlineKeyboardButton --button 'menu_vless' --line 1 --text 'Add VLess' --callback_data '_add_vless'
ShellBot.InlineKeyboardButton --button 'menu_vless' --line 2 --text 'Delete VLess' --callback_data '_delete_vless'
ShellBot.InlineKeyboardButton --button 'menu_vless' --line 3 --text 'Create Trial VLess' --callback_data '_trial_vless'
ShellBot.InlineKeyboardButton --button 'menu_vless' --line 4 --text 'List Member VLess' --callback_data '_member_vless'
ShellBot.InlineKeyboardButton --button 'menu_vless' --line 5 --text 'Check User Login VLess' --callback_data '_login_vless'
ShellBot.InlineKeyboardButton --button 'menu_vless' --line 6 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_gobackvless'
ShellBot.regHandleFunction --function add_vless --callback_data _add_vless
ShellBot.regHandleFunction --function del_vless --callback_data _delete_vless
ShellBot.regHandleFunction --function add_vless_trial --callback_data _trial_vless
ShellBot.regHandleFunction --function list_member_vless --callback_data _member_vless
ShellBot.regHandleFunction --function check_login_vless --callback_data _login_vless
ShellBot.regHandleFunction --function admin_service_see --callback_data _gobackvless
unset keyboardvless
keyboardvless="$(ShellBot.InlineKeyboardMarkup -b 'menu_vless')"

unset res_menu_vless
res_menu_vless=''
ShellBot.InlineKeyboardButton --button 'res_menu_vless' --line 1 --text 'âž• Add VLess âž•' --callback_data '_res_add_vless'
ShellBot.InlineKeyboardButton --button 'res_menu_vless' --line 3 --text 'â³ Create Trial VLess â³' --callback_data '_res_trial_vless'
ShellBot.InlineKeyboardButton --button 'res_menu_vless' --line 4 --text 'ðŸŸ¢ List Member VLess ðŸŸ¢' --callback_data '_res_member_vless'
ShellBot.InlineKeyboardButton --button 'res_menu_vless' --line 5 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_res_gobackvless'
ShellBot.regHandleFunction --function add_vless --callback_data _res_add_vless
ShellBot.regHandleFunction --function add_vless_trial --callback_data _res_trial_vless
ShellBot.regHandleFunction --function list_member_vless --callback_data _res_member_vless
ShellBot.regHandleFunction --function menu_reserv --callback_data _res_gobackvless
unset keyboardvlessres
keyboardvlessres="$(ShellBot.InlineKeyboardMarkup -b 'res_menu_vless')"



#====== ALL ABOUT ShadowSocks =======#

res_ss_menus() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "SELECT AN OPTION BELOW:" \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'res_menu_ss')"
        return 0
    }
}

ss_menus() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "SELECT AN OPTION BELOW:" \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'menu_ss')"
        return 0
    }
}

add_ss() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ‘¤ CREATE USER ShadowSocks ðŸ‘¤\n\nUsername:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

func_add_ss() {
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    [[ -f /etc/.maAsiss/.cache/DisableOrderSS ]] && {
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "â›” Disable Order Shadowsocks" \
                --parse_mode html
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
               --text "Func Error Do Nothing" \
               --reply_markup "$(ShellBot.ForceReply)"
        return 0
    }
}

file_user=$1
userna=$(sed -n '1 p' $file_user | cut -d' ' -f2)
data=$(sed -n '2 p' $file_user | cut -d' ' -f2)
exp=$(echo "$data" | awk -F'/' '{print $2FS$1FS$3}' | xargs -i date -d'{}' +%Y-%m-%d)
        
domain=$(cat /etc/$raycheck/domain)
lastport1=$(grep "port_tls" /etc/shadowsocks-libev/akun.conf | tail -n1 | awk '{print $2}')
lastport2=$(grep "port_http" /etc/shadowsocks-libev/akun.conf | tail -n1 | awk '{print $2}')
if [[ $lastport1 == '' ]]; then
tls=2443
else
tls="$((lastport1+1))"
fi
if [[ $lastport2 == '' ]]; then
http=3443
else
http="$((lastport2+1))"
fi

[[ "${message_from_id[$id]}" = "$Admin_ID" ]] && {
mkdir -p /etc/.maAsiss/info-user-ss
echo "$userna:$data" >/etc/.maAsiss/info-user-ss/$userna

cat > /etc/shadowsocks-libev/$userna-tls.json<<END
{   
    "server":"0.0.0.0",
    "server_port":$tls,
    "password":"$userna",
    "timeout":60,
    "method":"aes-256-cfb",
    "fast_open":true,
    "no_delay":true,
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=tls"
}
END
cat > /etc/shadowsocks-libev/$userna-http.json <<-END
{
    "server":"0.0.0.0",
    "server_port":$http,
    "password":"$userna",
    "timeout":60,
    "method":"aes-256-cfb",
    "fast_open":true,
    "no_delay":true,
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=http"
}
END
chmod +x /etc/shadowsocks-libev/$userna-tls.json
chmod +x /etc/shadowsocks-libev/$userna-http.json

systemctl start shadowsocks-libev-server@$userna-tls.service > /dev/null 2>&1
systemctl enable shadowsocks-libev-server@$userna-tls.service > /dev/null 2>&1
systemctl start shadowsocks-libev-server@$userna-http.service > /dev/null 2>&1
systemctl enable shadowsocks-libev-server@$userna-http.service > /dev/null 2>&1
tmp1=$(echo -n "aes-256-cfb:${userna}@${domain}:$tls" | base64 -w0)
tmp2=$(echo -n "aes-256-cfb:${userna}@${domain}:$http" | base64 -w0)
linkss1="ss://${tmp1}?plugin=obfs-local;obfs=tls;obfs-host=bing.com"
linkss2="ss://${tmp2}?plugin=obfs-local;obfs=http;obfs-host=bing.com"
echo -e "### $userna $exp
port_tls $tls
port_http $http">>"/etc/shadowsocks-libev/akun.conf"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>      ðŸ”¸ SS OBFS ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Address : $domain\n"
env_msg+="Password : $userna\n"
env_msg+="Expired On : $data \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port OBFS TLS : $tls\n"
env_msg+="Port OBFS HTTP : $http\n"
env_msg+="Encrypt Method : aes-256-cfb\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link OBFS TLS : \n"
env_msg+="<code>$linkss1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link OBFS HTTP : \n"
env_msg+="<code>$linkss2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
return 0
}

pricess=$(grep -w "Price Shadowsocks :" /etc/.maAsiss/price | awk '{print $NF}')
saldores=$(grep -w "Saldo_Reseller" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id} | awk '{print $NF}')
if [ "$saldores" -lt "$pricess" ]; then
ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "â›” Your Balance Not Enough â›”" \
    --parse_mode html
return 0
else
mkdir -p /etc/.maAsiss/info-user-ss
mkdir -p /etc/.maAsiss/db_reseller/${message_from_id}/user_ss
echo "$userna:$data" >/etc/.maAsiss/db_reseller/${message_from_id}/user_ss/$userna
echo "$userna:$data" >/etc/.maAsiss/info-user-ss/$userna
_CurrSal=$(echo $saldores - $pricess | bc)
sed -i "/Saldo_Reseller/c\Saldo_Reseller: $_CurrSal" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id}
sed -i "/${message_from_id}/c\USER: ${message_from_id} SALDO: $_CurrSal TYPE: reseller" $User_Active

cat > /etc/shadowsocks-libev/$userna-tls.json<<END
{   
    "server":"0.0.0.0",
    "server_port":$tls,
    "password":"$userna",
    "timeout":60,
    "method":"aes-256-cfb",
    "fast_open":true,
    "no_delay":true,
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=tls"
}
END
cat > /etc/shadowsocks-libev/$userna-http.json <<-END
{
    "server":"0.0.0.0",
    "server_port":$http,
    "password":"$userna",
    "timeout":60,
    "method":"aes-256-cfb",
    "fast_open":true,
    "no_delay":true,
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=http"
}
END
chmod +x /etc/shadowsocks-libev/$userna-tls.json
chmod +x /etc/shadowsocks-libev/$userna-http.json

systemctl start shadowsocks-libev-server@$userna-tls.service > /dev/null 2>&1
systemctl enable shadowsocks-libev-server@$userna-tls.service > /dev/null 2>&1
systemctl start shadowsocks-libev-server@$userna-http.service > /dev/null 2>&1
systemctl enable shadowsocks-libev-server@$userna-http.service > /dev/null 2>&1
tmp1=$(echo -n "aes-256-cfb:${userna}@${domain}:$tls" | base64 -w0)
tmp2=$(echo -n "aes-256-cfb:${userna}@${domain}:$http" | base64 -w0)
linkss1="ss://${tmp1}?plugin=obfs-local;obfs=tls;obfs-host=bing.com"
linkss2="ss://${tmp2}?plugin=obfs-local;obfs=http;obfs-host=bing.com"
echo -e "### $userna $exp
port_tls $tls
port_http $http">>"/etc/shadowsocks-libev/akun.conf"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>      ðŸ”¸ SS OBFS ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Address : $domain\n"
env_msg+="Password : $userna\n"
env_msg+="Expired On : $data \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port OBFS TLS : $tls\n"
env_msg+="Port OBFS HTTP : $http\n"
env_msg+="Encrypt Method : aes-256-cfb\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link OBFS TLS : \n"
env_msg+="<code>$linkss1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link OBFS HTTP : \n"
env_msg+="<code>$linkss2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
echo "$userna 30Days SHADOWSOCKS | ${message_from_username}" >> /etc/.maAsiss/log_res

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
return 0
fi
}

func_add_ss2() {
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    [[ -f /etc/.maAsiss/.cache/DisableOrderSS ]] && {
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "â›” Disable Order Shadowsocks" \
                --parse_mode html
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
               --text "Func Error Do Nothing" \
               --reply_markup "$(ShellBot.ForceReply)"
        return 0
    }
}
file_user=$1
userna=$(sed -n '1 p' $file_user | cut -d' ' -f2)
data=$(sed -n '2 p' $file_user | cut -d' ' -f2)
exp=$(echo "$data" | awk -F'/' '{print $2FS$1FS$3}' | xargs -i date -d'{}' +%Y-%m-%d)
        
domain=$(cat /etc/$raycheck/domain)
lastport1=$(grep "port_tls" /etc/shadowsocks-libev/akun.conf | tail -n1 | awk '{print $2}')
lastport2=$(grep "port_http" /etc/shadowsocks-libev/akun.conf | tail -n1 | awk '{print $2}')
if [[ $lastport1 == '' ]]; then
tls=2443
else
tls="$((lastport1+1))"
fi
if [[ $lastport2 == '' ]]; then
http=3443
else
http="$((lastport2+1))"
fi

[[ "${message_from_id[$id]}" = "$Admin_ID" ]] && {
mkdir -p /etc/.maAsiss/info-user-ss
echo "$userna:$data" >/etc/.maAsiss/info-user-ss/$userna

cat > /etc/shadowsocks-libev/$userna-tls.json<<END
{   
    "server":"0.0.0.0",
    "server_port":$tls,
    "password":"$userna",
    "timeout":60,
    "method":"aes-256-cfb",
    "fast_open":true,
    "no_delay":true,
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=tls"
}
END
cat > /etc/shadowsocks-libev/$userna-http.json <<-END
{
    "server":"0.0.0.0",
    "server_port":$http,
    "password":"$userna",
    "timeout":60,
    "method":"aes-256-cfb",
    "fast_open":true,
    "no_delay":true,
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=http"
}
END
chmod +x /etc/shadowsocks-libev/$userna-tls.json
chmod +x /etc/shadowsocks-libev/$userna-http.json

systemctl start shadowsocks-libev-server@$userna-tls.service > /dev/null 2>&1
systemctl enable shadowsocks-libev-server@$userna-tls.service > /dev/null 2>&1
systemctl start shadowsocks-libev-server@$userna-http.service > /dev/null 2>&1
systemctl enable shadowsocks-libev-server@$userna-http.service > /dev/null 2>&1
tmp1=$(echo -n "aes-256-cfb:${userna}@${domain}:$tls" | base64 -w0)
tmp2=$(echo -n "aes-256-cfb:${userna}@${domain}:$http" | base64 -w0)
linkss1="ss://${tmp1}?plugin=obfs-local;obfs=tls;obfs-host=bing.com"
linkss2="ss://${tmp2}?plugin=obfs-local;obfs=http;obfs-host=bing.com"
echo -e "### $userna $exp
port_tls $tls
port_http $http">>"/etc/shadowsocks-libev/akun.conf"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>      ðŸ”¸ SS OBFS ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Address : $domain\n"
env_msg+="Password : $userna\n"
env_msg+="Expired On : $data \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port OBFS TLS : $tls\n"
env_msg+="Port OBFS HTTP : $http\n"
env_msg+="Encrypt Method : aes-256-cfb\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link OBFS TLS : \n"
env_msg+="<code>$linkss1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link OBFS HTTP : \n"
env_msg+="<code>$linkss2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
return 0
}

pricess=$(grep -w "Price Shadowsocks :" /etc/.maAsiss/price | awk '{print $NF}')
saldores=$(grep -w "Saldo_Reseller" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id} | awk '{print $NF}')
urday=$(echo $pricess * 2 | bc)
if [ "$saldores" -lt "$urday" ]; then
ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "â›” Your Balance Not Enough â›”" \
    --parse_mode html
return 0
else
mkdir -p /etc/.maAsiss/info-user-ss
mkdir -p /etc/.maAsiss/db_reseller/${message_from_id}/user_ss
echo "$userna:$data" >/etc/.maAsiss/db_reseller/${message_from_id}/user_ss/$userna
echo "$userna:$data" >/etc/.maAsiss/info-user-ss/$userna
_CurrSal=$(echo $saldores - $urday | bc)
sed -i "/Saldo_Reseller/c\Saldo_Reseller: $_CurrSal" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id}
sed -i "/${message_from_id}/c\USER: ${message_from_id} SALDO: $_CurrSal TYPE: reseller" $User_Active

cat > /etc/shadowsocks-libev/$userna-tls.json<<END
{   
    "server":"0.0.0.0",
    "server_port":$tls,
    "password":"$userna",
    "timeout":60,
    "method":"aes-256-cfb",
    "fast_open":true,
    "no_delay":true,
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=tls"
}
END
cat > /etc/shadowsocks-libev/$userna-http.json <<-END
{
    "server":"0.0.0.0",
    "server_port":$http,
    "password":"$userna",
    "timeout":60,
    "method":"aes-256-cfb",
    "fast_open":true,
    "no_delay":true,
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=http"
}
END
chmod +x /etc/shadowsocks-libev/$userna-tls.json
chmod +x /etc/shadowsocks-libev/$userna-http.json

systemctl start shadowsocks-libev-server@$userna-tls.service > /dev/null 2>&1
systemctl enable shadowsocks-libev-server@$userna-tls.service > /dev/null 2>&1
systemctl start shadowsocks-libev-server@$userna-http.service > /dev/null 2>&1
systemctl enable shadowsocks-libev-server@$userna-http.service > /dev/null 2>&1
tmp1=$(echo -n "aes-256-cfb:${userna}@${domain}:$tls" | base64 -w0)
tmp2=$(echo -n "aes-256-cfb:${userna}@${domain}:$http" | base64 -w0)
linkss1="ss://${tmp1}?plugin=obfs-local;obfs=tls;obfs-host=bing.com"
linkss2="ss://${tmp2}?plugin=obfs-local;obfs=http;obfs-host=bing.com"
echo -e "### $userna $exp
port_tls $tls
port_http $http">>"/etc/shadowsocks-libev/akun.conf"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>      ðŸ”¸ SS OBFS ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Address : $domain\n"
env_msg+="Password : $userna\n"
env_msg+="Expired On : $data \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port OBFS TLS : $tls\n"
env_msg+="Port OBFS HTTP : $http\n"
env_msg+="Encrypt Method : aes-256-cfb\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link OBFS TLS : \n"
env_msg+="<code>$linkss1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link OBFS HTTP : \n"
env_msg+="<code>$linkss2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
echo "$userna 60Days SHADOWSOCKS | ${message_from_username}" >> /etc/.maAsiss/log_res

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
return 0
fi
}

del_ss() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ—‘ REMOVE USER ShadowSocks ðŸ—‘\n\nUsername:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}
	
func_del_ss() {
    userna=$1
    if [[ "${message_from_id[$id]}" = "$Admin_ID" ]]; then
        exp=$(grep -wE "^###" "/etc/shadowsocks-libev/akun.conf" | cut -d ' ' -f3 )
        sed -i "/^### $userna $exp/,/^port_http/d" "/etc/shadowsocks-libev/akun.conf"
        systemctl disable shadowsocks-libev-server@$userna-tls.service > /dev/null 2>&1
        systemctl disable shadowsocks-libev-server@$userna-http.service > /dev/null 2>&1
        systemctl stop shadowsocks-libev-server@$userna-tls.service > /dev/null 2>&1
        systemctl stop shadowsocks-libev-server@$userna-http.service > /dev/null 2>&1
	    rm -f "/etc/shadowsocks-libev/$userna-tls.json"
	    rm -f "/etc/shadowsocks-libev/$userna-http.json"
        datata=$(find /etc/.maAsiss/ -name $userna)
        for accc in "${datata[@]}"
        do
        rm $accc
        done
    elif [[ "${message_from_id[$id]}" != "$Admin_ID" ]]; then
        [[ ! -e /etc/.maAsiss/db_reseller/${message_from_id}/user_ss/$userna ]] && {
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "$(echo -e "â›” THE USER DOES NOT EXIST â›”")" \
                --parse_mode html
            _erro='1'      
            ShellBot.sendMessage --chat_id ${callack_query_message_chat_id[$id]} \
                 --text "Func Error Do Nothing" \
                 --reply_markup "$(ShellBot.ForceReply)"
            return 0
        }
        exp=$(grep -wE "^###" "/etc/shadowsocks-libev/akun.conf" | cut -d ' ' -f3 )
        sed -i "/^### $userna $exp/,/^port_http/d" "/etc/shadowsocks-libev/akun.conf"
        systemctl disable shadowsocks-libev-server@$userna-tls.service > /dev/null 2>&1
        systemctl disable shadowsocks-libev-server@$userna-http.service > /dev/null 2>&1
        systemctl stop shadowsocks-libev-server@$userna-tls.service > /dev/null 2>&1
        systemctl stop shadowsocks-libev-server@$userna-http.service > /dev/null 2>&1
	    rm -f "/etc/shadowsocks-libev/$userna-tls.json"
	    rm -f "/etc/shadowsocks-libev/$userna-http.json"
        rm -f /etc/.maAsiss/db_reseller/${message_from_id}/user_ss/$userna
        rm -f /etc/.maAsiss/info-user-ss/$userna
    fi
}

add_ss_trial() {
    if [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]]; then
        ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ‘¤ CREATE TRIAL ShadowSocks ðŸ‘¤\n\nHow many hours should it last ? EX: 1:" \
            --reply_markup "$(ShellBot.ForceReply)"
    elif [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]]; then
            ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                --text "ðŸ‘¤ CREATE TRIAL ShadowSocks ðŸ‘¤\n\nHow many hours should it last ? EX: 1:" \
                --reply_markup "$(ShellBot.ForceReply)"       
    else
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    fi
}

func_add_ss_trial() {
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    [[ -f /etc/.maAsiss/.cache/DisableOrderSS ]] && {
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "â›” Disable Order Shadowsocks" \
                --parse_mode html
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
               --text "Func Error Do Nothing" \
               --reply_markup "$(ShellBot.ForceReply)"
        return 0
    }
}
mkdir -p /etc/.maAsiss/info-user-ss
    userna=$(echo Trial`</dev/urandom tr -dc A-Z0-9 | head -c4`)
    t_time=$1
    domain=$(cat /etc/$raycheck/domain)
    lastport1=$(grep "port_tls" /etc/shadowsocks-libev/akun.conf | tail -n1 | awk '{print $2}')
    lastport2=$(grep "port_http" /etc/shadowsocks-libev/akun.conf | tail -n1 | awk '{print $2}')
    if [[ $lastport1 == '' ]]; then
    tls=2443
    else
    tls="$((lastport1+1))"
    fi
    if [[ $lastport2 == '' ]]; then
    http=3443
    else
    http="$((lastport2+1))"
    fi
    exp=`date -d "2 days" +"%Y-%m-%d"`
    tuserdate=$(date '+%C%y/%m/%d' -d " +2 days")
    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
       mkdir -p /etc/.maAsiss/db_reseller/${message_from_id}/trial-fold
    }
    [[ -z $t_time ]] && {
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
            --text "$(echo -e "â›” error try again")" \
            --parse_mode html
        return 0
        _erro='1'
    }
    

cat > /etc/shadowsocks-libev/$userna-tls.json<<END
{   
    "server":"0.0.0.0",
    "server_port":$tls,
    "password":"$userna",
    "timeout":60,
    "method":"aes-256-cfb",
    "fast_open":true,
    "no_delay":true,
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=tls"
}
END
cat > /etc/shadowsocks-libev/$userna-http.json <<-END
{
    "server":"0.0.0.0",
    "server_port":$http,
    "password":"$userna",
    "timeout":60,
    "method":"aes-256-cfb",
    "fast_open":true,
    "no_delay":true,
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=http"
}
END
chmod +x /etc/shadowsocks-libev/$userna-tls.json
chmod +x /etc/shadowsocks-libev/$userna-http.json

[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    echo "$userna:$exp" >/etc/.maAsiss/db_reseller/${message_from_id}/user_ss/$userna
    echo "$userna:$exp" >/etc/.maAsiss/db_reseller/${message_from_id}/trial-fold/$userna
}
dir_teste="/etc/.maAsiss/db_reseller/${message_from_id}/user_ss/$userna"
dir_teste2="/etc/.maAsiss/db_reseller/${message_from_id}/trial-fold/$userna"
dates=`date`
cat <<-EOF >/etc/.maAsiss/$userna.sh
#!/bin/bash
# USER TRIAL SS by ${message_from_id} $dates
exp=\$(grep -wE "^### " "/etc/shadowsocks-libev/akun.conf" | cut -d ' ' -f3 )
sed -i "/^### $userna $exp/,/^port_http/d" "/etc/shadowsocks-libev/akun.conf"
systemctl disable shadowsocks-libev-server@$userna-tls.service > /dev/null 2>&1
systemctl disable shadowsocks-libev-server@$userna-http.service > /dev/null 2>&1
systemctl stop shadowsocks-libev-server@$userna-tls.service > /dev/null 2>&1
systemctl stop shadowsocks-libev-server@$userna-http.service > /dev/null 2>&1
rm -f "/etc/shadowsocks-libev/$userna-tls.json"
rm -f "/etc/shadowsocks-libev/$userna-http.json"

rm /etc/.maAsiss/db_reseller/${message_from_id}/user_ss/$userna
rm /etc/.maAsiss/info-user-ss/$userna
[[ -e $dir_teste ]] && rm $dir_teste
[[ -e $dir_teste2 ]] && rm $dir_teste2
rm -f /etc/.maAsiss/$userna
rm -f /etc/.maAsiss/$userna.sh
EOF

chmod +x /etc/.maAsiss/$userna.sh
echo "/etc/.maAsiss/$userna.sh" | at now + $t_time hour >/dev/null 2>&1
[[ "$t_time" == '1' ]] && hrs="hour" || hrs="hours"          

systemctl start shadowsocks-libev-server@$userna-tls.service > /dev/null 2>&1
systemctl enable shadowsocks-libev-server@$userna-tls.service > /dev/null 2>&1
systemctl start shadowsocks-libev-server@$userna-http.service > /dev/null 2>&1
systemctl enable shadowsocks-libev-server@$userna-http.service > /dev/null 2>&1
tmp1=$(echo -n "aes-256-cfb:${userna}@${domain}:$tls" | base64 -w0)
tmp2=$(echo -n "aes-256-cfb:${userna}@${domain}:$http" | base64 -w0)
linkss1="ss://${tmp1}?plugin=obfs-local;obfs=tls;obfs-host=bing.com"
linkss2="ss://${tmp2}?plugin=obfs-local;obfs=http;obfs-host=bing.com"
echo -e "### $userna $exp
port_tls $tls
port_http $http">>"/etc/shadowsocks-libev/akun.conf"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>      ðŸ”¸ SS OBFS ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Address : $domain\n"
env_msg+="Password : $userna\n"
env_msg+="Expired On : $t_time $hrs â³ \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port OBFS TLS : $tls\n"
env_msg+="Port OBFS HTTP : $http\n"
env_msg+="Encrypt Method : aes-256-cfb\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link OBFS TLS : \n"
env_msg+="<code>$linkss1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link OBFS HTTP : \n"
env_msg+="<code>$linkss2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
return 0
}

list_member_ss() {
   if [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]]; then
      _result=$(grep -wE "^###" "/etc/shadowsocks-libev/akun.conf" | cut -d ' ' -f2 | column -t | sort | uniq | wc -l)
      _results=$(grep -wE "^###" "/etc/shadowsocks-libev/akun.conf" | cut -d ' ' -f2 | column -t | sort | uniq )
   elif [[ "${callback_query_from_id[$id]}" != "$Admin_ID" ]]; then
      _result=$(ls /etc/.maAsiss/db_reseller/${callback_query_from_id}/user_ss | wc -l)
      _results=$(ls /etc/.maAsiss/db_reseller/${callback_query_from_id}/user_ss )
   else
      ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "â›” ACCESS DENIE â›”" \
                --parse_mode html
      return 0
   fi
   if [ "$_result" = "0" ]; then
      ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "â›” YOU DONT HAVE ANY USER YET â›”" \
                --parse_mode html
      return 0
   else
      ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
      ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
         --text "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n ðŸŸ¢ ShadowSocks Member List ðŸŸ¢ \nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n\n$_results\n\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n" \
         --parse_mode html
      return 0
   fi
}

check_login_ss(){
if [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]]; then
echo -e "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”" > /tmp/ss-login
echo -e "       ðŸŸ¢ ShadowSocks User Login ðŸŸ¢ " >> /tmp/ss-login
echo -e "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”" >> /tmp/ss-login
data=( `cat /etc/shadowsocks-libev/akun.conf | grep '^###' | cut -d ' ' -f 2`);
x=1
echo " User | TLS : ">> /tmp/ss-login
for akun in "${data[@]}"
do
port=$(cat /etc/shadowsocks-libev/akun.conf | grep '^port_tls' | cut -d ' ' -f 2 | tr '\n' ' ' | awk '{print $'"$x"'}')
jum=$(netstat -anp | grep ESTABLISHED | grep obfs-server | cut -d ':' -f 2 | grep -w $port | awk '{print $2}' | sort | uniq | nl)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
echo " $akun - $port">> /tmp/ss-login
echo "$jum">> /tmp/ss-login
echo -e "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”">> /tmp/ss-login
fi
x=$(( "$x" + 1 ))
done
data=( `cat /etc/shadowsocks-libev/akun.conf | grep '^###' | cut -d ' ' -f 2`);
x=1
echo " User |  HTTP :">> /tmp/ss-login
for akun in "${data[@]}"
do
port=$(cat /etc/shadowsocks-libev/akun.conf | grep '^port_http' | cut -d ' ' -f 2 | tr '\n' ' ' | awk '{print $'"$x"'}')
jum=$(netstat -anp | grep ESTABLISHED | grep obfs-server | cut -d ':' -f 2 | grep -w $port | awk '{print $2}' | sort | uniq | nl)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
echo " $akun - $port">> /tmp/ss-login
echo "$jum">> /tmp/ss-login
echo -e "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”">> /tmp/ss-login
fi
x=$(( "$x" + 1 ))
done
msg=$(cat /tmp/ss-login)
cekk=$(cat /tmp/vmess-login | wc -l)
if [ "$cekk" = "0" ] || [ "$cekk" = "5" ]; then
ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "â›” NO USERS ONLINE â›”" \
                --parse_mode html
rm /tmp/ss-login
return 0
else
ShellBot.deleteMessage	--chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
         --text "$msg" \
         --parse_mode html
rm /tmp/ss-login
return 0
fi
else
ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "â›” ACCESS DENIED â›”" \
                --parse_mode html
return 0
fi
}

unset menu_ss
menu_ss=''
ShellBot.InlineKeyboardButton --button 'menu_ss' --line 1 --text 'Add Shadowsocks' --callback_data '_add_ss'
ShellBot.InlineKeyboardButton --button 'menu_ss' --line 2 --text 'Delete Shadowsocks' --callback_data '_delete_ss'
ShellBot.InlineKeyboardButton --button 'menu_ss' --line 3 --text 'Create Trial SS' --callback_data '_trial_ss'
ShellBot.InlineKeyboardButton --button 'menu_ss' --line 4 --text 'List Member SS' --callback_data '_member_ss'
ShellBot.InlineKeyboardButton --button 'menu_ss' --line 5 --text 'Check User Login SS' --callback_data '_login_ss'
ShellBot.InlineKeyboardButton --button 'menu_ss' --line 6 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_gobackss'
ShellBot.regHandleFunction --function add_ss --callback_data _add_ss
ShellBot.regHandleFunction --function del_ss --callback_data _delete_ss
ShellBot.regHandleFunction --function add_ss_trial --callback_data _trial_ss
ShellBot.regHandleFunction --function list_member_ss --callback_data _member_ss
ShellBot.regHandleFunction --function check_login_ss --callback_data _login_ss
ShellBot.regHandleFunction --function admin_service_see --callback_data _gobackss
unset keyboardss
keyboardss="$(ShellBot.InlineKeyboardMarkup -b 'menu_ss')"

unset res_menu_ss
res_menu_ss=''
ShellBot.InlineKeyboardButton --button 'res_menu_ss' --line 1 --text 'âž• Add Shadowsocks âž•' --callback_data '_res_add_ss'
ShellBot.InlineKeyboardButton --button 'res_menu_ss' --line 3 --text 'â³ Create Trial SS â³' --callback_data '_res_trial_ss'
ShellBot.InlineKeyboardButton --button 'res_menu_ss' --line 4 --text 'ðŸŸ¢ List Member SS ðŸŸ¢' --callback_data '_res_member_ss'
ShellBot.InlineKeyboardButton --button 'res_menu_ss' --line 5 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_res_gobackss'
ShellBot.regHandleFunction --function add_ss --callback_data _res_add_ss
ShellBot.regHandleFunction --function add_ss_trial --callback_data _res_trial_ss
ShellBot.regHandleFunction --function list_member_ss --callback_data _res_member_ss
ShellBot.regHandleFunction --function menu_reserv --callback_data _res_gobackss
unset keyboardssres
keyboardssres="$(ShellBot.InlineKeyboardMarkup -b 'res_menu_ss')"

#====== ALL ABOUT ShadowSocksR =======#

res_ssr_menus() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "SELECT AN OPTION BELOW:" \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'res_menu_ssr')"
        return 0
    }
}

ssr_menus() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "SELECT AN OPTION BELOW:" \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'menu_ssr')"
        return 0
    }
}

add_ssr() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.deleteMessage	--chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ‘¤ CREATE USER Shadowsocks-R ðŸ‘¤\n\nUsername:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

func_add_ssr() {
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    [[ -f /etc/.maAsiss/.cache/DisableOrderSSR ]] && {
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                    --text "â›” Disable Order Shadowsocks-R" \
                    --parse_mode html
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                   --text "Func Error Do Nothing" \
                   --reply_markup "$(ShellBot.ForceReply)"
            return 0
    }
}

file_user=$1
userna=$(sed -n '1 p' $file_user | cut -d' ' -f2)
data=$(sed -n '2 p' $file_user | cut -d' ' -f2)
exp=$(echo "$data" | awk -F'/' '{print $2FS$1FS$3}' | xargs -i date -d'{}' +%Y-%m-%d)        

domain=$(cat /etc/$raycheck/domain)
lastport=$(cat /usr/local/shadowsocksr/mudb.json | grep '"port": ' | tail -n1 | awk '{print $2}' | cut -d "," -f 1 | cut -d ":" -f 1 )
if [[ $lastport == '' ]]; then
ssr_port=1443
else
ssr_port=$((lastport+1))
fi

[[ "${message_from_id[$id]}" = "$Admin_ID" ]] && {
mkdir -p /etc/.maAsiss/info-user-ssr
echo "$userna:$data" >/etc/.maAsiss/info-user-ssr/$userna

ssr_password="$userna"
ssr_method="aes-256-cfb"
ssr_protocol="origin"
ssr_obfs="tls1.2_ticket_auth_compatible"
ssr_protocol_param="2"
ssr_speed_limit_per_con=0
ssr_speed_limit_per_user=0
ssr_transfer="838868"
ssr_forbid="bittorrent"
cd /usr/local/shadowsocksr
match_add=$(python mujson_mgr.py -a -u "${ssr_user}" -p "${ssr_port}" -k "${ssr_password}" -m "${ssr_method}" -O "${ssr_protocol}" -G "${ssr_protocol_param}" -o "${ssr_obfs}" -s "${ssr_speed_limit_per_con}" -S "${ssr_speed_limit_per_user}" -t "${ssr_transfer}" -f "${ssr_forbid}"|grep -w "add user info")
cd

echo -e "### $userna $exp" >> /usr/local/shadowsocksr/akun.conf
tmp1=$(echo -n "${ssr_password}" | base64 -w0 | sed 's/=//g;s/\//_/g;s/+/-/g')
SSRobfs=$(echo ${ssr_obfs} | sed 's/_compatible//g')
tmp2=$(echo -n "$domain:${ssr_port}:${ssr_protocol}:${ssr_method}:${SSRobfs}:${tmp1}/obfsparam=" | base64 -w0)
ssr_link="ssr://${tmp2}"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>  ðŸ”¸ Shadosocks-R ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Address : $domain\n"
env_msg+="Password : $userna\n"
env_msg+="Expired On : $exp \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port : $ssr_port\n"
env_msg+="Protocol : $ssr_protocol\n"
env_msg+="Encrypt Method : $ssr_method\n"
env_msg+="Obfs : $ssr_obfs\n"
env_msg+="Device Limit : $ssr_protocol_param\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link SSR: \n\n"
env_msg+="<code>$ssr_link</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
/etc/init.d/ssrmu restart
return 0
}

pricessr=$(grep -w "Price Shadowsocks-R" /etc/.maAsiss/price | awk '{print $NF}')
saldores=$(grep -w "Saldo_Reseller" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id} | awk '{print $NF}')
if [ "$saldores" -lt "$pricessr" ]; then
ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "â›” Your Balance Not Enough â›”" \
    --parse_mode html
return 0
else
mkdir -p /etc/.maAsiss/info-user-ssr
mkdir -p /etc/.maAsiss/db_reseller/${message_from_id}/user_ssr
echo "$userna:$data" >/etc/.maAsiss/db_reseller/${message_from_id}/user_ssr/$userna
echo "$userna:$data" >/etc/.maAsiss/info-user-ssr/$userna
_CurrSal=$(echo $saldores - $pricessr | bc)
sed -i "/Saldo_Reseller/c\Saldo_Reseller: $_CurrSal" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id}
sed -i "/${message_from_id}/c\USER: ${message_from_id} SALDO: $_CurrSal TYPE: reseller" $User_Active

ssr_password="$userna"
ssr_method="aes-256-cfb"
ssr_protocol="origin"
ssr_obfs="tls1.2_ticket_auth_compatible"
ssr_protocol_param="2"
ssr_speed_limit_per_con=0
ssr_speed_limit_per_user=0
ssr_transfer="838868"
ssr_forbid="bittorrent"
cd /usr/local/shadowsocksr
match_add=$(python mujson_mgr.py -a -u "${ssr_user}" -p "${ssr_port}" -k "${ssr_password}" -m "${ssr_method}" -O "${ssr_protocol}" -G "${ssr_protocol_param}" -o "${ssr_obfs}" -s "${ssr_speed_limit_per_con}" -S "${ssr_speed_limit_per_user}" -t "${ssr_transfer}" -f "${ssr_forbid}"|grep -w "add user info")
cd

echo -e "### $userna $exp" >> /usr/local/shadowsocksr/akun.conf
tmp1=$(echo -n "${ssr_password}" | base64 -w0 | sed 's/=//g;s/\//_/g;s/+/-/g')
SSRobfs=$(echo ${ssr_obfs} | sed 's/_compatible//g')
tmp2=$(echo -n "$domain:${ssr_port}:${ssr_protocol}:${ssr_method}:${SSRobfs}:${tmp1}/obfsparam=" | base64 -w0)
ssr_link="ssr://${tmp2}"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>  ðŸ”¸ Shadosocks-R ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Address : $domain\n"
env_msg+="Password : $userna\n"
env_msg+="Expired On : $exp \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port : $ssr_port\n"
env_msg+="Protocol : $ssr_protocol\n"
env_msg+="Encrypt Method : $ssr_method\n"
env_msg+="Obfs : $ssr_obfs\n"
env_msg+="Device Limit : $ssr_protocol_param\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link SSR: \n\n"
env_msg+="<code>$ssr_link</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
echo "$userna 30Days SHADOWSOCKS-R | ${message_from_username}" >> /etc/.maAsiss/log_res

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
/etc/init.d/ssrmu restart
return 0
fi
}

func_add_ssr2() {
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    [[ -f /etc/.maAsiss/.cache/DisableOrderSSR ]] && {
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                    --text "â›” Disable Order Shadowsocks-R" \
                    --parse_mode html
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                   --text "Func Error Do Nothing" \
                   --reply_markup "$(ShellBot.ForceReply)"
            return 0
    }
}
file_user=$1
userna=$(sed -n '1 p' $file_user | cut -d' ' -f2)
data=$(sed -n '2 p' $file_user | cut -d' ' -f2)
exp=$(echo "$data" | awk -F'/' '{print $2FS$1FS$3}' | xargs -i date -d'{}' +%Y-%m-%d)        

domain=$(cat /etc/$raycheck/domain)
lastport=$(cat /usr/local/shadowsocksr/mudb.json | grep '"port": ' | tail -n1 | awk '{print $2}' | cut -d "," -f 1 | cut -d ":" -f 1 )
if [[ $lastport == '' ]]; then
ssr_port=1443
else
ssr_port=$((lastport+1))
fi

[[ "${message_from_id[$id]}" = "$Admin_ID" ]] && {
mkdir -p /etc/.maAsiss/info-user-ssr
echo "$userna:$data" >/etc/.maAsiss/info-user-ssr/$userna

ssr_password="$userna"
ssr_method="aes-256-cfb"
ssr_protocol="origin"
ssr_obfs="tls1.2_ticket_auth_compatible"
ssr_protocol_param="2"
ssr_speed_limit_per_con=0
ssr_speed_limit_per_user=0
ssr_transfer="838868"
ssr_forbid="bittorrent"
cd /usr/local/shadowsocksr
match_add=$(python mujson_mgr.py -a -u "${ssr_user}" -p "${ssr_port}" -k "${ssr_password}" -m "${ssr_method}" -O "${ssr_protocol}" -G "${ssr_protocol_param}" -o "${ssr_obfs}" -s "${ssr_speed_limit_per_con}" -S "${ssr_speed_limit_per_user}" -t "${ssr_transfer}" -f "${ssr_forbid}"|grep -w "add user info")
cd

echo -e "### $userna $exp" >> /usr/local/shadowsocksr/akun.conf
tmp1=$(echo -n "${ssr_password}" | base64 -w0 | sed 's/=//g;s/\//_/g;s/+/-/g')
SSRobfs=$(echo ${ssr_obfs} | sed 's/_compatible//g')
tmp2=$(echo -n "$domain:${ssr_port}:${ssr_protocol}:${ssr_method}:${SSRobfs}:${tmp1}/obfsparam=" | base64 -w0)
ssr_link="ssr://${tmp2}"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>  ðŸ”¸ Shadosocks-R ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Address : $domain\n"
env_msg+="Password : $userna\n"
env_msg+="Expired On : $exp \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port : $ssr_port\n"
env_msg+="Protocol : $ssr_protocol\n"
env_msg+="Encrypt Method : $ssr_method\n"
env_msg+="Obfs : $ssr_obfs\n"
env_msg+="Device Limit : $ssr_protocol_param\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link SSR: \n\n"
env_msg+="<code>$ssr_link</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
/etc/init.d/ssrmu restart
return 0
}

pricessr=$(grep -w "Price Shadowsocks-R" /etc/.maAsiss/price | awk '{print $NF}')
saldores=$(grep -w "Saldo_Reseller" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id} | awk '{print $NF}')
urday=$(echo $pricessr * 2 | bc)
if [ "$saldores" -lt "$urday" ]; then
ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "â›” Your Balance Not Enough â›”" \
    --parse_mode html
return 0
else
mkdir -p /etc/.maAsiss/info-user-ssr
mkdir -p /etc/.maAsiss/db_reseller/${message_from_id}/user_ssr
echo "$userna:$data" >/etc/.maAsiss/db_reseller/${message_from_id}/user_ssr/$userna
echo "$userna:$data" >/etc/.maAsiss/info-user-ssr/$userna
_CurrSal=$(echo $saldores - $urday | bc)
sed -i "/Saldo_Reseller/c\Saldo_Reseller: $_CurrSal" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id}
sed -i "/${message_from_id}/c\USER: ${message_from_id} SALDO: $_CurrSal TYPE: reseller" $User_Active

ssr_password="$userna"
ssr_method="aes-256-cfb"
ssr_protocol="origin"
ssr_obfs="tls1.2_ticket_auth_compatible"
ssr_protocol_param="2"
ssr_speed_limit_per_con=0
ssr_speed_limit_per_user=0
ssr_transfer="838868"
ssr_forbid="bittorrent"
cd /usr/local/shadowsocksr
match_add=$(python mujson_mgr.py -a -u "${ssr_user}" -p "${ssr_port}" -k "${ssr_password}" -m "${ssr_method}" -O "${ssr_protocol}" -G "${ssr_protocol_param}" -o "${ssr_obfs}" -s "${ssr_speed_limit_per_con}" -S "${ssr_speed_limit_per_user}" -t "${ssr_transfer}" -f "${ssr_forbid}"|grep -w "add user info")
cd

echo -e "### $userna $exp" >> /usr/local/shadowsocksr/akun.conf
tmp1=$(echo -n "${ssr_password}" | base64 -w0 | sed 's/=//g;s/\//_/g;s/+/-/g')
SSRobfs=$(echo ${ssr_obfs} | sed 's/_compatible//g')
tmp2=$(echo -n "$domain:${ssr_port}:${ssr_protocol}:${ssr_method}:${SSRobfs}:${tmp1}/obfsparam=" | base64 -w0)
ssr_link="ssr://${tmp2}"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>  ðŸ”¸ Shadosocks-R ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Address : $domain\n"
env_msg+="Password : $userna\n"
env_msg+="Expired On : $exp \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port : $ssr_port\n"
env_msg+="Protocol : $ssr_protocol\n"
env_msg+="Encrypt Method : $ssr_method\n"
env_msg+="Obfs : $ssr_obfs\n"
env_msg+="Device Limit : $ssr_protocol_param\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link SSR: \n\n"
env_msg+="<code>$ssr_link</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
echo "$userna 60Days SHADOWSOCKS-R | ${message_from_username}" >> /etc/.maAsiss/log_res

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
/etc/init.d/ssrmu restart
return 0
fi
}

del_ssr() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.deleteMessage	--chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ—‘ REMOVE USER Shadowsocks-R ðŸ—‘\n\nUsername:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

func_del_ssr() {
    userna=$1
    if [[ "${message_from_id[$id]}" = "$Admin_ID" ]]; then
        exp=$(grep -wE "^###" "/usr/local/shadowsocksr/akun.conf" | cut -d ' ' -f 3)
        sed -i "/^### $userna/d" "/usr/local/shadowsocksr/akun.conf"
        cd /usr/local/shadowsocksr
        match_del=$(python mujson_mgr.py -d -u "${userna}"|grep -w "delete user")
        cd
        datata=$(find /etc/.maAsiss/ -name $userna)
        for accc in "${datata[@]}"
        do
        rm $accc
        done
        /etc/init.d/ssrmu restart
    elif [[ "${message_from_id[$id]}" != "$Admin_ID" ]]; then
        [[ ! -e /etc/.maAsiss/db_reseller/${message_from_id}/user_ssr/$userna ]] && {
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "$(echo -e "â›” THE USER DOES NOT EXIST â›”")" \
                --parse_mode html
            _erro='1'      
            ShellBot.sendMessage --chat_id ${callack_query_message_chat_id[$id]} \
                 --text "Func Error Do Nothing" \
                 --reply_markup "$(ShellBot.ForceReply)"
            return 0
        }
        exp=$(grep -wE "^###" "/usr/local/shadowsocksr/akun.conf" | cut -d ' ' -f 3)
        sed -i "/^### $userna/d" "/usr/local/shadowsocksr/akun.conf"
        cd /usr/local/shadowsocksr
        match_del=$(python mujson_mgr.py -d -u "${userna}"|grep -w "delete user")
        cd
        rm -f /etc/.maAsiss/db_reseller/${message_from_id}/user_ssr/$userna
        rm -f /etc/.maAsiss/info-user-ssr/$userna
        /etc/init.d/ssrmu restart
    fi
}

add_ssr_trial() {
    if [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]]; then
        ShellBot.deleteMessage	--chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ‘¤ CREATE TRIAL Shadowsocks-R ðŸ‘¤\n\nHow many hours should it last ? EX: 1:" \
            --reply_markup "$(ShellBot.ForceReply)"
    elif [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]]; then
            ShellBot.deleteMessage	--chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                --text "ðŸ‘¤ CREATE TRIAL Shadowsocks-R ðŸ‘¤\n\nHow many hours should it last ? EX: 1:" \
                --reply_markup "$(ShellBot.ForceReply)"       
    else
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    fi
}

func_add_ssr_trial() {
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    [[ -f /etc/.maAsiss/.cache/DisableOrderSSR ]] && {
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                    --text "â›” Disable Order Shadowsocks-R" \
                    --parse_mode html
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                   --text "Func Error Do Nothing" \
                   --reply_markup "$(ShellBot.ForceReply)"
            return 0
    }
}
mkdir -p /etc/.maAsiss/info-user-ssr
    userna=$(echo Trial`</dev/urandom tr -dc A-Z0-9 | head -c4`)
    t_time=$1
    domain=$(cat /etc/$raycheck/domain)
    lastport=$(cat /usr/local/shadowsocksr/mudb.json | grep '"port": ' | tail -n1 | awk '{print $2}' | cut -d "," -f 1 | cut -d ":" -f 1 )
    if [[ $lastport == '' ]]; then
    ssr_port=1443
    else
    ssr_port=$((lastport+1))
    fi
    exp=`date -d "2 days" +"%Y-%m-%d"`
    tuserdate=$(date '+%C%y/%m/%d' -d " +2 days")
    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
       mkdir -p /etc/.maAsiss/db_reseller/${message_from_id}/trial-fold
    }
    [[ -z $t_time ]] && {
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
            --text "$(echo -e "â›” error try again")" \
            --parse_mode html
        return 0
        _erro='1'
    }

ssr_password="$userna"
ssr_method="aes-256-cfb"
ssr_protocol="origin"
ssr_obfs="tls1.2_ticket_auth_compatible"
ssr_protocol_param="2"
ssr_speed_limit_per_con=0
ssr_speed_limit_per_user=0
ssr_transfer="838868"
ssr_forbid="bittorrent"
cd /usr/local/shadowsocksr
match_add=$(python mujson_mgr.py -a -u "${ssr_user}" -p "${ssr_port}" -k "${ssr_password}" -m "${ssr_method}" -O "${ssr_protocol}" -G "${ssr_protocol_param}" -o "${ssr_obfs}" -s "${ssr_speed_limit_per_con}" -S "${ssr_speed_limit_per_user}" -t "${ssr_transfer}" -f "${ssr_forbid}"|grep -w "add user info")
cd

[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    echo "$userna:$exp" >/etc/.maAsiss/db_reseller/${message_from_id}/user_ssr/$userna
    echo "$userna:$exp" >/etc/.maAsiss/db_reseller/${message_from_id}/trial-fold/$userna
}
dir_teste="/etc/.maAsiss/db_reseller/${message_from_id}/user_ssr/$userna"
dir_teste2="/etc/.maAsiss/db_reseller/${message_from_id}/trial-fold/$userna"
dates=`date`
cat <<-EOF >/etc/.maAsiss/$userna.sh
#!/bin/bash
# USER TRIAL SSR by ${message_from_id} $dates
exp=\$(grep -wE "^###" "/usr/local/shadowsocksr/akun.conf" | cut -d ' ' -f 3)
sed -i "/^### $userna/d" "/usr/local/shadowsocksr/akun.conf"
cd /usr/local/shadowsocksr
match_del=$(python mujson_mgr.py -d -u "${userna}"|grep -w "delete user")
cd
rm -f /etc/.maAsiss/db_reseller/${message_from_id}/user_ssr/$userna
rm -f /etc/.maAsiss/info-user-ssr/$userna
/etc/init.d/ssrmu restart
[[ -e $dir_teste ]] && rm $dir_teste
[[ -e $dir_teste2 ]] && rm $dir_teste2
rm -f /etc/.maAsiss/$userna
rm -f /etc/.maAsiss/$userna.sh
EOF

chmod +x /etc/.maAsiss/$userna.sh
echo "/etc/.maAsiss/$userna.sh" | at now + $t_time hour >/dev/null 2>&1
[[ "$t_time" == '1' ]] && hrs="hour" || hrs="hours"          

echo -e "### $userna $exp" >> /usr/local/shadowsocksr/akun.conf
tmp1=$(echo -n "${ssr_password}" | base64 -w0 | sed 's/=//g;s/\//_/g;s/+/-/g')
SSRobfs=$(echo ${ssr_obfs} | sed 's/_compatible//g')
tmp2=$(echo -n "$domain:${ssr_port}:${ssr_protocol}:${ssr_method}:${SSRobfs}:${tmp1}/obfsparam=" | base64 -w0)
ssr_link="ssr://${tmp2}"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>  ðŸ”¸ Shadosocks-R ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Address : $domain\n"
env_msg+="Password : $userna\n"
env_msg+="Expired On : $t_time $hrs â³ \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port : $ssr_port\n"
env_msg+="Protocol : $ssr_protocol\n"
env_msg+="Encrypt Method : $ssr_method\n"
env_msg+="Obfs : $ssr_obfs\n"
env_msg+="Device Limit : $ssr_protocol_param\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link SSR: \n\n"
env_msg+="<code>$ssr_link</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
    
/etc/init.d/ssrmu restart
return 0
}

list_member_ssr() {
   if [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]]; then
      _result=$(grep -wE "^###" "/usr/local/shadowsocksr/akun.conf" | cut -d ' ' -f2 | column -t | sort | uniq | wc -l)
      _results=$(grep -wE "^###" "/usr/local/shadowsocksr/akun.conf" | cut -d ' ' -f2 | column -t | sort | uniq )
   elif [[ "${callback_query_from_id[$id]}" != "$Admin_ID" ]]; then
      _result=$(ls /etc/.maAsiss/db_reseller/${callback_query_from_id}/user_ssr | wc -l)
      _results=$(ls /etc/.maAsiss/db_reseller/${callback_query_from_id}/user_ssr )
   else
      ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "â›” ACCESS DENIED â›”" \
                --parse_mode html
      return 0
   fi
   if [ "$_result" = "0" ]; then
      ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "â›” YOU DONT HAVE ANY USER YET â›”" \
                --parse_mode html
      return 0
   else
      ShellBot.deleteMessage	--chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
      ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
         --text "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\nðŸŸ¢ ShadowsocksR Member List ðŸŸ¢\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n\n$_results\n\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n" \
         --parse_mode html
      return 0
   fi
}

unset menu_ssr
menu_ssr=''
ShellBot.InlineKeyboardButton --button 'menu_ssr' --line 1 --text 'Add Shadowsocks-R' --callback_data '_add_ssr'
ShellBot.InlineKeyboardButton --button 'menu_ssr' --line 2 --text 'Delete Shadowsocks-R' --callback_data '_delete_ssr'
ShellBot.InlineKeyboardButton --button 'menu_ssr' --line 3 --text 'Create Trial SSR' --callback_data '_trial_ssr'
ShellBot.InlineKeyboardButton --button 'menu_ssr' --line 4 --text 'List Member SSR' --callback_data '_member_ssr'
ShellBot.InlineKeyboardButton --button 'menu_ssr' --line 6 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_gobackssr'
ShellBot.regHandleFunction --function add_ssr --callback_data _add_ssr
ShellBot.regHandleFunction --function del_ssr --callback_data _delete_ssr
ShellBot.regHandleFunction --function add_ssr_trial --callback_data _trial_ssr
ShellBot.regHandleFunction --function list_member_ssr --callback_data _member_ssr
ShellBot.regHandleFunction --function admin_service_see --callback_data _gobackssr
unset keyboardssr
keyboardssr="$(ShellBot.InlineKeyboardMarkup -b 'menu_ssr')"

unset res_menu_ssr
res_menu_ssr=''
ShellBot.InlineKeyboardButton --button 'res_menu_ssr' --line 1 --text 'âž• Add Shadowsocks-R âž•' --callback_data '_res_add_ssr'
ShellBot.InlineKeyboardButton --button 'res_menu_ssr' --line 3 --text 'â³ Create Trial SSR â³' --callback_data '_res_trial_ssr'
ShellBot.InlineKeyboardButton --button 'res_menu_ssr' --line 4 --text 'ðŸŸ¢ List Member SSR ðŸŸ¢' --callback_data '_res_member_ssr'
ShellBot.InlineKeyboardButton --button 'res_menu_ssr' --line 5 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_res_gobackssr'
ShellBot.regHandleFunction --function add_ssr --callback_data _res_add_ssr
ShellBot.regHandleFunction --function add_ssr_trial --callback_data _res_trial_ssr
ShellBot.regHandleFunction --function list_member_ssr --callback_data _res_member_ssr
ShellBot.regHandleFunction --function menu_reserv --callback_data _res_gobackssr
unset keyboardssrres
keyboardssrres="$(ShellBot.InlineKeyboardMarkup -b 'res_menu_ssr')"

#====== ALL ABOUT SSTP =======#

res_sstp_menus() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "SELECT AN OPTION BELOW:" \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'res_menu_sstppx')"
        return 0
    }
}

sstp_menus() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "SELECT AN OPTION BELOW:" \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'menu_sstppx')"
        return 0
    }
}

add_sstp() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.deleteMessage	--chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ‘¤ CREATE USER SSTP ðŸ‘¤\n\nUsername:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

func_add_sstp() {
file_user=$1
userna=$(sed -n '1 p' $file_user | cut -d' ' -f2)
passw=$(sed -n '2 p' $file_user | cut -d' ' -f2)
data=$(sed -n '3 p' $file_user | cut -d' ' -f2)
exp=$(echo "$data" | awk -F'/' '{print $2FS$1FS$3}' | xargs -i date -d'{}' +%Y-%m-%d)        
domain=$(cat /etc/$raycheck/domain)
IPK=$(curl -sS ipv4.icanhazip.com)
sstport="$(cat /root/log-install.txt | grep -i SSTP | cut -d: -f2|sed 's/ //g')"

[[ "${message_from_id[$id]}" = "$Admin_ID" ]] && {
mkdir -p /etc/.maAsiss/info-user-sstp
echo "$userna:$data" >/etc/.maAsiss/info-user-sstp/$userna

cat >> /home/sstp/sstp_account <<EOF
$userna * $passw *
EOF
echo -e "### $userna $exp">>"/var/lib/scrz-prem/data-user-sstp"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>         ðŸ”¸ SSTP ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="IP : $IPK\n"
env_msg+="Username : $userna\n"
env_msg+="Password : $passw\n"
env_msg+="Expired On : $data ðŸ—“ \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port : $sstport\n"
env_msg+="Cert : http://$IPs:81/server.crt\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
systemctl restart accel-ppp > /dev/null 2>&1
return 0
}

pricesstp=$(grep -w "Price SSTP" /etc/.maAsiss/price | awk '{print $NF}')
saldores=$(grep -w "Saldo_Reseller" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id} | awk '{print $NF}')
if [ "$saldores" -lt "$pricesstp" ]; then
ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "â›” Your Balance Not Enough â›”" \
    --parse_mode html
return 0
else
mkdir -p /etc/.maAsiss/info-user-sstp
mkdir -p /etc/.maAsiss/db_reseller/${message_from_id}/user_sstp
echo "$userna:$data" >/etc/.maAsiss/db_reseller/${message_from_id}/user_sstp/$userna
echo "$userna:$data" >/etc/.maAsiss/info-user-sstp/$userna
_CurrSal=$(echo $saldores - $pricesstp | bc)
sed -i "/Saldo_Reseller/c\Saldo_Reseller: $_CurrSal" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id}
sed -i "/${message_from_id}/c\USER: ${message_from_id} SALDO: $_CurrSal TYPE: reseller" $User_Active

cat >> /home/sstp/sstp_account <<EOF
$userna * $passw *
EOF
echo -e "### $userna $exp">>"/var/lib/scrz-prem/data-user-sstp"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>         ðŸ”¸ SSTP ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="IP : $IPK\n"
env_msg+="Username : $userna\n"
env_msg+="Password : $passw\n"
env_msg+="Expired On : $data ðŸ—“ \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port : $sstport\n"
env_msg+="Cert : http://$IPs:81/server.crt\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
echo "$userna 30Days SSTP | ${message_from_username}" >> /etc/.maAsiss/log_res

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
systemctl restart accel-ppp > /dev/null 2>&1
return 0
fi
}

func_add_sstp2() {
file_user=$1
userna=$(sed -n '1 p' $file_user | cut -d' ' -f2)
passw=$(sed -n '2 p' $file_user | cut -d' ' -f2)
data=$(sed -n '3 p' $file_user | cut -d' ' -f2)
exp=$(echo "$data" | awk -F'/' '{print $2FS$1FS$3}' | xargs -i date -d'{}' +%Y-%m-%d)        
domain=$(cat /etc/$raycheck/domain)
IPK=$(curl -sS ipv4.icanhazip.com)
sstport="$(cat /root/log-install.txt | grep -i SSTP | cut -d: -f2|sed 's/ //g')"

[[ "${message_from_id[$id]}" = "$Admin_ID" ]] && {
mkdir -p /etc/.maAsiss/info-user-sstp
echo "$userna:$data" >/etc/.maAsiss/info-user-sstp/$userna

cat >> /home/sstp/sstp_account <<EOF
$userna * $passw *
EOF
echo -e "### $userna $exp">>"/var/lib/scrz-prem/data-user-sstp"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>         ðŸ”¸ SSTP ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="IP : $IPK\n"
env_msg+="Username : $userna\n"
env_msg+="Password : $passw\n"
env_msg+="Expired On : $data ðŸ—“ \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port : $sstport\n"
env_msg+="Cert : http://$IPs:81/server.crt\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
systemctl restart accel-ppp > /dev/null 2>&1
return 0
}

pricesstp=$(grep -w "Price SSTP" /etc/.maAsiss/price | awk '{print $NF}')
saldores=$(grep -w "Saldo_Reseller" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id} | awk '{print $NF}')
urday=$(echo $pricesstp * 2 | bc)
if [ "$saldores" -lt "$urday" ]; then
ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "â›” Your Balance Not Enough â›”" \
    --parse_mode html
return 0
else
mkdir -p /etc/.maAsiss/info-user-sstp
mkdir -p /etc/.maAsiss/db_reseller/${message_from_id}/user_sstp
echo "$userna:$data" >/etc/.maAsiss/db_reseller/${message_from_id}/user_sstp/$userna
echo "$userna:$data" >/etc/.maAsiss/info-user-sstp/$userna
_CurrSal=$(echo $saldores - $urday | bc)
sed -i "/Saldo_Reseller/c\Saldo_Reseller: $_CurrSal" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id}
sed -i "/${message_from_id}/c\USER: ${message_from_id} SALDO: $_CurrSal TYPE: reseller" $User_Active

cat >> /home/sstp/sstp_account <<EOF
$userna * $passw *
EOF
echo -e "### $userna $exp">>"/var/lib/scrz-prem/data-user-sstp"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>         ðŸ”¸ SSTP ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="IP : $IPK\n"
env_msg+="Username : $userna\n"
env_msg+="Password : $passw\n"
env_msg+="Expired On : $data ðŸ—“ \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port : $sstport\n"
env_msg+="Cert : http://$IPs:81/server.crt\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
echo "$userna 60Days SSTP | ${message_from_username}" >> /etc/.maAsiss/log_res

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
systemctl restart accel-ppp > /dev/null 2>&1
return 0
fi
}

del_sstp() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.deleteMessage	--chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ—‘ REMOVE USER SSTP ðŸ—‘\n\nUsername:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

func_del_sstp() {
    userna=$1
    if [[ "${message_from_id[$id]}" = "$Admin_ID" ]]; then
        exp=$(grep -E "^###" /var/lib/scrz-prem/data-user-sstp | cut -d ' ' -f 3 )
        sed -i "/^### $userna $exp/d" /var/lib/scrz-prem/data-user-sstp
        sed -i '/^'"$userna"'/d' /home/sstp/sstp_account
        datata=$(find /etc/.maAsiss/ -name $userna)
        for accc in "${datata[@]}"
        do
        rm $accc
        done
        systemctl restart accel-ppp > /dev/null 2>&1
    elif [[ "${message_from_id[$id]}" != "$Admin_ID" ]]; then
        [[ ! -e /etc/.maAsiss/db_reseller/${message_from_id}/user_sstp/$userna ]] && {
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "$(echo -e "â›” THE USER DOES NOT EXIST â›”")" \
                --parse_mode html
            _erro='1'      
            ShellBot.sendMessage --chat_id ${callack_query_message_chat_id[$id]} \
                 --text "Func Error Do Nothing" \
                 --reply_markup "$(ShellBot.ForceReply)"
            return 0
        }
        exp=$(grep -E "^###" /var/lib/scrz-prem/data-user-sstp | cut -d ' ' -f 3 )
        sed -i "/^### $userna $exp/d" /var/lib/scrz-prem/data-user-sstp
        sed -i '/^'"$userna"'/d' /home/sstp/sstp_account
        rm -f /etc/.maAsiss/db_reseller/${message_from_id}/user_sstp/$userna
        rm -f /etc/.maAsiss/info-user-sstp/$userna
        systemctl restart accel-ppp > /dev/null 2>&1
    fi
}

add_sstp_trial() {
    if [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]]; then
        ShellBot.deleteMessage	--chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ‘¤ CREATE TRIAL SSTP ðŸ‘¤\n\nHow many hours should it last ? EX: 1:" \
            --reply_markup "$(ShellBot.ForceReply)"
    elif [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]]; then
            ShellBot.deleteMessage	--chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                --text "ðŸ‘¤ CREATE TRIAL SSTP ðŸ‘¤\n\nHow many hours should it last ? EX: 1:" \
                --reply_markup "$(ShellBot.ForceReply)"       
    else
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    fi
}

func_add_sstp_trial() {
mkdir -p /etc/.maAsiss/info-user-sstp
    userna=$(echo Trial`</dev/urandom tr -dc A-Z0-9 | head -c4`)
    t_time=$1
    passw="1"
    domain=$(cat /etc/$raycheck/domain)
    IPK=$(curl -sS ipv4.icanhazip.com)
    sstport="$(cat /root/log-install.txt | grep -i SSTP | cut -d: -f2|sed 's/ //g')"
    exp=`date -d "2 days" +"%Y-%m-%d"`
    tuserdate=$(date '+%C%y/%m/%d' -d " +2 days")
    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
       mkdir -p /etc/.maAsiss/db_reseller/${message_from_id}/trial-fold
    }
    [[ -z $t_time ]] && {
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
            --text "$(echo -e "â›” error try again")" \
            --parse_mode html
        return 0
        _erro='1'
    }

[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    echo "$userna:$passw:$exp" >/etc/.maAsiss/db_reseller/${message_from_id}/user_sstp/$userna
    echo "$userna:$passw:$exp" >/etc/.maAsiss/db_reseller/${message_from_id}/trial-fold/$userna
}
dir_teste="/etc/.maAsiss/db_reseller/${message_from_id}/user_sstp/$userna"
dir_teste2="/etc/.maAsiss/db_reseller/${message_from_id}/trial-fold/$userna"
dates=`date`
cat <<-EOF >/etc/.maAsiss/$userna.sh
#!/bin/bash
# USER TRIAL SSTP by ${message_from_id} $dates
exp=\$(grep -E "^###" /var/lib/scrz-prem/data-user-sstp | cut -d ' ' -f 3 )
sed -i "/^### $userna $exp/d" /var/lib/scrz-prem/data-user-sstp
sed -i '/^'"$userna"'/d' /home/sstp/sstp_account
rm -f /etc/.maAsiss/db_reseller/${message_from_id}/user_sstp/$userna
rm -f /etc/.maAsiss/info-user-sstp/$userna
systemctl restart accel-ppp > /dev/null 2>&1
[[ -e $dir_teste ]] && rm $dir_teste
[[ -e $dir_teste2 ]] && rm $dir_teste2
rm -f /etc/.maAsiss/$userna
rm -f /etc/.maAsiss/$userna.sh
EOF

chmod +x /etc/.maAsiss/$userna.sh
echo "/etc/.maAsiss/$userna.sh" | at now + $t_time hour >/dev/null 2>&1
[[ "$t_time" == '1' ]] && hrs="hour" || hrs="hours"          

cat >> /home/sstp/sstp_account <<EOF
$userna * $passw *
EOF
echo -e "### $userna $exp">>"/var/lib/scrz-prem/data-user-sstp"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>         ðŸ”¸ SSTP ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="IP : $IPK\n"
env_msg+="Username : $userna\n"
env_msg+="Password : $passw\n"
env_msg+="Expired On : $t_time $hrs â³ \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port : $sstport\n"
env_msg+="Cert : http://$IPs:81/server.crt\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
    
systemctl restart accel-ppp > /dev/null 2>&1
return 0
}

list_member_sstp() {
   if [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]]; then
      _result=$(grep -wE "^###" "/var/lib/scrz-prem/data-user-sstp" | cut -d ' ' -f2 | column -t | sort | uniq | wc -l)
      _results=$(grep -wE "^###" "/var/lib/scrz-prem/data-user-sstp" | cut -d ' ' -f2 | column -t | sort | uniq )
   elif [[ "${callback_query_from_id[$id]}" != "$Admin_ID" ]]; then
      _result=$(ls /etc/.maAsiss/db_reseller/${callback_query_from_id}/user_sstp | wc -l)
      _results=$(ls /etc/.maAsiss/db_reseller/${callback_query_from_id}/user_sstp )
   else
      ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "â›” ACCESS DENIED â›”" \
                --parse_mode html
      return 0
   fi
   if [ "$_result" = "0" ]; then
      ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "â›” YOU DONT HAVE ANY USER YET â›”" \
                --parse_mode html
      return 0
   else
      ShellBot.deleteMessage	--chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
      ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
         --text "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n ðŸŸ¢ SSTP Member List ðŸŸ¢\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n\n$_results\n\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n" \
         --parse_mode html
      return 0
   fi
}

unset menu_sstppx
menu_sstppx=''
ShellBot.InlineKeyboardButton --button 'menu_sstppx' --line 1 --text 'Add SSTP' --callback_data '_add_sstp'
ShellBot.InlineKeyboardButton --button 'menu_sstppx' --line 2 --text 'Delete SSTP' --callback_data '_delete_sstp'
ShellBot.InlineKeyboardButton --button 'menu_sstppx' --line 3 --text 'Create Trial SSTP' --callback_data '_trial_sstp'
ShellBot.InlineKeyboardButton --button 'menu_sstppx' --line 4 --text 'List Member SSTP' --callback_data '_member_sstp'
ShellBot.InlineKeyboardButton --button 'menu_sstppx' --line 6 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_gobacksstp'
ShellBot.regHandleFunction --function add_sstp --callback_data _add_sstp
ShellBot.regHandleFunction --function del_sstp --callback_data _delete_sstp
ShellBot.regHandleFunction --function add_sstp_trial --callback_data _trial_sstp
ShellBot.regHandleFunction --function list_member_sstp --callback_data _member_sstp
ShellBot.regHandleFunction --function admin_service_see --callback_data _gobacksstp
unset keyboardsstp
keyboardsstp="$(ShellBot.InlineKeyboardMarkup -b 'menu_sstppx')"

unset res_menu_sstppx
res_menu_sstppx=''
ShellBot.InlineKeyboardButton --button 'res_menu_sstppx' --line 1 --text 'âž• Add SSTP âž•' --callback_data '_res_add_sstp'
ShellBot.InlineKeyboardButton --button 'res_menu_sstppx' --line 2 --text 'â³ Create Trial SSTP â³' --callback_data '_res_trial_sstp'
ShellBot.InlineKeyboardButton --button 'res_menu_sstppx' --line 3 --text 'ðŸŸ¢ List Member SSTP ðŸŸ¢' --callback_data '_res_member_sstp'
ShellBot.InlineKeyboardButton --button 'res_menu_sstppx' --line 4 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_res_gobacksstp'
ShellBot.regHandleFunction --function add_sstp --callback_data _res_add_sstp
ShellBot.regHandleFunction --function add_sstp_trial --callback_data _res_trial_sstp
ShellBot.regHandleFunction --function list_member_sstp --callback_data _res_member_sstp
ShellBot.regHandleFunction --function menu_reserv --callback_data _res_gobacksstp
unset keyboardsstpres
keyboardsstpres="$(ShellBot.InlineKeyboardMarkup -b 'res_menu_sstppx')"

#====== ALL ABOUT L2TP =======#

res_l2tp_menus() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "SELECT AN OPTION BELOW:" \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'res_menu_l2tp')"
        return 0
    }
}

l2tp_menus() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "SELECT AN OPTION BELOW:" \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'menu_l2tp')"
        return 0
    }
}

add_l2tp() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.deleteMessage	--chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ‘¤ CREATE USER L2TP ðŸ‘¤\n\nUsername:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

func_add_l2tp() {
file_user=$1
userna=$(sed -n '1 p' $file_user | cut -d' ' -f2)
passw=$(sed -n '2 p' $file_user | cut -d' ' -f2)
data=$(sed -n '3 p' $file_user | cut -d' ' -f2)
exp=$(echo "$data" | awk -F'/' '{print $2FS$1FS$3}' | xargs -i date -d'{}' +%Y-%m-%d)        
domain=$(cat /etc/$raycheck/domain)

[[ "${message_from_id[$id]}" = "$Admin_ID" ]] && {
mkdir -p /etc/.maAsiss/info-user-l2tp
echo "$userna:$data" >/etc/.maAsiss/info-user-l2tp/$userna

# Add or update VPN user
cat >> /etc/ppp/chap-secrets <<EOF
"$userna" l2tpd "$passw" *
EOF

VPN_PASSWORD_ENC=$(openssl passwd -1 "$passw")
cat >> /etc/ipsec.d/passwd <<EOF
$userna:$VPN_PASSWORD_ENC:xauth-psk
EOF

# Update file attributes
chmod 600 /etc/ppp/chap-secrets* /etc/ipsec.d/passwd*
echo -e "### $userna $exp">>"/var/lib/scrz-prem/data-user-l2tp"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>         ðŸ”¸ L2TP ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="IP : $IPs\n"
env_msg+="Username : $userna\n"
env_msg+="Password : $passw\n"
env_msg+="Expired On : $data ðŸ—“ \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="IPsec PSK : myvpn\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
systemctl restart l2tpd > /dev/null 2>&1
return 0
}

pricel2tp=$(grep -w "Price L2TP" /etc/.maAsiss/price | awk '{print $NF}')
saldores=$(grep -w "Saldo_Reseller" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id} | awk '{print $NF}')
if [ "$saldores" -lt "$pricel2tp" ]; then
ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "â›” Your Balance Not Enough â›”" \
    --parse_mode html
return 0
else
mkdir -p /etc/.maAsiss/info-user-l2tp
mkdir -p /etc/.maAsiss/db_reseller/${message_from_id}/user_l2tp
echo "$userna:$data" >/etc/.maAsiss/db_reseller/${message_from_id}/user_l2tp/$userna
echo "$userna:$data" >/etc/.maAsiss/info-user-l2tp/$userna
_CurrSal=$(echo $saldores - $pricel2tp | bc)
sed -i "/Saldo_Reseller/c\Saldo_Reseller: $_CurrSal" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id}
sed -i "/${message_from_id}/c\USER: ${message_from_id} SALDO: $_CurrSal TYPE: reseller" $User_Active

cat >> /etc/ppp/chap-secrets <<EOF
"$userna" l2tpd "$passw" *
EOF

VPN_PASSWORD_ENC=$(openssl passwd -1 "$passw")
cat >> /etc/ipsec.d/passwd <<EOF
$userna:$VPN_PASSWORD_ENC:xauth-psk
EOF

# Update file attributes
chmod 600 /etc/ppp/chap-secrets* /etc/ipsec.d/passwd*
echo -e "### $userna $exp">>"/var/lib/scrz-prem/data-user-l2tp"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>         ðŸ”¸ L2TP ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="IP : $IPs\n"
env_msg+="Username : $userna\n"
env_msg+="Password : $passw\n"
env_msg+="Expired On : $data ðŸ—“ \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="IPsec PSK : myvpn\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
echo "$userna 30Days L2TP | ${message_from_username}" >> /etc/.maAsiss/log_res

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
systemctl restart l2tpd > /dev/null 2>&1
return 0
fi
}

func_add_l2tp2() {
file_user=$1
userna=$(sed -n '1 p' $file_user | cut -d' ' -f2)
passw=$(sed -n '2 p' $file_user | cut -d' ' -f2)
data=$(sed -n '3 p' $file_user | cut -d' ' -f2)
exp=$(echo "$data" | awk -F'/' '{print $2FS$1FS$3}' | xargs -i date -d'{}' +%Y-%m-%d)        
domain=$(cat /etc/$raycheck/domain)

[[ "${message_from_id[$id]}" = "$Admin_ID" ]] && {
mkdir -p /etc/.maAsiss/info-user-l2tp
echo "$userna:$data" >/etc/.maAsiss/info-user-l2tp/$userna

# Add or update VPN user
cat >> /etc/ppp/chap-secrets <<EOF
"$userna" l2tpd "$passw" *
EOF

VPN_PASSWORD_ENC=$(openssl passwd -1 "$passw")
cat >> /etc/ipsec.d/passwd <<EOF
$userna:$VPN_PASSWORD_ENC:xauth-psk
EOF

# Update file attributes
chmod 600 /etc/ppp/chap-secrets* /etc/ipsec.d/passwd*
echo -e "### $userna $exp">>"/var/lib/scrz-prem/data-user-l2tp"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>         ðŸ”¸ L2TP ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="IP : $IPs\n"
env_msg+="Username : $userna\n"
env_msg+="Password : $passw\n"
env_msg+="Expired On : $data ðŸ—“ \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="IPsec PSK : myvpn\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
systemctl restart l2tpd > /dev/null 2>&1
return 0
}

pricel2tp=$(grep -w "Price L2TP" /etc/.maAsiss/price | awk '{print $NF}')
saldores=$(grep -w "Saldo_Reseller" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id} | awk '{print $NF}')
urday=$(echo $pricel2tp * 2 | bc )
if [ "$saldores" -lt "$urday" ]; then
ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "â›” Your Balance Not Enough â›”" \
    --parse_mode html
return 0
else
mkdir -p /etc/.maAsiss/info-user-l2tp
mkdir -p /etc/.maAsiss/db_reseller/${message_from_id}/user_l2tp
echo "$userna:$data" >/etc/.maAsiss/db_reseller/${message_from_id}/user_l2tp/$userna
echo "$userna:$data" >/etc/.maAsiss/info-user-l2tp/$userna
_CurrSal=$(echo $saldores - $urday | bc)
sed -i "/Saldo_Reseller/c\Saldo_Reseller: $_CurrSal" /etc/.maAsiss/db_reseller/${message_from_id}/${message_from_id}
sed -i "/${message_from_id}/c\USER: ${message_from_id} SALDO: $_CurrSal TYPE: reseller" $User_Active

cat >> /etc/ppp/chap-secrets <<EOF
"$userna" l2tpd "$passw" *
EOF

VPN_PASSWORD_ENC=$(openssl passwd -1 "$passw")
cat >> /etc/ipsec.d/passwd <<EOF
$userna:$VPN_PASSWORD_ENC:xauth-psk
EOF

# Update file attributes
chmod 600 /etc/ppp/chap-secrets* /etc/ipsec.d/passwd*
echo -e "### $userna $exp">>"/var/lib/scrz-prem/data-user-l2tp"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>         ðŸ”¸ L2TP ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="IP : $IPs\n"
env_msg+="Username : $userna\n"
env_msg+="Password : $passw\n"
env_msg+="Expired On : $data ðŸ—“ \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="IPsec PSK : myvpn\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
echo "$userna 60Days L2TP | ${message_from_username}" >> /etc/.maAsiss/log_res

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
systemctl restart l2tpd > /dev/null 2>&1
return 0
fi
}

del_l2tp() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.deleteMessage	--chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ—‘ REMOVE USER L2TP ðŸ—‘\n\nUsername:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

func_del_l2tp() {
    export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    userna=$1
    if [[ "${message_from_id[$id]}" = "$Admin_ID" ]]; then
        exp=$(grep -E "^### " /var/lib/scrz-prem/data-user-l2tp | cut -d ' ' -f 3 )
        sed -i '/^"'"$userna"'" l2tpd/d' /etc/ppp/chap-secrets
        sed -i '/^'"$userna"':\$1\$/d' /etc/ipsec.d/passwd
        sed -i "/^### $userna $exp/d" /var/lib/scrz-prem/data-user-l2tp
        chmod 600 /etc/ppp/chap-secrets* /etc/ipsec.d/passwd*
        datata=$(find /etc/.maAsiss/ -name $userna)
        for accc in "${datata[@]}"
        do
        rm $accc
        done
        systemctl restart l2tpd> /dev/null 2>&1
    elif [[ "${message_from_id[$id]}" != "$Admin_ID" ]]; then
        [[ ! -e /etc/.maAsiss/db_reseller/${message_from_id}/user_l2tp/$userna ]] && {
            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                --text "$(echo -e "â›” THE USER DOES NOT EXIST â›”")" \
                --parse_mode html
            _erro='1'      
            ShellBot.sendMessage --chat_id ${callack_query_message_chat_id[$id]} \
                 --text "Func Error Do Nothing" \
                 --reply_markup "$(ShellBot.ForceReply)"
            return 0
        }
        exp=$(grep -E "^### " /var/lib/scrz-prem/data-user-l2tp | cut -d ' ' -f 3 )
        sed -i '/^"'"$userna"'" l2tpd/d' /etc/ppp/chap-secrets
        sed -i '/^'"$userna"':\$1\$/d' /etc/ipsec.d/passwd
        sed -i "/^### $userna $exp/d" /var/lib/scrz-prem/data-user-l2tp
        chmod 600 /etc/ppp/chap-secrets* /etc/ipsec.d/passwd*
        rm -f /etc/.maAsiss/db_reseller/${message_from_id}/user_l2tp/$userna
        rm -f /etc/.maAsiss/info-user-l2tp/$userna
        systemctl restart l2tpd > /dev/null 2>&1
    fi
}

add_l2tp_trial() {
    if [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]]; then
        ShellBot.deleteMessage	--chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ‘¤ CREATE TRIAL L2TP ðŸ‘¤\n\nHow many hours should it last ? EX: 1:" \
            --reply_markup "$(ShellBot.ForceReply)"
    elif [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]]; then
            ShellBot.deleteMessage	--chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                --text "ðŸ‘¤ CREATE TRIAL L2TP ðŸ‘¤\n\nHow many hours should it last ? EX: 1:" \
                --reply_markup "$(ShellBot.ForceReply)"       
    else
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    fi
}

func_add_l2tp_trial() {
mkdir -p /etc/.maAsiss/info-user-l2tp
    userna=$(echo Trial`</dev/urandom tr -dc A-Z0-9 | head -c4`)
    t_time=$1
    passw="1"
    domain=$(cat /etc/$raycheck/domain)
    exp=`date -d "2 days" +"%Y-%m-%d"`
    tuserdate=$(date '+%C%y/%m/%d' -d " +2 days")
    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
       mkdir -p /etc/.maAsiss/db_reseller/${message_from_id}/trial-fold
    }
    [[ -z $t_time ]] && {
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
            --text "$(echo -e "â›” error try again")" \
            --parse_mode html
        return 0
        _erro='1'
    }

[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
    echo "$userna:$passw:$exp" >/etc/.maAsiss/db_reseller/${message_from_id}/user_l2tp/$userna
    echo "$userna:$passw:$exp" >/etc/.maAsiss/db_reseller/${message_from_id}/trial-fold/$userna
}
dir_teste="/etc/.maAsiss/db_reseller/${message_from_id}/user_l2tp/$userna"
dir_teste2="/etc/.maAsiss/db_reseller/${message_from_id}/trial-fold/$userna"
dates=`date`
cat <<-EOF >/etc/.maAsiss/$userna.sh
#!/bin/bash
# USER TRIAL L2TP by ${message_from_id} $dates
exp=\$(grep -E "^###" /var/lib/scrz-prem/data-user-l2tp | cut -d ' ' -f 3 )
sed -i '/^"'"$userna"'" l2tpd/d' /etc/ppp/chap-secrets
sed -i '/^'"$userna"':\$1\$/d' /etc/ipsec.d/passwd
sed -i "/^### $userna $exp/d" /var/lib/scrz-prem/data-user-l2tp
chmod 600 /etc/ppp/chap-secrets* /etc/ipsec.d/passwd*
rm -f /etc/.maAsiss/db_reseller/${message_from_id}/user_l2tp/$userna
rm -f /etc/.maAsiss/info-user-l2tp/$userna
systemctl restart l2tpd > /dev/null 2>&1
[[ -e $dir_teste ]] && rm $dir_teste
[[ -e $dir_teste2 ]] && rm $dir_teste2
rm -f /etc/.maAsiss/$userna
rm -f /etc/.maAsiss/$userna.sh
EOF

chmod +x /etc/.maAsiss/$userna.sh
echo "/etc/.maAsiss/$userna.sh" | at now + $t_time hour >/dev/null 2>&1
[[ "$t_time" == '1' ]] && hrs="hour" || hrs="hours"          

cat >> /etc/ppp/chap-secrets <<EOF
"$userna" l2tpd "$passw" *
EOF

VPN_PASSWORD_ENC=$(openssl passwd -1 "$passw")
cat >> /etc/ipsec.d/passwd <<EOF
$userna:$VPN_PASSWORD_ENC:xauth-psk
EOF

# Update file attributes
chmod 600 /etc/ppp/chap-secrets* /etc/ipsec.d/passwd*
echo -e "### $userna $exp">>"/var/lib/scrz-prem/data-user-l2tp"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>         ðŸ”¸ L2TP ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="IP : $IPs\n"
env_msg+="Username : $userna\n"
env_msg+="Password : $passw\n"
env_msg+="Expired On : $t_time $hrs â³ \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="IPsec PSK : myvpn\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
    
systemctl restart l2tpd > /dev/null 2>&1
return 0
}

list_member_l2tp() {
   if [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]]; then
      _result=$(grep -wE "^###" "/var/lib/scrz-prem/data-user-l2tp" | cut -d ' ' -f2 | column -t | sort | uniq | wc -l)
      _results=$(grep -wE "^###" "/var/lib/scrz-prem/data-user-l2tp" | cut -d ' ' -f2 | column -t | sort | uniq )
   elif [[ "${callback_query_from_id[$id]}" != "$Admin_ID" ]]; then
      _result=$(ls /etc/.maAsiss/db_reseller/${callback_query_from_id}/user_l2tp | wc -l)
      _results=$(ls /etc/.maAsiss/db_reseller/${callback_query_from_id}/user_l2tp )
   else
      ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "â›” ACCESS DENIED â›”" \
                --parse_mode html
      return 0
   fi
   if [ "$_result" = "0" ]; then
      ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
                --text "â›” YOU DONT HAVE ANY USER YET â›”" \
                --parse_mode html
      return 0
   else
      ShellBot.deleteMessage	--chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
      ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
         --text "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n ðŸŸ¢ L2TP Member List ðŸŸ¢\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n\n$_results\n\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n" \
         --parse_mode html
      return 0
   fi
}

unset menu_l2tp
menu_l2tp=''
ShellBot.InlineKeyboardButton --button 'menu_l2tp' --line 1 --text 'Add L2TP' --callback_data '_add_l2tp'
ShellBot.InlineKeyboardButton --button 'menu_l2tp' --line 2 --text 'Delete L2TP' --callback_data '_delete_l2tp'
ShellBot.InlineKeyboardButton --button 'menu_l2tp' --line 3 --text 'Create Trial L2TP' --callback_data '_trial_l2tp'
ShellBot.InlineKeyboardButton --button 'menu_l2tp' --line 4 --text 'List Member L2TP' --callback_data '_member_l2tp'
ShellBot.InlineKeyboardButton --button 'menu_l2tp' --line 6 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_gobackl2tp'
ShellBot.regHandleFunction --function add_l2tp --callback_data _add_l2tp
ShellBot.regHandleFunction --function del_l2tp --callback_data _delete_l2tp
ShellBot.regHandleFunction --function add_l2tp_trial --callback_data _trial_l2tp
ShellBot.regHandleFunction --function list_member_l2tp --callback_data _member_l2tp
ShellBot.regHandleFunction --function admin_service_see --callback_data _gobackl2tp
unset keyboardl2tp
keyboardl2tp="$(ShellBot.InlineKeyboardMarkup -b 'menu_l2tp')"

unset res_menu_l2tp
res_menu_l2tp=''
ShellBot.InlineKeyboardButton --button 'res_menu_l2tp' --line 1 --text 'âž• Add L2TP âž•' --callback_data '_res_add_l2tp'
ShellBot.InlineKeyboardButton --button 'res_menu_l2tp' --line 3 --text 'â³ Create Trial L2TP â³' --callback_data '_res_trial_l2tp'
ShellBot.InlineKeyboardButton --button 'res_menu_l2tp' --line 4 --text 'ðŸŸ¢ List Member L2TP ðŸŸ¢' --callback_data '_res_member_l2tp'
ShellBot.InlineKeyboardButton --button 'res_menu_l2tp' --line 5 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_res_gobackl2tp'
ShellBot.regHandleFunction --function add_l2tp --callback_data _res_add_l2tp
ShellBot.regHandleFunction --function add_l2tp_trial --callback_data _res_trial_l2tp
ShellBot.regHandleFunction --function list_member_l2tp --callback_data _res_member_l2tp
ShellBot.regHandleFunction --function menu_reserv --callback_data _res_gobackl2tp
unset keyboardl2tpres
keyboardl2tpres="$(ShellBot.InlineKeyboardMarkup -b 'res_menu_l2tp')"





#====== SETTINGS DATABASE =======#

Ganti_Harga() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.deleteMessage	--chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ’° Change Price ðŸ’°\n\nPrice SSH:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

public_mod() {
[[ -f /etc/.maAsiss/public_mode/settings ]] && {
ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
     --text "âœ… Public mode is already on âœ…"
return 0
}
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        [[ ! -d /etc/.maAsiss/public_mode ]] && mkdir /etc/.maAsiss/public_mode
        ShellBot.deleteMessage	--chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸŒ Enable Public Mode ðŸŒ\n\nExpired Days [ex:3]:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

public_mod_off() {
[[ ! -f /etc/.maAsiss/public_mode/settings ]] && {
ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
     --text "â›” Public mode is currently off â›”"
return 0
} || {
rm -rf /etc/.maAsiss/public_mode
ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
   --text "âœ… Success disable public mode âœ…"
return 0
}   
}

Add_Info_Reseller() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.deleteMessage	--chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ“¢ Info for reseller ðŸ“¢\n\ntype your information:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

unblock_usr() {
    [[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] && {
        ShellBot.deleteMessage	--chat_id ${callback_query_message_chat_id[$id]} \
              --message_id ${callback_query_message_message_id[$id]}
        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
            --text "ðŸ˜¤ Unblock user ðŸ˜¤\n\nInput user ID to unblock:" \
            --reply_markup "$(ShellBot.ForceReply)"
    } || {
        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
            --text "â›” ACCESS DENIED â›”"
        return 0
    }
}

Del_Info_Reseller() {
[[ ! -f /etc/.maAsiss/update-info ]] && {
ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
     --text "â›” No Information Available â›”"
return 0
} || {
rm -f /etc/.maAsiss/update-info
ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
     --text "âœ… Success Delete Information âœ…"
return 0
}   
}

admin_server() {
[[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "Select Option Below:" \
            --parse_mode html \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'back_menu_admin')"
        return 0
    }
}


#======= MAIN MENU =========
see_sys() {
        systemctl is-active --quiet stunnel4 && stsstn="Running ðŸŸ¢" || stsstn="Not Running ðŸ”´"
        systemctl is-active --quiet dropbear && stsdb="Running ðŸŸ¢" || stsdb="Not Running ðŸ”´"
        systemctl is-active --quiet $raycheck && stsray="Running ðŸŸ¢" || stsray="Not Running ðŸ”´"
        systemctl is-active --quiet trojan-go && ststrgo="Running ðŸŸ¢" || ststrgo="Not Running ðŸ”´"
        systemctl is-active --quiet wg-quick@wg0 && stswg="Running ðŸŸ¢" || stswg="Not Running ðŸ”´"
        systemctl is-active --quiet shadowsocks-libev && stsss="Running ðŸŸ¢" || stsss="Not Running ðŸ”´"
        systemctl is-active --quiet ssrmu && stsssr="Running ðŸŸ¢" || stsssr="Not Running ðŸ”´"
        systemctl is-active --quiet accel-ppp && stssstp="Running ðŸŸ¢" || stssstp="Not Running ðŸ”´"
        systemctl is-active --quiet pptpd && stspptp="Running ðŸŸ¢" || stspptp="Not Running ðŸ”´"
        systemctl is-active --quiet xl2tpd && stsl2tp="Running ðŸŸ¢" || stsl2tp="Not Running ðŸ”´"

        local env_msg
        env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="<b> WELCOME TO BOT $nameStore</b>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="ðŸŸ¢ Status Service : \n\n"
        env_msg+="<code>Dropbear     : $stsdb\n"
        env_msg+="Stunnel      : $stsstn\n"
        env_msg+="VMess        : $stsray\n"
        env_msg+="VLess        : $stsray\n"
        env_msg+="Trojan       : $stsray\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
[[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "$env_msg" \
            --parse_mode html \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'back_menu_admin')"
        return 0
    }
}

sets_menu() {
        local env_msg
        env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
        env_msg+="<b> WELCOME TO BOT $nameStore</b>\n"
        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
[[ "${callback_query_from_id[$id]}" == "$Admin_ID" ]] || [[ "$(grep -wc ${callback_query_from_id} $User_Active)" != '0' ]] && {
        ShellBot.editMessageText --chat_id ${callback_query_message_chat_id[$id]} \
            --message_id ${callback_query_message_message_id[$id]} \
            --text "$env_msg" \
            --parse_mode html \
            --reply_markup "$(ShellBot.InlineKeyboardMarkup --button 'sett_menus')"
        return 0
    }
}


unset menuzzz
menuzzz=''
ShellBot.InlineKeyboardButton --button 'menuzzz' --line 1 --text 'ðŸ‘¨â€ðŸ¦± Add Reseller ðŸ‘¨â€ðŸ¦±' --callback_data '_add_res'
ShellBot.InlineKeyboardButton --button 'menuzzz' --line 2 --text 'ðŸ’° Top Up Balance ðŸ’°' --callback_data '_top_up_res'
ShellBot.InlineKeyboardButton --button 'menuzzz' --line 3 --text 'ðŸ“ƒ List %26 Info Reseller ðŸ“ƒ' --callback_data '_list_res'
ShellBot.InlineKeyboardButton --button 'menuzzz' --line 4 --text 'ðŸ—‘ Remove Reseller ðŸ—‘' --callback_data '_del_res'
ShellBot.InlineKeyboardButton --button 'menuzzz' --line 5 --text 'ðŸŒ€ Reset Saldo Reseller ðŸŒ€' --callback_data '_reset_res'
ShellBot.InlineKeyboardButton --button 'menuzzz' --line 10 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_gobakcuy'
ShellBot.regHandleFunction --function add_res --callback_data _add_res
ShellBot.regHandleFunction --function topup_res --callback_data _top_up_res
ShellBot.regHandleFunction --function func_list_res --callback_data _list_res
ShellBot.regHandleFunction --function del_res --callback_data _del_res
ShellBot.regHandleFunction --function reset_saldo_res --callback_data _reset_res
ShellBot.regHandleFunction --function menu_func_cb --callback_data _gobakcuy
unset keyboardzz
keyboardzz="$(ShellBot.InlineKeyboardMarkup -b 'menuzzz')"


unset menu_adm_ser
menu_adm_ser=''
ShellBot.InlineKeyboardButton --button 'menu_adm_ser' --line 1 --text 'â€¢ Menu SSH â€¢' --callback_data '_menussh'
ShellBot.InlineKeyboardButton --button 'menu_adm_ser' --line 2 --text 'â€¢ Menu VMess â€¢' --callback_data '_menuv2ray'
ShellBot.InlineKeyboardButton --button 'menu_adm_ser' --line 1 --text 'â€¢ Menu Trojan â€¢' --callback_data '_menutrojan'
ShellBot.InlineKeyboardButton --button 'menu_adm_ser' --line 2 --text 'â€¢ Menu VLess â€¢' --callback_data '_menuvless'
#ShellBot.InlineKeyboardButton --button 'menu_adm_ser' --line 3 --text 'â€¢ Menu ShadowSock â€¢' --callback_data '_menuss'
#ShellBot.InlineKeyboardButton --button 'menu_adm_ser' --line 4 --text 'â€¢ Menu ShadowSock-R â€¢' --callback_data '_menussr'
ShellBot.InlineKeyboardButton --button 'menu_adm_ser' --line 7 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_mebck'
ShellBot.regHandleFunction --function ssh_menus --callback_data _menussh
ShellBot.regHandleFunction --function v2ray_menus --callback_data _menuv2ray
ShellBot.regHandleFunction --function trojan_menus --callback_data _menutrojan
ShellBot.regHandleFunction --function vless_menus --callback_data _menuvless
#ShellBot.regHandleFunction --function ss_menus --callback_data _menuss
#ShellBot.regHandleFunction --function ssr_menus --callback_data _menussr
ShellBot.regHandleFunction --function menu_func_cb --callback_data _mebck
unset menu_adm_ser1
menu_adm_ser1="$(ShellBot.InlineKeyboardMarkup -b 'menu_adm_ser')"


unset list_bck_adm
list_bck_adm=''
ShellBot.InlineKeyboardButton --button 'list_bck_adm' --line 1 --text 'ðŸ”™ Back ðŸ”™' --callback_data 'list_bck_'
ShellBot.regHandleFunction --function res_menus --callback_data list_bck_
unset list_bck_adm1
list_bck_adm1="$(ShellBot.InlineKeyboardMarkup -b 'list_bck_adm')"


unset status_disable
status_disable=''
ShellBot.InlineKeyboardButton --button 'status_disable' --line 1 --text 'ðŸ’¡ How To Use ðŸ’¡' --callback_data '_how_to'
ShellBot.InlineKeyboardButton --button 'status_disable' --line 2 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_stsbck'
ShellBot.regHandleFunction --function how_to_order --callback_data _how_to
ShellBot.regHandleFunction --function menu_func_cb --callback_data _stsbck
unset status_disable1
status_disable1="$(ShellBot.InlineKeyboardMarkup -b 'status_disable')"

unset status_how_to
status_how_to=''
ShellBot.InlineKeyboardButton --button 'status_how_to' --line 1 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_howbck'
ShellBot.regHandleFunction --function status_order --callback_data _howbck
unset status_how_to1
status_how_to1="$(ShellBot.InlineKeyboardMarkup -b 'status_how_to')"

unset sett_menus
sett_menus=''
ShellBot.InlineKeyboardButton --button 'sett_menus' --line 1 --text 'ðŸ”’ Status Order ðŸ”’' --callback_data '_orderfo'
ShellBot.InlineKeyboardButton --button 'sett_menus' --line 1 --text 'ðŸ’° Change Price ðŸ’°' --callback_data '_price'
ShellBot.InlineKeyboardButton --button 'sett_menus' --line 2 --text 'ðŸ¤µ Reseller ðŸ¤µ' --callback_data '_ressssseller'
ShellBot.InlineKeyboardButton --button 'sett_menus' --line 2 --text 'âœï¸ See Log Reseller âœï¸' --callback_data '_seelog'
ShellBot.InlineKeyboardButton --button 'sett_menus' --line 3 --text 'ðŸŒ OpenPublic ðŸŒ' --callback_data '_publicmode'
ShellBot.InlineKeyboardButton --button 'sett_menus' --line 3 --text 'ðŸ“› DisablePublic ðŸ“›' --callback_data '_publicmodeoff'
ShellBot.InlineKeyboardButton --button 'sett_menus' --line 4 --text 'ðŸ”” Add Info ðŸ””' --callback_data '_addinfo'
ShellBot.InlineKeyboardButton --button 'sett_menus' --line 4 --text 'ðŸ”• Del Info ðŸ”•' --callback_data '_delinfo'
ShellBot.InlineKeyboardButton --button 'sett_menus' --line 10 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_setssbck'
ShellBot.regHandleFunction --function status_order --callback_data _orderfo
ShellBot.regHandleFunction --function Add_Info_Reseller --callback_data _addinfo
ShellBot.regHandleFunction --function Del_Info_Reseller --callback_data _delinfo
ShellBot.regHandleFunction --function Ganti_Harga --callback_data _price
ShellBot.regHandleFunction --function res_menus --callback_data _ressssseller
ShellBot.regHandleFunction --function see_log --callback_data _seelog
ShellBot.regHandleFunction --function public_mod --callback_data _publicmode
ShellBot.regHandleFunction --function public_mod_off --callback_data _publicmodeoff
ShellBot.regHandleFunction --function menu_func_cb --callback_data _setssbck
unset sett_menus1
sett_menus1="$(ShellBot.InlineKeyboardMarkup -b 'sett_menus')"

unset menu
menu=''
ShellBot.InlineKeyboardButton --button 'menu' --line 1 --text 'â‡ï¸ Open Service â‡ï¸ï¸' --callback_data '_openserv'
ShellBot.InlineKeyboardButton --button 'menu' --line 1 --text 'ðŸŸ¢ Status Service ðŸŸ¢ï¸ï¸' --callback_data '_stsserv'
ShellBot.InlineKeyboardButton --button 'menu' --line 2 --text 'ðŸ“‹ Current Price ðŸ“‹' --callback_data '_priceinfo'
ShellBot.InlineKeyboardButton --button 'menu' --line 2 --text 'âš™ï¸ Settings Menu âš™ï¸' --callback_data '_menusettss'
ShellBot.InlineKeyboardButton --button 'menu' --line 10 --text 'âš ï¸ Unblock User âš ï¸' --callback_data '_unblck'
ShellBot.regHandleFunction --function admin_service_see --callback_data _openserv
ShellBot.regHandleFunction --function see_sys --callback_data _stsserv
ShellBot.regHandleFunction --function admin_price_see --callback_data _priceinfo
ShellBot.regHandleFunction --function sets_menu --callback_data _menusettss
ShellBot.regHandleFunction --function unblock_usr --callback_data _unblck
unset keyboard1
keyboard1="$(ShellBot.InlineKeyboardMarkup -b 'menu')"

unset menu_re_ser
menu_re_ser=''
ShellBot.InlineKeyboardButton --button 'menu_re_ser' --line 1 --text 'â€¢ SSH â€¢' --callback_data '_res_ssh_menu'
ShellBot.InlineKeyboardButton --button 'menu_re_ser' --line 2 --text 'â€¢ VMess â€¢' --callback_data '_res_v2ray_menus'
ShellBot.InlineKeyboardButton --button 'menu_re_ser' --line 1 --text 'â€¢ Trojan â€¢' --callback_data '_res_trojan_menus'
ShellBot.InlineKeyboardButton --button 'menu_re_ser' --line 2 --text 'â€¢ VLess â€¢' --callback_data '_res_vless_menus'
#ShellBot.InlineKeyboardButton --button 'menu_re_ser' --line 6 --text 'â€¢ ShadowSocks â€¢' --callback_data '_res_ss_menus'
#ShellBot.InlineKeyboardButton --button 'menu_re_ser' --line 6 --text 'â€¢ ShadowSocks-R â€¢' --callback_data '_res_ssr_menus'
ShellBot.InlineKeyboardButton --button 'menu_re_ser' --line 10 --text 'ðŸ”™ Back ðŸ”™' --callback_data 'clses_ser_res'
ShellBot.regHandleFunction --function res_ssh_menu --callback_data _res_ssh_menu
ShellBot.regHandleFunction --function res_v2ray_menus --callback_data _res_v2ray_menus
ShellBot.regHandleFunction --function res_trojan_menus --callback_data _res_trojan_menus
ShellBot.regHandleFunction --function res_vless_menus --callback_data _res_vless_menus
#ShellBot.regHandleFunction --function res_ss_menus --callback_data _res_ss_menus
#ShellBot.regHandleFunction --function res_ssr_menus --callback_data _res_ssr_menus
ShellBot.regHandleFunction --function res_opener --callback_data clses_ser_res
unset menu_re_ser1
menu_re_ser1="$(ShellBot.InlineKeyboardMarkup -b 'menu_re_ser')"


unset menu_re_main
menu_re_main=''
ShellBot.InlineKeyboardButton --button 'menu_re_main' --line 1 --text 'âš–ï¸ Open Service âš–ï¸ï¸' --callback_data '_pps_serv'
ShellBot.InlineKeyboardButton --button 'menu_re_main' --line 2 --text 'ðŸŸ¢ Status Service ðŸŸ¢ï¸' --callback_data '_sts_serv'
ShellBot.InlineKeyboardButton --button 'menu_re_main' --line 3 --text 'ðŸ“š Info Port ðŸ“š' --callback_data '_pports'
ShellBot.InlineKeyboardButton --button 'menu_re_main' --line 4 --text 'ðŸ“ Close Menu ðŸ“' --callback_data 'closesss'
ShellBot.regHandleFunction --function menu_reserv --callback_data _pps_serv
ShellBot.regHandleFunction --function see_sys --callback_data _sts_serv
ShellBot.regHandleFunction --function info_port --callback_data _pports
ShellBot.regHandleFunction --function res_closer --callback_data closesss
unset menu_re_main1
menu_re_main1="$(ShellBot.InlineKeyboardMarkup -b 'menu_re_main')"

unset back_menu
back_menu=''
ShellBot.InlineKeyboardButton --button 'back_menu' --line 1 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_res_back_opn'
ShellBot.regHandleFunction --function res_opener --callback_data _res_back_opn
unset back_menu1
back_menu1="$(ShellBot.InlineKeyboardMarkup -b 'back_menu')"

unset back_menu_admin
back_menu_admin=''
ShellBot.InlineKeyboardButton --button 'back_menu_admin' --line 1 --text 'ðŸ”™ Back ðŸ”™' --callback_data '_res_backadm_opn'
ShellBot.regHandleFunction --function menu_func_cb --callback_data _res_backadm_opn
unset back_menu_admin1
back_menu_admin1="$(ShellBot.InlineKeyboardMarkup -b 'back_menu_admin')"

unset menu_re_main_updater
menu_re_main_updater=''
ShellBot.InlineKeyboardButton --button 'menu_re_main_updater' --line 1 --text 'ðŸ“‚ Open Menu ðŸ“‚' --callback_data '_res_main_opn'
ShellBot.regHandleFunction --function res_opener --callback_data _res_main_opn
unset menu_re_main_updater1
menu_re_main_updater1="$(ShellBot.InlineKeyboardMarkup -b 'menu_re_main_updater')"

hantuu() {
    ShellBot.deleteMessage --chat_id ${message_chat_id[$id]} \
             --message_id ${message_message_id[$id]}
    [[ "${message_from_id[$id]}" = "$Admin_ID" ]] && {
        while read _atvs; do
              msg1+="â€¢ [ ðŸ‘»Anonymous](tg://user?id=$_atvs) \n"
        done <<<"$(cat /etc/.maAsiss/User_Generate_Token |  awk '{print $3}' )"
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
              --text "$msg1" \
              --parse_mode markdown
        return 0
    }
}
#================================| PUBLIC MODE |=====================================
_if_public() {
[[ "$(grep -wc ${message_chat_id[$id]} $User_Flood)" = '1' ]] && return 0 || AUTOBLOCK
[[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
   [[ ! -f /etc/.maAsiss/public_mode/settings ]] && {
       ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
            --text "<b>Public Mode Has Been Closed by Admin</b>" \
            --parse_mode html
       return 0
   }
}
ossl=`cat /root/log-install.txt | grep -w " OpenVPN" | cut -f2 -d: | awk '{print $6}'`
opensh=`cat /root/log-install.txt | grep -w "OpenSSH" | cut -f2 -d: | awk '{print $1}'`
db=`cat /root/log-install.txt | grep -w "Dropbear" | cut -f2 -d: | awk '{print $1,$2}'`
ssl="$(cat /root/log-install.txt | grep -w "Stunnel4" | cut -d: -f2)"
sqd="$(cat /root/log-install.txt | grep -w "Squid" | cut -d: -f2)"
portovpn=$(grep -w " OpenVPN" /root/log-install.txt | awk '{print $5,$7,$9}')
portsshws=`cat /root/log-install.txt | grep -w "SSH Websocket" | cut -d: -f2 | awk '{print $1}'`
tls="$(cat /root/log-install.txt | grep -w "Vmess TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat /root/log-install.txt | grep -w "Vmess None TLS" | cut -d: -f2|sed 's/ //g')"
trgo="$(cat /root/log-install.txt | grep -w "Trojan Go" | cut -d: -f2|sed 's/ //g')"
tr="$(cat /root/log-install.txt | grep -w "Trojan " | cut -d: -f2|sed 's/ //g')"
OhpSSH=`cat /root/log-install.txt | grep -w "OHP SSH" | cut -d: -f2 | awk '{print $1}'`
OhpDB=`cat /root/log-install.txt | grep -w "OHP DBear" | cut -d: -f2 | awk '{print $1}'`
OhpOVPN=`cat /root/log-install.txt | grep -w "OHP OpenVPN" | cut -d: -f2 | awk '{print $1}'`
wsssl=`cat /root/log-install.txt | grep -w "SSH SSL Websocket" | cut -d: -f2 | awk '{print $1}'`
xray="$(cat /root/log-install.txt | grep -w "VLess TCP XTLS" | cut -d: -f2|sed 's/ //g')"

getLimits=$(grep -w "MAX_USERS" "/etc/.maAsiss/public_mode/settings" | awk '{print $NF}')
dx=$(ls /etc/.maAsiss/public_mode --ignore='settings' | wc -l)
   local env_msg
   env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
   env_msg+="<b>  WELCOME TO $nameStore</b>\n"
   env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
   env_msg+="â€¢> <b>1 ID Tele = 1 Server VPN</b>\n"
   env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
   env_msg+="â€¢OpenSSH : $opensh\n"
   env_msg+="â€¢Dropbear : $db\n"
   env_msg+="â€¢SSH WS : 80\n"
   env_msg+="â€¢SSH-WS-SSL : 443\n"
   env_msg+="â€¢SSL/TLS : $ssl\n"
   env_msg+="â€¢UDPGW : 7100-7300\n"
   env_msg+="â€¢Trojan TLS : $tr\n"
   env_msg+="â€¢VMess/VLess WS TLS : 443\n"
   env_msg+="â€¢VMess/VLess WS Non TLS : 80\n"
   env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
   env_msg+="â€¢> Status = ðŸ‘¤ $dx / $getLimits Max \n"
   env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n\n"

# ShellBot.deleteMessage --chat_id ${message_chat_id[$id]} \
     # --message_id ${message_message_id[$id]}
ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
     --text "$env_msg" \
     --reply_markup "$pub_menu1" \
     --parse_mode html
}

ssh_publik(){
ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} --message_id ${callback_query_message_message_id[$id]}
func_limit_publik ${callback_query_from_id}
r0=$(tr -dc a-zA-Z </dev/urandom | head -c5)
r1=$(tr -dc 0-9 </dev/urandom | head -c3)
userna=$(echo $r0$r1)
passw=$r1
getDays=$(grep -w "MAX_DAYS" "/etc/.maAsiss/public_mode/settings" | awk '{print $NF}')
data=$(date '+%d/%m/%C%y' -d " +$getDays days")
exp=$(echo "$data" | awk -F'/' '{print $2FS$1FS$3}' | xargs -i date -d'{}' +%Y-%m-%d)

if /usr/sbin/useradd -M -N -s /bin/false $userna -e $exp; then
    (echo "${passw}";echo "${passw}") | passwd "${userna}"
else
    ShellBot.sendMessage --chat_id ${callback_query_chat_id[$id]} \
            --text "â›” ERROR CREATING USER" \
            --parse_mode html
    return 0
fi

[[ "${callback_query_from_id[$id]}" != "$Admin_ID" ]] && {
        mkdir -p /etc/.maAsiss/public_mode/${callback_query_from_id}
        echo "$userna:$passw:$data" >/etc/.maAsiss/public_mode/${callback_query_from_id}/$userna
        echo "$userna:$passw $getDays Days SSH | ${callback_query_from_first_name}" >> /root/log-public
}

ossl=`cat /root/log-install.txt | grep -w " OpenVPN" | cut -f2 -d: | awk '{print $6}'`
opensh=`cat /root/log-install.txt | grep -w "OpenSSH" | cut -f2 -d: | awk '{print $1}'`
db=`cat /root/log-install.txt | grep -w "Dropbear" | cut -f2 -d: | awk '{print $1,$2}'`
ssl="$(cat /root/log-install.txt | grep -w "Stunnel4" | cut -d: -f2)"
sqd="$(cat /root/log-install.txt | grep -w "Squid" | cut -d: -f2)"
ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
portsshws=`cat /root/log-install.txt | grep -w "SSH Websocket" | cut -d: -f2 | awk '{print $1}'`
OhpSSH=`cat /root/log-install.txt | grep -w "OHP SSH" | cut -d: -f2 | awk '{print $1}'`
OhpDB=`cat /root/log-install.txt | grep -w "OHP DBear" | cut -d: -f2 | awk '{print $1}'`
OhpOVPN=`cat /root/log-install.txt | grep -w "OHP OpenVPN" | cut -d: -f2 | awk '{print $1}'`
wsssl=`cat /root/log-install.txt | grep -w "SSH SSL Websocket" | cut -d: -f2 | awk '{print $1}'`

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>    ðŸ”¸ SSH ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Host : $IPs \n"
env_msg+="Username: <code>$userna</code>\n"
env_msg+="Password: <code>$passw</code>\n"
env_msg+="Expired On: $data ðŸ“…\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="OpenSSH : $opensh\n"
env_msg+="Dropbear : $db\n"
env_msg+="SSH-WS : $portsshws\n"
env_msg+="SSH-WS-SSL : $wsssl\n"
env_msg+="SSL/TLS : $ssl\n"
env_msg+="UDPGW : 7100-7900 \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="OpenVPN Config : http://$IPs:81/\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Payload WS : \n\n"
env_msg+="<code>GET / HTTP/1.1[crlf]Host: $IPs [crlf]Connection: Keep-Alive[crlf]User-Agent: [ua][crlf]Upgrade: websocket[crlf][crlf]</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
ShellBot.sendMessage --chat_id ${callback_query_from_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
}

vmess_publik() {
ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} --message_id ${callback_query_message_message_id[$id]}
func_limit_publik ${callback_query_from_id}
r0=$(tr -dc a-zA-Z </dev/urandom | head -c5)
r1=$(tr -dc 0-9 </dev/urandom | head -c3)
userna=$(echo $r0$r1)
passw=$r1
getDays=$(grep -w "MAX_DAYS" "/etc/.maAsiss/public_mode/settings" | awk '{print $NF}')
data=$(date '+%d/%m/%C%y' -d " +$getDays days")
exp=$(echo "$data" | awk -F'/' '{print $2FS$1FS$3}' | xargs -i date -d'{}' +%Y-%m-%d)
        
domain=$(cat /etc/$raycheck/domain)
tls="$(cat /root/log-install.txt | grep -w "Vmess TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat /root/log-install.txt | grep -w "Vmess None TLS" | cut -d: -f2|sed 's/ //g')"

uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#vmess$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$userna""'"' /etc/xray/config.json
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmessgrpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$userna""'"' /etc/xray/config.json
            
asu=`cat<<EOF
      {
      "v": "2",
      "ps": "${userna}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmess",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF`
ask=`cat<<EOF
      {
      "v": "2",
      "ps": "${userna}",
      "add": "${domain}",
      "port": "80",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmess",
      "type": "none",
      "host": "",
      "tls": "none"
}
EOF`
grpc=`cat<<EOF
      {
      "v": "2",
      "ps": "${userna}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "grpc",
      "path": "vmess-grpc",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF`
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmess_base643=$( base64 -w 0 <<< $vmess_json3)
vmesslink1="vmess://$(echo $asu | base64 -w 0)"
vmesslink2="vmess://$(echo $ask | base64 -w 0)"
vmesslink3="vmess://$(echo $grpc | base64 -w 0)"
systemctl restart xray > /dev/null 2>&1

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>      ðŸ”¸ VMESS ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Domain : $domain\n"
env_msg+="Remarks : $userna\n"
env_msg+="Expired On : $data ðŸ“†\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port TLS : 443\n"
env_msg+="Port None TLS : 80\n"
env_msg+="ID : $uuid\n"
env_msg+="AlterID : 0\n"
env_msg+="Security : auto\n"
env_msg+="Network : websocket/ws\n"
env_msg+="Path : /vmess\n"
env_msg+="ServiceName : vmess-grpc\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link TLS : \n<code>$vmesslink1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link None TLS : \n<code>$vmesslink2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link GRPC : \n<code>$vmesslink3</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
[[ "${callback_query_from_id[$id]}" != "$Admin_ID" ]] && {
        mkdir -p /etc/.maAsiss/public_mode/${callback_query_from_id}
        echo "$userna:$uuid:$data" >/etc/.maAsiss/public_mode/${callback_query_from_id}/$userna
        echo "$userna:$uuid $getDays Days VMESS | ${callback_query_from_first_name}" >> /root/log-public
}

ShellBot.sendMessage --chat_id ${callback_query_from_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
systemctl restart $raycheck > /dev/null 2>&1
return 0
}

vless_publik() {
ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} --message_id ${callback_query_message_message_id[$id]}
func_limit_publik ${callback_query_from_id}
r0=$(tr -dc a-zA-Z </dev/urandom | head -c5)
r1=$(tr -dc 0-9 </dev/urandom | head -c3)
userna=$(echo $r0$r1)
passw=$r1
getDays=$(grep -w "MAX_DAYS" "/etc/.maAsiss/public_mode/settings" | awk '{print $NF}')
data=$(date '+%d/%m/%C%y' -d " +$getDays days")
exp=$(echo "$data" | awk -F'/' '{print $2FS$1FS$3}' | xargs -i date -d'{}' +%Y-%m-%d)

domain=$(cat /etc/$raycheck/domain)
tls="$(cat /root/log-install.txt | grep -w "Vless TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat /root/log-install.txt | grep -w "Vless None TLS" | cut -d: -f2|sed 's/ //g')"

uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#vless$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#vlessgrpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
vlesslink1="vless://${uuid}@${domain}:$tls?path=/vless&security=tls&encryption=none&type=ws#${userna}"
vlesslink2="vless://${uuid}@${domain}:$none?path=/vless&encryption=none&type=ws#${userna}"
vlesslink3="vless://${uuid}@${domain}:$tls?mode=gun&security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=bug.com#${userna}"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>        ðŸ”¸ VLESS ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Address : $domain\n"
env_msg+="Remarks : $userna\n"
env_msg+="Expired On : $data \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port TLS : $tls\n"
env_msg+="Port None TLS : $none\n"
env_msg+="ID : <code>$uuid</code>\n"
env_msg+="Encryption : none\n"
env_msg+="Network : websocket/ws\n"
env_msg+="Path : /vless\n"
env_msg+="ServiceName : vless-grpc\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link TLS : \n"
env_msg+="<code>$vlesslink1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link None TLS : \n"
env_msg+="<code>$vlesslink2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link GRPC : \n"
env_msg+="<code>$vlesslink3</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

[[ "${callback_query_from_id[$id]}" != "$Admin_ID" ]] && {
        mkdir -p /etc/.maAsiss/public_mode/${callback_query_from_id}
        echo "$userna:$uuid:$data" >/etc/.maAsiss/public_mode/${callback_query_from_id}/$userna
        echo "$userna:$uuid $getDays Days VLESS | ${callback_query_from_first_name}" >> /root/log-public
}

ShellBot.sendMessage --chat_id ${callback_query_from_id[$id]} \
    --text "$env_msg" \
    --parse_mode html 
systemctl restart $raycheck > /dev/null 2>&1
return 0

}

trojan_publik() {
ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} --message_id ${callback_query_message_message_id[$id]}
func_limit_publik ${callback_query_from_id}
r0=$(tr -dc a-zA-Z </dev/urandom | head -c5)
r1=$(tr -dc 0-9 </dev/urandom | head -c3)
userna=$(echo $r0$r1)
passw=$r1
getDays=$(grep -w "MAX_DAYS" "/etc/.maAsiss/public_mode/settings" | awk '{print $NF}')
data=$(date '+%d/%m/%C%y' -d " +$getDays days")
exp=$(echo "$data" | awk -F'/' '{print $2FS$1FS$3}' | xargs -i date -d'{}' +%Y-%m-%d)

domain=$(cat /etc/$raycheck/domain)
tr="$(cat /root/log-install.txt | grep -w "Trojan " | cut -d: -f2|sed 's/ //g')"

uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#trojanws$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#trojangrpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#trojantcp$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$userna""'"' /etc/xray/config.json
sed -i '/#trojanxtls$/a\#&# '"$user $exp"'\
},{"password": "'""$uuid""'","flow": "'""xtls-rprx-direct""'","email": "'""$userna""'"' /etc/xray/config.json
trojanlink3="trojan://${uuid}@${domain}:${tr}?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=bug.com#${userna}"
trojanlink2="trojan://${uuid}@${domain}:${tr}?path=%2Ftrojan-ws&security=tls&host=bug.com&type=ws&sni=bug.com#${userna}"
trojanlink="trojan://${uuid}@${domain}:443#${userna}"
trojanlink1="trojan://${uuid}@${doman}:443?security=xtls&headerType=none&type=tcp&flow=xtls-rprx-direct&sni=bug.com#${userna}"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>     ðŸ”¸ TROJAN ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Domain : $domain\n"
env_msg+="Remarks : $userna\n"
env_msg+="Expired On : $data â³ \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port  : $tr\n"
env_msg+="Key : $uuid\n"
env_msg+="Path : /trojan-ws\n"
env_msg+="Flow : xtls-rprx-direct\n"
env_msg+="ServiceName : trojan-grpc\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link TCP: \n<code>$trojanlink</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link XTLS: \n<code>$trojanlink1</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link WS: \n<code>$trojanlink2</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link GRPC: \n<code>$trojanlink3</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

[[ "${callback_query_from_id[$id]}" != "$Admin_ID" ]] && {
        mkdir -p /etc/.maAsiss/public_mode/${callback_query_from_id}
        echo "$userna:$uuid:$data" >/etc/.maAsiss/public_mode/${callback_query_from_id}/$userna
        echo "$userna:$uuid $getDays Days TROJAN | ${callback_query_from_first_name}" >> /root/log-public
}

ShellBot.sendMessage --chat_id ${callback_query_from_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
systemctl restart $raycheck > /dev/null 2>&1
return 0
}

trgo_publik() {
ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} --message_id ${callback_query_message_message_id[$id]}
func_limit_publik ${callback_query_from_id}
r0=$(tr -dc a-zA-Z </dev/urandom | head -c5)
r1=$(tr -dc 0-9 </dev/urandom | head -c3)
userna=$(echo $r0$r1)
passw=$r1
getDays=$(grep -w "MAX_DAYS" "/etc/.maAsiss/public_mode/settings" | awk '{print $NF}')
data=$(date '+%d/%m/%C%y' -d " +$getDays days")
exp=$(echo "$data" | awk -F'/' '{print $2FS$1FS$3}' | xargs -i date -d'{}' +%Y-%m-%d)

domain=$(cat /etc/$raycheck/domain)
trgo="$(cat /root/log-install.txt | grep -w "Trojan Go" | cut -d: -f2|sed 's/ //g')"

uuidR=$(cat /proc/sys/kernel/random/uuid)
uuid=$(cat /etc/trojan-go/idtrojango)
sed -i '/"'""$uuid""'"$/a\,"'""$uuidR""'"' /etc/trojan-go/config.json
echo -e "### $userna $exp $uuidR" | tee -a /etc/trojan-go/akun.conf
linktrgo="trojan-go://${uuidR}@${domain}:${trgo}/?sni=${domain}%26type=ws%26host=${domain}%26path=/scvps%26encryption=none#${userna}"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>    ðŸ”¸ TROJAN GO ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Address : $domain\n"
env_msg+="User : $userna\n"
env_msg+="Expired On : $data ðŸ—“ \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port : $trgo\n"
env_msg+="Key : $uuidR\n"
env_msg+="Network : ws\n"
env_msg+="Path : /scvps\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link TRGO: \n\n"
env_msg+="<code>$linktrgo</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

[[ "${callback_query_from_id[$id]}" != "$Admin_ID" ]] && {
        mkdir -p /etc/.maAsiss/public_mode/${callback_query_from_id}
        echo "$userna:$uuid:$data" >/etc/.maAsiss/public_mode/${callback_query_from_id}/$userna
        echo "$userna:$uuid $getDays Days TRJ-GO | ${callback_query_from_first_name}" >> /root/log-public
}

ShellBot.sendMessage --chat_id ${callback_query_from_id[$id]} \
    --text "$env_msg" \
    --parse_mode html
systemctl restart trojan-go > /dev/null 2>&1
return 0

}

xray_publik() {
ShellBot.deleteMessage --chat_id ${callback_query_message_chat_id[$id]} --message_id ${callback_query_message_message_id[$id]}
func_limit_publik ${callback_query_from_id}
r0=$(tr -dc a-zA-Z </dev/urandom | head -c5)
r1=$(tr -dc 0-9 </dev/urandom | head -c3)
userna=$(echo $r0$r1)
passw=$r1
getDays=$(grep -w "MAX_DAYS" "/etc/.maAsiss/public_mode/settings" | awk '{print $NF}')
data=$(date '+%d/%m/%C%y' -d " +$getDays days")
exp=$(echo "$data" | awk -F'/' '{print $2FS$1FS$3}' | xargs -i date -d'{}' +%Y-%m-%d)

domain=$(cat /etc/$raycheck/domain)
xray="$(cat /root/log-install.txt | grep -w "VLess TCP XTLS" | cut -d: -f2|sed 's/ //g')"

xCho='xtls-rprx-direct'
uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#vlessXTLS$/a\#& '"$userna $exp"'\
},{"id": "'""$uuid""'","flow": "'""$xCho""'","email": "'""$userna""'"' /usr/local/etc/xtls/config.json

vlessTcpXtls="vless://${uuid}@${domain}:$xray?path=/%26security=xtls%26encryption=none%26flow=${xCho}%26type=tcp#${userna}"

local env_msg
env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>    ðŸ”¸ VLESS XTLS ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Address : $domain\n"
env_msg+="Remarks : $userna\n"
env_msg+="Expired On : $data \n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Port : $xray\n"
env_msg+="ID : <code>$uuid</code>\n"
env_msg+="Encryption : none\n"
env_msg+="Network : tcp\n"
env_msg+="Flow : $xCho\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
env_msg+="Link : \n"
env_msg+="<code>$vlessTcpXtls</code>\n"
env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"

[[ "${callback_query_from_id[$id]}" != "$Admin_ID" ]] && {
        mkdir -p /etc/.maAsiss/public_mode/${callback_query_from_id}
        echo "$userna:$uuid:$data" >/etc/.maAsiss/public_mode/${callback_query_from_id}/$userna
        echo "$userna:$uuid $getDays Days VLESS | ${callback_query_from_first_name}" >> /root/log-public
}

ShellBot.sendMessage --chat_id ${callback_query_from_id[$id]} \
    --text "$env_msg" \
    --parse_mode html 
systemctl restart xtls > /dev/null 2>&1
return 0

}

unset pub_menu
pub_menu=''
ShellBot.InlineKeyboardButton --button 'pub_menu' --line 1 --text 'â€¢ VMess â€¢' --callback_data 'vmess'
ShellBot.InlineKeyboardButton --button 'pub_menu' --line 1 --text 'â€¢ VLess â€¢' --callback_data 'vless'
ShellBot.InlineKeyboardButton --button 'pub_menu' --line 2 --text 'â€¢ Trojan â€¢' --callback_data 'trojan'
ShellBot.InlineKeyboardButton --button 'pub_menu' --line 2 --text 'â€¢ TrojanGO â€¢' --callback_data 'trgo'
ShellBot.InlineKeyboardButton --button 'pub_menu' --line 3 --text 'â€¢ SSH â€¢' --callback_data 'ssh'
ShellBot.InlineKeyboardButton --button 'pub_menu' --line 3 --text 'â€¢ XRAY â€¢' --callback_data 'xray'

ShellBot.regHandleFunction --function ssh_publik --callback_data ssh
ShellBot.regHandleFunction --function vmess_publik --callback_data vmess
ShellBot.regHandleFunction --function vless_publik --callback_data vless
ShellBot.regHandleFunction --function trojan_publik --callback_data trojan
ShellBot.regHandleFunction --function trgo_publik --callback_data trgo
ShellBot.regHandleFunction --function xray_publik --callback_data xray


unset pub_menu1
pub_menu1="$(ShellBot.InlineKeyboardMarkup -b 'pub_menu')"
while :; do
    ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 35
    for id in $(ShellBot.ListUpdates); do
        (
            ShellBot.watchHandle --callback_data ${callback_query_data[$id]}
            [[ ${message_chat_type[$id]} != 'private' ]] && {
                   ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                        --text "$(echo -e "â›” only run this command on private chat / pm on bot")" \
                        --parse_mode html
                   >$CAD_ARQ
                   break
                   ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                        --text "Func Error Do Nothing" \
                        --reply_markup "$(ShellBot.ForceReply)"
            }
            CAD_ARQ=/tmp/cad.${message_from_id[$id]}
            echotoprice=/tmp/price
            if [[ ${message_entities_type[$id]} == bot_command ]]; then
                case ${message_text[$id]} in
                *)
                    :
                    comando=(${message_text[$id]})
                    [[ "${comando[0]}" = "/start" ]] && msg_welcome
                    [[ "${comando[0]}" = "/menu" ]] && menu_func
                    [[ "${comando[0]}" = "/info" ]] && about_server
                    [[ "${comando[0]}" = "/anonym" ]] && hantuu
                    [[ "${comando[0]}" = "/free" ]] && _if_public
                    [[ "${comando[0]}" = "/disable" ]] && echo "${message_text[$id]}" > /tmp/order && Disable_Order
                    ;;
                esac
            fi
            if [[ ${message_reply_to_message_message_id[$id]} ]]; then
                case ${message_reply_to_message_text[$id]} in
                'ðŸ‘¤ CREATE USER ðŸ‘¤\n\nUsername:')
                    verifica_acesso
                    Saldo_CheckerSSH
                    [[ "$_erro" != '1' ]] && {
                    [[ "$(awk -F : '$3 >= 1000 { print $1 }' /etc/passwd | grep -w ${message_text[$id]} | wc -l)" != '0' ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "âš ï¸ User Already Exist..")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    [ "${message_text[$id]}" == 'root' ] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” INVALID USER")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    sizemax=$(echo -e ${#message_text[$id]})
                    [[ "$sizemax" -gt '10' ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use no maximum 10 characters [EX: KennXV]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                    }
                    echo "Name: ${message_text[$id]}" >$CAD_ARQ
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'Password:' \
                        --reply_markup "$(ShellBot.ForceReply)" # ForÃ§a a resposta.
                    }
                    ;;
                'Password:')
                    verifica_acesso
                    Saldo_CheckerSSH
                    [[ "$_erro" != '1' ]] && {
                    echo "Password: ${message_text[$id]}" >>$CAD_ARQ
                    # PrÃ³ximo campo.
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'Validity in days: ' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    }
                    ;;
                'Validity in days:')
                    verifica_acesso
                    Saldo_CheckerSSH
                    [[ "$_erro" != '1' ]] && {
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 30]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                if ((${message_text[$id]} >= 1 && ${message_text[$id]} <= 30)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    cret_user $CAD_ARQ
                    [[ "(grep -w ${message_text[$id]} /etc/passwd)" = '0' ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e â›” Error creating user !)" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }

                        ossl=`cat /root/log-install.txt | grep -w " OpenVPN" | cut -f2 -d: | awk '{print $6}'`
                        opensh=`cat /root/log-install.txt | grep -w "OpenSSH" | cut -f2 -d: | awk '{print $1}'`
                        db=`cat /root/log-install.txt | grep -w "Dropbear" | cut -f2 -d: | awk '{print $1,$2}'`
                        ssl="$(cat /root/log-install.txt | grep -w "Stunnel4" | cut -d: -f2)"
                        sqd="$(cat /root/log-install.txt | grep -w "Squid" | cut -d: -f2)"
                        ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
                        ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
                        portsshws=`cat /root/log-install.txt | grep -w "SSH Websocket" | cut -d: -f2 | awk '{print $1}'`
                        OhpSSH=`cat /root/log-install.txt | grep -w "OHP SSH" | cut -d: -f2 | awk '{print $1}'`
                        OhpDB=`cat /root/log-install.txt | grep -w "OHP DBear" | cut -d: -f2 | awk '{print $1}'`
                        OhpOVPN=`cat /root/log-install.txt | grep -w "OHP OpenVPN" | cut -d: -f2 | awk '{print $1}'`
                        wsssl=`cat /root/log-install.txt | grep -w "SSH SSL Websocket" | cut -d: -f2 | awk '{print $1}'`

                        env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>       ðŸ”¸ SSH ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
                        env_msg+="Host : $IPs \n"
                        env_msg+="Username: <code>$(awk -F " " '/Name/ {print $2}' $CAD_ARQ)</code>\n"
                        env_msg+="Password: <code>$(awk -F " " '/Password/ {print $2}' $CAD_ARQ)</code>\n"
                        env_msg+="Expired On: $(awk -F " " '/Validity/ {print $2}' $CAD_ARQ) ðŸ—“\n"
                        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
                        env_msg+="OpenSSH : $opensh\n"
                        env_msg+="Dropbear : $db\n"
                        env_msg+="SSH-WS : $portsshws\n"
                        env_msg+="SSH-WS-SSL : $wsssl\n"
                        env_msg+="SSL/TLS : $ssl\n"
                        env_msg+="OHP SSH : $OhpSSH\n"
                        env_msg+="OHP Dropbear : $OhpDB\n"
                        env_msg+="OHP OpenVPN : $OhpOVPN\n"
                        env_msg+="Port Squid : $sqd\n"
                        env_msg+="UDPGW : 7100-7300 \n"
                        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
                        env_msg+="OpenVPN Config : http://$IPs:81/\n"
                        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
                        env_msg+="Payload WS : \n\n"
                        env_msg+="<code>GET / HTTP/1.1[crlf]Host: $IPs [crlf]Upgrade: websocket[crlf][crlf]</code>\n"
                        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
                        ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                            --text "$env_msg" \
                            --parse_mode html
                        break
                elif ((${message_text[$id]} >= 30 && ${message_text[$id]} <= 60)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    Saldo_CheckerSSH2Month
                    [[ "$_erro" != '1' ]] && {
                    2month_user $CAD_ARQ
                    [[ "(grep -w ${message_text[$id]} /etc/passwd)" = '0' ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e â›” Error creating user !)" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }

                        ossl=`cat /root/log-install.txt | grep -w " OpenVPN" | cut -f2 -d: | awk '{print $6}'`
                        opensh=`cat /root/log-install.txt | grep -w "OpenSSH" | cut -f2 -d: | awk '{print $1}'`
                        db=`cat /root/log-install.txt | grep -w "Dropbear" | cut -f2 -d: | awk '{print $1,$2}'`
                        ssl="$(cat /root/log-install.txt | grep -w "Stunnel4" | cut -d: -f2)"
                        sqd="$(cat /root/log-install.txt | grep -w "Squid" | cut -d: -f2)"
                        ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
                        ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
                        portsshws=`cat /root/log-install.txt | grep -w "SSH Websocket" | cut -d: -f2 | awk '{print $1}'`
                        OhpSSH=`cat /root/log-install.txt | grep -w "OHP SSH" | cut -d: -f2 | awk '{print $1}'`
                        OhpDB=`cat /root/log-install.txt | grep -w "OHP DBear" | cut -d: -f2 | awk '{print $1}'`
                        OhpOVPN=`cat /root/log-install.txt | grep -w "OHP OpenVPN" | cut -d: -f2 | awk '{print $1}'`
                        wsssl=`cat /root/log-install.txt | grep -w "SSH SSL Websocket" | cut -d: -f2 | awk '{print $1}'`

                        local env_msg
                        env_msg="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>       ðŸ”¸ SSH ACCOUNT ðŸ”¸ </b>\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
                        env_msg+="Host : $IPs \n"
                        env_msg+="Username: <code>$(awk -F " " '/Name/ {print $2}' $CAD_ARQ)</code>\n"
                        env_msg+="Password: <code>$(awk -F " " '/Password/ {print $2}' $CAD_ARQ)</code>\n"
                        env_msg+="Expired On: $(awk -F " " '/Validity/ {print $2}' $CAD_ARQ) ðŸ—“\n"
                        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
                        env_msg+="OpenSSH : $opensh\n"
                        env_msg+="Dropbear : $db\n"
                        env_msg+="SSH-WS : $portsshws\n"
                        env_msg+="SSH-WS-SSL : $wsssl\n"
                        env_msg+="SSL/TLS : $ssl\n"
                        env_msg+="OHP SSH : $OhpSSH\n"
                        env_msg+="OHP Dropbear : $OhpDB\n"
                        env_msg+="OHP OpenVPN : $OhpOVPN\n"
                        env_msg+="Port Squid : $sqd\n"
                        env_msg+="UDPGW : 7100-7900 \n"
                        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
                        env_msg+="OpenVPN Config : http://$IPs:81/\n"
                        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
                        env_msg+="Payload WS : \n\n"
                        env_msg+="<code>GET / HTTP/1.1[crlf]Host: $IPs [crlf]Upgrade: websocket[crlf][crlf]</code>\n"
                        env_msg+="â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n"
                        ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                            --text "$env_msg" \
                            --parse_mode html
                        break
                        }
                else
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Can't be more than 60 Days")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                fi
                    }
                    ;;
                'â³ Renew SSH â³\n\nUsername:')
                    verifica_acesso
                    Saldo_CheckerSSH
                    [[ "$_erro" != '1' ]] && {
                    echo "${message_text[$id]}" >/tmp/name-d
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'Input the days or date:' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    }
                    ;;
                'Input the days or date:')
                    verifica_acesso
                    Saldo_CheckerSSH
                    [[ "$_erro" != '1' ]] && {
                    [[ ${message_text[$id]} != ?(+|-)+([0-9/]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "â›” Error! Follow the example \nData format [EX: 30]" \
                            --parse_mode html
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                if ((${message_text[$id]} >= 1 && ${message_text[$id]} <= 30)); then
                    func_renew_ssh $(cat /tmp/name-d) ${message_text[$id]}
                    [[ "$_erro" == '1' ]] && break
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text "$(echo -e "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>âœ… DATE CHANGED !</b> !\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n\n<b>Username:</b> $(cat /tmp/name-d)\n<b>New date:</b> $udata")" \
                        --parse_mode html
                    rm /tmp/name-d >/dev/null 2>&1
                else
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Can't be more than 30 Days")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                fi
                    }
                    ;;
                'ðŸ—‘ REMOVE USER ðŸ—‘\n\nUsername:')
                    verifica_acesso
                    func_del_ssh ${message_text[$id]}
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text "âœ… *Successfully removed.* ðŸš®" \
                        --parse_mode markdown
                    ;;
                'ðŸ‘¥ ADD Reseller ðŸ‘¥\n\nEnter the name:')
                    verifica_acesso
                    echo "Name: ${message_text[$id]}" > $CAD_ARQ
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'User token by generate:' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'User token by generate:')
                    verifica_acesso
                    _VAR1=$(echo ${message_text[$id]} | sed -e 's/[^0-9]//ig'| rev)
                    [[ ! -z $(grep -w "$_VAR1" "$User_Active" ) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Already Registered")" \
                            --parse_mode html
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    echo "${message_text[$id]}" >/tmp/scvpsss
                    echo "User: $_VAR1" >> $CAD_ARQ
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'Saldo:' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'Saldo:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "âš ï¸ Use only numbers [EX: 100000]")" \
                            --parse_mode html
                        break
                    }
                    echo "Saldo: ${message_text[$id]}" >> $CAD_ARQ
                    sleep 1
                    cret_res $CAD_ARQ
                    ;;
                'ðŸ—‘ REMOVE Reseller ðŸ—‘\n\nInput Name of Reseller:')
                    echo -e "${message_text[$id]}" >$CAD_ARQ
                    _VAR12=$(grep -w "${message_text[$id]}" "$Res_Token")
                    [[ -z $_VAR12 ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Token invalid")" \
                            --parse_mode html
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    func_del_res $_VAR12
                    sed -i "/\b${message_text[$id]}\b/d" $Res_Token
                    break
                    ;;
                'ðŸ’¸ Topup Saldo ðŸ’¸\n\nName reseller:')
                    verifica_acesso
                    cek_res_token=$(grep -w "${message_text[$id]}" "$Res_Token" | awk '{print $NF}' | sed -e 's/[^0-9]//ig'| rev)
                    echo $cek_res_token > /tmp/ruii
                    echo ${message_text[$id]} > /tmp/ruiix
                    [[ -z $cek_res_token ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” No user found")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                 #   _VARSaldo=$(echo ${message_text[$id]} | sed -e 's/[^0-9]//ig'| rev)
                 #   echo -e "${message_text[$id]}" > /tmp/name-l
                 #   sed -i 's/^@//' /tmp/name-l
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'Topup Saldo:' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'Topup Saldo:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "âš ï¸ Use only numbers [EX: 100000]")" \
                            --parse_mode html
                        break
                    }
                    func_topup_res $(cat /tmp/ruii) ${message_text[$id]}
                    [[ "$_erro" == '1' ]] && break
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text "$(echo -e "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n  âœ… <b>Succesfully Topup !</b> âœ… !\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n<b>Name:</b> $(cat /tmp/ruiix) \n<b>Topup Saldo:</b> ${message_text[$id]}\n<b>Total Saldo Now:</b> $_TopUpSal \nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”")" \
                        --parse_mode html
                    rm /tmp/ruii >/dev/null 2>&1 && rm /tmp/ruiix >/dev/null 2>&1
                    ;;
                'ðŸ‘¤ CREATE TRIAL SSH ðŸ‘¤\n\nHow many hours should it last ? EX: 1:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
                        func_verif_limite_res ${message_from_id}
                        [[ "$_result" -ge "$_limTotal" ]] && {
                            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                                --text "â›” Max Limit Create Trial only $_limTotal Users\n\nYou Still Have User Active : $user_on" \
                                --parse_mode html
                            break
                            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                 --text "Func Error Do Nothing" \
                                 --reply_markup "$(ShellBot.ForceReply)"
                        }
                    }
                    if ((${message_text[$id]} == 1 || ${message_text[$id]} == 2)); then
                        func_add_ssh_trial ${message_text[$id]}
                    else
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Trial Max Hours only 1-2")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    fi
                    ;;
                'ðŸ‘¤ CREATE USER VMess ðŸ‘¤\n\nUsername:')
                    verifica_acesso
                    [ "${message_text[$id]}" == 'root' ] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” INVALID USER")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    sizemax=$(echo -e ${#message_text[$id]})
                    [[ "$sizemax" -gt '10' ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use no maximum 10 characters [EX: KennXV]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                    }
                    user_already_exist ${message_text[$id]}
                    echo "Name: ${message_text[$id]}" >$CAD_ARQ
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'VMess Validity in days: ' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'VMess Validity in days:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 30]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                if ((${message_text[$id]} >= 1 && ${message_text[$id]} <= 30)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    func_add_ray $CAD_ARQ
                elif ((${message_text[$id]} >= 30 && ${message_text[$id]} <= 60)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    func_add_ray2 $CAD_ARQ
                else
                    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                        --text "$(echo -e "â›” Can't be more than 60 Days")" \
                        --parse_mode html
                    >$CAD_ARQ
                    break
                    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                        --text "Func Error Do Nothing" \
                        --reply_markup "$(ShellBot.ForceReply)"
                fi
                    ;;
                'ðŸ‘¤ CREATE TRIAL VMess ðŸ‘¤\n\nHow many hours should it last ? EX: 1:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
                        user_on=$(ls /etc/.maAsiss/db_reseller/${message_from_id}/trial-fold)
                        func_verif_limite_res ${message_from_id}
                        [[ "$_result" -ge "$_limTotal" ]] && {
                            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                                --text "â›” Max Limit Create Trial only $_limTotal Users\n\nYou Still Have User Active : $user_on" \
                                --parse_mode html
                            break
                            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                 --text "Func Error Do Nothing" \
                                 --reply_markup "$(ShellBot.ForceReply)"
                        }
                    }
                    if ((${message_text[$id]} == 1 || ${message_text[$id]} == 2)); then
                        func_add_ray_trial ${message_text[$id]}
                    else
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Trial Max Hours only 1-2")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    fi
                    ;;
                'ðŸ—‘ REMOVE USER V2RAY ðŸ—‘\n\nUsername:')
                    verifica_acesso
                    func_del_ray ${message_text[$id]}
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text "âœ… *Successfully removed.* ðŸš®" \
                        --parse_mode markdown
                    ;;
                'ðŸ‘¤ CREATE USER Trojan ðŸ‘¤\n\nUsername:')
                    verifica_acesso
                    [ "${message_text[$id]}" == 'root' ] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” INVALID USER")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    sizemax=$(echo -e ${#message_text[$id]})
                    [[ "$sizemax" -gt '10' ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use no maximum 10 characters [EX: KennXV]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                    }
                    user_already_exist ${message_text[$id]}
                    echo "Name: ${message_text[$id]}" >$CAD_ARQ
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'Trojan Validity in days: ' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'Trojan Validity in days:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 30]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                if ((${message_text[$id]} >= 1 && ${message_text[$id]} <= 30)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    func_add_trojan $CAD_ARQ
                elif ((${message_text[$id]} >= 30 && ${message_text[$id]} <= 60)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    func_add_trojan2 $CAD_ARQ
                else
                    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                        --text "$(echo -e "â›” Can't be more than 60 Days")" \
                        --parse_mode html
                    >$CAD_ARQ
                    break
                    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                        --text "Func Error Do Nothing" \
                        --reply_markup "$(ShellBot.ForceReply)"
                fi
                    ;;
                'ðŸ—‘ REMOVE USER TROJAN ðŸ—‘\n\nUsername:')
                    verifica_acesso
                    func_del_trojan ${message_text[$id]}
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text "âœ… *Successfully removed.* ðŸš®" \
                        --parse_mode markdown
                    ;;
                'ðŸ‘¤ CREATE TRIAL Trojan ðŸ‘¤\n\nHow many hours should it last ? EX: 1:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
                        user_on=$(ls /etc/.maAsiss/db_reseller/${message_from_id}/trial-fold)
                        func_verif_limite_res ${message_from_id}
                        [[ "$_result" -ge "$_limTotal" ]] && {
                            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                                --text "â›” Max Limit Create Trial only $_limTotal Users\n\nYou Still Have User Active : $user_on" \
                                --parse_mode html
                            break
                            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                 --text "Func Error Do Nothing" \
                                 --reply_markup "$(ShellBot.ForceReply)"
                        }
                    }
                    if ((${message_text[$id]} == 1 || ${message_text[$id]} == 2)); then
                        func_add_trojan_trial ${message_text[$id]}
                    else
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Trial Max Hours only 1-2")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    fi
                    ;;
                'ðŸ‘¤ CREATE USER VLess ðŸ‘¤\n\nUsername:')
                    verifica_acesso
                    [ "${message_text[$id]}" == 'root' ] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” INVALID USER")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    sizemax=$(echo -e ${#message_text[$id]})
                    [[ "$sizemax" -gt '10' ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use no maximum 10 characters [EX: KennXV]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                    }
                    user_already_exist ${message_text[$id]}
                    echo "Name: ${message_text[$id]}" >$CAD_ARQ
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'VLess Validity in days: ' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'VLess Validity in days:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 30]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                if ((${message_text[$id]} >= 1 && ${message_text[$id]} <= 30)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    func_add_vless $CAD_ARQ
                elif ((${message_text[$id]} >= 30 && ${message_text[$id]} <= 60)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    func_add_vless2 $CAD_ARQ
                else
                    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                        --text "$(echo -e "â›” Can't be more than 60 Days")" \
                        --parse_mode html
                    >$CAD_ARQ
                    break
                    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                        --text "Func Error Do Nothing" \
                        --reply_markup "$(ShellBot.ForceReply)"
                fi
                    ;;
                'ðŸ—‘ REMOVE USER VLess ðŸ—‘\n\nUsername:')
                    verifica_acesso
                    func_del_vless ${message_text[$id]}
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text "âœ… *Successfully removed.* ðŸš®" \
                        --parse_mode markdown
                    ;;
                'ðŸ‘¤ CREATE TRIAL VLess ðŸ‘¤\n\nHow many hours should it last ? EX: 1:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
                        user_on=$(ls /etc/.maAsiss/db_reseller/${message_from_id}/trial-fold)
                        func_verif_limite_res ${message_from_id}
                        [[ "$_result" -ge "$_limTotal" ]] && {
                            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                                --text "â›” Max Limit Create Trial only $_limTotal Users\n\nYou Still Have User Active : $user_on" \
                                --parse_mode html
                            break
                            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                 --text "Func Error Do Nothing" \
                                 --reply_markup "$(ShellBot.ForceReply)"
                        }
                    }
                    if ((${message_text[$id]} == 1 || ${message_text[$id]} == 2)); then
                        func_add_vless_trial ${message_text[$id]}
                    else
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Trial Max Hours only 1-2")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    fi
                    ;;
                'ðŸ‘¤ CREATE USER WireGuard ðŸ‘¤\n\nUsername:')
                    verifica_acesso
                    [ "${message_text[$id]}" == 'root' ] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” INVALID USER")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    sizemax=$(echo -e ${#message_text[$id]})
                    [[ "$sizemax" -gt '10' ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use no maximum 10 characters [EX: KennXV]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                    }
                    user_already_exist ${message_text[$id]}
                    echo "Name: ${message_text[$id]}" >$CAD_ARQ
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'WG Validity in days: ' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'WG Validity in days:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 30]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                if ((${message_text[$id]} >= 1 && ${message_text[$id]} <= 30)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    func_add_wg $CAD_ARQ
                elif ((${message_text[$id]} >= 30 && ${message_text[$id]} <= 60)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    func_add_wg2 $CAD_ARQ
                else
                    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                        --text "$(echo -e "â›” Can't be more than 60 Days")" \
                        --parse_mode html
                    >$CAD_ARQ
                    break
                    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                        --text "Func Error Do Nothing" \
                        --reply_markup "$(ShellBot.ForceReply)"
                fi
                    ;;
                'ðŸ—‘ REMOVE USER WireGuard ðŸ—‘\n\nUsername:')
                    verifica_acesso
                    func_del_wg ${message_text[$id]}
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text "âœ… *Successfully removed.* ðŸš®" \
                        --parse_mode markdown
                    ;;
                'ðŸ‘¤ CREATE TRIAL WireGuard ðŸ‘¤\n\nHow many hours should it last ? EX: 1:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
                        user_on=$(ls /etc/.maAsiss/db_reseller/${message_from_id}/trial-fold)
                        func_verif_limite_res ${message_from_id}
                        [[ "$_result" -ge "$_limTotal" ]] && {
                            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                                --text "â›” Max Limit Create Trial only $_limTotal Users\n\nYou Still Have User Active : $user_on" \
                                --parse_mode html
                            break
                            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                 --text "Func Error Do Nothing" \
                                 --reply_markup "$(ShellBot.ForceReply)"
                        }
                    }
                    if ((${message_text[$id]} == 1 || ${message_text[$id]} == 2)); then
                        func_add_wg_trial ${message_text[$id]}
                    else
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Trial Max Hours only 1-2")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    fi
                    ;;
                'ðŸ‘¤ CREATE USER ShadowSocks ðŸ‘¤\n\nUsername:')
                    verifica_acesso
                    [ "${message_text[$id]}" == 'root' ] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” INVALID USER")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    sizemax=$(echo -e ${#message_text[$id]})
                    [[ "$sizemax" -gt '10' ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use no maximum 10 characters [EX: KennXV]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                    }
                    user_already_exist ${message_text[$id]}
                    echo "Name: ${message_text[$id]}" >$CAD_ARQ
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'SS Validity in days: ' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'SS Validity in days:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 30]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                if ((${message_text[$id]} >= 1 && ${message_text[$id]} <= 30)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    func_add_ss $CAD_ARQ
                elif ((${message_text[$id]} >= 30 && ${message_text[$id]} <= 60)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    func_add_ss2 $CAD_ARQ
                else
                    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                        --text "$(echo -e "â›” Can't be more than 60 Days")" \
                        --parse_mode html
                    >$CAD_ARQ
                    break
                    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                        --text "Func Error Do Nothing" \
                        --reply_markup "$(ShellBot.ForceReply)"
                fi
                    ;;
                'ðŸ—‘ REMOVE USER ShadowSocks ðŸ—‘\n\nUsername:')
                    verifica_acesso
                    func_del_ss ${message_text[$id]}
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text "âœ… *Successfully removed.* ðŸš®" \
                        --parse_mode markdown
                    ;;
                'ðŸ‘¤ CREATE TRIAL ShadowSocks ðŸ‘¤\n\nHow many hours should it last ? EX: 1:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
                        user_on=$(ls /etc/.maAsiss/db_reseller/${message_from_id}/trial-fold)
                        func_verif_limite_res ${message_from_id}
                        [[ "$_result" -ge "$_limTotal" ]] && {
                            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                                --text "â›” Max Limit Create Trial only $_limTotal Users\n\nYou Still Have User Active : $user_on" \
                                --parse_mode html
                            break
                            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                 --text "Func Error Do Nothing" \
                                 --reply_markup "$(ShellBot.ForceReply)"
                        }
                    }
                    if ((${message_text[$id]} == 1 || ${message_text[$id]} == 2)); then
                        func_add_ss_trial ${message_text[$id]}
                    else
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Trial Max Hours only 1-2")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    fi
                    ;;
                'ðŸ‘¤ CREATE USER Shadowsocks-R ðŸ‘¤\n\nUsername:')
                    verifica_acesso
                    [ "${message_text[$id]}" == 'root' ] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” INVALID USER")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    sizemax=$(echo -e ${#message_text[$id]})
                    [[ "$sizemax" -gt '10' ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use no maximum 10 characters [EX: KennXV]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                    }
                    user_already_exist ${message_text[$id]}
                    echo "Name: ${message_text[$id]}" >$CAD_ARQ
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'SSR Validity in days: ' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'SSR Validity in days:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 30]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                if ((${message_text[$id]} >= 1 && ${message_text[$id]} <= 30)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    func_add_ssr $CAD_ARQ
                elif ((${message_text[$id]} >= 30 && ${message_text[$id]} <= 60)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    func_add_ssr2 $CAD_ARQ
                else
                    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                        --text "$(echo -e "â›” Can't be more than 60 Days")" \
                        --parse_mode html
                    >$CAD_ARQ
                    break
                    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                        --text "Func Error Do Nothing" \
                        --reply_markup "$(ShellBot.ForceReply)"
                fi
                    ;;
                'ðŸ—‘ REMOVE USER Shadowsocks-R ðŸ—‘\n\nUsername:')
                    verifica_acesso
                    func_del_ssr ${message_text[$id]}
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text "âœ… *Successfully removed.* ðŸš®" \
                        --parse_mode markdown
                    ;;
                'ðŸ‘¤ CREATE TRIAL Shadowsocks-R ðŸ‘¤\n\nHow many hours should it last ? EX: 1:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
                        user_on=$(ls /etc/.maAsiss/db_reseller/${message_from_id}/trial-fold)
                        func_verif_limite_res ${message_from_id}
                        [[ "$_result" -ge "$_limTotal" ]] && {
                            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                                --text "â›” Max Limit Create Trial only $_limTotal Users\n\nYou Still Have User Active : $user_on" \
                                --parse_mode html
                            break
                            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                 --text "Func Error Do Nothing" \
                                 --reply_markup "$(ShellBot.ForceReply)"
                        }
                    }
                    if ((${message_text[$id]} == 1 || ${message_text[$id]} == 2)); then
                        func_add_ssr_trial ${message_text[$id]}
                    else
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Trial Max Hours only 1-2")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    fi
                    ;;
                'ðŸ‘¤ CREATE USER SSTP ðŸ‘¤\n\nUsername:')
                    verifica_acesso
                    [ "${message_text[$id]}" == 'root' ] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” INVALID USER")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    sizemax=$(echo -e ${#message_text[$id]})
                    [[ "$sizemax" -gt '10' ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use no maximum 10 characters [EX: KennXV]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                    }
                    user_already_exist ${message_text[$id]}
                    echo "Name: ${message_text[$id]}" >$CAD_ARQ
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'SSTP Password:' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'SSTP Password:')
                    verifica_acesso
                    echo "Password: ${message_text[$id]}" >>$CAD_ARQ
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'SSTP Validity in days: ' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'SSTP Validity in days:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 30]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                if ((${message_text[$id]} >= 1 && ${message_text[$id]} <= 30)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    func_add_sstp $CAD_ARQ
                elif ((${message_text[$id]} >= 30 && ${message_text[$id]} <= 60)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    func_add_sstp2 $CAD_ARQ
                else
                    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                        --text "$(echo -e "â›” Can't be more than 60 Days")" \
                        --parse_mode html
                    >$CAD_ARQ
                    break
                    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                        --text "Func Error Do Nothing" \
                        --reply_markup "$(ShellBot.ForceReply)"
                fi
                    ;;
                'ðŸ—‘ REMOVE USER SSTP ðŸ—‘\n\nUsername:')
                    verifica_acesso
                    func_del_sstp ${message_text[$id]}
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text "âœ… *Successfully removed.* ðŸš®" \
                        --parse_mode markdown
                    ;;
                'ðŸ‘¤ CREATE TRIAL SSTP ðŸ‘¤\n\nHow many hours should it last ? EX: 1:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
                        user_on=$(ls /etc/.maAsiss/db_reseller/${message_from_id}/trial-fold)
                        func_verif_limite_res ${message_from_id}
                        [[ "$_result" -ge "$_limTotal" ]] && {
                            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                                --text "â›” Max Limit Create Trial only $_limTotal Users\n\nYou Still Have User Active : $user_on" \
                                --parse_mode html
                            break
                            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                 --text "Func Error Do Nothing" \
                                 --reply_markup "$(ShellBot.ForceReply)"
                        }
                    }
                    if ((${message_text[$id]} == 1 || ${message_text[$id]} == 2)); then
                        func_add_sstp_trial ${message_text[$id]}
                    else
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Trial Max Hours only 1-2")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    fi
                    ;;
                'ðŸ‘¤ CREATE USER L2TP ðŸ‘¤\n\nUsername:')
                    verifica_acesso
                    [ "${message_text[$id]}" == 'root' ] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” INVALID USER")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    sizemax=$(echo -e ${#message_text[$id]})
                    [[ "$sizemax" -gt '10' ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use no maximum 10 characters [EX: KennXV]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                    }
                    user_already_exist ${message_text[$id]}
                    echo "Name: ${message_text[$id]}" >$CAD_ARQ
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'L2TP Password:' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'L2TP Password:')
                    verifica_acesso
                    echo "Password: ${message_text[$id]}" >>$CAD_ARQ
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'L2TP Validity in days: ' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'L2TP Validity in days:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 30]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                if ((${message_text[$id]} >= 1 && ${message_text[$id]} <= 30)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    func_add_l2tp $CAD_ARQ
                elif ((${message_text[$id]} >= 30 && ${message_text[$id]} <= 60)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    func_add_l2tp2 $CAD_ARQ
                else
                    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                        --text "$(echo -e "â›” Can't be more than 60 Days")" \
                        --parse_mode html
                    >$CAD_ARQ
                    break
                    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                        --text "Func Error Do Nothing" \
                        --reply_markup "$(ShellBot.ForceReply)"
                fi
                    ;;
                'ðŸ—‘ REMOVE USER L2TP ðŸ—‘\n\nUsername:')
                    verifica_acesso
                    func_del_l2tp ${message_text[$id]}
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text "âœ… *Successfully removed.* ðŸš®" \
                        --parse_mode markdown
                    ;;
                'ðŸ‘¤ CREATE TRIAL L2TP ðŸ‘¤\n\nHow many hours should it last ? EX: 1:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
                        user_on=$(ls /etc/.maAsiss/db_reseller/${message_from_id}/trial-fold)
                        func_verif_limite_res ${message_from_id}
                        [[ "$_result" -ge "$_limTotal" ]] && {
                            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                                --text "â›” Max Limit Create Trial only $_limTotal Users\n\nYou Still Have User Active : $user_on" \
                                --parse_mode html
                            break
                            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                 --text "Func Error Do Nothing" \
                                 --reply_markup "$(ShellBot.ForceReply)"
                        }
                    }
                    if ((${message_text[$id]} == 1 || ${message_text[$id]} == 2)); then
                        func_add_l2tp_trial ${message_text[$id]}
                    else
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Trial Max Hours only 1-2")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    fi
                    ;;
                'ðŸ‘¤ CREATE USER PPTP ðŸ‘¤\n\nUsername:')
                    verifica_acesso
                    [ "${message_text[$id]}" == 'root' ] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” INVALID USER")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    sizemax=$(echo -e ${#message_text[$id]})
                    [[ "$sizemax" -gt '10' ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use no maximum 10 characters [EX: KennXV]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                    }
                    user_already_exist ${message_text[$id]}
                    echo "Name: ${message_text[$id]}" >$CAD_ARQ
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'PPTP Password:' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'PPTP Password:')
                    verifica_acesso
                    echo "Password: ${message_text[$id]}" >>$CAD_ARQ
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'PPTP Validity in days: ' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'PPTP Validity in days:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 30]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                if ((${message_text[$id]} >= 1 && ${message_text[$id]} <= 30)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    func_add_pptp $CAD_ARQ
                elif ((${message_text[$id]} >= 30 && ${message_text[$id]} <= 60)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    func_add_pptp2 $CAD_ARQ
                else
                    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                        --text "$(echo -e "â›” Can't be more than 60 Days")" \
                        --parse_mode html
                    >$CAD_ARQ
                    break
                    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                        --text "Func Error Do Nothing" \
                        --reply_markup "$(ShellBot.ForceReply)"
                fi
                    ;;
                'ðŸ—‘ REMOVE USER PPTP ðŸ—‘\n\nUsername:')
                    verifica_acesso
                    func_del_pptp ${message_text[$id]}
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text "âœ… *Successfully removed.* ðŸš®" \
                        --parse_mode markdown
                    ;;
                'ðŸ‘¤ CREATE TRIAL PPTP ðŸ‘¤\n\nHow many hours should it last ? EX: 1:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
                        user_on=$(ls /etc/.maAsiss/db_reseller/${message_from_id}/trial-fold)
                        func_verif_limite_res ${message_from_id}
                        [[ "$_result" -ge "$_limTotal" ]] && {
                            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                                --text "â›” Max Limit Create Trial only $_limTotal Users\n\nYou Still Have User Active : $user_on" \
                                --parse_mode html
                            break
                            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                 --text "Func Error Do Nothing" \
                                 --reply_markup "$(ShellBot.ForceReply)"
                        }
                    }
                    if ((${message_text[$id]} == 1 || ${message_text[$id]} == 2)); then
                        func_add_pptp_trial ${message_text[$id]}
                    else
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Trial Max Hours only 1-2")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    fi
                    ;;
                'ðŸ‘¤ CREATE USER Trojan-GO ðŸ‘¤\n\nUsername:')
                    verifica_acesso
                    [ "${message_text[$id]}" == 'root' ] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” INVALID USER")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    sizemax=$(echo -e ${#message_text[$id]})
                    [[ "$sizemax" -gt '10' ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use no maximum 10 characters [EX: KennXV]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                    }
                    user_already_exist ${message_text[$id]}
                    echo "Name: ${message_text[$id]}" >$CAD_ARQ
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'TRGo Validity in days: ' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'TRGo Validity in days:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 30]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                if ((${message_text[$id]} >= 1 && ${message_text[$id]} <= 30)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    func_add_trgo $CAD_ARQ
                elif ((${message_text[$id]} >= 30 && ${message_text[$id]} <= 60)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    func_add_trgo2 $CAD_ARQ
                else
                    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                        --text "$(echo -e "â›” Can't be more than 60 Days")" \
                        --parse_mode html
                    >$CAD_ARQ
                    break
                    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                        --text "Func Error Do Nothing" \
                        --reply_markup "$(ShellBot.ForceReply)"
                fi
                    ;;
                'ðŸ—‘ REMOVE USER Trojan-GO ðŸ—‘\n\nUsername:')
                    verifica_acesso
                    func_del_trgo ${message_text[$id]}
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text "âœ… *Successfully removed.* ðŸš®" \
                        --parse_mode markdown
                    ;;
                'ðŸ‘¤ CREATE TRIAL Trojan-GO ðŸ‘¤\n\nHow many hours should it last ? EX: 1:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1000]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    [[ "${message_from_id[$id]}" != "$Admin_ID" ]] && {
                        user_on=$(ls /etc/.maAsiss/db_reseller/${message_from_id}/trial-fold)
                        func_verif_limite_res ${message_from_id}
                        [[ "$_result" -ge "$_limTotal" ]] && {
                            ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                                --text "â›” Max Limit Create Trial only $_limTotal Users\n\nYou Still Have User Active : $user_on" \
                                --parse_mode html
                            break
                            ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                                 --text "Func Error Do Nothing" \
                                 --reply_markup "$(ShellBot.ForceReply)"
                        }
                    }
                    if ((${message_text[$id]} == 1 || ${message_text[$id]} == 2)); then
                        func_add_trgo_trial ${message_text[$id]}
                    else
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Trial Max Hours only 1-2")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    fi
                    ;;
                'ðŸ‘¤ CREATE USER Xray ðŸ‘¤\n\nUsername:')
                    verifica_acesso
                    [ "${message_text[$id]}" == 'root' ] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” INVALID USER")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    sizemax=$(echo -e ${#message_text[$id]})
                    [[ "$sizemax" -gt '10' ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use no maximum 10 characters [EX: KennXV]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                    }
                    user_already_exist ${message_text[$id]}
                    echo "Name: ${message_text[$id]}" >$CAD_ARQ
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'Xray Validity in days: ' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'Xray Validity in days:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 30]")" \
                            --parse_mode html
                        >$CAD_ARQ
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                if ((${message_text[$id]} >= 1 && ${message_text[$id]} <= 30)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    func_add_xray $CAD_ARQ
                elif ((${message_text[$id]} >= 30 && ${message_text[$id]} <= 1000)); then
                    info_data=$(date '+%d/%m/%C%y' -d " +${message_text[$id]} days")
                    echo "Validity: $info_data" >>$CAD_ARQ
                    func_add_xray2 $CAD_ARQ
                else
                    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                        --text "$(echo -e "â›” Can't be more than 1000 Days")" \
                        --parse_mode html
                    >$CAD_ARQ
                    break
                    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                        --text "Func Error Do Nothing" \
                        --reply_markup "$(ShellBot.ForceReply)"
                fi
                    ;;
                'ðŸ—‘ REMOVE USER Xray ðŸ—‘\n\nUsername:')
                    verifica_acesso
                    func_del_xray ${message_text[$id]}
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text "âœ… *Successfully removed.* ðŸš®" \
                        --parse_mode markdown
                    ;;
                'ðŸ’° Change Price ðŸ’°\n\nPrice SSH:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1000]")" \
                            --parse_mode html
                        >$echotoprice
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    echo "Price SSH : ${message_text[$id]}" >$echotoprice
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'Price VMess:' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'Price VMess:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1000]")" \
                            --parse_mode html
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    echo "Price VMess : ${message_text[$id]}" >>$echotoprice
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'Price VLess:' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'Price VLess:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1000]")" \
                            --parse_mode html
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    echo "Price VLess : ${message_text[$id]}" >>$echotoprice
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'Price Trojan:' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'Price Trojan:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1000]")" \
                            --parse_mode html
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    echo "Price Trojan : ${message_text[$id]}" >>$echotoprice
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'Price TrojanGO:' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'Price TrojanGO:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1000]")" \
                            --parse_mode html
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    echo "Price Trojan-GO : ${message_text[$id]}" >>$echotoprice
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'Price Wireguard:' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'Price Wireguard:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1000]")" \
                            --parse_mode html
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    echo "Price Wireguard : ${message_text[$id]}" >>$echotoprice
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'Price Shadowsocks:' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'Price Shadowsocks:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1000]")" \
                            --parse_mode html
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    echo "Price Shadowsocks : ${message_text[$id]}" >>$echotoprice
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'Price Shadowsocks-R:' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'Price Shadowsocks-R:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1000]")" \
                            --parse_mode html
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    echo "Price Shadowsocks-R : ${message_text[$id]}" >>$echotoprice
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'Price SSTP:' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'Price SSTP:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1000]")" \
                            --parse_mode html
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    echo "Price SSTP : ${message_text[$id]}" >>$echotoprice
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'Price L2TP:' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'Price L2TP:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1000]")" \
                            --parse_mode html
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    echo "Price L2TP : ${message_text[$id]}" >>$echotoprice
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'Price PPTP:' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'Price PPTP:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1000]")" \
                            --parse_mode html
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    echo "Price PPTP : ${message_text[$id]}" >>$echotoprice
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'Price Xray:' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'Price Xray:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1000]")" \
                            --parse_mode html
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    echo "Price Xray : ${message_text[$id]}" >>$echotoprice
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text "âœ… *Successfully Updated Price List* âœ…" \
                        --parse_mode markdown
                    mv /tmp/price /etc/.maAsiss/
                    ;;
                'ðŸ“¢ Info for reseller ðŸ“¢\n\ntype your information:')
                    verifica_acesso
                    echo "${message_text[$id]}" > /etc/.maAsiss/update-info
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text "âœ… *Successfully Added Information* âœ…" \
                        --parse_mode markdown
                    ;;
                'ðŸŒ€ Reset Saldo Reseller ðŸŒ€\n\nInput Name of Reseller:')
                    verifica_acesso
                    _VAR14=$(grep -w "${message_text[$id]}" "$Res_Token")
                    [[ -z $_VAR14 ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "No username found ðŸ”´")" \
                            --parse_mode html
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    echo $_VAR14 > /tmp/resSaldo
                    func_reset_saldo_res
                    ;;
                'ðŸŒ Enable Public Mode ðŸŒ\n\nExpired Days [ex:3]:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1000]")" \
                            --parse_mode html
                        >$echotoprice
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    echo "MAX_DAYS : ${message_text[$id]}" > /etc/.maAsiss/public_mode/settings
                    ShellBot.sendMessage --chat_id ${message_from_id[$id]} \
                        --text 'Max User [ex:10]:' \
                        --reply_markup "$(ShellBot.ForceReply)"
                    ;;
                'Max User [ex:10]:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 1000]")" \
                            --parse_mode html
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    echo "MAX_USERS : ${message_text[$id]}" >> /etc/.maAsiss/public_mode/settings
                    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                          --text "Succesfully enable public modeâˆš\n\nShare your bot and tell everyones to type /free" \
                          --parse_mode html
                    ;;
                'ðŸ˜¤ Unblock user ðŸ˜¤\n\nInput user ID to unblock:')
                    verifica_acesso
                    [[ ${message_text[$id]} != ?(+|-)+([0-9]) ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "â›” Use only numbers [EX: 100938380]")" \
                            --parse_mode html
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    _VA4=$(grep -w "${message_text[$id]}" "/etc/.maAsiss/user_flood")
                    [[ -z $_VA4 ]] && {
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                            --text "$(echo -e "ID not found ðŸ”´")" \
                            --parse_mode html
                        break
                        ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} \
                            --text "Func Error Do Nothing" \
                            --reply_markup "$(ShellBot.ForceReply)"
                    }
                    sed -i "/^${message_text[$id]}/d" "/etc/.maAsiss/user_flood"
                    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                          --text "Succesfully unblock user id <b>${message_text[$id]}</b>" \
                          --parse_mode html
                    ;;
                esac
            fi
        ) &
    done
done