
#webrtc = WTFWebRTC()

window.sworker = (msg)->
    new Promise (resolve, reject)->
        console.log 'promise'
        channel = new MessageChannel()
        channel.port1.onmessage = (event)->
            console.log 'onmessage', event
            if event.data.error
                reject event.data.error
            else
                resolve event.data
        navigator.serviceWorker.controller.postMessage(msg, [channel.port2])

window.offerClicked = (event)->
    console.log 'offerClicked', event

    url = document.querySelector('#url').value.trim()
    content = document.querySelector('#data').value.trim()
    console.log 'url', url, data

    window.sworker({ command: 'keys'}).then (data)->
            console.log 'keys', data

    if url.length isnt 0
        console.log url, data
        window.sworker({command: 'add', url: url, content: if content.length is 0 then null else content}).then (data)->
            console.log 'add', url, content, data




    #peer = new Peer peerId,
    #    key: 'lwjd5qra8257b9'

    #peer.on 'open', (id)->
    #    console.log 'PeerID: ', id

    #    if id is 'b2ornot2b'
    #    conn = peer.connect 'b2ornot2b'
    #    conn.on 'open', ()->
    #        console.log 'connection.'
    #        conn.on 'data', (data)->
    #            console.log 'data:', data
    #            return
    #        conn.send 'hello'
    #        conn.on '

    #rtc = RTC
    #    room: 'b2ornot2b'
    #    signaller: 'https://switchboard.rtc.io'
    #    capture: false
    #rtc.on 'ready', (session)->
    #    session.createDataChannel 'chat',
    #        ordered: true
    #        maxRetransmits: 12
    #    session.on 'channel:opened:chat', (id, channel, attributes, connection)->
    #        console.log 'channel:opened:chat', id, channel, attributes, connection
    #        channel.onmessage = (event)->
    #            console.log 'msg: ', event.data

