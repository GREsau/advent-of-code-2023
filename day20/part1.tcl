proc readInput {} {
  set fd [open input.txt r]
  while {[gets $fd line] > -1} {
    set module [lindex $line 0]
    set type [string index $module 0]
    set module [string trimleft $module "%&"]
    set destinations [lmap word [lrange $line 2 end] { string trimright $word "," }]

    dict set modules $module type $type
    dict set modules $module destinations $destinations
  }
  close $fd

  foreach {module info} $modules {
    set type [dict get $info type]
    switch $type {
      "%" {
        dict set modules $module state 0
      }
      "&" {
        foreach {module2 info2} $modules {
          if {[lsearch -exact [dict get $info2 destinations] $module] > -1} {
            dict set modules $module state $module2 0
          }
        }
      }
    }
  }

  return $modules
}

proc handlePulse {module pulse sender} {
  global modules queue lowPulses highPulses

  if {$pulse} {
    incr highPulses
  } else {
    incr lowPulses
  }

  if {![dict exists $modules $module]} {
    return
  }

  dict with modules $module {
    switch $type {
      "%" {
        if {! $pulse} {
          set state [expr {! $state}]
          foreach dest $destinations {
            lappend queue $dest $state $module
          }
        }
      }
      "&" {
        dict set state $sender $pulse
        set i [lsearch -exact -inline [dict values $state] 0]
        # i is 0 if any state values are 0, otherwise {}
        set i [expr {$i == 0}]
        # i is 1 if any state values are 0, otherwise 0
        foreach dest $destinations {
          lappend queue $dest $i $module
        }
      }
      "b" {
        foreach dest $destinations {
          lappend queue $dest $pulse $module
        }
      }
    }
  }
}


proc pushButton {} {
  global modules queue
  set queue [list broadcaster 0 button]

  while {[llength $queue]} {
    set queue [lassign $queue module pulse sender]

    handlePulse $module $pulse $sender
  }
}

set modules [readInput]
set lowPulses 0
set highPulses 0

for {set i 0} {$i < 1000} {incr i} {
  pushButton
}

set result [expr {$lowPulses * $highPulses}]

puts "Part 1: $result"
