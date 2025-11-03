#   MIT License - Copyright (c) 2025 Eray Zesen
#   Github: https://github.com/erayzesen/textalot
#   License information: https://github.com/erayzesen/textalot/blob/master/LICENSE


import posix,strutils,Termios
import unicode

#Event Mouse 

const 
  EVENT_MOUSE_NONE*:uint16=0
  EVENT_MOUSE_LEFT*:uint16=1
  EVENT_MOUSE_RIGHT*:uint16=2
  EVENT_MOUSE_MIDDLE*:uint16=3
  EVENT_MOUSE_MOVE*:uint16=4
  EVENT_MOUSE_RELEASE*:uint16=5
  EVENT_MOUSE_WHEEL_UP*:uint16=6
  EVENT_MOUSE_WHEEL_DOWN*:uint16=7
  EVENT_MOUSE_LEFT_DRAG*:uint16=8
  EVENT_MOUSE_MIDDLE_DRAG*:uint16=9
  EVENT_MOUSE_RIGHT_DRAG*:uint16=10


#Event Keys
const
  EVENT_KEY_NONE*: uint16 = 0
  EVENT_KEY_CTRL_TILDE*: uint16 = 1            # old CTRL_TILDE (0x00 / NUL)
  EVENT_KEY_CTRL_A*: uint16 = 2
  EVENT_KEY_CTRL_B*: uint16 = 3
  EVENT_KEY_CTRL_C*: uint16 = 4
  EVENT_KEY_CTRL_D*: uint16 = 5
  EVENT_KEY_CTRL_E*: uint16 = 6
  EVENT_KEY_CTRL_F*: uint16 = 7
  EVENT_KEY_CTRL_G*: uint16 = 8
  EVENT_KEY_BACKSPACE*: uint16 = 9
  EVENT_KEY_TAB*: uint16 = 10
  EVENT_KEY_ENTER*: uint16 = 11
  EVENT_KEY_CTRL_K*: uint16 = 12
  EVENT_KEY_CTRL_L*: uint16 = 13
  EVENT_KEY_CTRL_N*: uint16 = 15
  EVENT_KEY_CTRL_O*: uint16 = 16
  EVENT_KEY_CTRL_P*: uint16 = 17
  EVENT_KEY_CTRL_Q*: uint16 = 18
  EVENT_KEY_CTRL_R*: uint16 = 19
  EVENT_KEY_CTRL_S*: uint16 = 20
  EVENT_KEY_CTRL_T*: uint16 = 21
  EVENT_KEY_CTRL_U*: uint16 = 22
  EVENT_KEY_CTRL_V*: uint16 = 23
  EVENT_KEY_CTRL_W*: uint16 = 24
  EVENT_KEY_CTRL_X*: uint16 = 25
  EVENT_KEY_CTRL_Y*: uint16 = 26
  EVENT_KEY_CTRL_Z*: uint16 = 27
  EVENT_KEY_ESC*: uint16 = 28
  EVENT_KEY_CTRL_4*: uint16 = 29
  EVENT_KEY_CTRL_5*: uint16 = 30
  EVENT_KEY_CTRL_6*: uint16 = 31
  EVENT_KEY_CTRL_7*: uint16 = 32
  EVENT_KEY_SPACE*: uint16 = 33
  EVENT_KEY_BACKSPACE2*: uint16 = 34
  EVENT_KEY_ARROW_UP*: uint16 = 35
  EVENT_KEY_ARROW_DOWN*: uint16 = 36
  EVENT_KEY_ARROW_RIGHT*: uint16 = 37
  EVENT_KEY_ARROW_LEFT*: uint16 = 38
  EVENT_KEY_HOME*: uint16 = 39
  EVENT_KEY_INSERT*: uint16 = 40
  EVENT_KEY_DELETE*: uint16 = 41
  EVENT_KEY_END*: uint16 = 42
  EVENT_KEY_PGUP*: uint16 = 43
  EVENT_KEY_PGDN*: uint16 = 44
  EVENT_KEY_F1*: uint16 = 45
  EVENT_KEY_F2*: uint16 = 46
  EVENT_KEY_F3*: uint16 = 47
  EVENT_KEY_F4*: uint16 = 48
  EVENT_KEY_F5*: uint16 = 49
  EVENT_KEY_F6*: uint16 = 50
  EVENT_KEY_F7*: uint16 = 51
  EVENT_KEY_F8*: uint16 = 52
  EVENT_KEY_F9*: uint16 = 53
  EVENT_KEY_F10*: uint16 = 54
  EVENT_KEY_F11*: uint16 = 55
  EVENT_KEY_F12*: uint16 = 56



#Terminal Foreground Colors 
const
  FG_COLOR_BLACK*:uint32=30
  FG_COLOR_RED*:uint32=31
  FG_COLOR_GREEN*:uint32=32
  FG_COLOR_YELLOW*:uint32=33
  FG_COLOR_BLUE*:uint32=34
  FG_COLOR_MAGENTA*:uint32=35
  FG_COLOR_CYAN*:uint32=36
  FG_COLOR_WHITE*:uint32=37
  FG_COLOR_DEFAULT*:uint32=39

  FG_COLOR_BLACK_BRIGHT*:uint32=90
  FG_COLOR_RED_BRIGHT*:uint32=91
  FG_COLOR_GREEN_BRIGHT*:uint32=92
  FG_COLOR_YELLOW_BRIGHT*:uint32=93
  FG_COLOR_BLUE_BRIGHT*:uint32=94
  FG_COLOR_MAGENTA_BRIGHT*:uint32=95
  FG_COLOR_CYAN_BRIGHT*:uint32=96
  FG_COLOR_WHITE_BRIGHT*:uint32=97

#Terminal Background Colors 
const 
  BG_COLOR_BLACK*:uint32=40
  BG_COLOR_RED*:uint32=41
  BG_COLOR_GREEN*:uint32=42
  BG_COLOR_YELLOW*:uint32=43
  BG_COLOR_BLUE*:uint32=44
  BG_COLOR_MAGENTA*:uint32=45
  BG_COLOR_CYAN*:uint32=46
  BG_COLOR_WHITE*:uint32=47
  BG_COLOR_DEFAULT*:uint32=49

  BG_COLOR_BLACK_BRIGHT*:uint32=100
  BG_COLOR_RED_BRIGHT*:uint32=101
  BG_COLOR_GREEN_BRIGHT*:uint32=102
  BG_COLOR_YELLOW_BRIGHT*:uint32=103
  BG_COLOR_BLUE_BRIGHT*:uint32=104
  BG_COLOR_MAGENTA_BRIGHT*:uint32=105
  BG_COLOR_CYAN_BRIGHT*:uint32=106
  BG_COLOR_WHITE_BRIGHT*:uint32=107

#Terminal styles
const 
  STYLE_NONE*: uint16 = 0
  STYLE_BOLD*: uint16 = 1 shl 0         # SGR Code 1 (Bold/Increased intensity)
  STYLE_FAINT*: uint16 = 1 shl 1        # SGR Code 2 (Faint/Dim/Decreased intensity)
  STYLE_ITALIC*: uint16 = 1 shl 2       # SGR Code 3 (Italic)
  STYLE_UNDERLINE*: uint16 = 1 shl 3    # SGR Code 4 (Underline)
  STYLE_REVERSE*: uint16 = 1 shl 4      # SGR Code 7 (Reverse/Invert)
  STYLE_STRIKE*: uint16 = 1 shl 5       # SGR Code 9 (Strikethrough/Crossed-out)
  STYLE_BLINK*: uint16 = 1 shl 6        # SGR Code 5 (Blink - Slow)   



var origTermios: Termios

#Terminal Resize Operations
var isResized: bool = false

const SIGWINCH*:cint = 28

proc handleResize(signum: cint) {.noconv.} =
  ## SIGWINCH sinyalini yakalar ve global bayrağı ayarlar.
  if signum == SIGWINCH:
    isResized = true


proc setupSignalHandler() =
  ## Uygulama başlangıcında sinyal yakalamayı kurar.
  var action: SigAction # Yeni Sigaction yapımızı tanımlıyoruz
  
  # sa_handler'a bizim handleResize fonksiyonumuzu atıyoruz
  action.sa_handler = handleResize
  action.sa_flags = 0

  # Üçüncü argüman olan 'olact' (eski ayarı saklama), 
  # eğer nil geçilmesi gerekiyorsa bu şekilde yapılır:
  let nullPtr = cast[ptr Sigaction](0)

  # sigaction(sinyal, yeni_ayarlar, eski_ayarları_sakla)
  let result = sigaction(SIGWINCH, action, nullPtr)
  
  if result != 0:
    # Hata kontrolü ekleyebiliriz
    echo "Hata: SIGWINCH işleyicisi kurulamadı."

proc hideCursor*() =
    stdout.write("\x1b[?25l")
    stdout.flushFile()

proc showCursor*() =
    stdout.write("\x1b[?25h")
    stdout.flushFile()

proc enableMouseTracking() =
  stdout.write("\x1b[?1003h\x1b[?1006h")
  stdout.flushFile()

proc disableMouseTracking() =
  stdout.write("\x1b[?1003l\x1b[?1006l")
  stdout.flushFile()
    
proc enableRawMode() =
    discard tcgetattr(STDIN_FILENO, origTermios.addr)
    var raw = origTermios
    raw.c_lflag = raw.c_lflag and not (ICANON or ECHO)
    raw.c_cc[VMIN] = char(1)
    raw.c_cc[VTIME] = char(0)
    discard tcsetattr(STDIN_FILENO, TCSAFLUSH, raw.addr)
    stdout.write("\x1b[?1049h")
    stdout.flushFile()
  

# Disable raw mode
proc disableRawMode() =
    discard tcsetattr(STDIN_FILENO, TCSAFLUSH, origTermios.addr)
    stdout.write("\x1b[?1049l")
    stdout.flushFile()

#Get Terminal Size
type
  Winsize = object
    ws_row: cushort
    ws_col: cushort
    ws_xpixel: cushort
    ws_ypixel: cushort

proc getTerminalWidth*: int =
  var ws: Winsize
  if ioctl(STDOUT_FILENO, TIOCGWINSZ, addr ws) == -1:
    return 0
  return int(ws.ws_col)

proc getTerminalHeight*: int =
  var ws: Winsize
  if ioctl(STDOUT_FILENO, TIOCGWINSZ, addr ws) == -1:
    return 0
  return int(ws.ws_row)

# Clear Screen
proc clearScreen*() =
  stdout.write("\x1b[49m\x1b[39m\x1b[2J\x1b[H")
  stdout.flushFile()

### BUFFERS ###
type 
  Cell = object
    bg:uint32
    fg:uint32
    ch:string=" "
    style:uint16=STYLE_NONE # Style attributes (Bold, Underline, etc.)
  Buffer = object 
    width :int
    height :int
    data:seq[Cell]

proc newBuffer(w,h:int) :Buffer =
  result.width=w
  result.height=h
  result.data=newSeq[Cell](w*h)
  var defaultCell=Cell(bg: BG_COLOR_DEFAULT, fg: FG_COLOR_DEFAULT, ch:" ")

  for i in 0..w*h-1 :
    result.data[i]=defaultCell


var textalotFrontBuffer*:Buffer
var textalotBackBuffer*:Buffer

proc recreateBuffers*() =
  let w = max(getTerminalWidth(),10)
  let h = max(getTerminalHeight(),10)
  textalotBackBuffer=newBuffer(w,h )
  textalotFrontBuffer=newBuffer(w,h )
  clearScreen()

### END OF BUFFERS ###



### INITIALIZERS ###

proc initTextalot*() =
  recreateBuffers()    
  hideCursor()
  enableRawMode()
  setupSignalHandler() #Catching resize events
  enableMouseTracking()
  clearScreen()
  
  

proc deinitTextalot*() =
    showCursor()
    disableRawMode()
    disableMouseTracking()

### END OF INITIALIZERS ###


### RENDERING ###
# Move Curstor

proc getMoveCursorCode(x,y:int):string =
  return "\x1b[" & $y & ";" & $x & "H"


proc texalotRender*() =
  ## Compares the front and back buffers and draws only the differences to the terminal.
  ## This reduces screen flickering and improves performance.

  # Ensure buffers have the same dimensions before proceeding
  # If dimensions mismatch, something went wrong, or terminal size changed (needs resize handling)
  if textalotBackBuffer.width != textalotFrontBuffer.width or 
    textalotBackBuffer.height != textalotFrontBuffer.height:
    return
    
  let bufferSize = textalotBackBuffer.data.len

  # Use a StringBuilder or collect data to write in bulk for better terminal performance
  var output = ""
  var appliedReset = false

  var lastFg: uint32 = FG_COLOR_DEFAULT
  var lastBg: uint32 = BG_COLOR_DEFAULT
  var lastStyle: uint16 = STYLE_NONE

  # Iterate over every cell in the buffer
  for i in 0..<bufferSize:
    let backCell = textalotBackBuffer.data[i]
    let frontCell = textalotFrontBuffer.data[i]

    # 1. Check if the cell content is different (bg, fg, or character)
    if backCell.bg != frontCell.bg or 
        backCell.fg != frontCell.fg or 
        backCell.ch != frontCell.ch or
        backCell.style != frontCell.style :
      
      # The cell has changed, we need to draw it.
      

      # Calculate the (x, y) coordinates from the flat index 'i'
      let x = i mod textalotBackBuffer.width
      let y = i div textalotBackBuffer.width

      #Move cursor
      output.add(getMoveCursorCode(x+1,y+1) )

      #Handle Attribute/Style Changes
      if backCell.fg != lastFg or backCell.bg != lastBg or backCell.style != lastStyle:
        if not appliedReset or backCell.style == STYLE_NONE:
            # Reset all SGR attributes (Color and Style) to ensure a clean start
            output.add("\x1b[0m")
            appliedReset = true
        else:
            appliedReset = false
        
        output.add("\x1b[" & $backCell.fg & ";" & $backCell.bg & "m")

        if (backCell.style and STYLE_BOLD) != 0:
            output.add("\x1b[1m") 
        if (backCell.style and STYLE_FAINT) != 0:
            output.add("\x1b[2m") 
        if (backCell.style and STYLE_ITALIC) != 0:
            output.add("\x1b[3m") 
        if (backCell.style and STYLE_UNDERLINE) != 0:
            output.add("\x1b[4m")
        if (backCell.style and STYLE_BLINK) != 0:
            output.add("\x1b[5m") 
        if (backCell.style and STYLE_REVERSE) != 0:
            output.add("\x1b[7m")
        if (backCell.style and STYLE_STRIKE) != 0:
            output.add("\x1b[9m") 

        lastFg = backCell.fg
        lastBg = backCell.bg
        lastStyle = backCell.style


      output.add(backCell.ch)

      # 2. Update the Front Buffer:
      # Copy the changed cell from back to front, so they match for the next frame
      textalotFrontBuffer.data[i] = backCell 

  # Finally, perform a single write to the terminal for efficiency
  stdout.write(output) 

  # Flush the output to ensure it's displayed immediately
  stdout.flushFile()


proc drawText*(text:string,x,y:int,fg,bg:uint32,style:uint16=STYLE_NONE) =
  let w = textalotBackBuffer.width
  let h = textalotBackBuffer.height
  var currentX = x
  let currentY = y

  if currentY < 0 or currentY >= h:
    return
  for ch in text.runes:
    if currentX >= 0 and currentX < w:
      let index = currentY * w + currentX
      textalotBackBuffer.data[index] = Cell(
        ch: ch.toUTF8(),
        fg: fg,
        bg: bg,
        style:style
      )
    currentX+=1

proc drawChar*(x, y: int, ch: string, fg, bg: uint32,style:uint16=STYLE_NONE) =
  let w = textalotBackBuffer.width
  let h = textalotBackBuffer.height


  if x >= 0 and x < w and y >= 0 and y < h:
    let index = y * w + x

    var fch=if ch=="" : " " else : ch
    
    textalotBackBuffer.data[index] = Cell(
      ch: fch.runeAt(0).toUTF8(),
      fg: fg,
      bg: bg,
      style:style
    )

proc drawRectangle*(x1,y1,x2,y2:int,bg,fg:uint32,ch:string=" ",style:uint16=STYLE_NONE) =
  let startX = min(x1, x2)
  let endX = max(x1, x2)
  let startY = min(y1, y2)
  let endY = max(y1, y2)

  let w = textalotBackBuffer.width
  let h = textalotBackBuffer.height

  var fch=if ch=="" : " " else : ch

  let fillCell = Cell(bg: bg, fg: fg, ch: fch.runeAt(0).toUTF8(),style:style)

  for y in startY..<endY:
    for x in startX..<endX:
      if x >= 0 and x < w and y >= 0 and y < h:
        let index = y * w + x
        textalotBackBuffer.data[index] = fillCell


proc removeArea*(x1,y1,x2,y2:int) =
  drawRectangle(x1,y1,x2,y2,BG_COLOR_DEFAULT,FG_COLOR_DEFAULT," ")



### END OF RENDERING ###


  
### EVENTS ###

type 
  Event* = ref object of RootObj

  ResizeEvent* = ref object of Event

  KeyEvent* = ref object of Event
    key*: uint32

  MouseEvent* = ref object of Event
    key*: uint32
    x*: int
    y*: int
    shift*: bool
    ctrl*: bool
    alt*: bool

  NoneEvent* = ref object of Event

#We're using queue based system of the event handling 
# --- Internal Event Queue ---
var eventQueue: seq[Event] = @[]

proc enqueue(ev: Event) =
  if not ev.isNil: eventQueue.add(ev)

proc dequeue(): Event =
  if eventQueue.len > 0:
    result = eventQueue[0]
    eventQueue.delete(0)
  else:
    result = new(NoneEvent)


# ---Main Non-blocking Reader ---
proc readEvent*(): Event =
  if eventQueue.len > 0:
    return dequeue()

  if isResized:
    isResized = false
    return new(ResizeEvent)

  var readfds: TFdSet
  FD_ZERO(readfds)
  FD_SET(STDIN_FILENO, readfds)
  var tv: Timeval
  tv.tv_sec = posix.Time(0)
  tv.tv_usec = 1000

  let sel = select(STDIN_FILENO + 1, addr readfds, nil, nil, addr tv)
  if sel <= 0:
    return new(NoneEvent)

  var buf = newString(256)
  let n = read(STDIN_FILENO, buf[0].addr, buf.len)
  if n <= 0:
    return new(NoneEvent)

  var s = buf[0 ..< n]

  while s.len > 0:
    var parsed = false
    var key: uint32 = EVENT_KEY_NONE

    # --- SGR Mouse ---
    if s.startsWith("\x1b[<"):
      let endPos = s.find({'M','m'})
      if endPos > 0:
        let seq = s[3 ..< endPos]
        let finalKind = s[endPos]
        let parts = seq.split(';')
        if parts.len >= 3:
          let cb = parseInt(parts[0])
          let cx = parseInt(parts[1]) - 1
          let cy = parseInt(parts[2]) - 1
          let button = cb and 3
          let isMotion = (cb and 32) != 0
          let isCtrl = (cb and 16) != 0
          let isMeta = (cb and 8) != 0
          let isShift = (cb and 4) != 0
          let isWheelUp = cb == 64
          let isWheelDown = cb == 65

          var ev = new(MouseEvent)
          ev.x = cx
          ev.y = cy
          ev.ctrl = isCtrl
          ev.alt = isMeta
          ev.shift = isShift

          if isWheelUp:
            ev.key = EVENT_MOUSE_WHEEL_UP
          elif isWheelDown:
            ev.key = EVENT_MOUSE_WHEEL_DOWN
          elif isMotion:
            ev.key = case button
            of 0: EVENT_MOUSE_LEFT_DRAG
            of 1: EVENT_MOUSE_MIDDLE_DRAG
            of 2: EVENT_MOUSE_RIGHT_DRAG
            else: EVENT_MOUSE_MOVE
          else:
            case button
            of 0: ev.key = if finalKind == 'M': EVENT_MOUSE_LEFT else: EVENT_MOUSE_RELEASE
            of 1: ev.key = if finalKind == 'M': EVENT_MOUSE_MIDDLE else: EVENT_MOUSE_RELEASE
            of 2: ev.key = if finalKind == 'M': EVENT_MOUSE_RIGHT else: EVENT_MOUSE_RELEASE
            else: ev.key = EVENT_MOUSE_NONE
          enqueue(ev)
        s = s[endPos+1 .. ^1]
        parsed = true
    
    # --- X10 Mouse ---
    elif s.len >= 6 and s.startsWith("\x1b[M"):
      let cb = ord(s[3]) - 32
      let x = ord(s[4]) - 33
      let y = ord(s[5]) - 33
      var ev = new(MouseEvent)
      ev.x = x
      ev.y = y
      ev.key = case cb and 3
        of 0: EVENT_MOUSE_LEFT
        of 1: EVENT_MOUSE_MIDDLE
        of 2: EVENT_MOUSE_RIGHT
        of 3: EVENT_MOUSE_RELEASE
        else: EVENT_MOUSE_NONE
      enqueue(ev)
      s = s[6..^1]
      parsed = true

    # --- Single-byte keys / Ctrl keys ---
    elif s.len == 1:
      case ord(s[0])
      of 0x00: key = EVENT_KEY_CTRL_TILDE
      of 0x01: key = EVENT_KEY_CTRL_A
      of 0x02: key = EVENT_KEY_CTRL_B
      of 0x03: key = EVENT_KEY_CTRL_C
      of 0x04: key = EVENT_KEY_CTRL_D
      of 0x05: key = EVENT_KEY_CTRL_E
      of 0x06: key = EVENT_KEY_CTRL_F
      of 0x07: key = EVENT_KEY_CTRL_G
      of 0x08, 0x7F: key = EVENT_KEY_BACKSPACE
      of 0x09: key = EVENT_KEY_TAB
      of 0x0A, 0x0D: key = EVENT_KEY_ENTER
      of 0x0B: key = EVENT_KEY_CTRL_K
      of 0x0C: key = EVENT_KEY_CTRL_L
      of 0x0E: key = EVENT_KEY_CTRL_N
      of 0x0F: key = EVENT_KEY_CTRL_O
      of 0x10: key = EVENT_KEY_CTRL_P
      of 0x11: key = EVENT_KEY_CTRL_Q
      of 0x12: key = EVENT_KEY_CTRL_R
      of 0x13: key = EVENT_KEY_CTRL_S
      of 0x14: key = EVENT_KEY_CTRL_T
      of 0x15: key = EVENT_KEY_CTRL_U
      of 0x16: key = EVENT_KEY_CTRL_V
      of 0x17: key = EVENT_KEY_CTRL_W
      of 0x18: key = EVENT_KEY_CTRL_X
      of 0x19: key = EVENT_KEY_CTRL_Y
      of 0x1A: key = EVENT_KEY_CTRL_Z
      of 0x1B: key = EVENT_KEY_ESC
      of 0x1C: key = EVENT_KEY_CTRL_4
      of 0x1D: key = EVENT_KEY_CTRL_5
      of 0x1E: key = EVENT_KEY_CTRL_6
      of 0x1F: key = EVENT_KEY_CTRL_7
      of 0x20: key = EVENT_KEY_SPACE
      else: key = uint32(s.toRunes()[0].ord)
      s = s[1..^1]
      parsed = true

    # --- ESC sequences (arrows, F keys, Home/End, Insert/Delete, PgUp/PgDn) ---
    elif s.startsWith("\x1b"):
      if s.len >= 3 and s[1] == '[':
        if s[2] in {'A','B','C','D','H','F'}:
          case s[2]
          of 'A': key = EVENT_KEY_ARROW_UP
          of 'B': key = EVENT_KEY_ARROW_DOWN
          of 'C': key = EVENT_KEY_ARROW_RIGHT
          of 'D': key = EVENT_KEY_ARROW_LEFT
          of 'H': key = EVENT_KEY_HOME        
          of 'F': key = EVENT_KEY_END 
          else: discard
          s = s[3 .. ^1]
          parsed = true
        else:
          let endTilde = s.find('~')
          if endTilde >= 0:
            case s[2..endTilde-1]
            of "1": key = EVENT_KEY_HOME
            of "2": key = EVENT_KEY_INSERT
            of "3": key = EVENT_KEY_DELETE
            of "4": key = EVENT_KEY_END
            of "5": key = EVENT_KEY_PGUP
            of "6": key = EVENT_KEY_PGDN
            of "15": key = EVENT_KEY_F5
            of "17": key = EVENT_KEY_F6
            of "18": key = EVENT_KEY_F7
            of "19": key = EVENT_KEY_F8
            of "20": key = EVENT_KEY_F9
            of "21": key = EVENT_KEY_F10
            of "23": key = EVENT_KEY_F11
            of "24": key = EVENT_KEY_F12
            else: discard
            s = s[endTilde+1 .. ^1]
            parsed = true
      elif s.len >= 3 and s[1] == 'O':
        case s[2]
        of 'P': key = EVENT_KEY_F1
        of 'Q': key = EVENT_KEY_F2
        of 'R': key = EVENT_KEY_F3
        of 'S': key = EVENT_KEY_F4
        else: discard
        s = s[3..^1]
        parsed = true
      else:
        key = EVENT_KEY_ESC
        s = s[1..^1]
        parsed = true

    # --- Unicode / multi-byte UTF-8 fallback ---
    else:
      if s[0] != '\x1b':
        try:
          let firstRune = s.toRunes()[0]
          if firstRune.ord >= 0x20 and firstRune.ord <= 0x10FFFF:
            key = uint32(firstRune.ord)
            let runeByteLen = firstRune.toUTF8.len
            s = s[min(runeByteLen, s.len)..^1]
            parsed = true
        except:
          discard

    if key != EVENT_KEY_NONE:
      let ev = new(KeyEvent)
      ev.key = key
      enqueue(ev)

    if not parsed:
      s = s[1..^1]

  if eventQueue.len > 0:
    return dequeue()
  else:
    return new(NoneEvent)

### END OF EVENTS ###


### UPDATE ###
var texalotEvent*:Event=NoneEvent()
proc updateTextalot*() =
  texalotEvent=readEvent() # Update Events
  texalotRender() #Update Render
  if texalotEvent of ResizeEvent :
    recreateBuffers()
    

### END OF UPDATE ###


 
