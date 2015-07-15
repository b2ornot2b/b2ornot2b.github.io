
#webrtc = WTFWebRTC()

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

window.rooms = {}
window.connectRoom = (room, onPeer, onMessage)->
    context =
        'room': room
        'onPeer': onPeer
        'onMessage': onMessage
        peers: []

    context.send = (msg, peerAttrs)->
      console.log '0 send', context.peers.length
      context.peers = (peer for peer in context.peers when peer.channel.readyState isnt 'closed')
      console.log '1 send', context.peers.length
      for peer in context.peers when peer.channel.readyState is 'open'
        unless typeof peerAttrs is 'undefined'
          for k,v of peerAttrs
            console.log 'send peerAttrs', msg, peer, k, v
            if peer.meta[k] is v
              console.log 'sending message', msg, peer
              peer.channel.send msg
        else
          peer.channel.send msg


    conf = RTC
        'room': room
        'signaller': 'http://128.199.127.220:8997'
        'constraints': null
        'channels':
            'chat': true
        'ice': [  { url: 'stun:stun1.l.google.com:19302' },
                { url: 'stun:stun2.l.google.com:19302' },
                { url: 'stun:stun3.l.google.com:19302' },
                { url: 'stun:stun4.l.google.com:19302' } ]

    conf.on 'channel:opened:chat', (id, channel, attributes, connection)->
        console.log 'channel:opened:chat', id, channel, attributes, connection

        peerInfo =
          id: id
          channel: channel
          browser:
              name: attributes.browser
              version: attributes.browserVersion
          signaller: attributes.signaller

        channel.onmessage = (event)-> context.onMessage event.data, peerInfo

        peerInfo.meta = context.onPeer.apply context
        context.peers.push peerInfo

    context

window.rooms.test = window.connectRoom 'b2ornot2b:test', (id)->
    console.log 'onPeer', this
, (msg, peer)->
    console.log 'onMessage', this, msg, peer


# Service Worker
if navigator.serviceWorker
    n = navigator.serviceWorker.register('service-worker.js', {scope: './'}).then ()->
        if navigator.serviceWorker.controller
            console.log 'The service worker is currently handling network operations.'
        else
            console.log 'Please reload this page to allow the service worker to handle network operations.'
            location.reload()
    n.catch (error)->
        console.log error
else
    console.log 'Service worker unavailable'

window.sendWorker = (msg)->
    new Promise (resolve, reject)->
        channel = new MessageChannel()
        console.log 'promise'
        channel.port1.onmessage = (event)->
            console.log 'onmessage', event
            if event.data.error
                reject event.data.error
            else
                resolve event.data
        navigator.serviceWorker.controller.postMessage(msg, [channel.port2])


window.loadSharedWorker = (name)->
    worker = new SharedWorker name+'.js'
    worker.port.addEventListener 'message', (event)->
        console.log 'SharedWorker ', name, '>>', event.data
    , false
    worker.port.start()
    worker.port.postMessage
        'command': 'init'
        'name': name

window.loadSharedWorker 'jsworker'
