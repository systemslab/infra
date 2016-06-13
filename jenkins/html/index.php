<?php

# sort by the number and re-append 'issdm' string; 
# we needed to sort by # first to prevent order:
# - issdm-0, issdm-1, issdm-10, issdm-11, ..., issdm-2, etc...
function sort_by_number($nodes) {
  ksort($nodes);
  foreach($nodes as $node => $status) {
    $ret['issdm-'.$node] = $status;
  }
  return $ret;
}

function print_table($nodes) {
  echo "<table border='4' class='stats' cellspacing='0' align='left' style='width:15%;display='inline-block'>
        <tr> 
          <th> Node </th> 
          <th> Status </th> 
          <th> Storage </th> 
        </tr>";

  # parse out the huge string  
  foreach($nodes as $k => $v) {
    list($node, $status, $rc, $containers, $storage) = explode("|", $v);
    $containers = str_replace("\\n", "\n", trim($containers));
    if(strcmp(trim($status), 'UNREACHABLE!') == 0)
      $img = "<img src='./pictures/fail.png' height=30 width=50>";
    else {
      list($stdout, $containers) = explode(' ', $containers);
      if(strlen($containers) == 0)
        $img = "<img src='./pictures/success.gif' height=30 width=30>";
      else
        $img = "<span title=\"containers = \n" . $containers . "\">
                <img src='./pictures/busy.gif' height=30 width=30>
                </span>";
    }

    # parse storage
    $storage = str_replace("\\n", "\n", trim($storage));
    $storage = str_replace("sda", "", trim($storage));
    $devices = "";
    foreach(explode("\n", $storage) as $x) {
      if(strcmp(trim($x), 'sde') == 0)
        $devices = $devices . "<img src='./pictures/ssd.jpg' height=25 width=25>";
      else if(strpos($x, 'nvm') !== false)
        $devices = $devices . "<img src='./pictures/nvm.png' height=30 width=30>";
      else if(strpos($x, 'sd') !== false)
        $devices = $devices . "<img src='./pictures/hdd.png' height=30 width=30>";
    }
    if(strcmp($devices, "") == 0) $devices = "<br>";

   
  
    echo "<tr  style='text-align:center'>
            <td> ". $node . " </td>
            <td> ". $img ." </td>
            <td align='left'> ". $devices . "</td>
          </tr>";
  }
  echo "</table>";
}

if ($_GET['run']) {
  # This code will run if ?run=true is set.
  exec("./run.sh");
}

# main

# check to see if we have an previous status checks
$f = fopen("./lastcheck.txt", "r")
  or die ("<font color='red'><b>ERROR: Server status check has not been run -- [<a href='?run=true'>click to re-check!</a>]</b></font>");
$lastcheck = fread($f, filesize("./lastcheck.txt"));
fclose($f);

# parse input into a dictionary, where k=node, v=output
$fname = "./status.txt";
$f = fopen($fname, "r") 
  or die ("<font color='red'><b>ERROR: Could not read status; check /var/log/apache2/error.log.</b></font>");
$issdm_nodes = array();
$other_nodes = array();
while(!feof($f)) {
  $line = fgets($f);
  if(strlen($line) > 0) {
    list($node) = explode("|", $line);
    if(strpos($node, 'issdm') !== false) {
      list($issdm, $node) = explode("-", $node);
      $issdm_nodes[intval($node)] = $line;
    }
    else {
      $other_nodes[$node] = $line;
    }
  }
}
fclose($f);

ksort($issdm_nodes);
ksort($other_nodes);

# split nodes into columns for html page
$nodes0 = array();
$nodes1 = array();
foreach($issdm_nodes as $node => $line) {
  if(count($nodes0) < 24) $nodes0[$node] = $line;
  else $nodes1[$node] = $line;
}

echo "Last Check: " . $lastcheck . " [<a href='?run=true'>click to re-check!</a>] <br>
      <br>
        <img src='./pictures/fail.png' height=15 width=20> dead
        <img src='./pictures/success.gif' height=15 width=15> available
        <img src='./pictures/busy.gif' height=15 width=15> busy (scroll over to see running containers)
      <br> 
        <img src='./pictures/nvm.png' height=15 width=15> nvme
        <img src='./pictures/hdd.png' height=15 width=15> harddrive
        <img src='./pictures/ssd.jpg' height=15 width=15> ssd
      <br> 
      <br>
      Notes:
      <br> - <b>Restarting Jenkins</b>: Fill out a cluster directory (see GitHub repo), download <a href='https://raw.githubusercontent.com/systemslab/srl-roles/master/jenkins/run.sh' target='_blank'><font face='courier'>run.sh</font></a> and execute it. 
      <br> - <b>Jenkins Docker Image</b>: <a href='https://github.com/systemslab/srl-roles/tree/master/jenkins' target='_blank'>GitHub</a>, <a href='https://hub.docker.com/r/michaelsevilla/jenkins/tags/' target='_blank'>Docker Hub</a>
      <br>
      <br>";

print_table(sort_by_number($nodes0));
print_table(sort_by_number($nodes1));
print_table($other_nodes);

?>
