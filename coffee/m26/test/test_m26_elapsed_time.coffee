
m26 = require('../js/m26')

describe 'm26.ElapsedTime', ->

  it 'should parse its values from a 3-token String passed to the constructor', ->
    et1 = new m26.ElapsedTime('01:02:03')
    et1.hh.should.equal 1
    et1.mm.should.equal 2
    et1.ss.should.equal 3
    et1.secs.should.equal 3723

  it 'should parse its values from a 2-token String passed to the constructor', ->
    et1 = new m26.ElapsedTime('02:03')
    et1.hh.should.equal 0
    et1.mm.should.equal 2
    et1.ss.should.equal 3
    et1.secs.should.equal 123

  it 'should parse its values from a 1-token String passed to the constructor', ->
    et1 = new m26.ElapsedTime('08')
    et1.hh.should.equal 0
    et1.mm.should.equal 0
    et1.ss.should.equal 8
    et1.secs.should.equal 8

  it 'should parse its values from Number passed to the constructor', ->
    et1 = new m26.ElapsedTime(3664)
    et1.hh.should.equal 1
    et1.mm.should.equal 1
    et1.ss.should.equal 4
    et1.secs.should.equal 3664

    et1 = new m26.ElapsedTime(1)
    et1.hh.should.equal 0
    et1.mm.should.equal 0
    et1.ss.should.equal 1
    et1.secs.should.equal 1

  it 'should implement zero_pad', ->
    et1 = new m26.ElapsedTime('00:30:00')
    et1.zero_pad(0).should.equal '00'
    et1.zero_pad(1).should.equal '01'
    et1.zero_pad(17).should.equal '17'

  it 'should implement as_hhmmss', ->
    new m26.ElapsedTime('00:30:00').as_hhmmss().should.equal '00:30:00'
    new m26.ElapsedTime('1:2:3').as_hhmmss().should.equal '01:02:03'
    new m26.ElapsedTime('1:2:3.5').as_hhmmss().should.equal '01:02:03'
    new m26.ElapsedTime('1:2:3.6').as_hhmmss().should.equal '01:02:03'

  it 'should implement as_hours', ->
    new m26.ElapsedTime('00:30:00').as_hours().should.be.within(0.49999, 0.50001)
    new m26.ElapsedTime('03:45:00').as_hours().should.be.within(3.749999, 3.750001)
