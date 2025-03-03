pkgs:
pkgs.writeShellScript "sway-slider" ''
  operation=$1
  current=$2
  shift
  shift
  scale=($@)
  len=''${#scale[@]}
  max=$(( $len - 1 ))

  case $operation in
      "up")
          num=$max
          level=''${scale[$num]}
          for (( i=$max; i>=0; i-- )); do
              if [[ $current -lt ''${scale[$i]} ]]; then
                  num=$i
                  level=''${scale[$i]}
              fi
          done
          ;;
      "down")
          num=0
          level=''${scale[$num]}
          for (( i=0; i<=$max; i++ )); do
              if [[ $current -gt ''${scale[$i]} ]]; then
                  num=$i
                  level=''${scale[$i]}
              fi
          done
          ;;
      "query")
          num=0
          for (( i=0; i<=$max; i++ )); do
              if [[ $current -ge ''${scale[$i]} ]]; then
                  num=$i
              fi
          done
          level=$current
          ;;
      *)
          echo error
          exit 1
  esac

  
  hundred=$(( $num * ( 100 / $max ) )) # preserve 0-100
  echo $level $hundred $num $max
''
