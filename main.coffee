

offerClicked = (event)->
    console.log 'offerClicked', event

    wtfwebrtc = WTFWebRTC()

    wtfwebrtc.onConnected = ()->
        console.log 'wtfwebrtc.onConnected'

        wtfwebrtc.onMessage = (data)->
            console.log 'wtfwebrtc.onMessage', data
            fbp.onCtrlIn data

    wtfwebrtc.getOffer offerText, ->
        console.log offerText

