class Test extends Diagram
  start: =>
    Axis(@paper, 250, 250)

$ -> diagram('test', Test, 500, 500)
