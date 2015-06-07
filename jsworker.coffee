
version  = '0.0.1'

log = (args...)->
    console.log 'shw', version, args...
    
connections = 0
log 'connections', connections

self.addEventListener 'connect', (event)->
    log 'connect', event
    port = event.ports[0]
    connections++

    port.addEventListener 'message', (event)->
        log 'message', event
        port.postMessage 'hello ' + event.data + ' ' + connections

    port.start()

, false
