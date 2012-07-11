
m26 = require('../js/m26')

describe 'm26.Speed', ->

  d = new m26.Distance(26.20)
  t = new m26.ElapsedTime('03:47:30')
  s = new m26.Speed(d, t)

  it 'should implement mph', ->
    s.mph().should.be.within(6.90989010989010, 6.90989010989012)

  it 'should implement kph', ->
    s.kph().should.be.within(11.1449840482343, 11.1449840482345)

  it 'should implement yph', ->
    s.yph().should.be.within(12161.4065934065, 12161.4065934067)

  it 'should implement pace_per_mile', ->
    s.pace_per_mile().should.equal('8:40.99')

  it 'should implement seconds_per_mile', ->
    s.seconds_per_mile().should.be.within(520.992366412213, 520.992366412215)

  it 'should implement projected_time with the simple algorithm', ->
    d2 = new m26.Distance(20.0)
    s.projected_time(d2).should.equal('02:53:39')

  it 'should implement projected_time with the riegel algorithm', ->
    d2 = new m26.Distance(20.0)
    s.projected_time(d2, 'riegel').should.equal('02:50:52')
