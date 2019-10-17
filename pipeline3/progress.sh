#!/bin/sh

speed="0.05"
duration="100"
barSymbol="#"
barsize="100" #$((`tput cols` - 7))
unity=$(($barsize / $duration))
increment=$(($barsize%$duration))
skip=$(($duration/($duration-$increment)))
curr_bar=0
prev_bar=
elapsed=1; while [ "$elapsed" -le "$duration" ]; do

  prev_bar=$curr_bar
  let curr_bar+=$unity
  [[ $increment -eq 0 ]] || {  
    [[ $skip -eq 1 ]] &&
      { [[ $(($elapsed%($duration/$increment))) -eq 0 ]] && let curr_bar++; } ||
	{ [[ $(($elapsed%$skip)) -ne 0 ]] && let curr_bar++; }
  }
  [[ $elapsed -eq 1 && $increment -eq 1 && $skip -ne 1 ]] && let curr_bar++
  [[ $(($barsize-$curr_bar)) -eq 1 ]] && let curr_bar++
  [[ $curr_bar -lt $barsize ]] || curr_bar=$barsize

  filled=0; while [ "$filled" -le "$curr_bar" ]; do

    printf $barSymbol

  filled=$((filled + 1))
  done

  # Remaining

  remain=$curr_bar; while [ "$remain" -lt "$barsize" ]; do
    printf " "
    remain=$((remain + 1 ))
  done

  # Percentage
  printf "| %s%%" $(( ($elapsed*100)/$duration))
  elapsed=$((elapsed + 1))
  
  # Return
  sleep $speed
  printf "\r"
done
printf "\n"
exit 0
