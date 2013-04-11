width = 500
height = 300
padding = 50
zx = padding
zy = height - padding
unit = width - 2 * padding
rectWidth = 30
heightUnit = 60

class Growth extends Diagram
  start: =>
    @principle = @paper.rect(zx, zy - heightUnit, rectWidth, heightUnit)
    $(@principle.node).attr 'class', 'green'
    @axis zx, zy, unit: unit, to: new Bound(1, false)
    # TODO: Extract common logic
    @elem.waypoint(@reset, offset: 'bottom-in-view', triggerOnce: true)


  reset: =>
    @principle.attr transform: '', x: zx, y: zy - heightUnit, height: heightUnit
    setTimeout @n1, 2000

  n1: =>
    @principle.attr {transform: ''}
    ding = =>
      console.log 'dinging'
      interest1 = @paper.rect(zx + unit - rectWidth, zy - heightUnit, rectWidth, heightUnit)
      $(interest1.node).attr 'class', 'teal'
      interest1.toBack()
      interest1.animate {transform: ['t', 0, -heightUnit]}, 500, 'backOut', callbackAfter(@n2, 2000)
    @principle.animate {transform: ['t', unit - rectWidth, 0]}, 3000, 'linear', ding

  n2: =>
    @continuous()

  continuous: =>
    @principle.attr {transform: ''}
    @principle.animate {x: zx + unit - rectWidth, y: zy - (Math.E * heightUnit), height: Math.E * heightUnit}, 3000, callbackAfter(@reset, 2000)






$ -> diagram('growth', Growth, width, height)
