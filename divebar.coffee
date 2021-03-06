Divebar = ->
  window.chrome ?={}
  wrapped = false

  x = window.screenLeft
  y = window.screenTop
  SCRNW = window.screen.width
  SCRNH = window.screen.height

  dualMode  = chrome.runtime.sendMessage {greeting:"checkDualMode"}, (response) -> dualMode  = response.dualMode
  dualMode ?= "unchecked"
  dualNums = chrome.runtime.sendMessage {greeting:"getDualNums"}, (response) -> dualNums = response.dualNums
  dualNums ?= [SCRNW,SCRNH,0,0,0,0]
  
  getCoordinates = (x, y, w, h) -> 
    C = []

    if (dualMode == "unchecked")
      if x + w > SCRNW
        C[0] = x + w - SCRNW
      else
        C[0] = 0

      if y + h > SCRNH
        C[1] = y + h - SCRNH
      else
        C[1] = 0

      if (x < 0)
        C[2] = (-x)
      else
        C[2] = 0
    else if (dualMode == "checked")
      BW = dualNums[0]
      BH = dualNums[1]
      DW = dualNums[2]
      DH = dualNums[3]
      DX = dualNums[4]
      DY = dualNums[5]

      Rbreach_RM  = (DX ==  BW) && (x + w > BW + DW)
      Rbreach_BBM = (DY ==  BH) && (x + w > DX + DW) && (y > BH)
      Rbreach_BDM = (DY ==  BH) && (x + w > BW)      && (y + h < BH)
      Rbreach_LM  = (DX == -DW) && (x + w > BW)

      Bbreach_RBM = (DX ==  BW) && (x > BW)     && (y + h > DY + DH)
      Bbreach_RDM = (DX ==  BW) && (x + w < BW) && (y + h > BH)
      Bbreach_BM  = (DY ==  BH) && (y + h > BH + DH)
      Bbreach_LBM = (DX == -DW) && (x > 0)      && (y + h > BH)
      Bbreach_LDM = (DX == -DW) && (x + w < 0)  && (y + h > DY + DH)
      
      Lbreach_RM  = (DX ==  BW) && (x <  0)
      Lbreach_BBM = (DY ==  BH) && (x <  0) && (y + h < BH)
      Lbreach_BDM = (DY ==  BH) && (x < DX) && (y > BH)
      Lbreach_LM  = (DX == -DW) && (x < -DW)

      if Rbreach_LM || Rbreach_BDM
        C[0] = x + w - BW
      else if Rbreach_RM
        C[0] = x + w - BW - DW
      else if Rbreach_BBM
        C[0] = x + w - DX - DW
      else
        C[0] = 0

      if Bbreach_LBM || Bbreach_RDM
        C[1] = y + h - BH
      else if Bbreach_LDM || Bbreach_RBM
        C[1] = y + h - DY - DH
      else if Bbreach_BM
        C[1] = y + h - BH - DH
      else
        C[1] = 0

      if Lbreach_LM
        C[2] = -(x + DW)
      else if Lbreach_RM || Lbreach_BBM
        C[2] = -x
      else if  Lbreach_BDM
        C[2] = DX - x
      else
        C[2] = 0

    return C

  appendPadding = (padding) ->
    if padding[0] == 0 && padding[1] == 0 && padding[2] == 0
      if wrapped == true
        $("#dive-div").unwrap()
        $("#dive-div > *").unwrap()
        wrapped = false
    else
      if wrapped == false
        $('body > *').wrapAll("<div id='dive-div' style='position:relative' />")
        $('#dive-div').wrapAll("<div id='dive-div2' style='position:relative; width:100%' />")
        wrapped = true
      DIV = $('#dive-div2')
      DIV.css('padding-right',  padding[0] + "px")
      DIV.css('padding-bottom', padding[1] + "px")
      DIV.css('padding-left',   padding[2] + "px")
      window.scrollBy(padding[2],0)

  setInterval ->
    if ( x != window.screenLeft || y != window.screenTop )
      x = window.screenLeft
      y = window.screenTop
      w = window.outerWidth
      h = window.outerHeight
      appendPadding(getCoordinates(x,y,w,h))
  , 200


Divebar()