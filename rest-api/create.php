<?php
header('Content-Type: application/json');
include "./db.php";


$name = $_POST['nama'];
$nim = $_POST['nim'];
$description = $_POST['description'];
$createdAt = $_POST['createdAt'];

$stmt = $db->prepare("INSERT INTO mahasiswa (nama, nim, description, createdAt) VALUES (?, ?, ?, ?)");
$result = $stmt->execute([$name, $nim, $description, $createdAt]);

echo json_encode([
'success' => $result
]);

?>