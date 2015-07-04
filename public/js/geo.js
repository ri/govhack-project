(function() {
  var Geo;

  Geo = (function() {
    function Geo() {}

    Geo.prototype.d2r = function(degrees) {
      return (degrees * Math.PI) / 180;
    };

    Geo.prototype.circlePoint = function(centerX, centerY, radius, angle) {
      var x, y;
      x = centerX + radius * Math.cos(degToRad(angle));
      y = centerY + radius * Math.sin(degToRad(angle));
      return {
        x: x,
        y: y
      };
    };

    Geo.prototype.areaFromRadius = function(radius) {
      return Math.PI * Math.pow(radius, 2);
    };

    Geo.prototype.radiusFromArea = function(area) {
      return Math.sqrt(area / Math.PI);
    };

    Geo.prototype.p2c = function(radius, angle) {
      var angleRadians, x, y;
      angleRadians = d2r(angle);
      x = radius * Math.cos(angleRadians);
      y = radius * Math.sin(angleRadians);
      return {
        x: x,
        y: y
      };
    };

    Geo.prototype.dist3D = function(point1, point2) {
      return Math.sqrt(Math.pow(point1.x - point2.x) + Math.pow(point1.y - point2.y) + Math.pow(point1.z - point2.z));
    };

    return Geo;

  })();

  window.Geo = Geo;

}).call(this);