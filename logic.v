module main

import rand


fn (mut app App) generate() {
    for i in 0 .. 4 {  // 0,1,2,3, not 4
        mut a := rand.intn(6) or {0}
        a++
        app.felad[i] = a
    }
}

fn (mut app App) osszehas() (int,int) {  // app.felad es app.tipp ooszehasonlitasa
    mut hp       := 0                    // helyes pozicio
    mut hsz      := 0                    // helyes szin
    mut fszin    := [0,0,0,0,0,0]
    mut tszin    := [0,0,0,0,0,0]

    mut f := app.felad
    mut t := app.tipp

    for i in 0 .. 4 {  // 0,1,2,3, not 4
        if f[i] == t[i] {
            hp++
            f[i] += 100
            t[i] += 100
        }
    }

    mut tipp := 0
    for i in 1 .. 7 {  // 1..6 not 7
        for j in 0 .. 4 {  // 0,1,2,3, not 4
            if f[j] == i {
                fszin[i-1]++ 
            }
            if t[j] == i {
                tszin[i-1]++ 
            }
        }
        if tszin[i-1] <= fszin[i-1] {
            tipp += tszin[i-1]
        }
        if tszin[i-1] > fszin[i-1] {
            tipp += fszin[i-1]
        }
    }

    hsz = tipp
    return hp,hsz
}



