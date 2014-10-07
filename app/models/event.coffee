`import DS from 'ember-data'`

Event = DS.Model.extend
  name: DS.attr

  createdAt: DS.attr('date')

  startTime: DS.attr('date')

  endTime: DS.attr('date')

  user: DS.belongsTo('user')

`export default Event`
