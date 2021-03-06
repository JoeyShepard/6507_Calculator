from collections import namedtuple

DEBUG=True

BUTTON_COUNT_X=5
BUTTON_COUNT_Y=8

BUTTON_WIDTH=120
BUTTON_HEIGHT=80
BUTTON_GAP_HORZ=32.4
BUTTON_GAP_VERT=72.4
BUTTON_BORDER_HORZ=20
BUTTON_BORDER_VERT=20

#slicer shows gap in 6 and 9 and no line on $
#FONT_SIZE=60
#3, 8, and SP failed printing. M and W look wrong in slicer
#FONT_SIZE=62
#3 fails slicing Xo

#wait for 0.2mm nozzle to try again
FONT_SIZE=60



FONT_OFFSET_Y=5

LETTER_GAP_VERT=12
LETTER_HEIGHT=BUTTON_HEIGHT-2*BUTTON_BORDER_HORZ
LETTER_OFFSET_Y=-5

IMG_WIDTH=BUTTON_COUNT_X*(BUTTON_WIDTH+BUTTON_GAP_HORZ)+BUTTON_GAP_HORZ
IMG_HEIGHT=BUTTON_COUNT_Y*(BUTTON_HEIGHT+BUTTON_GAP_VERT)+BUTTON_GAP_VERT

if DEBUG:
    BACK_COLOR="black"
    FONT_COLOR="red"
    BUTTON_COLOR="#C0C0C0"
    LINE_COLOR="#00FF00"
    LETTER_COLOR="purple"
    BBOX_COLOR="green"
else:
    BACK_COLOR="white"
    FONT_COLOR="black"
    BUTTON_COLOR="white"
    LINE_COLOR="00FF00"  #not used
    LETTER_COLOR="black"
    BBOX_COLOR="black"


#NOTE: font names tested with raster versions. WON'T WORK WITH SVG!    

#Line thickness varies too much
#FONT_NAME="lucon.ttf"   #Lucida Console

#Hmm, too curvy. top and bottom not symetrical
#FONT_NAME="micross.ttf"     #MS Sans Serif

#Too generic
#FONT_NAME="FRABK.TTF"      #Frankling Gothic Book

#Too generic
#FONT_NAME="msgothic.ttc"    #MS Gothic

#pretty good, though lines different widths. lower leg of E too long
#FONT_NAME="segoeui.ttf"

#so so
#FONT_NAME="tahoma.ttf"

#Straighter, clean edges. commas and quotes look wrong
#FONT_NAME="calibri.ttf"

#decent
#FONT_NAME="YuGothM.ttc"

#Much better than first two though may need to be blockier
#Best looking in raster version
#FONT_NAME="arial.ttf"

#Favorite in SVG version, though inkscape renders as a different font
#FONT_NAME="monospace"

#What Chrome is actually rendering for "monospace"
FONT_NAME="Consolas"


keys=[["A","B","C","D","E"],
      [":",";","[","]",","],
      ["'","<","=",">","^"],
      ["ENTER","$",'"',"EE","DEL"],
      ["ALPHA","7","8","9","/"],
      ["STO","4","5","6","*"],
      ["@","1","2","3","-"],
      ["ON","0","."," ","+"]]

letters=[["","","","","",],
         ["F","G","H","I","J"],
         ["K","L","M","N","O"],
         ["","P","Q","R",""],
         ["","S","T","U",""],
         ["!","V","W","X",""],
         ["?","Y","Z","_",""],
         ["","","","",""]]

charinfo=namedtuple("charinfo",["size","font","weight","offset_y","char"])

#button text adjustments
SPECIAL_CHARS=  {}
SPECIAL_CHARS|= {":":charinfo(0,"","",1,"")}
SPECIAL_CHARS|= {";":charinfo(0,"","",1,"")}
SPECIAL_CHARS|= {",":charinfo(0,"","",1,"")}

SPECIAL_CHARS|= {"[":charinfo(50,"","bold",1,"")}
SPECIAL_CHARS|= {"]":charinfo(50,"","bold",1,"")}

SPECIAL_CHARS|= {"'":charinfo(80,"","",15,"")}
SPECIAL_CHARS|= {"<":charinfo(80,"","",2,"")}
SPECIAL_CHARS|= {"=":charinfo(90,"","",2,"")}
SPECIAL_CHARS|= {">":charinfo(80,"","",2,"")}
SPECIAL_CHARS|= {"^":charinfo(100,"","",24,"")}

SPECIAL_CHARS|= {"ENTER":charinfo(0,"","",0,"ENT")}
SPECIAL_CHARS|= {"$":charinfo(0,"calibri","",0,"")} #no cross bar
SPECIAL_CHARS|= {'"':charinfo(80,"","",15,"")}
SPECIAL_CHARS|= {"DEL":charinfo(54,"","",6,"&#x1F868;")}

SPECIAL_CHARS|= {"ALPHA":charinfo(70,"","",-0.5,"a")}

OP_SIZE=80
SPECIAL_CHARS|= {"+":charinfo(OP_SIZE,"","",2,"")}
SPECIAL_CHARS|= {"-":charinfo(OP_SIZE+20,"","",2,"")}
SPECIAL_CHARS|= {"*":charinfo(OP_SIZE,"","",2,"&#xD7;")}
SPECIAL_CHARS|= {"/":charinfo(OP_SIZE,"","",2,"&#xF7;")}

SPECIAL_CHARS|= {"STO":charinfo(54,"","",6,"&#x1F86A;")}
SPECIAL_CHARS|= {"@":charinfo(54,"calibri","bold",-0,"")} #rounder, easier to print
SPECIAL_CHARS|= {".":charinfo(0,"","",1,"")}

#Looks correct in Chrome but way too big and wrong shape in inkscape :( :( :(
#SPECIAL_CHARS|= {" ":charinfo(120,"","",-28,"&#x2423;")}
#Doesn't render at all in inkscape :( :( :(
#SPECIAL_CHARS|= {" ":charinfo(0,"","",0,"&#x2334;")}
#Technically not the space character, but looks right in Chrome and inkscape
#SPECIAL_CHARS|= {" ":charinfo(0,"","",0,"&#x2334;")}
#Trying this for now
SPECIAL_CHARS|= {" ":charinfo(0,"","",0,"SP")}

#letter text adjustments
SPECIAL_CHARS|= {"?":charinfo(0,"calibri","",0,"?")}
SPECIAL_CHARS|= {"Q":charinfo(54,"","",0,"")}
SPECIAL_CHARS|= {"_":charinfo(0,"","",-16,"")}

def draw_box(x1,y1,x2,y2,color):
    f.write(f'<line x1="{x1}" y1="{y1}" ')
    f.write(f'x2="{x2}" y2="{y1}" ')
    f.write(f'style="stroke:{color};stroke-width:1" />\n')

    f.write(f'<line x1="{x2}" y1="{y1}" ')
    f.write(f'x2="{x2}" y2="{y2}" ')
    f.write(f'style="stroke:{color};stroke-width:1" />\n')

    f.write(f'<line x1="{x2}" y1="{y2}" ')
    f.write(f'x2="{x1}" y2="{y2}" ')
    f.write(f'style="stroke:{color};stroke-width:1" />\n')

    f.write(f'<line x1="{x1}" y1="{y2}" ')
    f.write(f'x2="{x1}" y2="{y1}" ')
    f.write(f'style="stroke:{color};stroke-width:1" />\n')
    
def char_info(key,font_offset_y):

    #default values
    font_size=FONT_SIZE
    font_name=FONT_NAME
    font_weight=""
    #font_offset_y=FONT_OFFSET_Y
    font_char=key

    #character adjustments
    if key in SPECIAL_CHARS.keys():

        #font size
        if SPECIAL_CHARS[key].size!=0:
            font_size=SPECIAL_CHARS[key].size

        #font name
        if SPECIAL_CHARS[key].font!="":
            font_name=SPECIAL_CHARS[key].font

        #font weight
        font_weight=SPECIAL_CHARS[key].weight
            
        #font y offset
        if SPECIAL_CHARS[key].offset_y!=0:
            font_offset_y=SPECIAL_CHARS[key].offset_y
            
        #font character replacement
        if SPECIAL_CHARS[key].char!="":
            font_char=SPECIAL_CHARS[key].char

    return font_size, font_name, font_weight, font_offset_y, font_char


f=open("keypad.svg","w")

f.write('<svg xmlns="http://www.w3.org/2000/svg" ')
f.write(f'width="{IMG_WIDTH}" height="{IMG_HEIGHT}">\n')

#background color
if DEBUG:
    f.write(f'<rect width="100%" height="100%" fill="{BACK_COLOR}" />\n\n')

#bounding box of file - confirms centering in openscad
#if not DEBUG:
#    draw_box(0,0,IMG_WIDTH,IMG_HEIGHT,BBOX_COLOR)

for row in range(BUTTON_COUNT_Y):
    for column in range(BUTTON_COUNT_X):
        rect_x=BUTTON_GAP_HORZ+column*(BUTTON_WIDTH+BUTTON_GAP_HORZ)
        rect_y=BUTTON_GAP_VERT+row*(BUTTON_HEIGHT+BUTTON_GAP_VERT)

        #button
        if DEBUG:
            f.write(f'<rect width="{BUTTON_WIDTH}" height="{BUTTON_HEIGHT}" ')
            f.write(f'x="{rect_x}" y="{rect_y}" fill="{BUTTON_COLOR}" />\n')

        #button debug lines
        if DEBUG:
            f.write(f'<line x1="{rect_x+BUTTON_BORDER_HORZ}" y1="{rect_y}" ')
            f.write(f'x2="{rect_x+BUTTON_BORDER_HORZ}" y2="{rect_y+BUTTON_HEIGHT}" ')
            f.write(f'style="stroke:{LINE_COLOR};stroke-width:1" />\n')

            f.write(f'<line x1="{rect_x+BUTTON_WIDTH-BUTTON_BORDER_HORZ}" y1="{rect_y}" ')
            f.write(f'x2="{rect_x+BUTTON_WIDTH-BUTTON_BORDER_HORZ}" y2="{rect_y+BUTTON_HEIGHT}" ')
            f.write(f'style="stroke:{LINE_COLOR};stroke-width:1" />\n')

            f.write(f'<line x1="{rect_x}" y1="{rect_y+BUTTON_BORDER_VERT}" ')
            f.write(f'x2="{rect_x+BUTTON_WIDTH}" y2="{rect_y+BUTTON_BORDER_VERT}" ')
            f.write(f'style="stroke:{LINE_COLOR};stroke-width:1" />\n')

            f.write(f'<line x1="{rect_x}" y1="{rect_y+BUTTON_HEIGHT-BUTTON_BORDER_VERT}" ')
            f.write(f'x2="{rect_x+BUTTON_WIDTH}" y2="{rect_y+BUTTON_HEIGHT-BUTTON_BORDER_VERT}" ')
            f.write(f'style="stroke:{LINE_COLOR};stroke-width:1" />\n')
            
        #draw button text
        font_size, font_name, font_weight, font_offset_y, font_char=char_info(keys[row][column],FONT_OFFSET_Y)
        
        f.write(f'<text x="{rect_x+BUTTON_WIDTH/2}" y="{rect_y+BUTTON_HEIGHT/2+font_offset_y}" ')
        f.write(f'fill="{FONT_COLOR}" dominant-baseline="middle" text-anchor="middle" ')
        if font_weight!="": f.write(f'font-weight="{font_weight}" ')
        f.write(f'font-family="{font_name}" font-size="{font_size}">')
        f.write(f'{"&lt;" if font_char=="<" else font_char}</text>\n\n')

        rect_y-=LETTER_GAP_VERT+LETTER_HEIGHT

        #letter debug lines
        if DEBUG:
            draw_box(rect_x,rect_y,rect_x+BUTTON_WIDTH,rect_y+LETTER_HEIGHT,LINE_COLOR)
            
        #draw letter
        font_size, font_name, font_weight, font_offset_y, font_char=char_info(letters[row][column],LETTER_OFFSET_Y)
        
        f.write(f'<text x="{rect_x+BUTTON_WIDTH}" y="{rect_y+font_offset_y}" ')
        f.write(f'fill="{LETTER_COLOR}" dominant-baseline="hanging" text-anchor="end" ')
        if font_weight!="": f.write(f'font-weight="{font_weight}" ')
        f.write(f'font-family="{font_name}" font-size="{font_size}">')
        f.write(f'{"&lt;" if font_char=="<" else font_char}</text>\n\n')
        
        
f.write("</svg>")
f.close()

print(IMG_WIDTH,IMG_HEIGHT)
