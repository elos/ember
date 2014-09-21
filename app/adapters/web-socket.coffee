# encoding: utf-8
`import DS from 'ember-data'`
`import Ember from 'ember'`

WebSocketAdapter = DS.Adapter.extend
  id: null
  key: null

  store: null

  connected: false
  queue: []

  host: "ws://localhost:8000/v1/authenticate"

  protocol: (->
    return null unless @get("id") and @get("key")
    "#{@get("id")}-#{@get("key")}"
  ).observes("id", "key")

  setupConnection: (->
    protocol = @protocol()
    return unless protocol

    @connection = new WebSocket @get("host"), protocol
    @connection.onopen = @onOpen
    @connection.onmessage = @onMessage
    @connection.onerror = @onError
    @connection.onclose = @onClose
  ).observes("id", "key").on("init")

  onMessage: (event) ->
    @process JSON.parse event.data

  onError: (event) ->
    console.log "There was an error with the WebSocket connection"
    console.log event

  onOpen: ->
    @connected = true
    console.log "WebSocket connection opened"

  onClose: (event) ->
    @connected = false
    if event.manual
      console.log "You manually closed the WebSocket connection"
    else
      console.log "The WebSocket connection has been closed"
      console.log event

  process: (envelope)->
    console.log envelope

  message: (action, type, messageData={}) ->
    data = {}
    data[type.typeKey] = messageData

    action: action
    data: data

  sendMessage: (action, type, messageData={}) ->
    data = {}
    data[type.typeKey] = messageData

    msg =
      action: action
      data: data

    if @get 'connected'
      @connection.send JSON.stringify msg
    else
      @queue.push msg

  find: (store, type, id) ->
    @sendMessage "GET", type, { id: id }
    id: id

  createRecord: (store, type, record) ->
    data = {}
    serializer = store.serializerFor(type.typeKey)

    serializer.serializeIntoHash(data, type, record, { includeId: true })

    @sendMessage "POST", type, data
    record

  updateRecord: (store, type, record) ->
    @createRecord(store, type, record) # for now...
    record

  deleteRecord: (store, type, record) ->
    id = Ember.get(record, "id")

    @sendMessage "DELETE", type, { id: id }

`export default WebSocketAdapter`

# vim: ai tabstop=2 expandtab shiftwidth=2 softtabstop=2
