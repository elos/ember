# encoding: utf-8
`import DS from 'ember-data'`
`import Ember from 'ember'`

# --- WebSocketAdapter {{{
WebSocketAdapter = DS.Adapter.extend
  id: null
  key: null
  host: "ws://localhost:8000/v1/authenticate"

  protocol: (->
    return null unless @get("id") and @get("key")
    "#{@get("id")}-#{@get("key")}"
  ).observes("id", "key")

  setupConnection: (->
    protocol = @protocol()
    return unless protocol

    @connection = new WebSocket @get "host", protocol
    @connection.onmessage = @onMessage
    @connection.onerror = @onError
    @connection.onclose = @onClose
  ).observes("id", "key").on("init")

  onMessage: (event) ->
    @process JSON.parse event.data

  onError: (event) ->
    console.log "There was an error with the WebSocket connection"
    console.log event

  onClose: (event) ->
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

  find: (store, type, id, record) ->
    msg = @message "GET", type, { id: id }
    @connection.send JSON.stringify msg

  createRecord: (store, type, record) ->
    data = {}
    serializer = store.serializerFor(type.typeKey)

    serializer.serializeIntoHash(data, type, record, { includeId: true })

    msg = @message "POST", type, data
    @connection.send JSON.stringify msg

  updateRecord: (store, type, record) ->
    @createRecord(store, type, record) # for now...

  deleteRecord: (store, type, record) ->
    id = Ember.get(record, "id")

    msg = @message "DELETE", type, { id: id }
    @connection.send JSON.stringify msg
# --- }}}

`export default WebSocketAdapter`

# vim: ai tabstop=2 expandtab shiftwidth=2 softtabstop=2