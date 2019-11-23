<?php
include 'conn2.php';


	if ($_POST['Task']=="get") {


		$barcode = $_POST['barcode'];
		$queryResult=$connect->query("SELECT * FROM posts WHERE barcode='".$barcode."'");
		$result=array();
		while($fetchData=$queryResult->fetch_assoc()){
		$result[]=$fetchData;
		}

		echo json_encode($result);
	}
	elseif ($_POST['Task']=="put") {
		$sql = "INSERT INTO posts(barcode,productName,company,brand)VALUES ('".$_POST["BarcodeNo"]."','".$_POST["Product"]."','".$_POST["Syarikat"]."','".$_POST["Jenama"]."')";

            if (mysqli_query($connect, $sql)) {
               //echo "New record created successfully";
                   echo "Maklumat berjaya didaftarkan dan akan diluluskan dalam masa 24jam.Terima kasih kerana menjayakan kempen BMF.";
            } else {
               echo "Error: " . $sql . "" . mysqli_error($connect);
            }
 
	}

elseif($_POST["Task"]=="upload"){
    
 
    $image = $_POST['image'];
    $name = $_POST['name'];
   $barcode = $_POST['barcodeEnd'];
 
$new_string = str_replace(' ', '', $barcode);
$new_name =$new_string.".jpeg";
 
 
 
   $realImage = base64_decode($image);
 
   file_put_contents("imageproduct2/".$new_string.".jpeg", $realImage);
   $sql = "UPDATE posts SET imageP='".$new_name."' WHERE barcode='".$new_string."'";

if ($connect->query($sql) === TRUE) {
    echo "Maklumat berjaya didaftarkan dan akan diluluskan dalam masa 24jam.Terima kasih kerana menjayakan kempen BMF.";
} else {
    echo "Error updating record: " . $connect->error;
}
 
    
 

    
    
}
elseif($_POST["Task"]=="complain"){
    $sql = "INSERT INTO complain(barcode,text_complain)VALUES ('".$_POST["barcode"]."','".$_POST["ulasan"]."')";

            if (mysqli_query($connect, $sql)) {
               echo "Aduan berjaya dikemaskini..Terima Kasih";
            } else {
               echo "Error: " . $sql . "" . mysqli_error($connect);
            }
   
}

?>


