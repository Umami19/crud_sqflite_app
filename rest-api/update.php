<?php
header('Content-Type: application/json');
include "./db.php";

$id = $_POST['id'];
$name = $_POST['nama'];
$nim = $_POST['nim'];
$description = $_POST['description'];
$createdAt = $_POST['createdAt'];

$stmt = $db->prepare("UPDATE mahasiswa SET nama = ?, nim = ?, description = ?, createdAt = ? WHERE id = ?");
$result =  $stmt->execute([$name, $nim, $description, $createdAt, $id]);

echo json_encode([
'success' => $result
]);

?>