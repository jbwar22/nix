lib: {
  # format:
  # ${numCharacters}x${numSteps}

  getHorizontal = numChars: numSteps: with lib; let
    stepDefs = {
      "1" = [ "█" ];
      "2" = [ "▌" "█" ];
      "4" = [ "▎" "▌" "▊" "█" ];
      "8" = [ "▏" "▎" "▍" "▌" "▋" "▊" "▉" "█" ];
    };
    maxIndex = ((numChars * numSteps) - 1);
    stepList = stepDefs.${toString numSteps};
    fullc = last stepList;
    emptyc = " ";
  in map (x: let
    chari = x / numSteps;
    stepi = mod x numSteps;
    numFull = chari;
    numEmpty = (numChars - 1) - chari;
    full = map (_: fullc) (range 1 numFull);
    empty = map (_: emptyc) (range 1 numEmpty);
    active = [ (elemAt stepList stepi) ];
    combined = full ++ active ++ empty;
    fullstr = concatStrings combined;
  in fullstr) (range 0 maxIndex);

  vertical = {
    step1x8 = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
  };
}
