# encoding: utf-8
`import DS from 'ember-data'`
`import Ember from 'ember'`

WebSocketAdapter = DS.Adapter.extend
  id: null
  key: null
  connection: null
  connected: false
  failedConnection: false

  store: null

  queue: []

  host: "ws://localhost:8000/v1/authenticate"

  protocol: (->
    return null unless @get("id") and @get("key")
    "#{@get("id")}-#{@get("key")}"
  ).observes("id", "key")

  connect: (id, key)->
    @set('failedConnection', false)
    @setProperties({"id": id, "key": key})
    protocol = @protocol()
    return unless protocol

    @set('connection', new WebSocket @get("host"), protocol)
    connection = @get('connection')
    connection.adapter = @
    connection.onopen = @get('onOpen')
    connection.onmessage = @get('onMessage')
    connection.onerror = @get('onError')
    connection.onclose = @get('onClose')

  onMessage: (event) ->
    @adapter.process JSON.parse event.data

  onError: (event) ->
    console.log "There was an error with the WebSocket connection"
    console.log event
    @adapter.set('failedConnection', true)

  onOpen: ->
    @adapter.set('connected', true)
    console.log "WebSocket connection opened"

  onClose: (event) ->
    @adapter.set('connected', false)
    if event.manual
      console.log "You manually closed the WebSocket connection"
    else
      console.log "The WebSocket connection has been closed"
      console.log event

  process: (envelope)->
    store = @get('container').lookup "store:main"
    for kind, data of envelope.data
      store.push(kind, data)

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
