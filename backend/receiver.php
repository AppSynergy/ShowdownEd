<?php
/*
 *  This is a cheap, scaffold-y backend.
 *  Do something more sensible and secure than this in RL!
 *
 */
$data = json_decode(file_get_contents("php://input"));
$fh = fopen("markdown/".$data->file, 'w') or die("can't open file");
if (!fwrite($fh, $data->content)) {
	die("can't write to file");	
}
fclose($fh);
echo $data->file." updated successfully";