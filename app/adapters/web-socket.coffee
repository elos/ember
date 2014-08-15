# encoding: utf-8
`import DS from 'ember-data'`
`import Ember from 'ember'`

# --- ElosConnection {{{
ElosConnection = Ember.Object.extend

  # URL to connect to
  host: "ws://localhost:8000/v1/authenticate"

  # The ember adapter that queries this connection
  adapter: null

  # The websocket connection to the elos server
  connection: null

  # Opens a socket to the server
  connect: (id, key)->
    return if @get "connected"

    protocol = "#{id}-#{key}"
    @connection = new WebSocket @host, protocol
    @configureConnection()

  # Closes the connection to the server
  disconnect: ->
    return unless @get "connected"

    @connection.close()
    @onClose manual: true

  # Checks the presence of the connection
  connected: (->
    return !!@connection
  ).property "connection"


  # Internal configuration of the websocket connection
  configureConnection: ->
    @connection.onmessage = @OnMessage
    @connection.onerror = @onError
    @connection.onclose = @onClose


  # Handles generic onmessage (where everything happens)
  onMessage: (event)->
    @adapter.process JSON.parse event.data

  # Handles errors (not sure what those might be yet)
  onError: (event)->
    console.log "There was an error with your Elos connection"
    console.log event

  # Handles close event (triggered twice on manual close for console info)
  onClose: (event)->
    if event.manual
      console.log "You manually closed the elos connection"
    else
      console.log "The Elos connection has been closed"
      console.log event

  init: (id, key, adapter)->
    @connect id, key
    @adapter = adapter
    return this
# --- }}}

# --- WebSocketAdapter {{{
WebSocketAdapter = DS.ActiveModelAdapter.extend

  process: (envelope)->
    console.log envelope
# --- }}}

`export default WebSocketAdapter`

# vim: ai tabstop=2 expandtab shiftwidth=2 softtabstop=2
