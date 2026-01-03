module main

import ui
//import gx
import gg
//import rand
import time
//import os
//import strconv
//import strings


const win_width  = 400
const win_height = 480
const ex = 40      
const ey = 40  
const game_max_time = 300
const toplistafile  = "toplista.txt"
const prgversion = "v0.11"
      
@[heap]
struct App {
mut:
   window  &ui.Window = unsafe { nil }
   open      int
   text      string = 'aaa'
   t         [8][4]int
   felad     [4]int
   tipp      [4]int
   state     int
   ertekeles [8][2]int
   toplista  []Result
   newscore int
   counter  int
   helptxt  string
}

struct Result {
   name  string
   score int
}

fn main() {
   println("")
   println("vlang mastermind $prgversion")

   mut app   := &App{ }

   app.toplista << Result{'Bela',10}
   app.toplista << Result{'Geza',20}
   app.toplista << Result{'Anna',30}
   app.toplista.sort(a.score > b.score)

   app.load_toplist_ifexists_ifnotexist_write(toplistafile)

//   helptxt := readtxtfile('help.txt')
//   for i:=0; i<helptxt.len; i++ { 
//     app.helptxt += helptxt[i]+'\n' 
//       print(helptxt[i]+'\n')
//   }
//   app.helptxt = readtxtfile_tostring('help.txt')
//   app.helptxt.replace("\r", "")    // on windows line ending: "\r\n"
    app.helptxt = readtxtfile_tostring_indirect('help.txt')

//   app.newscore = 111
//   newscorestr := app.newscore.str()
   newscorestr := ''
   app.newgame()

//   print('$app.t') print('\n')
//   print('${app.t[0]}') print('\n')
/*   for i:=0; i<4; i++ {
     e := app.t[0][i]
     print('${e}') 
   }*/
//   print('\n\n\n')

   sw_start   := app.subwin_start()
   sw_toplist := app.subwin_toplist(newscorestr)
   sw_help    := app.subwin_help()
   app.window =  app.main_window()
   app.window.subwindows << sw_start
   app.window.subwindows << sw_toplist
   app.window.subwindows << sw_help
   ui.run(app.window)                                   

}


fn (mut app App) click_color(c &ui.Button) {
//   mut l := c.ui.window.get_or_panic[ui.Label]('l_also')    // we are going to write into this element
   color      := get_color_from_btnid(c.id)
   mut s      := app.state
   mut sor    := 0
   mut oszlop := 0
   if s >= 100 && s < 174 {  // in game states, 174 is the last position
       if s == 104 || s == 114 || s == 124 || s == 134 || s == 144 || s == 154 || s == 164 {
           s += 6   // next line 1st element
       }  
       s++
       ss     := s.str()                    // 104 -> '104'
       sor    = ss[1].ascii_str().int()     // 104 -> 0    8 sor:    0..7 
       oszlop = ss[2].ascii_str().int()-1   // 104 -> 3    4 oszlop: 0..3 
       app.t[sor][oszlop] = color
       if oszlop == 3 {      // it is the last column
           for ii:=0; ii<4; ii++ {
               app.tipp[ii] = app.t[sor][ii]
           }
           hp,hsz := app.osszehas()
           app.ertekeles[sor][0] = hp
           app.ertekeles[sor][1] = hsz
           if hp == 4 {  // result is known
               s = 174 
               app.indicate_finished_ok(c)
           } else if s == 174 || (sor == 7 && oszlop == 3) {  // end is reached, but result is not known
               app.indicate_finished_not_known(c)
           }
       }
   }
//   st := color.str() + ' ' + s.str() + ' ' + sor.str() + ' ' + oszlop.str() 
//   l.set_text(st)

   app.state = s
//   print('$app.t') print('\n')
   app.window.refresh()

}

fn (mut app App) draw_boxes(mut d ui.DrawDevice, c &ui.CanvasLayout) {
//	w, h := c.full_width, c.full_height
   w, h := ex, ey
   for j:=0; j<8; j++ {     // drawing color boxes (tips)
     for i:=0; i<4; i++ {
       co := app.t[j][i]
       color := get_gxcolor(co) or { return }
       c.draw_device_rect_filled(d, i*(w+5), j*(h+5), w, h, color)
     }
   }
   
   for j:=0; j<8; j++ {     // drawing result boxes
     for i:=0; i<2; i++ {
       mut color := gg.black
       co := app.ertekeles[j][i]
       if i == 0 { color = gg.yellow }
       if i == 1 { color = gg.magenta }
       for e:=0; e < co; e++ {
         c.draw_device_rect_filled(d, 200+e*(10), j*(ey+5)+i*ey/2-i*8+10, 8, 8, color)
       }
     }
   }
  
 
}

fn get_gxcolor(color int) ?gg.Color {
   mut cc := gg.black
   if color == 1 {
      cc = gg.red
   } else if color == 2 {
      cc = gg.yellow
   } else if color == 3 {
      cc = gg.orange
   } else if color == 4 {
      cc = gg.green
   } else if color == 5 {
      cc = gg.white
   } else if color == 6 {
      cc = gg.blue
   } else {
//     return gg.black
//     return gg.gray
     return gg.light_gray
   }
   return cc
}

fn get_color_from_btnid(color string) int {
   mut cc := 0
   if color == 'btn_red' {
      cc = 1
   } else if color == 'btn_yellow' {
      cc = 2
   } else if color == 'btn_orange' {
      cc = 3
   } else if color == 'btn_green' {
      cc = 4
   } else if color == 'btn_white' {
      cc = 5
   } else if color == 'btn_blue' {
      cc = 6
   } else {
     cc = 0
   }
   return cc
}


fn (mut app App) indicate_finished_ok(c &ui.Button) {
//   mut l := c.ui.window.get_or_panic[ui.Label]('l_also')    // we are going to write into this element
   mut l := app.window.get_or_panic[ui.Label]('l_also')    // we are going to write into this element
   l.set_text('GAME OVER, task is guessed, you are clever! ')

   app.newscore = app.counter        // counting game score at the end
   mut newrecord := false            // deciding if new record
   for _, e in app.toplista {
      if app.newscore > e.score { newrecord = true } 
   }
   if newrecord {
//     time.sleep(time.millisecond*1000) 
     app.state = 175
     app.start_counter_toplist_delay1(0)   // display toplist after 1 sec
     app.start_counter_toplist_delay2(0)   // display new line after 1 sec
   }
}

fn (mut app App) indicate_finished_not_known(c &ui.Button) {
//   mut l := c.ui.window.get_or_panic[ui.Label]('l_also')    // we are going to write into this element
   mut l := app.window.get_or_panic[ui.Label]('l_also')    // we are going to write into this element
   l.set_text('GAME OVER, task is NOT guessed')
}

fn (mut app App) win_init(win &ui.Window) {
   app.display_subwindow_start()

//   app.start_counter_toplist_delay1(1)   // display toplist after 1 sec
//   app.win_init_toplist2()               // display insert new line

}

fn (mut app App) display_subwindow_start()  {
   mut sw  := app.window.get_or_panic[ui.SubWindow]('sw_start')
     if !sw.is_visible() {
        sw.set_visible(true)
        sw.set_pos(50, 100)
        sw.update_layout()
        app.dont_display_counter()
        app.dont_display_also()
     } else {
        sw.set_visible(false)
        sw.update_layout()
     }
}


//fn (mut app App) click_start_game(c &ui.Button) {
fn (mut app App) click_start_game() {
//   mut l := c.ui.window.get_or_panic[ui.Label]('l_count')           // we are going to write into this element
//   mut l2 := c.ui.window.get_or_panic[ui.Label]('l_also')           // we are going to write into this element
   mut l := app.window.get_or_panic[ui.Label]('l_count')           // we are going to write into this element
   mut l2 := app.window.get_or_panic[ui.Label]('l_also')           // we are going to write into this element

   app.state = 100
   fv := fn [mut l, mut app, mut l2] () {
     app.counter = game_max_time
     for {
        l.set_text(app.counter.str())
        time.sleep(time.millisecond*1000) 
//        l2.set_text(app.state.str())
        if app.state == 10 {  // start window
           break
        }
        if app.counter > 0 {
//           if app.state == 100 {
//              break
//           } 
           if app.state < 174 {
              app.counter--
           }
        } else {
           app.state = 174
           l2.set_text('GAME OVER, task is NOT guessed')
        }
     }
   }
   go fv()
}




fn (mut app App) newgame() {
//   mut tipp  := [0,0,0,0]
   app.generate()
//   print(app.felad)
   app.state = 10   // program started

//   app.state = 99  // start game after press start

   for j:=0; j<8; j++ {
//     generate(mut &tipp)
     for i:=0; i<4; i++ {
       app.t[j][i] = 0
     }
   }
   for j:=0; j<8; j++ {
     for i:=0; i<2; i++ {
//        mut a := rand.intn(4) or {0}
//        a++
        a := 0
        app.ertekeles[j][i] = a
     }
   }
}


fn (mut app App) dont_display_counter() {
   mut ll := app.window.get_or_panic[ui.Label]('l_count')           // we are going to write into this element
   ll.set_text('')
}

fn (mut app App) dont_display_also() {
   mut ll := app.window.get_or_panic[ui.Label]('l_also')           // we are going to write into this element
   ll.set_text('')
}






