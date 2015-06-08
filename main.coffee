

window.offerClicked = (event)->
    console.log 'offerClicked', event

    offerText = document.querySelector('#offer').value
    console.log 'offerText', offerText


    rtc = RTC
        room: 'b2ornot2b'
        #signaller: 'http://10.10.0.13:8997'
        signaller: 'https://switchboard.rtc.io'
        capture: false
    rtc.on 'ready', (session)->
        session.createDataChannel 'chat',
            ordered: true
            maxRetransmits: 12
        session.on 'channel:opened:chat', (id, channel, attributes, connection)->
            console.log 'channel:opened:chat', id, channel, attributes, connection
            channel.onmessage = (event)->
                console.log 'msg: ', event.data

