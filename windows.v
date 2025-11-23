module main

import ui
//import gx
import gg
import time


fn (mut app App) subwin_start() &ui.SubWindow {
   sw_start := ui.subwindow(
      id: 'sw_start'
      layout: ui.column(
         width: 300
         height: 100
         margin_: 10
         spacing: 10
//         bg_color: ui.alpha_colored(gx.light_gray, 90)
         bg_color: ui.alpha_colored(gg.white, 480)
         widths: ui.stretch
         heights: ui.compact
         children: [
            ui.label(text: 'press start to begin the game', justify: ui.center_center),
            ui.button(
               id: 'btn_start'
               height: 10
               width: 50
               bg_color: gg.light_gray
               text: 'Start'
               on_click: app.close_subwindow_start
            ),
         ]
       )
   )
   return sw_start
}

fn (mut app App) main_window() &ui.Window {
//   app.window = ui.window(
   window1 := ui.window(
   width: win_width
   height: win_height
   title: 'Mastermind'
//   mode: .resizable
//   mode: .fullscreen
//   mode: .max_size
   mode: .normal_size
   on_init: app.win_init
   on_key_down: app.on_keypress
   children: [
      ui.column(   // below each others
         margin_: 15
         spacing: 10
         widths: ui.stretch
         heights: ui.compact
         children: [
            ui.row(  // next to each others
               margin_: 6
               children: [
                  ui.button(
                     id: 'btn_newgame' 
                     text: 'New Game'
                     on_click: app.btn_newgame_click
                  ),
                  ui.button(
                     id: 'btn_toplist' 
                     text: 'Toplist'
                     on_click: app.btn_toplist_click
                  ),
                  ui.button(
                     text: 'Help'
                     on_click: app.btn_help_click
                  ),
                  ui.button(
                     text: 'Exit'
                     on_click: btn_exit_click
                  ),
               ]
            ),
            ui.row(  // next to each others
               margin_: 0
               children: [
                  ui.canvas_plus(
                     id: 'c_bal'
                     full_width: win_width / 2
                     full_height: win_height - 100
//                     bg_color: gg.white
                     bg_radius: .025
                     clipping: true
                     on_draw: app.draw_boxes
                  ),
                  ui.column(
                     children: [
                        ui.column(
                           alignment: .center
                           spacing: 10
                           margin: ui.Margin{10, 10, 10, 10}
                           children: [
                              ui.button(
                                 id: 'btn_red'
                                 height: ey
                                 width: ex
                                 bg_color: gg.red
                                 text: ''
                                 on_click: app.click_color
                              ),
                              ui.button(
                                 id: 'btn_yellow'
                                 height: ey
                                 width: ex
                                 bg_color: gg.yellow
                                 text: ''
                                 on_click: app.click_color
                              ),
                              ui.button(
                                 id: 'btn_orange'
                                 height: ey
                                 width: ex
                                 bg_color: gg.orange
                                 text: ''
                                 on_click: app.click_color
                              ),
                              ui.button(
                                 id: 'btn_green'
                                 height: ey
                                 width: ex    
                                 bg_color: gg.green
                                 text: ''
                                 on_click: app.click_color
                              ),
                              ui.button(
                                 id: 'btn_white'
                                 height: ey
                                 width: ex
                                 bg_color: gg.white
                                 text: ''
                                 on_click: app.click_color
                              ),
                              ui.button(
                                 id: 'btn_blue'
                                 height: ey
                                 width: ex
                                 bg_color: gg.blue
                                 text: ''
                                 on_click: app.click_color
                              ),
                           ] 
                        ),
                     ]
                  ),
               ]
            ),  
            ui.label(
              id: 'l_count' 
//              text: 'coordinates'
              text: '..'
//              justify: [0.1, 0.1]
              text_align: .left
              z_index : 20
            ),
            ui.label(
              id: 'l_also' 
//              text: 'hello, please click on one of the 2 boxes !'
              text: ''
//              justify: [0.1, 0.1]
              text_align: .left
              z_index : 20
            ),

         ]
      ),
 
   ]  
   )
   return window1
}

fn (mut app App) subwin_toplist(newscorestr string) &ui.SubWindow {
   sw_toplist := ui.subwindow(
      id: 'sw_toplist'
//      on_init: app.win_init_toplist
      x : 25
      y : 40
      layout: ui.column(
         alignments: ui.HorizontalAlignments{
            center: [ 0, ]
            right: [ 1 ]
            left: [ 2 ]
	 }
         widths: [
            ui.stretch,
            ui.stretch,
            ui.compact,
//            ui.stretch,
         ]
         heights: [
            20.0,
            ui.stretch,
            40.0,
         ]
         width: 350
         height: 340
         margin_: 10
         spacing: 5
//         bg_color: ui.alpha_colored(gg.light_gray, 120)
         bg_color: ui.alpha_colored(gg.white, 210)
//         widths: ui.stretch
//         heights: ui.compact
         children: [
            ui.label(text: 'Toplist', justify: ui.center_center),
            ui.canvas(
              width: 400
              height: 275
              draw_fn: app.canvas_draw
            ),
            ui.row(  // next to each others
               margin_: 10
//               widths: ui.stretch
//               heights: ui.compact
//               align: .center
               children: [
                  ui.textbox(
                     id: 'tb_newline'
//                   mode: .word_wrap
//                     text: &newname
                     width: 280
                     height: 30
                     text_size: 17
                     bg_color: ui.alpha_colored(gg.light_gray, 0)
                     read_only : true
//                     fitted_height: true
                     max_len : 25
                     borderless : true
                     text_align: .left
                     on_enter: app.add_new_result
                  ),
                  ui.textbox(
                     id: 'tb_newscore'
                     text: &newscorestr
                     width: 120
                     height: 30
                     bg_color: ui.alpha_colored(gg.light_gray, 0)
                     borderless : true
                     read_only : true
                     text_align: .left
//                     text_align: .center
                  ),
               ]  
            )

         ]
       )
   )
   return sw_toplist
}


fn (mut app App) subwin_help() &ui.SubWindow {
   sw_help := ui.subwindow(
      id: 'sw_help'
//      on_init: app.win_init_toplist
      x : 5
      y : 5
      layout: ui.column(
         width: 390
         height: 460
         margin_: 0
         spacing: 0
//         bg_color: ui.alpha_colored(gg.light_gray, 120)
         bg_color: ui.alpha_colored(gg.white, 210)
         widths: ui.stretch
//         alignments: ui.HorizontalAlignments{
//           center: [0, 1]
//         }
//         widths: ui.compact
         heights: ui.compact
         children: [
//            ui.label(text: '\nHelp', justify: ui.center_center),
//            ui.label(text: '\nHelp', justify: ui.top_center),
            ui.label(text: '\nHelp', text_align: .center, justify: ui.center_center),
            ui.textbox(
               id: 'tb_help'
               text: &app.helptxt
               mode: .multiline
//             text: &newname
               width: 390
               height: 444
               text_size: 10
               bg_color: ui.alpha_colored(gg.light_gray, 0)
               read_only : true
//             fitted_height: true
//               max_len : 25
               borderless : true
               text_align: .left
//               on_enter: app.add_new_result
            ),
         ]
      )
   )
   return sw_help
}


fn (mut app App) canvas_draw(gg_ &gg.Context, c &ui.Canvas) { // x_offset int, y_offset int) {
   x_offset, y_offset := c.x, c.y
   x           := x_offset
   cell_height := 20
   cell_width  := 280 

   for i, l in app.toplista {
//   for i, l in app.toplista[..12] {
      y := y_offset + i * cell_height
      mut plus := '' 
      if i < 9 { plus = '  ' }
      i2 := i + 1
//      print(i2.str() + ' ' + l.name + ' ' + l.score.str()+'|')
      gg_.draw_text_def(x + 30, y, i2.str() + '.    ' + plus + l.name)
      gg_.draw_text_def(x + cell_width, y , l.score.str())
      if i == 11 { break }
   }
//   println('')
//   println(app.toplista.len)

}


fn (mut app App) add_new_result(mut tb &ui.TextBox) {
//   mut l := app.window.get_or_panic[ui.Label]('label1')    // we are going to write into this element
//   l.set_text('aaa')

   name := *tb.text
//   l.set_text(name)
   st := '' 
   tb.text = &st

//   println(name.len)

//   if app.toplista.len >= 10 {
//      return
//   }

   if name == ''  {
       return
   }
//   app.newscore++
   newelem := Result{name,app.newscore}
   app.toplista << newelem
   app.toplista.sort(a.score > b.score)     // !!! otherwise last results will not be seen

//   print(app.toplista)
//   print(app.toplista[..5])
//    for i, l2 in app.toplista {
//       print(i.str()+' '+l2.name+' '+l2.score.str()+'|')
//    }
//   println(name+' '+app.newscore.str())
//   println('')
   app.toplista.trim(12)    // if length is greater than 12, removes the elements after 12
   time.sleep(time.millisecond * 100)
   app.save_toplist_txtfile(toplistafile) // save new toplist to file 
   app.state = 176

   app.display_subwindow('sw_toplist')    // close the toplist subwindow
//   mut e := app.window.get_or_panic[ui.Label]('tb_newline')    // we are going to write into this element

//   time.sleep(time.millisecond * 50) 
//   app.window.refresh()
//   app.window.close()
//   mut subwin := app.window.get_or_panic[ui.SubWindow]('sw_toplist')
//   subwin.set_visible(false)
//   subwin.update_layout()

//   subwin.set_visible(true)
//   subwin.update_layout()

}


fn (mut app App) display_subwindow(swname string)  {
   mut sw2 := app.window.get_or_panic[ui.SubWindow]('sw_toplist')
   mut sw3 := app.window.get_or_panic[ui.SubWindow]('sw_help')
   mut sw  := app.window.get_or_panic[ui.SubWindow](swname)

   if sw2.is_visible() {
      sw2.set_visible(false)
      sw2.update_layout()
      return
   } 
   if sw3.is_visible() {
      sw3.set_visible(false)
      sw3.update_layout()
      return
   } 
   if !sw.is_visible() {
      sw.set_visible(true)
//      sw.set_pos(25, 40)
      sw.update_layout()
   }
}


fn (mut app App) display_toplist_newline()  {
   mut t := app.window.get_or_panic[ui.TextBox]('tb_newline')

////   if !sw.is_visible() {
//      t.set_visible(true)
    t.read_only  = false
    t.borderless = false
    t.is_focused = true

    mut t2 := app.window.get_or_panic[ui.TextBox]('tb_newscore')
    newscorestr := app.newscore.str()
    t2.text = &newscorestr

//      t.set_visible(true)
////      sw.set_pos(20, 50)
//      t.update_layout()
////   }
}

fn (mut app App) btn_newgame_click(b voidptr) {
   app.display_subwindow_start()
   app.newgame()
}

fn btn_exit_click(b voidptr) {
   exit(0)
}

fn (mut app App) btn_toplist_click(b voidptr) {
   mut t := app.window.get_or_panic[ui.TextBox]('tb_newline')
   t.read_only  = true
   t.borderless = true
//   t.is_focused = true
   mut t2 := app.window.get_or_panic[ui.TextBox]('tb_newscore')
   a := ''
   t2.text = &a
   app.display_subwindow('sw_toplist') 
}


fn (mut app App) btn_help_click(b voidptr) {
   app.display_subwindow('sw_help') 
}


fn (mut app App) win_init_toplist1(win &ui.Window) {
   app.start_counter_toplist_delay1(1)
//   app.win_init_toplist(win)
}

//fn (mut app App) win_init_toplist(win &ui.Window) {
fn (mut app App) win_init_toplist2() {
   app.start_counter_toplist_delay2(2)
}

fn (mut app App) start_counter_toplist_delay1(max1 int) {
// mut l := app.window.get_or_panic[ui.Label]('label1')    // we are going to write into this element

// fv := fn [mut l, mut app, max1] () {
   fv := fn [mut app, max1] () {
     for i:=0; i <= max1; i++ {
//        counter := max1 - i
//        l.set_text(counter.str())
        time.sleep(time.millisecond*1000) 
     }
     app.display_subwindow('sw_toplist') 
   }
   go fv()
}

fn (mut app App) start_counter_toplist_delay2(max1 int) {
//   mut l := app.window.get_or_panic[ui.Label]('label2')    // we are going to write into this element

//   fv := fn [mut l, mut app, max1] () {
   fv := fn [mut app, max1] () {
     for i:=0; i <= max1; i++ {
//        counter := max1 - i
//        l.set_text(counter.str())
        time.sleep(time.millisecond*1000) 
     }
     app.display_toplist_newline() 
   }
   go fv()
}

fn (mut app App) on_keypress(w &ui.Window, e ui.KeyEvent) {
   mut l := app.window.get_or_panic[ui.Label]('l_also')    // we are going to write into this element
//   l.set_text('$e.key')
   mut st := ''
//   l.set_text('$app.state')

   match e.key {
      .escape { 
         app.close_subwindow_misc('sw_toplist')
         app.close_subwindow_misc('sw_start')
         app.close_subwindow_misc('sw_help')
      }
      .enter { 
         mut sw   := app.window.get_or_panic[ui.SubWindow]('sw_start')
         mut bu1  := app.window.get_or_panic[ui.Button]('btn_newgame')
         mut bu2  := app.window.get_or_panic[ui.Button]('btn_toplist')
//         l.set_text('$app.state')
         if app.state == 10 && sw.is_visible() {
            app.close_subwindow_misc('sw_toplist')
            app.close_subwindow_misc('sw_start')
            app.close_subwindow_misc('sw_help')
//            sw.set_visible(false)
//            sw.update_layout()
            bu1.is_focused = false          // important!!! otherwise new start window will appear
            bu2.is_focused = false          // important!!! otherwise new start window will appear
            app.click_start_game()
         }
      }
      .x {
         if e.mods.has(.alt) {              // it is alt_x
            exit(0)
         }
      }
      .f1 {
         mut sw   := app.window.get_or_panic[ui.SubWindow]('sw_help')
         if !sw.is_visible() {
            app.display_subwindow('sw_help') 
         }
      }
      .t {
         mut t := app.window.get_or_panic[ui.TextBox]('tb_newline')
         t.read_only  = true
         t.borderless = true
//         t.is_focused = true
         mut sw   := app.window.get_or_panic[ui.SubWindow]('sw_toplist')
         if !sw.is_visible() {
            app.display_subwindow('sw_toplist') 
         }
      }
      .s {
//         if app.state == 175 { return } // new record toplist insert state - not working
//         if app.state >= 174 { return } // new record toplist insert state - not working
         if app.state == 174 { return } // new record toplist insert state, allow to enter s key in the toplist insert field
         mut sw   := app.window.get_or_panic[ui.SubWindow]('sw_start')
         if !sw.is_visible() {
            app.display_subwindow('sw_start') 
         }
      }
      else {}
   }
   l.set_text(st)
 
}

fn (mut app App) close_subwindow_misc(subwinid string)  {
   mut sw2 := app.window.get_or_panic[ui.SubWindow](subwinid)
   if sw2.is_visible() {
      sw2.set_visible(false)
      sw2.update_layout()
   } 
}

fn (mut app App) close_subwindow_start(b voidptr)  {
   mut sw  := app.window.get_or_panic[ui.SubWindow]('sw_start')
     if sw.is_visible() {
        sw.set_visible(false)
        sw.update_layout()
        app.click_start_game()
     }
}








