class Test extends Uriel.Diagram
  constructor: ->
    super
    @x = @axis 50, @height / 2, unit: 40


$ -> Uriel.diagram('test', Test)
