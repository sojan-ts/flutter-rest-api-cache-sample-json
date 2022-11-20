<?php 
$return["error"] = false;
$return["msg"] = "";
$return["data"] = array();

if(isset($_REQUEST["auth"])){
    $authkey = $_REQUEST["auth"];
    if($authkey == "dfvbhdhvchdgcvdchd"){
          $countries = array(
               array(
                   "name"=>"Native Development",
                   "language"=>"Kotlin"
               ),

               array(
                "name"=>"Hybrid Development",
                "language"=>"Flutter"
               )
            );

            $return["data"] = $countries;
    }else{
       $return["error"] = true;
       $return["msg"] = "Authentication error.";
    }
}else{
    $return["error"]  = true;
    $return["msg"] = "Send auth key.";
}

header('Content-Type: application/json');
echo json_encode($return);
//converting array to JSON string