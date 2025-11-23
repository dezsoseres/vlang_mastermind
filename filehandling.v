module main

import time
import os
import strconv


fn readtxtfile_tolines(file string) []string {
   lines := os.read_lines(file) or {
      println("cannot read $file")
      return []
   }
   return lines
}

fn readtxtfile_tostring_direct(file string) string {
   data := os.read_file(file) or { return "" }
   return data
}

fn readtxtfile_tostring_indirect(file string) string {
   a  := readtxtfile_tolines(file) //println(a) exit(1)
   mut st := ''
   for i:=0; i<a.len; i++ {
      st = st + a[i] + '\n'
   }
   return st
}


fn (mut app App) save_toplist_txtfile(file string) {
   mut f := os.open_file(file,'w') or { os.create(file) or { return } } 
//   println(app.toplista.len)

   for _, e in app.toplista {
      scorest := e.score.str()
      f.writeln("$e.name;$scorest") or {}
//      println("$e.name $scorest") 
   }
   f.close()
}


fn (mut app App) load_toplist_ifexists_ifnotexist_write(toplistafile string) {
   lines := readtxtfile_tolines(toplistafile)
   if lines.len > 0 {
      app.toplista = []                   // delete existing init toplista values
      for line in lines {
         a  := line.split(';') 
         a1 := strconv.atoi(a[1]) or { 0 }
         app.toplista << Result{a[0],a1}
      }
      app.toplista.sort(a.score > b.score)
   } else {
//   println(app.toplista.len)
      time.sleep(time.millisecond * 100)
      app.save_toplist_txtfile(toplistafile)
   }
}


