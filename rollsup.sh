cd /root/massa/massa-client

#Set variables

catt=/usr/bin/cat
passwd=$($catt $HOME/massapasswd)

export PATH=$HOME/.cargo/env:$HOME/.cargo/bin:$PATH

candidat=$(/root/massa/massa-client/massa-client -p "$passwd" wallet_info|grep 'Rolls'|awk '{print $4}'| sed 's/=/ /'|awk '{print $2}')
massa_wallet_address=$(/root/massa/massa-client/massa-client -p "$passwd" wallet_info |grep 'Address'|awk '{print $2}')
tmp_final_balans=$(/root/massa/massa-client/massa-client -p "$passwd" wallet_info |grep 'alance'|awk '{print $3}'| sed 's/=/ /'|sed 's/,/ /'|awk '{print $2}')
final_balans=${tmp_final_balans%%.*}
averagetmp=$($catt /proc/loadavg | awk '{print $1}')
node=$(/root/massa/massa-client/massa-client -p "$passwd" get_status |grep 'Error'|awk '{print $1}')

if [ -z "$node" ]&&[ -z "$candidat" ];then
 echo `/bin/date +"%b %d %H:%M"` "(rollsup) Node is currently offline" >> /root/rolls.log
elif [ $candidat -gt "0" ];then
 echo `/bin/date +"%b %d %H:%M"` "Ok" >> /root/rolls.log
elif [ $final_balans -gt "99" ]; then
 echo `/bin/date +"%b %d %H:%M"` "(rollsup) The roll flew off, we check the number of coins and try to buy" >> /root/rolls.log
 resp=$(/root/massa/massa-client/massa-client -p "$passwd" buy_rolls $massa_wallet_address 1 0)
else
 echo `/bin/date +"%b %d %H:%M"` "(rollsup) Not enough coins to buy a roll from you $final_balans, minimum 100" >> /root/rolls.log
fi
