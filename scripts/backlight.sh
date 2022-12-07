#!/bin/sh                                                                       
bl_dev=/sys/class/backlight/intel_backlight                                     
                                                                                
min=5                                                                        
max=$(< $bl_dev/max_brightness)                                                 
step=42                                                             
                                                                                
curr=$(< $bl_dev/brightness)                                                    
                                                                                
case $1 in                                                                      
  -) new=$(($curr - $step));;                                                   
  +) new=$(($curr + $step));;                                                   
esac                                                                            
                                                                                                                                  
new=$(($new < $min ? $min : $new))                                                    
new=$(($new > $max ? $max : $new))                                              
                                                                                
echo $new > $bl_dev/brightness

