{
  ...
}: {
  services.libinput = {
    enable = true;
    
    mouse = {
      accelProfile = "flat";
      accelSpeed = "0";
      middleEmualtion = false;
    };

    touchpad = {
      naturalScrolling = true;
      tapping = true;
      clickMethod = "clickfinger";
      disableWhileTyping = false;
    };
  };
}
