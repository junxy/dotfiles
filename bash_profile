    for f in ~/.dotfiles/bash/*; do
      # echo -n "$(basename $f) "
      #echo -n "."
      if [[ -f "$f" ]]; then 
        source $f
      fi
    done
 

