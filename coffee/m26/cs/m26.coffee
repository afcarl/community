###
Copyright 2013, Chris Joakim, <cjoakim@bellsouth.net>
###

class M26

  @UOM_MILES:      'm'
  @UOM_KILOMETERS: 'k'
  @UOM_YARDS:      'y'
  @UNITS_OF_MEASURE: [@UOM_MILES, @UOM_KILOMETERS, @UOM_YARDS]
  @KILOMETERS_PER_MILE = 1.61290322581
  @YARDS_PER_MILE      = 1760.0
  @MILES_PER_KILOMETER = 0.62
  @YARDS_PER_KILOMETER = 1091.2
  @SECONDS_PER_HOUR    = 3600.0

class Distance

  constructor: (d=0, uom=M26.UOM_MILES) ->
    @d = parseFloat(d)
    @d = 0 unless @d
    if uom
      @u = uom.toString().toLowerCase()
    else
      @u = M26.UOM_MILES

    unless @u in M26.UNITS_OF_MEASURE
      @u = M26.UOM_MILES

  as_miles: ->
    switch @u
      when M26.UOM_MILES then @d
      when M26.UOM_KILOMETERS then @d / M26.KILOMETERS_PER_MILE
      when M26.UOM_YARDS then @d / M26.YARDS_PER_MILE
      else 0

  as_kilometers: ->
    switch @u
      when M26.UOM_MILES then @d * M26.KILOMETERS_PER_MILE
      when M26.UOM_KILOMETERS then @d
      when M26.UOM_YARDS then (@d / M26.YARDS_PER_MILE) / M26.MILES_PER_KILOMETER
      else 0

  as_yards: ->
    switch @u
      when M26.UOM_MILES then @d * M26.YARDS_PER_MILE
      when M26.UOM_KILOMETERS then (@d * M26.MILES_PER_KILOMETER) * M26.YARDS_PER_MILE
      when M26.UOM_YARDS then @d
      else 0

  subtract: (another_instance) ->
    if another_instance
      d1 = @as_miles()
      d2 = another_instance.as_miles()
      new m26.Distance(d1 - d2)


class ElapsedTime

  constructor: (val='00:00:00') ->
    [@hh, @mm, @ss, @secs] = [0, 0, 0, 0]
    if typeof val is 'number'
      @initialize_from_number(val)
    else
      @initialize_from_string(val)

  initialize_from_number: (n) ->
    try
      @secs = new Number(n)
      @hh = Math.floor(@secs / M26.SECONDS_PER_HOUR)
      rem = @secs - (@hh * M26.SECONDS_PER_HOUR)
      @mm = Math.floor(rem / 60.0)
      @ss = rem - (@mm * 60.0)
    catch error
      console.log 'Error in ElpasedTime constructor (nbr) for ' + n + ', error: ' + error

  initialize_from_string: (s) ->
    try
      tokens = s.split(':')
      if tokens.length is 3
        @hh = parseInt(tokens[0], 10)
        @mm = parseInt(tokens[1], 10)
        @ss = parseInt(tokens[2], 10)
      else if tokens.length is 2
        @mm = parseInt(tokens[0], 10)
        @ss = parseInt(tokens[1], 10)
      else if tokens.length is 1
        @ss = parseInt(tokens[0], 10)
      else
        @ss = parseInt(s)
      @secs = (@hh * 3600) + (@mm * 60) + @ss
    catch error
      console.log 'Error in ElpasedTime constructor (str) for ' + s + ', error: ' + error

  as_hours: ->
    @secs / M26.SECONDS_PER_HOUR

  as_hhmmss: ->
    @ss = parseInt(@ss)
    '' + @zero_pad(@hh) + ':'  + @zero_pad(@mm) + ':' + @zero_pad(@ss)

  zero_pad: (n=0) ->
    if n < 10
      '0' + n
    else
      '' + n

class Speed

  constructor: (d, et) ->
    [@d, @et] = [d, et]

  mph: ->
    @d.as_miles() / @et.as_hours()

  kph: ->
    @d.as_kilometers() / @et.as_hours()

  yph: ->
    @d.as_yards() / @et.as_hours()

  pace_per_mile: ->
    spm = @seconds_per_mile()
    mm  = Math.floor(spm / 60.0)
    ss  = spm - (mm * 60)

    if ss < 10
      ss = '0' + ss
    else
      ss = '' + ss

    if ss.length > 5
      ss = ss.substring(0, 5)

    '' + mm + ':' + ss

  seconds_per_mile: ->
    @et.secs / @d.as_miles()

  projected_time: (another_distance, algorithm='simple') ->
    if algorithm is 'riegel'
      t1 = @et.secs
      d1 = @d.as_miles()
      d2 = another_distance.as_miles()
      # t2 = t1.to_f * ((d2.to_f / d1.to_f) ** pow)   Math.pow(3,3)
      t2 = t1 * Math.pow((d2 / d1), 1.06)
      et = new m26.ElapsedTime(t2);
      return et.as_hhmmss()
    else
      secs = @seconds_per_mile() * another_distance.as_miles()
      et = new m26.ElapsedTime(secs);
      return et.as_hhmmss()
    end

