class ParallelLines extends Uriel.Diagram
  constructor: (elem, width=500, height=50) ->
    super elem, width, height
    p = @paper.path(['M', 0, 16, 'l', 500, 0])
    p.node.setAttribute('class', 'colored')
    p = @paper.path(['M', 0, 33, 'l', 500, 0])
    p.node.setAttribute('class', 'colored')

class BentLines extends Uriel.Diagram
  constructor: (elem, width=500, height=75) ->
    super elem, width, height
    p = @paper.path(['M', 0, 16, 'a', 600, 100, 0, 0, 1, 600, 100])
    p.node.setAttribute('class', 'colored line')
    p = @paper.path(['M', 0, 33, 'l', 500, 0])
    p.node.setAttribute('class', 'colored')

$ ->
  Uriel.diagram('parallel', ParallelLines)
  Uriel.diagram('bent', BentLines)
