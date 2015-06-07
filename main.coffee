

window.offerClicked = (event)->
    console.log 'offerClicked', event

    offerText = document.querySelector('#offer').value
    console.log 'offerText', offerText

    wtfwebrtc = WTFWebRTC()

    wtfwebrtc.onConnected = ()->
        console.log 'wtfwebrtc.onConnected'

        wtfwebrtc.onMessage = (data)->
            console.log 'wtfwebrtc.onMessage', data
            fbp.onCtrlIn data

    wtfwebrtc.getOffer offerText, ->
        console.log offerText

