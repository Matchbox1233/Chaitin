(define (color-curve)
(let* (
    (tomb (cons-array 8 'byte))
)
    (aset tomb 0 0)
    (aset tomb 1 0)
    (aset tomb 2 50)
    (aset tomb 3 190)
    (aset tomb 4 110)
    (aset tomb 5 20)
    (aset tomb 6 200)
    (aset tomb 7 190)
tomb)    
)

;(color-curve)

(define (elem x lista)

    (if (= x 1) (car lista) (elem (- x 1) ( cdr lista ) ) )

)

(define (text-wh text font fontsize)
(let*
    (
        (text-width 1)
        (text-height 1)
    )
 
    (set! text-width (car (gimp-text-get-extents-fontname text fontsize PIXELS font)))    
    (set! text-height (elem 2  (gimp-text-get-extents-fontname text fontsize PIXELS font)))    
    
    (list text-width text-height)
    )
)

;(text-width "alma" "Sans" 100)

(define (script-fu-bhax-chrome text font fontsize width height color gradient)
(let*
    (
        (image (car (gimp-image-new width height 0)))
        (layer (car (gimp-layer-new image width height RGB-IMAGE "bg" 100  LAYER-MODE-NORMAL-LEGACY)))
        (textfs)
        (text-width (car (text-wh text font fontsize)))
        (text-height (elem 2 (text-wh text font fontsize)))
        (layer2)        
    )
    
    ;step 1
    (gimp-image-insert-layer image layer 0 0)
    (gimp-context-set-foreground '(0 0 0)) // a ' miatt nem lesz függvény, szabadnak tekinti a lips
    (gimp-drawable-fill layer  FILL-FOREGROUND )
    (gimp-context-set-foreground '(255 255 255))
   
    (set! textfs (car (gimp-text-layer-new image text font fontsize PIXELS)))
    (gimp-image-insert-layer image textfs 0 0)   
    (gimp-layer-set-offsets textfs (- (/ width 2) (/ text-width 2)) (- (/ height 2) (/ text-height 2)))
   
    (set! layer (car(gimp-image-merge-down image textfs CLIP-TO-BOTTOM-LAYER))) 
   
    ;step 2   
    (plug-in-gauss-iir RUN-INTERACTIVE image layer 15 TRUE TRUE)
   
    ;step 3
    (gimp-drawable-levels layer HISTOGRAM-VALUE .11 .42 TRUE 1 0 1 TRUE)
   
    ;step 4   
    (plug-in-gauss-iir RUN-INTERACTIVE image layer 2 TRUE TRUE)

    ;step 5    
    (gimp-image-select-color image CHANNEL-OP-REPLACE layer '(0 0 0))
    (gimp-selection-invert image)

    ;step 6        
    (set! layer2 (car (gimp-layer-new image width height RGB-IMAGE "2" 100 LAYER-MODE-NORMAL-LEGACY)))
    (gimp-image-insert-layer image layer2 0 0)

    ;step 7        
    (gimp-context-set-gradient gradient) 
    (gimp-edit-blend layer2 BLEND-CUSTOM LAYER-MODE-NORMAL-LEGACY GRADIENT-LINEAR 100 0 REPEAT-NONE 
        FALSE TRUE 5 .1 TRUE width (/ height 3) width  (- height (/ height 3)))
    
    ;step 8        
    (plug-in-bump-map RUN-NONINTERACTIVE image layer2 layer 120 25 7 5 5 0 0 TRUE FALSE 2)
   
    ;step 9       
    (gimp-curves-spline layer2 HISTOGRAM-VALUE 8 (color-curve))
      
    (gimp-display-new image)
    (gimp-image-clean-all image)
    )
)

;(script-fu-bhax-chrome "Bátf41 Haxor" "Sans" 120 1000 1000 '(255 0 0) "Crown molding")

(script-fu-register "script-fu-bhax-chrome"
    "Chrome3"
    "Creates a chrome effect on a given text."
    "Norbert Bátfai"
    "Copyright 2019, Norbert Bátfai"
    "January 19, 2019"
    ""
    SF-STRING       "Text"      "Bátf41 Haxor"
    SF-FONT         "Font"      "Sans"
    SF-ADJUSTMENT   "Font size" '(100 1 1000 1 10 0 1)
    SF-VALUE        "Width"     "1000"
    SF-VALUE        "Height"    "1000"
    SF-COLOR        "Color"     '(255 0 0)
    SF-GRADIENT     "Gradient"  "Crown molding"    
)
(script-fu-menu-register "script-fu-bhax-chrome" 
    "<Image>/File/Create/BHAX"
)