Divebar = ->
  window.chrome ?={}
  
  SCRNW = window.screen.width
  SCRNH = window.screen.height

  TYPE  = chrome.runtime.sendMessage {greeting:"getTYPE"}, (response) -> TYPE  = response.TYPE
  BASEW = chrome.runtime.sendMessage {greeting:"getBASEW"},(response) -> BASEW = parseInt(response.BASEW)
  BASEH = chrome.runtime.sendMessage {greeting:"getBASEH"},(response) -> BASEH = parseInt(response.BASEH)
  DUALW = chrome.runtime.sendMessage {greeting:"getDUALW"},(response) -> DUALW = parseInt(response.DUALW)
  DUALH = chrome.runtime.sendMessage {greeting:"getDUALH"},(response) -> DUALH = parseInt(response.DUALH)
  DUALX = chrome.runtime.sendMessage {greeting:"getDUALX"},(response) -> DUALX = parseInt(response.DUALX)
  DUALY = chrome.runtime.sendMessage {greeting:"getDUALY"},(response) -> DUALY = parseInt(response.DUALY)

  $ -> $('body > *').wrapAll("<article id='dive-div' />")
  $ -> $('#dive-div').css('position', "relative")
  $ -> $('#dive-div').wrapAll("<article id='dive-div2' />")

  getCoordinates = (x, y, w, h) -> 
    padding = []
    p = y + h
    r = DUALY + DUALH
    t = x + w
    u = DUALX + DUALW
    
    if (TYPE == "unchecked")
      if (t > SCRNW)
        padding[0] = (t - SCRNW)
      else
        padding[0] = 0

      if (p > SCRNH)
        padding[1] = (p - SCRNH )
      else
        padding[1] = 0

      if (x < 0)
        padding[2] = (-x)
      else
        padding[2] = 0
    else if (TYPE == "checked")
      if ( DUALX == -DUALW)
        if (t > BASEW)
          padding[0] = (t - BASEW)
        else
          padding[0] = 0

        if (p > BASEH) && (x > 0)
          padding[1] = p - BASEH
        else if (t < 0) && (p > r)
          padding[1] = p - r
        else
          padding[1] = 0
        
        if (x < (-DUALW))
          padding[2] = (-x) - DUALW
        else
          padding[2] = 0
      else if (DUALX == BASEW)
        if (t > (BASEW + DUALW))
          padding[0] = t - (BASEW + DUALW)
        else
          padding[0] = 0

        if (p > BASEH) && (t < BASEW)
          padding[1] = p - BASEH
        else if (p > r) && (x > BASEW)
          padding[1] = p - r
        else
          padding[1] = 0
        
        if (x < 0)
          padding[2] = -x
        else
          padding[2] = 0
      else
        if (t > BASEW) && (p < BASEH)
          padding[0] = t - BASEW
        else if (y > BASEH) && (t > u)
          padding[0] = t - u
        else
          padding[0] = 0

        if (p > (BASEH + DUALH))
          padding[1] = p - (BASEH + DUALH)
        else
          padding[1] = 0

        if (x < 0) && (p < BASEH)
          padding[2] = -x
        else if (y > BASEH) && (x < DUALX)
          padding[2] = DUALX - x
        else
          padding[2] = 0

    return padding

  appendPadding = (padding) ->   
    DIV = $('#dive-div2')
    DIV.css('width', '100%')
    DIV.css('positon', 'relative')
    DIV.css('padding-right',  padding[0] + "px")
    DIV.css('padding-bottom', padding[1] + "px")
    DIV.css('padding-left',   padding[2] + "px")

  setInterval ->
    if ( x != window.screenLeft || y != window.screenTop )
      x = window.screenLeft
      y = window.screenTop
      w = window.outerWidth
      h = window.outerHeight
      appendPadding(getCoordinates(x,y,w,h))
  , 200


Divebar()