

window.offerClicked = (event)->
    console.log 'offerClicked', event

    offerText = document.querySelector('#offer').value
    console.log 'offerText', offerText

    peer = new Peer
        key: 'lwjd5qra8257b9'

    peer.on 'open', (id)->
        console.log 'PeerID:', id

        conn = peer.connect 'b2ornot2b'
        conn.on 'open', ()->
            console.log 'open.'
            conn.on 'data', (data)->
                console.log 'Data:', data

            conn.send offerText
