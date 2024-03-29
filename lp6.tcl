set ns [new Simulator]

set nam [open out.nam w]
$ns namtrace-all $nam

set tr [open out.tr w]
$ns trace-all $tr

set n0 [$ns node]
set n1 [$ns node]

$ns at 0.0 "$n0 label Sender"
$ns at 0.0 "$n1 label Receiver"

$ns duplex-link $n0 $n1 0.2Mb 200ms DropTail
$ns queue-limit $n0 $n1 10

Agent/TCP set nam_tracevar_ true

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

$tcp set window_ 1
$tcp set maxcwnd_ 1

set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink

$ns connect $tcp $sink

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $tcp

$ns add-agent-trace $tcp tcp
$ns monitor-agent-trace $tcp
$tcp tracevar cwnd_

proc finish {} {
	global ns tr nam
	$ns flush-trace
	close $tr
	close $nam
	exec nam out.nam &
	exit 0
}

$ns at 0.1 "$cbr start"
$ns at 3.5 "finish"
$ns run
