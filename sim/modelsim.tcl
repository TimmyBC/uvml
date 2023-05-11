#Copyright 1991-2022 Mentor Graphics Corporation
#
#All Rights Reserved.
#
#THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF 
#MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.

proc my_buttons {args} {

   add button "Compile" "vlog -incr -f ../rtl/rtl.f
                         vlog -incr -f uvml/uvml.f -f sim.f"
   
   add button "Rerun" "restart -force
                       run -all"

   }

lappend PrefMain(user_hook) my_buttons

