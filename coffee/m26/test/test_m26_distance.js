// Generated by CoffeeScript 1.3.3
(function() {
  var m26;

  m26 = require('../js/m26');

  describe('m26.Distance', function() {
    it('should default to uom miles', function() {
      new m26.Distance(1, 'x').u.should.equal('m');
      new m26.Distance(1).u.should.equal('m');
      return new m26.Distance(1, null).u.should.equal('m');
    });
    it('should lowercase the unit of measure', function() {
      new m26.Distance(1, 'M').u.should.equal('m');
      new m26.Distance(1, 'K').u.should.equal('k');
      new m26.Distance(1, 'Y').u.should.equal('y');
      new m26.Distance(1, 'm').u.should.equal('m');
      new m26.Distance(1, 'k').u.should.equal('k');
      return new m26.Distance(1, 'y').u.should.equal('y');
    });
    it('should accept either string or number values as the distance', function() {
      new m26.Distance('26.2', 'M').d.should.be.within(26.19999, 26.20001);
      return new m26.Distance(26.2, 'M').d.should.be.within(26.19999, 26.20001);
    });
    it('should implement as_miles', function() {
      new m26.Distance('26.2', 'M').as_miles().should.be.within(26.19999, 26.20001);
      new m26.Distance('10', 'k').as_miles().should.be.within(6.19999, 6.20001);
      return new m26.Distance('1760', 'y').as_miles().should.be.within(0.9999999, 1.0000001);
    });
    it('should implement as_kilometers', function() {
      new m26.Distance('6.2', 'M').as_kilometers().should.be.within(9.99999, 10.00001);
      new m26.Distance('10', 'k').as_kilometers().should.be.within(9.99999, 10.00001);
      return new m26.Distance('1760', 'y').as_kilometers().should.be.within(1.61290322580, 1.61290322582);
    });
    it('should implement as_yards', function() {
      new m26.Distance('1', 'M').as_yards().should.be.within(1759.99999, 1760.00001);
      new m26.Distance('1.61290322581', 'k').as_yards().should.be.within(1759.99999, 1760.00001);
      return new m26.Distance('1760', 'y').as_yards().should.be.within(1759.99999, 1760.00001);
    });
    return it('should implement subtract', function() {
      var d1, d2, d3;
      d1 = new m26.Distance(10, 'k');
      d2 = new m26.Distance(5, 'k');
      d3 = d1.subtract(d2);
      d3.u.should.equal('m');
      return d3.as_kilometers().should.be.within(4.99999, 5.00001);
    });
  });

}).call(this);
