WTFWebRTC = (webrtc)->
  context =
    send: (data)->
      data
  webrtc = window if typeof webrtc is 'undefined'
  #require('wrtc');

  pc = null
  offer = null
  answer = null

  ### 1. Global settings, data and functions. ###
  dataChannelSettings = 'reliable':
    ordered: true
    maxRetransmits: 0
  pcSettings = [
    { iceServers: [ { url: 'stun:stun.l.google.com:19302' } ] }
    { 'optional': [ { DtlsSrtpKeyAgreement: false } ] }
  ]
  pendingDataChannels = {}
  dataChannels = {}

  ### 2. This code deals with the --join case. ###
  doHandleError = (error) ->
    throw error
    return

  onsignalingstatechange = (event) ->
    console.info('signaling state change:', event.target)
    return

  oniceconnectionstatechange = (event) ->
    console.info('ice connection state change:', event.target)
    return

  onicegatheringstatechange = (event) ->
    console.info('ice gathering state change:', event.target)
    return

  inputLoop = (channel) ->
    console.log 'inputLoop', channel
    context.channel = channel
    return

  doShowAnswer = ->
    answer = pc.localDescription
    console.log '\n\nHere is your answer:'
    JSON.stringify(answer.toJSON())
    # console.log(JSON.stringify(ans) + "\n\n");

  doCreateAnswer = ->
    pc.createAnswer doSetLocalDesc, doHandleError
    return

  doSetLocalDesc = (desc) ->
    answer = desc
    pc.setLocalDescription desc, undefined, doHandleError
    return

  doHandleDataChannels = ->
    labels = Object.keys(dataChannelSettings)

    pc.ondatachannel = (evt) ->
      channel = evt.channel
      label = channel.label
      pendingDataChannels[label] = channel
      #channel.binaryType = 'arraybuffer';

      channel.onopen = ->
        dataChannels[label] = channel
        delete pendingDataChannels[label]
        if Object.keys(dataChannels).length == labels.length
          console.log '\nConnected!'
          if context.onConnected
            context.onConnected #(data)->
             #   channel.send JSON.stringify data
          inputLoop channel
        return

      channel.onmessage = (evt) ->
        console.log 'onMessage peer', evt.data
        data = JSON.parse(evt.data)
        #cursor.blue();
        console.log data
        if context.onMessage
          context.onMessage data
        inputLoop channel
        return

      channel.onerror = doHandleError
      return

    pc.setRemoteDescription offer, doCreateAnswer, doHandleError
    return

  makeDataChannel = ->
    # If you don't make a datachannel *before* making your offer (such
    # that it's included in the offer), then when you try to make one
    # afterwards it just stays in "connecting" state forever.  This is
    # my least favorite thing about the datachannel API.
    channel = pc.createDataChannel('test', reliable: true)

    channel.onopen = ->
      console.log '\nConnected!'
      if context.onConnected
        context.onConnected channel
      inputLoop channel
      return

    channel.onmessage = (evt) ->
      console.log 'onmessage', evt.data
      data = JSON.parse(evt.data)
      #cursor.blue();
      console.log data
      if context.onMessage
        context.onMessage data
      inputLoop channel
      return

    channel.onerror = doHandleError
    return

  context.getOffer = (pastedOffer, success) ->
    data = JSON.parse(pastedOffer)
    offer = new (webrtc.RTCSessionDescription)(data)
    answer = null
    pc = new (webrtc.RTCPeerConnection)(pcSettings[0])
    pc.onsignalingstatechange = onsignalingstatechange
    pc.oniceconnectionstatechange = oniceconnectionstatechange
    pc.onicegatheringstatechange = onicegatheringstatechange

    pc.onicecandidate = (candidate) ->
      # Firing this callback with a null candidate indicates that
      # trickle ICE gathering has finished, and all the candidates
      # are now present in pc.localDescription.  Waiting until now
      # to create the answer saves us from having to send offer +
      # answer + iceCandidates separately.
      if candidate.candidate == null
        console.log  pc.localDescription
        ans = doShowAnswer()
        console.log JSON.stringify(ans) + '\n\n'
        if success
          success ans
      return

    doHandleDataChannels()
    return

  ### 3. From here on down deals with the --create case. ###

  context.makeOffer = (success) ->
    pc = new (webrtc.RTCPeerConnection)(pcSettings[0])
    makeDataChannel()
    pc.onsignalingstatechange = onsignalingstatechange
    pc.oniceconnectionstatechange = oniceconnectionstatechange
    pc.onicegatheringstatechange = onicegatheringstatechange
    pc.createOffer (desc) ->
      pc.setLocalDescription desc, ->
      # We'll pick up the offer text once trickle ICE is complete,
      # in onicecandidate.
      return

    pc.onicecandidate = (candidate) ->
      # Firing this callback with a null candidate indicates that
      # trickle ICE gathering has finished, and all the candidates
      # are now present in pc.localDescription.  Waiting until now
      # to create the answer saves us from having to send offer +
      # answer + iceCandidates separately.
      if candidate.candidate == null
        console.log 'Your offer is:'
        offerText = JSON.stringify(pc.localDescription)
        console.log JSON.stringify(offerText)
        if success
          success offerText
      return

    return

  context.getAnswer = (pastedAnswer) ->
    data = if typeof pastedAnswer is 'object' then pastedAnswer else JSON.parse(pastedAnswer)
    answer = new webrtc.RTCSessionDescription(data)
    pc.setRemoteDescription answer
    return

  context

module?.exports = WTFWebRTC
