#!/bin/sh

## Set key and secret.

KEY=ENTER_API_KEY_HERE
SECRET=ENTER_API_SECRET_HERE

## Print selection menu.

printf "\n"

showMenu(){
  
  echo "===================================="
  echo "    ShellOgre    "
  echo "===================================="
  echo "[1] Get BTC Balance."
  echo "[2] Get XMR Balance."
  echo "[3] Buy XMR with BTC"
  echo "[4] Buy BTC with XMR"
  echo "[5] Exit"
  echo "===================================="
  
  printf "\n"
  printf "\n"
  
  read -p "Please Select A Number: " mc
  return $mc
}

## Execute the selection input.

while [[ "$m" != "5" ]]
do
  if [[ "$m" == "1" ]]; then
    
    ## Get BTC Balance.
    
    printf "\n"
    printf "\n"
    
    echo Your BTC balance is:
    
    curl -s --request POST \
    --url https://tradeogre.com/api/v1/account/balance \
    --user $KEY:$SECRET \
    --form currency=BTC | jq '.balance' | tr '"' ' '
    
    printf "\n"
    printf "\n"
    
    echo Your available BTC balance is:
    
    curl -s --request POST \
    --url https://tradeogre.com/api/v1/account/balance \
    --user $KEY:$SECRET \
    --form currency=BTC | jq '.available' | tr '"' ' '
    
    printf "\n"
    printf "\n"
    
    elif [[ "$m" == "2" ]]; then
    
    ## Get XMR Balance.
    
    printf "\n"
    printf "\n"
    
    echo Your XMR balance is:
    
    curl -s --request POST \
    --url https://tradeogre.com/api/v1/account/balance \
    --user $KEY:$SECRET \
    --form currency=XMR | jq '.balance' | tr '"' ' '
    
    printf "\n"
    printf "\n"
    
    echo Your available XMR balance is:
    
    curl -s --request POST \
    --url https://tradeogre.com/api/v1/account/balance \
    --user $KEY:$SECRET \
    --form currency=XMR | jq '.available' | tr '"' ' '
    
    printf "\n"
    printf "\n"
    
    
    elif [[ "$m" == "3" ]]; then
    
    ## Buy XMR with BTC
    
    BTCXMR=$(curl -s --request GET \
    --url https://tradeogre.com/api/v1/ticker/BTC-XMR | jq '.price' | tr -d '"')
    
    XMRUSD=$(curl -s -X GET "https://api.coingecko.com/api/v3/simple/price?ids=monero&vs_currencies=usd" -H  "accept: application/json" | jq '.monero.usd')
    
    CURRENTBTC=$(curl -s --request POST \
      --url https://tradeogre.com/api/v1/account/balance \
      --user $KEY:$SECRET \
    --form currency=BTC | jq '.available' | tr -d '"')
    
    echo Current XMR Price is 1 XMR = "$BTCXMR" BTC, worth $XMRUSD USD. &&
    echo How many BTC would you like to trade for XMR? &&
    echo Your current balance is $CURRENTBTC BTC.
    printf "\n"
    
    read howmanybtc
    
    curl --request POST \
    --url https://tradeogre.com/api/v1/order/buy \
    --user $KEY:$SECRET \
    --form market=BTC-XMR \
    --form quantity=$howmanybtc \
    --form price=$BTCXMR
    
    
    printf "\n"
    printf "\n"
    
    
    elif [[ "$m" == "4" ]]; then
    
    ## Buy BTC with XMR
    
    XMRBTC=$(curl -s --request GET \
    --url https://tradeogre.com/api/v1/ticker/BTC-XMR | jq '.bid' | tr -d '"')
    
    BTCUSD=$(curl -s -X GET "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd" -H  "accept: application/json" | jq '.bitcoin.usd')
    
    CURRENTXMR=$(curl -s --request POST \
      --url https://tradeogre.com/api/v1/account/balance \
      --user $KEY:$SECRET \
    --form currency=XMR | jq '.available' | tr -d '"')
    
    echo Current BTC Price is 1 BTC = "$XMRBTC" XMR, worth $BTCUSD USD. &&
    echo How many XMR would you like to trade for BTC? &&
    echo Your current balance is $CURRENTXMR XMR.
    printf "\n"
    
    read howmanyxmr
    
    curl --request POST \
    --url https://tradeogre.com/api/v1/order/buy \
    --user $KEY:$SECRET \
    --form market=XMR-BTC \
    --form quantity=$howmanyxmr \
    --form price=$XMRBTC
    
    
    printf "\n"
    printf "\n"
    
    
  fi
  showMenu
  m=$?
done

exit 0;
