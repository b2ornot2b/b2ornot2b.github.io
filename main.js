// Generated by CoffeeScript 1.9.2
var offerClicked;

offerClicked = function(event) {
  var wtfwebrtc;
  console.log('offerClicked', event);
  wtfwebrtc = WTFWebRTC();
  wtfwebrtc.onConnected = function() {
    console.log('wtfwebrtc.onConnected');
    return wtfwebrtc.onMessage = function(data) {
      console.log('wtfwebrtc.onMessage', data);
      return fbp.onCtrlIn(data);
    };
  };
  return wtfwebrtc.getOffer(offerText, function() {
    return console.log(offerText);
  });
};

//# sourceMappingURL=main.js.map
