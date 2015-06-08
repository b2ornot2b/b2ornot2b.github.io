
window.requestFileSystem  = window.requestFileSystem ||  window.webkitRequestFileSystem

document.addEventListener 'DOMContentLoaded', (eventLoaded)->
    elem = document.querySelector '#dev-src-dropzone'

    elem.addEventListener 'dragover', (event)->
        console.log 'dragover', event
        event.stopPropagation()
        event.preventDefault()
        event.dataTransfer.dropEffect = 'copy'

    elem.addEventListener 'drop', (event)->
        console.log 'drop', event
        event.stopPropagation()
        event.preventDefault()

    #elem.ondrop = (event)->
    #    console.log event
