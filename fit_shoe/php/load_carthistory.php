<?php
error_reporting(0);
include_once ("dbconnect.php");
$orderid = $_POST['orderid'];

$sql = "SELECT SHOE.ID, SHOE.NAME, SHOE.PRICE, SHOE.QUANTITY, CARTHISTORY.CQUANTITY FROM SHOE INNER JOIN CARTHISTORY ON CARTHISTORY.PRODID = SHOE.ID WHERE  CARTHISTORY.ORDERID = '$orderid'";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["carthistory"] = array();
    while ($row = $result->fetch_assoc())
    {
        $cartlist = array();
        $cartlist["id"] = $row["ID"];
        $cartlist["name"] = $row["NAME"];
        $cartlist["price"] = $row["PRICE"];
        $cartlist["cquantity"] = $row["CQUANTITY"];
        array_push($response["carthistory"], $cartlist);
    }
    echo json_encode($response);
}
else
{
    echo "Cart Empty";
}
?>