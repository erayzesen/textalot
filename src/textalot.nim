#   MIT License - Copyright (c) 2025 Eray Zesen
#   Github: 
#   License information: 


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
  EVENT_KEY_CTRL_M*: uint16 = 14
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


var lastFg: uint32 = FG_COLOR_DEFAULT
var lastBg: uint32 = BG_COLOR_DEFAULT
var lastStyle: uint16 = STYLE_NONE

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
  ResizeEvent* =ref object of Event
  KeyEvent* = ref object of Event
    key*:uint32
  MouseEvent* = ref object of Event
    key*:uint32
    x*:int
    y*:int
  NoneEvent* = ref object of Event



proc readEvent(): Event =
  ## Non-blocking event reader that returns a specific inherited Event object.
  #Resize Event
  if isResized:
    isResized = false # Bayrağı temizle
    return new(ResizeEvent)

  # 1. Non-blocking Check (Single point of control)
  var readfds: TFdSet
  FD_ZERO(readfds)
  FD_SET(STDIN_FILENO, readfds)
  
  var tv: Timeval
  tv.tv_sec = posix.Time(0) 
  tv.tv_usec = 1000 # 1 ms timeout

  let sel = select(STDIN_FILENO + 1, addr readfds, nil, nil, addr tv)
  if sel <= 0:
    return new(NoneEvent)  # No input available, return NoneEvent

  # 2. Read Data
  var buf = newString(128)
  let n = read(STDIN_FILENO, buf[0].addr, buf.len)
  if n <= 0:
    return new(NoneEvent)

  let s = buf[0 ..< n]

  # ---------------------------------------------------------------------
  # 3. MOUSE PARSE (Priority 1: Check for Mouse sequences)
  # ---------------------------------------------------------------------

  # --- SGR PARSE LOGIC (ESC [ < Cb ; Cx ; Cy (M/m) ) ---
  if s.startsWith("\x1b[<"):
    var seq = s[3..^1]
    
    if seq.len >= 3 and seq[^1] in {'M', 'm', 'S', 'H'}: 
      let finalKind = seq[^1]
      let numbers = seq[0 ..< seq.len-1]
      let parts = numbers.split(';')
      
      if parts.len >= 3:
        try:
          let cb = parseInt(parts[0]) 
          var mouseKey: uint32 = 0
          
          # Check for scroll (64/65) and movement (32/35)
          if cb == 64: mouseKey = EVENT_MOUSE_WHEEL_UP
          elif cb == 65: mouseKey = EVENT_MOUSE_WHEEL_DOWN
          elif cb in [32, 35]: mouseKey = EVENT_MOUSE_MOVE # Movement/Drag
          else: 
            # Mask Cb with 3 for button type
            case cb and 3 
            of 0: mouseKey = if finalKind == 'M': EVENT_MOUSE_LEFT else: EVENT_MOUSE_RELEASE
            of 1: mouseKey = if finalKind == 'M': EVENT_MOUSE_MIDDLE else: EVENT_MOUSE_RELEASE
            of 2: mouseKey = if finalKind == 'M': EVENT_MOUSE_RIGHT else: EVENT_MOUSE_RELEASE
            else: mouseKey = EVENT_MOUSE_NONE
            
          if mouseKey != EVENT_MOUSE_NONE:
            let ev = new(MouseEvent)
            ev.key = mouseKey
            ev.x = parseInt(parts[1]) - 1 
            ev.y = parseInt(parts[2]) - 1
            return ev
        except:
          discard # Parsing error, fall through to key check
          
  # --- X10/DEC Format Check ---
  elif s.len >= 6 and s[0] == '\x1b' and s[1] == '[' and s[2] == 'M':
    let cb = ord(s[3]) - 32
    var mouseKey: uint32 = 0
    
    case cb and 3 
    of 0: mouseKey = EVENT_MOUSE_LEFT
    of 1: mouseKey = EVENT_MOUSE_MIDDLE
    of 2: mouseKey = EVENT_MOUSE_RIGHT
    of 3: mouseKey = EVENT_MOUSE_RELEASE
    else: mouseKey = EVENT_MOUSE_NONE
    
    if mouseKey != EVENT_MOUSE_NONE:
      let ev = new(MouseEvent)
      ev.key = mouseKey
      ev.x = ord(s[4]) - 32 - 1 
      ev.y = ord(s[5]) - 32 - 1
      return ev

  # ---------------------------------------------------------------------
  # 4. KEY PARSE (Priority 2: Your Original readKey Logic)
  # ---------------------------------------------------------------------

  var key: uint32 = EVENT_KEY_NONE
  
  # --- Single-byte control characters ---
  if n == 1:
    case ord(s[0])
    of 0x00: key = EVENT_KEY_CTRL_TILDE
    of 0x01: key = EVENT_KEY_CTRL_A
    of 0x02: key = EVENT_KEY_CTRL_B
    of 0x03: key = EVENT_KEY_CTRL_C
    of 0x04: key = EVENT_KEY_CTRL_D
    of 0x05: key = EVENT_KEY_CTRL_E
    of 0x06: key = EVENT_KEY_CTRL_F
    of 0x07: key = EVENT_KEY_CTRL_G
    of 0x08: key = EVENT_KEY_BACKSPACE
    of 0x09: key = EVENT_KEY_TAB
    of 0x0A: key = EVENT_KEY_ENTER       
    of 0x0B: key = EVENT_KEY_CTRL_K
    of 0x0C: key = EVENT_KEY_CTRL_L
    of 0x0D: key = EVENT_KEY_CTRL_M      
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
    of 0x7F: key = EVENT_KEY_BACKSPACE
    else: key = uint32(s.runeAt(0).ord)  # normal character

  # --- Multi-byte escape sequences ---
  elif s.startsWith("\x1b"):
    if n >= 3 and s[1] == '[':
      case s[2]
      of 'A': key = EVENT_KEY_ARROW_UP
      of 'B': key = EVENT_KEY_ARROW_DOWN
      of 'C': key = EVENT_KEY_ARROW_RIGHT
      of 'D': key = EVENT_KEY_ARROW_LEFT
      of '1':
        if n >= 5 and s[4] == '~':
          case s[3]
          of '1': key = EVENT_KEY_HOME
          of '2': key = EVENT_KEY_INSERT
          of '3': key = EVENT_KEY_DELETE
          of '4': key = EVENT_KEY_END
          of '5': key = EVENT_KEY_PGUP
          of '6': key = EVENT_KEY_PGDN
          else: discard
        else: discard
      else: discard
    elif n >= 2 and s[1] == 'O':
      case s[2]
      of 'P': key = EVENT_KEY_F1
      of 'Q': key = EVENT_KEY_F2
      of 'R': key = EVENT_KEY_F3
      of 'S': key = EVENT_KEY_F4
      of 't': key = EVENT_KEY_F5
      of 'u': key = EVENT_KEY_F6
      of 'v': key = EVENT_KEY_F7
      of 'w': key = EVENT_KEY_F8
      of 'x': key = EVENT_KEY_F9
      of 'y': key = EVENT_KEY_F10
      of 'z': key = EVENT_KEY_F11
      of 'a': key = EVENT_KEY_F12
      else: discard
    else:
      key = EVENT_KEY_ESC  # single ESC press
  elif n > 1:
    try:
        key = uint32(s.toRunes()[0].ord)
    except:
        discard

  # 5. Return the Key Event if successfully parsed
  if key != EVENT_KEY_NONE:
    let ev = new(KeyEvent)
    ev.key = key
    return ev

  # 6. Return None if nothing was successfully parsed
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


 