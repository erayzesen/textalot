#   MIT License - Copyright (c) 2025 Eray Zesen
#   Github: 
#   License information: 



# File: basics.nim
# Description: A comprehensive example demonstrating the core features of the Textalot TUI Backend/Engine,
# including drawing text/shapes with various styles and colors, and handling input events.

import textalot, os
  
# --- Cleanup and Initialization ---

proc onExit() {.noconv.} =
    ## Function to clean up the terminal state (show cursor, restore settings) before exiting.
    deinitTextalot()
    quit(0)

# Set a hook to ensure onExit runs when Ctrl+C is pressed, preventing a corrupted terminal state.
setControlCHook(onExit)

# Initialize the Textalot TUI: enables raw mode, hides cursor, and sets up buffers.
initTextalot()

# --- Main Application Loop ---

while true:
    # Update: Reads input events (Key, Mouse, Resize) and performs differential rendering.
    updateTexalot()


    # Display the application title (Bold, White text on Yellow background).
    drawText("TEXTALOT", 2, 3, FG_COLOR_WHITE, BG_COLOR_YELLOW, STYLE_BOLD)
    
    # Draw a horizontal separator line.
    drawText("_________________________________", 2, 4, FG_COLOR_CYAN, BG_COLOR_DEFAULT)
    
    # Display the project description.
    drawText(" A High-Performance TUI Backend/Engine written in Nim!", 2, 6, FG_COLOR_YELLOW, BG_COLOR_DEFAULT)
    
    # Header for the events test area.
    drawText("Events Test:", 2, 8, FG_COLOR_WHITE, BG_COLOR_DEFAULT, STYLE_BOLD)
    
    # Draw a cyan-filled rectangle as a background for style examples (coordinates: 2,15 to 24,24).
    drawRectangle(2, 15, 24, 24, FG_COLOR_DEFAULT, BG_COLOR_CYAN) 
    
    # Demonstrate various text styles defined in Textalot.
    drawText("Style None", 5, 16, FG_COLOR_DEFAULT, BG_COLOR_CYAN, STYLE_NONE)
    drawText("Style Bold", 5, 17, FG_COLOR_DEFAULT, BG_COLOR_CYAN, STYLE_BOLD)
    drawText("Style Italic", 5, 18, FG_COLOR_DEFAULT, BG_COLOR_CYAN, STYLE_ITALIC)
    drawText("Style Blink", 5, 19, FG_COLOR_DEFAULT, BG_COLOR_CYAN, STYLE_BLINK)
    drawText("Style Faint", 5, 20, FG_COLOR_DEFAULT, BG_COLOR_CYAN, STYLE_FAINT)
    drawText("Style Reverse", 5, 21, FG_COLOR_DEFAULT, BG_COLOR_CYAN, STYLE_REVERSE)
    drawText("Style Strike", 5, 22, FG_COLOR_DEFAULT, BG_COLOR_CYAN, STYLE_STRIKE)
    drawText("Style Underline", 5, 23, FG_COLOR_DEFAULT, BG_COLOR_CYAN, STYLE_UNDERLINE)

    # Demonstrate standard and bright background colors for all ANSI palettes.
    drawText("Red           ", 26, 15, FG_COLOR_DEFAULT, BG_COLOR_RED)
    drawText("Red Bright    ", 35, 15, FG_COLOR_DEFAULT, BG_COLOR_RED_BRIGHT)
    drawText("Green         ", 26, 16, FG_COLOR_DEFAULT, BG_COLOR_GREEN)
    drawText("Green Bright  ", 35, 16, FG_COLOR_DEFAULT, BG_COLOR_GREEN_BRIGHT)
    drawText("Blue          ", 26, 17, FG_COLOR_DEFAULT, BG_COLOR_BLUE)
    drawText("Blue Bright   ", 35, 17, FG_COLOR_DEFAULT, BG_COLOR_BLUE_BRIGHT)
    drawText("Yellow        ", 26, 18, FG_COLOR_DEFAULT, BG_COLOR_YELLOW)
    drawText("Yellow Bright ", 35, 18, FG_COLOR_DEFAULT, BG_COLOR_YELLOW_BRIGHT)
    drawText("Magenta       ", 26, 19, FG_COLOR_DEFAULT, BG_COLOR_MAGENTA)
    drawText("Magenta Bright", 35, 19, FG_COLOR_DEFAULT, BG_COLOR_MAGENTA_BRIGHT)
    drawText("Cyan          ", 26, 20, FG_COLOR_DEFAULT, BG_COLOR_CYAN)
    drawText("Cyan Bright   ", 35, 20, FG_COLOR_DEFAULT, BG_COLOR_CYAN_BRIGHT)
    drawText("Black         ", 26, 21, FG_COLOR_DEFAULT, BG_COLOR_BLACK)
    drawText("Black Bright  ", 35, 21, FG_COLOR_DEFAULT, BG_COLOR_BLACK_BRIGHT)
    drawText("White         ", 26, 22, FG_COLOR_DEFAULT, BG_COLOR_WHITE)
    drawText("White Bright  ", 35, 22, FG_COLOR_DEFAULT, BG_COLOR_WHITE_BRIGHT)

    # --- Event Handling Section ---
    # Handles all events captured by the TUI engine (Mouse, Key, Resize).

    if texalotEvent of MouseEvent:
        var mouseEvent = MouseEvent(texalotEvent)
        removeArea(4, 10, 64, 10) 

        if mouseEvent.key == EVENT_MOUSE_MOVE:
            drawText("- Mouse moving - x:" & $mouseEvent.x & " y:" & $mouseEvent.y, 4, 10, FG_COLOR_WHITE, BG_COLOR_DEFAULT)
        
        elif mouseEvent.key == EVENT_MOUSE_LEFT:
            drawText("- Mouse clicked - x:" & $mouseEvent.x & " y:" & $mouseEvent.y, 4, 10, FG_COLOR_WHITE, BG_COLOR_DEFAULT)
            
            drawChar(mouseEvent.x, mouseEvent.y, '?', FG_COLOR_WHITE, BG_COLOR_MAGENTA)
            
    elif texalotEvent of KeyEvent:
        var keyEvent = KeyEvent(texalotEvent)
        removeArea(4, 11, 64, 11)
        
        drawText("- Key pressed - key:" & $chr(keyEvent.key), 4, 11, FG_COLOR_WHITE, BG_COLOR_DEFAULT)
        
    elif texalotEvent of ResizeEvent:
        removeArea(4, 12, 64, 12)
        
        drawText("- Window Resized - w:" & $getTerminalWidth() & " h:" & $getTerminalHeight(), 4, 12, FG_COLOR_WHITE, BG_COLOR_DEFAULT)

    # Introduce a small sleep to limit the CPU usage and control the frame rate (~100 FPS)
    os.sleep(10) 
